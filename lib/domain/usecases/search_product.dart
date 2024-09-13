import 'package:dartz/dartz.dart';

import '../../data/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProducts {
  final ProductRepository repository;

  SearchProducts(this.repository);

  Future<Either<Failure, List<Product>>> call(String query) async {
    return repository.searchProducts(query);
  }
}
