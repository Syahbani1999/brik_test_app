import 'dart:io';

import 'package:brik_test_app/domain/entities/product.dart';
import 'package:brik_test_app/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

import '../datasources/remote_product_source.dart';
import '../exception.dart';
import '../failure.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource remoteDataSource;
  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts(
      int page, int pageSize) async {
    // TODO: implement getCurrentWeather
    try {
      final result = await remoteDataSource.getProducts();
      // Calculate start and end index for pagination
      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;

      // Paginate the products
      final paginatedProducts = result.sublist(
        startIndex,
        endIndex > result.length ? result.length : endIndex,
      );
      return Right(paginatedProducts);
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(Product product) async {
    try {
      await remoteDataSource.addProduct(ProductModel.fromEntity(product));
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Failed to add product $error'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    try {
      await remoteDataSource.updateProduct(ProductModel.fromEntity(product));
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Failed to update product $error'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Failed to delete product'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      final products = await remoteDataSource.getProducts();
      final filteredProducts = products.where((product) {
        final nameLower = product.name!.toLowerCase();
        final skuLower = product.sku!.toLowerCase();
        final descriptionLower = product.description!.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) ||
            skuLower.contains(searchLower) ||
            descriptionLower.contains(searchLower);
      }).toList();
      return Right(filteredProducts);
    } catch (e) {
      return Left(ServerFailure('Failed'));
    }
  }
}
