import 'package:bemol/app/core/app_error.dart';
import 'package:bemol/app/core/entitys/product.dart';
import 'package:bemol/app/modules/home/home.repository.dart';
import 'package:bemol/app/modules/home/home_errors.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../constants/constants.dart';

class DioMock extends Mock implements Dio {}

void main() {
  late final HomeRepository repository;
  late final Dio dio;

  setUp(() {
    dio = DioMock();
    repository = HomeRepositoryImpl(dio: dio);
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
    test('should return AppError when to catch any Exception ', () async {
      final Exception exception = Exception('');
      when(() => dio.get(any())).thenThrow(exception);
      final result = await repository.getAllProducts();
      expect(result.fold(id, id), isA<AppError>());
    });
  });
}
