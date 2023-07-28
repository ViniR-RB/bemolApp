import 'package:bemol/app/core/entitys/product.dart';
import 'package:bemol/app/core/models/product_model.dart';
import 'package:bemol/app/modules/home/home.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/app_state.dart';
import 'home_state.dart';

class HomeController {
  final HomeRepository _repository;
  final ValueNotifier<AppState> _state = ValueNotifier(HomeInitialState());
  final ValueNotifier<List<Product>> _productsFavorite = ValueNotifier([]);
  final ValueNotifier<List<Product>> _products = ValueNotifier([]);
  final Map<Product, ValueNotifier<bool>> _isFavoriteMap = {};
  HomeController(this._repository);

  Future<void> getAllProducts() async {
    _emit(HomeGetAllProductsState());
    _emit(HomeGetAllProductsLoadingState());
    final result = await _repository.getAllProducts();
    result.fold((l) {
      _emit(HomeGetAllProductsErrorState(message: l.message));
    }, (r) {
      for (var product in r) {
        _isFavoriteMap[product] = ValueNotifier(false);
      }
      _products.value = r;
      _emit(HomeGetAllProductsLoadedState(products: r));
    });
  }

  void filterListProduct(String title) {
    if (title.isEmpty) {
      _emit(HomeGetAllProductsLoadedState(products: _products.value));
      return;
    }
    _emit(HomeGetAllProductsLoadedState(
        products: _products.value
            .where((element) =>
                element.title.toLowerCase().contains(title.toLowerCase()))
            .toList()));
  }

  Future<void> getAllFavoritesProducts() async {
    final result = await _repository.getAllFavoritesProducts();
    result.fold(
        (l) => Modular.to.pushReplacementNamed('/error', arguments: l.message),
        (r) => _productsFavorite.value = r);
  }

  Future<void> addOrRemoveFavoriteProduct(ProductModel product) async {
    final result = await _repository.addOrRemoveFavoriteProduct(product);
    result.fold(
        (l) => Modular.to.pushReplacementNamed('/error', arguments: l.message),
        (r) => r);
  }

  Future<bool> checkExistingProduct(ProductModel product) async {
    final result = await _repository.checkExistingProduct(product);
    bool isFavorite = false;
    result.fold(
        (l) => Modular.to.pushReplacementNamed('/error', arguments: l.message),
        (r) => isFavorite = r);
    return isFavorite;
  }

  ValueNotifier<bool> getProductFavoriteNotifier(Product product) {
    return _isFavoriteMap[product] ?? ValueNotifier(false);
  }

  _emit(AppState state) {
    _state.value = state;
  }

  ValueNotifier<AppState> get notifier => _state;
  ValueNotifier<List<Product>> get productsFavorite => _productsFavorite;
  ValueNotifier<List<Product>> get products => _products;
  Map<Product, ValueNotifier<bool>> get isFavoriteMap => _isFavoriteMap;
}
