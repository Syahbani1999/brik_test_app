import 'package:brik_test_app/domain/entities/product.dart';
import 'package:dartz/dartz.dart';

import '../../data/failure.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<Either<Failure, List<Product>>> execute() async {
    return await repository.getProducts();
  }
}
