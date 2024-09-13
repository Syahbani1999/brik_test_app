import 'dart:convert';

import 'package:brik_test_app/data/models/product_model.dart';
import 'package:brik_test_app/domain/entities/product.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';
import '../exception.dart';

abstract class RemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  RemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(Uri.parse(Urls.crudProducts()));
    if (response.statusCode == 200) {
      final List<dynamic> products = json.decode(response.body);
      return products.map((product) => ProductModel.fromJson(product)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    await client.post(
      Uri.parse(Urls.crudProducts()),
      body: json.encode(product.toJson()),
      headers: {'Content-Type': 'application/json'},
    ).then((value) {
      print('response : ${value.statusCode}');
    });
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await client
        .put(
      Uri.parse(Urls.crudProducts() + '/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    )
        .then((value) {
      print('response : ${value.statusCode}');
    });
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response =
        await client.delete(Uri.parse(Urls.crudProducts() + '/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
