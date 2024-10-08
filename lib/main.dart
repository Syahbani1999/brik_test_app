import 'package:brik_test_app/presentation/pages/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection.dart' as di;
import 'presentation/bloc/product_bloc.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (context) => di.locator<ProductBloc>()
            ..add(ProductsLoadEvent(page: 1, pageSize: 5)),
        ),
      ],
      child: MaterialApp(
        title: 'Klontong ',
        theme: ThemeData(
          useMaterial3: false,
        ),
        debugShowCheckedModeBanner: false,
        home: ProductsPage(),
      ),
    );
  }
}
