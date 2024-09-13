part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class ProductsLoadEvent extends ProductEvent {
  final int page;
  final int pageSize;

  ProductsLoadEvent({required this.page, required this.pageSize});
}

class ProductAddEvent extends ProductEvent {
  final Product product;
  const ProductAddEvent(this.product);
  @override
  List<Object?> get props => [product];
}

class ProductUpdateEvent extends ProductEvent {
  final Product product;
  const ProductUpdateEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductDeleteEvent extends ProductEvent {
  final String productId;
  const ProductDeleteEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class SearchProductsEvent extends ProductEvent {
  final String query;

  SearchProductsEvent(this.query);
}
