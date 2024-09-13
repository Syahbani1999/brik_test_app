import 'package:bloc_test/bloc_test.dart';
import 'package:brik_test_app/domain/entities/product.dart';
import 'package:brik_test_app/presentation/bloc/product_bloc.dart';
import 'package:brik_test_app/presentation/pages/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

class FakeProductState extends Fake implements ProductState {}

class FakeProductEvent extends Fake implements ProductEvent {}

void main() {
  late MockProductBloc mockProductBloc;

  setUpAll(() {
    registerFallbackValue(FakeProductState());
    registerFallbackValue(FakeProductEvent());

    final di = GetIt.instance;
    di.registerFactory(() => mockProductBloc);
  });

  setUp(() {
    mockProductBloc = MockProductBloc();
  });

  tearDown(() {
    mockProductBloc.close();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<ProductBloc>(
        create: (_) => mockProductBloc,
        child: child,
      ),
    );
  }

  testWidgets('should display loading indicator when state is loading',
      (WidgetTester tester) async {
    when(() => mockProductBloc.state).thenReturn(ProductLoading());

    await tester.pumpWidget(makeTestableWidget(const ProductsPage()));
    // Verify if CircularProgressIndicator is shown
    expect(find.byType(CircularProgressIndicator), equals(findsOneWidget));
  });

  testWidgets('should display products in table view when state has data',
      (WidgetTester tester) async {
    final products = [
      Product(id: '1', name: 'Product 1', harga: 10000),
      Product(id: '2', name: 'Product 2', harga: 20000),
    ];

    when(() => mockProductBloc.state).thenReturn(ProductHasData(products));

    await tester.pumpWidget(makeTestableWidget(ProductsPage()));

    // Verify if table columns and rows are shown
    expect(find.text('No'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Price'), findsOneWidget);

    // Verify product data
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Product 1'), findsOneWidget);
    expect(find.text('Rp10000'), findsOneWidget);

    expect(find.text('2'), findsOneWidget);
    expect(find.text('Product 2'), findsOneWidget);
    expect(find.text('Rp20000'), findsOneWidget);
  });

  testWidgets('should display error message when state is error',
      (WidgetTester tester) async {
    when(() => mockProductBloc.state)
        .thenReturn(ProductError('Error occurred'));

    await tester.pumpWidget(makeTestableWidget(ProductsPage()));

    // Verify if error message is shown
    expect(find.text('Error occurred'), findsOneWidget);
  });
}
