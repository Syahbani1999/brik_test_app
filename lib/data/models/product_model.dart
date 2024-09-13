import 'package:brik_test_app/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    String? id,
    int? categoryId,
    String? categoryName,
    String? sku,
    String? name,
    String? description,
    int? weight,
    int? width,
    int? length,
    int? height,
    String? image,
    int? harga,
  }) : super(
          id: id,
          categoryId: categoryId,
          categoryName: categoryName,
          sku: sku,
          name: name,
          description: description,
          weight: weight,
          width: width,
          length: length,
          height: height,
          image: image,
          harga: harga,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        categoryId: json['CategoryId'],
        categoryName: json['categoryName'],
        description: json['description'],
        harga: json['harga'],
        height: json['height'],
        id: json['_id'],
        image: json['image'],
        length: json['length'],
        name: json['name'],
        sku: json['sku'],
        weight: json['weight'],
        width: json['width'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['CategoryId'] = categoryId;
    data['categoryName'] = categoryName;
    data['sku'] = sku;
    data['name'] = name;
    data['description'] = description;
    data['weight'] = weight;
    data['width'] = width;
    data['length'] = length;
    data['height'] = height;
    data['image'] = image;
    data['harga'] = harga;
    return data;
  }

  Product toEntity() => Product(
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      harga: harga,
      height: height,
      id: id,
      image: image,
      length: length,
      name: name,
      sku: sku,
      weight: weight,
      width: width);

  // Method to convert domain entity Product to ProductModel
  static ProductModel fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      categoryId: product.categoryId,
      categoryName: product.categoryName,
      sku: product.sku,
      name: product.name,
      description: product.description,
      weight: product.weight,
      width: product.width,
      length: product.length,
      height: product.height,
      image: product.image,
      harga: product.harga,
    );
  }

  @override
  List<Object?> get props => [
        categoryId,
        categoryName,
        description,
        harga,
        height,
        id,
        image,
        length,
        name,
        sku,
        weight,
        width,
      ];
}
