import 'package:bemol/app/core/app_error.dart';
import 'package:bemol/app/core/entitys/product.dart';
import 'package:bemol/app/core/models/product_model.dart';
import 'package:bemol/app/core/services/shared_prefrence.dart';
import 'package:bemol/app/modules/home/home.repository.dart';
import 'package:bemol/app/modules/home/home_errors.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../constants/constants.dart';

class DioMock extends Mock implements Dio {}

class SharedPreferencesAppMock extends Mock implements SharedPreferencesApp {}

void main() {
  late final HomeRepository repository;
  late final Dio dio;
  late final SharedPreferencesApp preferences;

  setUpAll(() {
    dio = DioMock();
    preferences = SharedPreferencesAppMock();
    repository = HomeRepositoryImpl(dio: dio, preferences: preferences);
  });
  group('Test in HomeRepository', () {
    test('should  return List the Product', () async {
      final response = Response<dynamic>(
          data: listProducts,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''));
      when(() => dio.get(any())).thenAnswer((_) async => response);
      final result = await repository.getAllProducts();
      expect(result.fold(id, id), isA<List<Product>>());
    });
    test('should return HomeFetchError when to catch DioException error ',
        () async {
      final dioException =
          DioException(requestOptions: RequestOptions(path: ''));
      when(() => dio.get(any())).thenThrow(dioException);
      final result = await repository.getAllProducts();
      expect(result.fold(id, id), isA<HomeFetchError>());
    });
    test('should return AppError when to catch any Exception', () async {
      final Exception exception = Exception('');
      when(() => dio.get(any())).thenThrow(exception);
      final result = await repository.getAllProducts();
      expect(result.fold(id, id), isA<AppError>());
    });
    test('should  return List<ProductModel> in get all favorite products',
        () async {
      when(() => preferences.getProductListFavorite())
          .thenAnswer((_) async => productsModelList);
      final result = await repository.getAllFavoritesProducts();
      expect(result.fold(id, id), isA<List<ProductModel>>());
    });
    test('should me return AppError in get all favorite products', () async {
      final Exception exception = Exception('');
      when(() => preferences.getProductListFavorite()).thenThrow(exception);
      final result = await repository.getAllFavoritesProducts();
      expect(result.fold(id, id), isA<AppError>());
    });
    test('should return void in Add Or Remove Favorite Product', () async {
      final ProductModel productModel = productsModelList[0];
      when(() => preferences.addOrRemoveProductInShared(productModel))
          .thenAnswer((_) => Future.value());
      final result = await repository.addOrRemoveFavoriteProduct(productModel);
      expect(result, const Right(unit));
    });
    test('should return AppError in Add Or Remove Favorite Product', () async {
      final ProductModel productModel = productsModelList[0];
      when(() => preferences.addOrRemoveProductInShared(productModel))
          .thenThrow(Exception('Error'));
      final result = await repository.addOrRemoveFavoriteProduct(productModel);
      expect(result.fold(id, id), isA<AppError>());
    });
    test('should return bool in Check Existing Product', () async {
      final ProductModel productModel = productsModelList[0];
      when(() => preferences.checkExistingProduct(productModel))
          .thenAnswer((_) => Future.value(true));
      final result = await repository.checkExistingProduct(productModel);
      expect(result.fold(id, id), isA<bool>());
    });
    test('should return AppError in Check Existing Product', () async {
      final ProductModel productModel = productsModelList[0];
      when(() => preferences.checkExistingProduct(productModel))
          .thenThrow(Exception('Error'));
      final result = await repository.checkExistingProduct(productModel);
      expect(result.fold(id, id), isA<AppError>());
    });
  });
}
