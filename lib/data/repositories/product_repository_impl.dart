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
  Future<Either<Failure, List<Product>>> getProducts() async {
    // TODO: implement getCurrentWeather
    try {
      final result = await remoteDataSource.getProducts();
      return Right(
          (result as List<ProductModel>).map((model) => model).toList());
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
}
