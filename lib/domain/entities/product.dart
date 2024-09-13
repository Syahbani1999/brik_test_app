import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    this.categoryId,
    this.categoryName,
    this.description,
    this.harga,
    this.height,
    this.id,
    this.image,
    this.length,
    this.name,
    this.sku,
    this.weight,
    this.width,
  });

  final String? id;
  final int? categoryId;
  final String? categoryName;
  final String? sku;
  final String? name;
  final String? description;
  final int? weight;
  final int? width;
  final int? length;
  final int? height;
  final String? image;
  final int? harga;

  @override
  // TODO: implement props
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
