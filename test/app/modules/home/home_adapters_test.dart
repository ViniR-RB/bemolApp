import 'package:bemol/app/modules/home/home_adapters.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../constants/constants.dart';

void main() {
  group('Test in HomeAdapters', () {
    test('should must return a product that came from the API ', () async {
      final product = HomeAdapters.dynamicFromProduct(dynamicProductResponse);
      expect(product.id, 1);
      expect(product.title,
          'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops');
      expect(product.price, 109.95);
      expect(product.description,
          'Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday');
      expect(product.category, "men's clothing");
      expect(product.image,
          'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg');
      expect(product.rate, 3.9);
      expect(product.count, 120);
    });
    test('should must return a product that came from the API invalid format', () async {
      final product = HomeAdapters.dynamicFromProduct(dynamicProductResponseFormatInvalid);
      expect(product.id, 1);
      expect(product.title,
          'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops');
      expect(product.price, 109.95);
      expect(product.description,
          'Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday');
      expect(product.category, "men's clothing");
      expect(product.image,
          'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg');
      expect(product.rate, 3);
      expect(product.count, 120);
    });
  });
}
