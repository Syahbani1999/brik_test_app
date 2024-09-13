import 'package:brik_test_app/domain/entities/product.dart';
import 'package:dartz/dartz.dart';

import '../../data/failure.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts(int page, int pageSize);
  Future<Either<Failure, void>> addProduct(Product product);
  Future<Either<Failure, void>> updateProduct(Product product);
  Future<Either<Failure, void>> deleteProduct(String id);
  Future<Either<Failure, List<Product>>> searchProducts(String query);
}
