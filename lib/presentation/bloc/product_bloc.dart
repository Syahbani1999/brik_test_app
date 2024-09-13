import 'package:bloc/bloc.dart';
import 'package:brik_test_app/domain/entities/product.dart';
import 'package:brik_test_app/domain/usecases/get_products.dart';
import 'package:brik_test_app/domain/usecases/search_product.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/update_product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final AddProduct addProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;
  final SearchProducts searchProduct;
  ProductBloc({
    required this.getProducts,
    required this.addProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.searchProduct,
  }) : super(ProductEmpty()) {
    // load product
    on<ProductsLoadEvent>((event, emit) async {
      try {
        emit(ProductLoading());
        final result = await getProducts.execute(event.page, event.pageSize);

        result.fold(
          (failure) => emit(ProductError(failure.message)),
          (data) => emit(ProductHasData(data)),
        );
      } catch (e) {
        rethrow;
      }
    });

    // search product
    on<SearchProductsEvent>((event, emit) async {
      try {
        emit(ProductLoading());
        final result = await searchProduct.call(event.query);

        result.fold(
          (failure) => emit(ProductError(failure.message)),
          (data) => emit(ProductHasData(data)),
        );
      } catch (e) {
        rethrow;
      }
    });
    // add product
    on<ProductAddEvent>((event, emit) async {
      try {
        emit(ProductLoading());

        final result = await addProduct(event.product);
        result.fold((failure) => emit(ProductError(failure.message)), (_) {
          add(ProductsLoadEvent(page: 1, pageSize: 5));
          emit(ProductAdded());
        });
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    });

    // update product
    on<ProductUpdateEvent>((event, emit) async {
      try {
        emit(ProductLoading());

        final result = await updateProduct(event.product);
        result.fold((failure) => emit(ProductError(failure.message)), (_) {
          add(ProductsLoadEvent(page: 1, pageSize: 5));
          emit(ProductUpdated());
        });
      } catch (e) {
        rethrow;
      }
    });

    // delete product

    on<ProductDeleteEvent>((event, emit) async {
      try {
        emit(ProductLoading());

        final result = await deleteProduct(event.productId);
        result.fold((failure) => emit(ProductError(failure.message)), (_) {
          add(ProductsLoadEvent(page: 1, pageSize: 5));
          emit(ProductDeleted());
        });
      } catch (e) {
        rethrow;
      }
    });
  }
}
