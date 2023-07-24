import 'package:bemol/app/core/entitys/product.dart';

abstract class HomeAdapters {
  static Product dynamicFromProduct(dynamic data) {
    return Product(
        id: data['id'],
        title: data['title'],
        price: _convertToDouble(data['price']),
        description: data['description'],
        category: data['category'],
        image: data['image'],
        rate: _convertToDouble(data['rating']['rate']),
        count: _convertToInt(data['rating']['count']));
  }

  static double _convertToDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      return 0.0; // Valor padrão ou outro tratamento apropriado
    }
  }

  static int _convertToInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else {
      return 0; // Valor padrão ou outro tratamento apropriado
    }
  }
}
