import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';

class SharedPreferencesApp {
  final Future<SharedPreferences> pref;
  SharedPreferencesApp({required this.pref});

  Future<void> addOrRemoveProductInShared(ProductModel product) async {
    final List<ProductModel> productList = await getProductListFavorite();
    if (productList.any((products) => products.id == product.id)) {
      productList.removeWhere((products) => products.id == product.id);
    } else {
      productList.add(product);
    }
    await saveProductListInShared(productList);
  }

  Future<List<ProductModel>> getProductListFavorite() async {
    SharedPreferences prefs = await pref;
    String productJson =  prefs.getString('productListFavotire') ?? '';
    if (productJson.isNotEmpty) {
      List<dynamic> productMapList = json.decode(productJson);
      List<ProductModel> productList = productMapList
          .map((productMap) => ProductModel.fromMap(productMap))
          .toList();
      return productList;
    } else {
      List<ProductModel> productList = [];
      return productList;
    }
  }

  Future<void> saveProductListInShared(List<ProductModel> productList) async {
    SharedPreferences prefs = await pref;
    List<Map<String, dynamic>> productMapList =
        productList.map((product) => product.toMap()).toList();
    String productJson = json.encode(productMapList);
    prefs.setString('productListFavotire', productJson);
  }

  Future<bool> checkExistingProduct(ProductModel product) async {
    final List<ProductModel> productList = await getProductListFavorite();
    return productList.any((products) => products.id == product.id);
  }
}
