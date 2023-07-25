import 'package:bemol/app/core/app_error.dart';
import 'package:bemol/app/core/services/shared_prefrence.dart';
import 'package:bemol/app/modules/home/home_errors.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/entitys/product.dart';
import 'home_adapters.dart';

abstract class HomeRepository {
  Future<Either<AppError, List<Product>>> getAllProducts();
  Future<Either<AppError, List<Product>>> getAllFavoritesProducts();
}

class HomeRepositoryImpl implements HomeRepository {
  final Dio dio;
  final SharedPreferencesApp preferences;
  HomeRepositoryImpl({required this.dio, required this.preferences});
  @override
  Future<Either<AppError, List<Product>>> getAllProducts() async {
    try {
      final response = await dio.get('/products/');
      final data = response.data as List<dynamic>;
      final List<Product> products =
          data.map(HomeAdapters.dynamicFromProduct).toList();
      return Right(products);
    } on DioException catch (error) {
      return Left(HomeFetchError(
          message: error.message ?? 'Houve um Error Inesperado'));
    } catch (error) {
      return Left(AppError(message: error.toString()));
    }
  }

  @override
  Future<Either<AppError, List<Product>>> getAllFavoritesProducts() async {
    try {
      final List<Product> response = await preferences.getProductListFavorite();
      return Right(response);
    } catch (error) {
      return Left(AppError(message: error.toString()));
    }
  }
}
