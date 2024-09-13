import 'package:brik_test_app/data/repositories/product_repository_impl.dart';
import 'package:brik_test_app/domain/repositories/product_repository.dart';
import 'package:brik_test_app/domain/usecases/get_products.dart';
import 'package:brik_test_app/domain/usecases/search_product.dart';
import 'package:brik_test_app/presentation/bloc/product_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/remote_product_source.dart';
import 'domain/usecases/add_product.dart';
import 'domain/usecases/delete_product.dart';
import 'domain/usecases/update_product.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(() => ProductBloc(
        addProduct: locator(),
        deleteProduct: locator(),
        getProducts: locator(),
        updateProduct: locator(),
        searchProduct: locator(),
      ));

  // usecase
  locator.registerLazySingleton(() => GetProducts(locator()));
  locator.registerLazySingleton(() => AddProduct(locator()));
  locator.registerLazySingleton(() => UpdateProduct(locator()));
  locator.registerLazySingleton(() => DeleteProduct(locator()));
  locator.registerLazySingleton(() => SearchProducts(locator()));

  //repo
  locator.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(remoteDataSource: locator()));

  // data source
  locator.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(client: locator()));

  // external
  locator.registerLazySingleton(() => http.Client());
}
