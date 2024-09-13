part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductEmpty extends ProductState {}

final class ProductLoading extends ProductState {}

class ProductAdded extends ProductState {}

class ProductUpdated extends ProductState {}

class ProductDeleted extends ProductState {}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductHasData extends ProductState {
  final List<Product> result;
  const ProductHasData(this.result);

  @override
  List<Object?> get props => [result];
}
