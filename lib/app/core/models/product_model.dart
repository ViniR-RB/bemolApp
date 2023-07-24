import 'dart:convert';

import 'package:bemol/app/core/entitys/product.dart';

class ProductModel extends Product {
  ProductModel(
      {required super.id,
      required super.title,
      required super.price,
      required super.description,
      required super.category,
      required super.image,
      required super.rate,
      required super.count});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rate': rate,
      'count': count,
    };
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      title: map['title'] as String,
      price: map['price'] as double,
      description: map['description'] as String,
      category: map['category'] as String,
      image: map['image'] as String,
      rate: map['rate'] as double,
      count: map['count'] as int,
    );
  }

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ProductModel.productFromModel(Product product) {
    return ProductModel(
        id: product.id,
        title: product.title,
        price: product.price,
        description: product.description,
        category: product.category,
        image: product.image,
        rate: product.rate,
        count: product.count);
  }
}
