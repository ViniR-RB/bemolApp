import '../../core/app_state.dart';
import '../../core/entitys/product.dart';

class HomeInitialState extends AppState {}

class HomeGetAllProductsState extends AppState {}

class HomeGetAllProductsLoadingState extends AppState {}

class HomeGetAllProductsLoadedState extends AppState {
  final List<Product> products;
  HomeGetAllProductsLoadedState({required this.products});
}

class HomeGetAllProductsErrorState extends AppState {
  final String message;
  HomeGetAllProductsErrorState({required this.message});
}
