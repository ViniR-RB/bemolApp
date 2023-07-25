import 'dart:convert';

import 'package:bemol/app/core/services/shared_prefrence.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';

class SharedPreferencesMock extends Mock implements SharedPreferences {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('SharedPreferencesApp test', () {
    late SharedPreferencesApp preferencesApp;
    late Future<SharedPreferences> mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = Future.value(MockSharedPreferences());
      preferencesApp = SharedPreferencesApp(pref: mockSharedPreferences);
    });

    test('Add product in shared preferences', () async {
      // Defina a lista inicial de produtos favoritos vazia
      final shared = await mockSharedPreferences;
      when(() => shared.getString('productListFavotire')).thenReturn('');

      // Simule a chamada do método addOrRemoveProductInShared com um produto específico
      final productToAdd = productsModelList[0];

      verifyNever(() => shared.getString('productListFavotire'));

      List<Map<String, dynamic>> productMapList =
          productsModelList.map((product) => product.toMap()).toList();
      String productJson = json.encode(productMapList);

      when(() => shared.setString('productListFavotire', productJson))
          .thenAnswer((_) async => true);
      verifyNever(() => shared.setString('productListFavotire', productJson));
      await preferencesApp.addOrRemoveProductInShared(productToAdd);
      verify(() => shared.setString('productListFavotire', productJson))
          .called(1);
      final updatedProductList = await preferencesApp.getProductListFavorite();
      expect(updatedProductList.any((product) => product.id == productToAdd.id),
          false);
    });
    test('Remove product in shared preferences', () async {
      // Defina a lista inicial de produtos favoritos contendo o produto que você deseja remover

      final shared = await mockSharedPreferences;
      when(() => shared.getString('productListFavotire'))
          .thenReturn(productListJson);
      verifyNever(() => shared.getString('productListFavotire'));
      // Simule a chamada do método addOrRemoveProductInShared com um produto específico
      final productToRemove = productsModelList[0];

      // Verifique se o produto está na lista antes da remoção (opcional)
      final initialProductList = await preferencesApp.getProductListFavorite();
      expect(
          initialProductList.any((product) => product.id == productToRemove.id),
          true);
      print('Passou');
      // Execute a função addOrRemoveProductInShared
      when(() => shared.setString('productListFavotire', '[]'))
          .thenAnswer((_) async => true);
      verifyNever(() => shared.setString('productListFavotire', '[]'));
      await preferencesApp.addOrRemoveProductInShared(productToRemove);
      print('Passou');
      // Verifique se o produto foi removido da lista de produtos favoritos
      final updatedProductList = await preferencesApp.getProductListFavorite();
      expect(
          updatedProductList.any((product) => product.id == productToRemove.id),
          true);
    });
    test('check if exists product in shared preferences', () async {
      final shared = await mockSharedPreferences;
      when(() => shared.getString('productListFavotire'))
          .thenReturn(productListJson);

      // Simule a chamada do método addOrRemoveProductInShared com um produto específico
      final productToAdd = productsModelList[0];
      verifyNever(() => shared.getString('productListFavotire'));
      final result = await preferencesApp.checkExistingProduct(productToAdd);
      expect(result, true);
    });
  });
}
