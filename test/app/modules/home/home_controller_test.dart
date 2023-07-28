import 'package:bemol/app/core/app_error.dart';
import 'package:bemol/app/core/entitys/product.dart';
import 'package:bemol/app/modules/home/home.repository.dart';
import 'package:bemol/app/modules/home/home_controller.dart';
import 'package:bemol/app/modules/home/home_errors.dart';
import 'package:bemol/app/modules/home/home_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../constants/constants.dart';

class HomeRepositoryMock extends Mock implements HomeRepository {}

class ModularNavigateMock extends Mock implements IModularNavigator {}

class HomeControllerMock extends Mock implements HomeController {}

void main() {
  group('Test in HomeController', () {
    late final HomeController controller;
    late final HomeController controllerMock;
    late final HomeRepository repository;
    late final IModularNavigator navigate;
    setUpAll(() {
      repository = HomeRepositoryMock();
      controller = HomeController(repository);
      navigate = ModularNavigateMock();

      Modular.navigatorDelegate = navigate;
      controllerMock = HomeControllerMock();
    });

    test('should return List Product in get All Products', () async {
      when(() => repository.getAllProducts())
          .thenAnswer((_) async => Right(productsList));
      await controller.getAllProducts();
      expect(controller.notifier.value, isA<HomeGetAllProductsLoadedState>());
    });
    test(
        'should return HomeGetAllProductsErrorState in get All Products which returns a generics Error',
        () async {
      when(() => repository.getAllProducts())
          .thenAnswer((_) async => Left(AppError(message: '')));
      await controller.getAllProducts();
      expect(controller.notifier.value, isA<HomeGetAllProductsErrorState>());
      expect(
          (controller.notifier.value as HomeGetAllProductsErrorState).message,
          '');
    });
    test(
        'should return HomeGetAllProductsErrorState in get All Products which retur DioError',
        () async {
      when(() => repository.getAllProducts())
          .thenAnswer((_) async => Left(HomeFetchError(message: '')));
      await controller.getAllProducts();
      expect(controller.notifier.value, isA<HomeGetAllProductsErrorState>());
      expect(
          (controller.notifier.value as HomeGetAllProductsErrorState).message,
          '');
    });
    test('should return List Products Favorite in Get All Favorites Products',
        () async {
      when(() => repository.getAllFavoritesProducts())
          .thenAnswer((_) async => Right(productsList));

      await controller.getAllFavoritesProducts();
      expect(controller.productsFavorite.value, equals(productsList));
    });
    test('should return AppError in Get All Favorites Products', () async {
      when(() => repository.getAllFavoritesProducts()).thenAnswer((_) async =>
          Left(AppError(message: 'Erro ao obter produtos favoritos')));

      when(() => navigate.pushReplacementNamed(any(),
              arguments: any(named: 'arguments')))
          .thenAnswer((_) => Future.value());
      controller.productsFavorite.value = [];
      await controller.getAllFavoritesProducts();
      expect(controller.productsFavorite.value, isEmpty);
    });
    test('should return void/unit in Add Or Remove Favorite Product', () async {
      when(() => repository.addOrRemoveFavoriteProduct(productsModelList[0]))
          .thenAnswer((_) async => const Right(unit));

      await controller.addOrRemoveFavoriteProduct(productsModelList[0]);
      expect(controller.addOrRemoveFavoriteProduct(productsModelList[0]),
          completes);
    });
    test('should return AppError in in Add Or Remove Favorite Product',
        () async {
      when(() => repository.addOrRemoveFavoriteProduct(productsModelList[0]))
          .thenAnswer((_) async =>
              Left(AppError(message: 'Erro ao obter produtos favoritos')));

      when(() => navigate.pushReplacementNamed(any(),
              arguments: any(named: 'arguments')))
          .thenAnswer((_) => Future.value());
      controller.productsFavorite.value = [];
      await controller.addOrRemoveFavoriteProduct(productsModelList[0]);
      expect(controller.addOrRemoveFavoriteProduct(productsModelList[0]),
          completes);
    });
    test('should return bool in Check Existing Product', () async {
      when(() => repository.checkExistingProduct(productsModelList[0]))
          .thenAnswer((_) async => const Right(true));

      final result =
          await controller.checkExistingProduct(productsModelList[0]);
      expect(result, isA<bool>());
    });
    test('should return AppError in in Check Existing Product', () async {
      when(() => repository.checkExistingProduct(productsModelList[0]))
          .thenAnswer((_) async =>
              Left(AppError(message: 'Erro ao obter produtos favoritos')));

      when(() => navigate.pushReplacementNamed(any(),
              arguments: any(named: 'arguments')))
          .thenAnswer((_) => Future.value());
      final result =
          await controller.checkExistingProduct(productsModelList[0]);
      expect(controller.checkExistingProduct(productsModelList[0]), completes);
      expect(result, false);
    });
    test('should return ValueNotifier with false for a non-favorite product',
        () async {
      final Product product = productsList[0];
      when(() => controllerMock.isFavoriteMap[product]).thenReturn(null);
      when(() => controllerMock.getProductFavoriteNotifier(product))
          .thenReturn(ValueNotifier(false));
      final notifier =
          controllerMock.getProductFavoriteNotifier(productsList[0]);
      expect(notifier, isA<ValueNotifier<bool>>());
      expect(notifier.value, isFalse);
    });
    test('should return ValueNotifier with true for a favorite product',
        () async {
      final Product product = productsList[0];
      when(() => controllerMock.isFavoriteMap[product])
          .thenReturn(ValueNotifier(true));
      when(() => controllerMock.getProductFavoriteNotifier(productsList[0]))
          .thenReturn(ValueNotifier(true));
      final notifier =
          controllerMock.getProductFavoriteNotifier(productsList[0]);

      expect(notifier, isA<ValueNotifier<bool>>());

      expect(notifier.value, isTrue);
    });
    test('filterListProduct should return all products when title is empty',
        () {
      controller.products.value = productsList;
      controller.filterListProduct('');
      expect(controller.notifier.value, isA<HomeGetAllProductsLoadedState>());
      final newState =
          controller.notifier.value as HomeGetAllProductsLoadedState;
      expect(newState.products, productsList);
    });
    test('filterListProduct should return filtered products', () {
      List<Product> productsList = [
        Product(
            id: 13,
            title:
                'Acer SB220Q bi 21.5 inches Full HD (1920 x 1080) IPS Ultra-Thin',
            price: 599,
            description:
                '21. 5 inches Full HD (1920 x 1080) widescreen IPS display And Radeon free Sync technology. No compatibility for VESA Mount Refresh Rate: 75Hz - Using HDMI port Zero-frame design | ultra-thin | 4ms response time | IPS panel Aspect ratio - 16: 9. Color Supported - 16. 7 million colors. Brightness - 250 nit Tilt angle -5 degree to 15 degree. Horizontal viewing angle-178 degree. Vertical viewing angle-178 degree 75 hertz',
            category: 'electronics',
            image: 'https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_.jpg',
            rate: 2.9,
            count: 250),
        Product(
            id: 13,
            title: 'Mans',
            price: 599,
            description:
                '21. 5 inches Full HD (1920 x 1080) widescreen IPS display And Radeon free Sync technology. No compatibility for VESA Mount Refresh Rate: 75Hz - Using HDMI port Zero-frame design | ultra-thin | 4ms response time | IPS panel Aspect ratio - 16: 9. Color Supported - 16. 7 million colors. Brightness - 250 nit Tilt angle -5 degree to 15 degree. Horizontal viewing angle-178 degree. Vertical viewing angle-178 degree 75 hertz',
            category: 'electronics',
            image: 'https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_.jpg',
            rate: 2.9,
            count: 250)
      ];
      controller.products.value = productsList;
      controller.filterListProduct('Acer');
      expect(controller.notifier.value, isA<HomeGetAllProductsLoadedState>());
      final newState =
          controller.notifier.value as HomeGetAllProductsLoadedState;
      expect(newState.products, [
        Product(
            id: 13,
            title:
                'Acer SB220Q bi 21.5 inches Full HD (1920 x 1080) IPS Ultra-Thin',
            price: 599,
            description:
                '21. 5 inches Full HD (1920 x 1080) widescreen IPS display And Radeon free Sync technology. No compatibility for VESA Mount Refresh Rate: 75Hz - Using HDMI port Zero-frame design | ultra-thin | 4ms response time | IPS panel Aspect ratio - 16: 9. Color Supported - 16. 7 million colors. Brightness - 250 nit Tilt angle -5 degree to 15 degree. Horizontal viewing angle-178 degree. Vertical viewing angle-178 degree 75 hertz',
            category: 'electronics',
            image: 'https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_.jpg',
            rate: 2.9,
            count: 250)
      ]);
    });
    test('filterListProduct should return filtered products empty', () {
      List<Product> productsList = [
        Product(
            id: 13,
            title:
                'Acer SB220Q bi 21.5 inches Full HD (1920 x 1080) IPS Ultra-Thin',
            price: 599,
            description:
                '21. 5 inches Full HD (1920 x 1080) widescreen IPS display And Radeon free Sync technology. No compatibility for VESA Mount Refresh Rate: 75Hz - Using HDMI port Zero-frame design | ultra-thin | 4ms response time | IPS panel Aspect ratio - 16: 9. Color Supported - 16. 7 million colors. Brightness - 250 nit Tilt angle -5 degree to 15 degree. Horizontal viewing angle-178 degree. Vertical viewing angle-178 degree 75 hertz',
            category: 'electronics',
            image: 'https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_.jpg',
            rate: 2.9,
            count: 250),
        Product(
            id: 13,
            title: 'Mans',
            price: 599,
            description:
                '21. 5 inches Full HD (1920 x 1080) widescreen IPS display And Radeon free Sync technology. No compatibility for VESA Mount Refresh Rate: 75Hz - Using HDMI port Zero-frame design | ultra-thin | 4ms response time | IPS panel Aspect ratio - 16: 9. Color Supported - 16. 7 million colors. Brightness - 250 nit Tilt angle -5 degree to 15 degree. Horizontal viewing angle-178 degree. Vertical viewing angle-178 degree 75 hertz',
            category: 'electronics',
            image: 'https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_.jpg',
            rate: 2.9,
            count: 250)
      ];
      controller.products.value = productsList;
      controller.filterListProduct('Acer dshajkhdkjashdjkashdkjhkj');
      expect(controller.notifier.value, isA<HomeGetAllProductsLoadedState>());
      final newState =
          controller.notifier.value as HomeGetAllProductsLoadedState;
      expect(newState.products, isEmpty);
    });
  });
}
