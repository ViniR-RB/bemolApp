import 'package:bemol/app/core/entitys/product.dart';
import 'package:bemol/app/modules/home/home.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/app_state.dart';
import 'home_state.dart';

class HomeController {
  final HomeRepository _repository;
  final ValueNotifier<AppState> _state = ValueNotifier(HomeInitialState());
  final ValueNotifier<List<Product>> _productsFavorite = ValueNotifier([]);
  HomeController(this._repository);

  Future<void> getAllProducts() async {
    _emit(HomeGetAllProductsState());
    _emit(HomeGetAllProductsLoadingState());
    final result = await _repository.getAllProducts();
    result.fold((l) {
      _emit(HomeGetAllProductsErrorState(message: l.message));
    }, (r) => _emit(HomeGetAllProductsLoadedState(products: r)));
  }

  Future<void> getAllFavoritesProducts() async {
    final result = await _repository.getAllFavoritesProducts();
    result.fold(
        (l) => Modular.to.pushReplacementNamed('/error', arguments: l.message),
        (r) => _productsFavorite.value = r);
  }

  _emit(AppState state) {
    _state.value = state;
  }

  ValueNotifier<AppState> get notifier => _state;
  ValueNotifier<List<Product>> get productsFavorite => _productsFavorite;
}
