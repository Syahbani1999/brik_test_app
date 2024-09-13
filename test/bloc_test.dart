import 'package:bloc_test/bloc_test.dart';
import 'package:brik_test_app/data/failure.dart';
import 'package:brik_test_app/domain/usecases/add_product.dart';
import 'package:brik_test_app/domain/usecases/delete_product.dart';
import 'package:brik_test_app/domain/usecases/search_product.dart';
import 'package:brik_test_app/domain/usecases/update_product.dart';
import 'package:brik_test_app/presentation/bloc/product_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brik_test_app/domain/repositories/product_repository.dart';

import 'package:brik_test_app/domain/entities/product.dart';
import 'package:brik_test_app/domain/usecases/get_products.dart';
import 'package:dartz/dartz.dart';

// Mock class for ProductRepository
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository mockProductRepository;
  late ProductBloc productBloc;

  setUp(() {
    mockProductRepository = MockProductRepository();
    productBloc = ProductBloc(
        getProducts: GetProducts(mockProductRepository),
        addProduct: AddProduct(mockProductRepository),
        updateProduct: UpdateProduct(mockProductRepository),
        deleteProduct: DeleteProduct(mockProductRepository),
        searchProduct: SearchProducts(mockProductRepository));
  });

  tearDown(() {
    productBloc.close();
  });

  // Testing LoadProducts Event
  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoading, ProductLoaded] when LoadProducts is added and products are fetched successfully',
    build: () {
      // Set up mock behavior
      when(() => mockProductRepository.getProducts(1, 5)).thenAnswer(
          (_) async => Right(
              [Product(id: 'aksd87asdh', name: 'Test Product', harga: 100)]));
      return productBloc;
    },
    act: (bloc) => bloc.add(ProductsLoadEvent(page: 1, pageSize: 5)),
    expect: () => [
      ProductLoading(),
      ProductHasData(
          [Product(id: 'aksd87asdh', name: 'Test Product', harga: 100)])
    ],
    verify: (_) {
      verify(() => mockProductRepository.getProducts(1, 5)).called(1);
    },
  );

  // Testing Error State
  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoading, ProductError] when LoadProducts fails',
    build: () {
      // Set up mock behavior to return failure
      when(() => mockProductRepository.getProducts(1, 5)).thenAnswer(
          (_) async => Left(ServerFailure('Failed to fetch products')));
      return productBloc;
    },
    act: (bloc) => bloc.add(ProductsLoadEvent(page: 1, pageSize: 5)),
    expect: () => [ProductLoading(), ProductError('Failed to fetch products')],
    verify: (_) {
      verify(() => mockProductRepository.getProducts(1, 5)).called(1);
    },
  );
}
