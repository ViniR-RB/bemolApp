import 'package:bemol/app/modules/home/home.repository.dart';
import 'package:bemol/app/modules/home/home_controller.dart';
import 'package:bemol/app/modules/home/pages/error_page.dart';
import 'package:bemol/app/modules/home/pages/product_details.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_configure.dart';
import 'core/services/shared_prefrence.dart';
import 'modules/home/pages/favorite_products_page.dart';
import 'modules/home/pages/home_page.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => Dio(BaseOptions(baseUrl: AppConfigure.apiUrl))),
        Bind<HomeRepository>(
            (i) => HomeRepositoryImpl(dio: i.get(), preferences: i.get())),
        Bind((i) => HomeController(i.get())),
        Bind<Future<SharedPreferences>>(
          (i) => SharedPreferences.getInstance(),
        ),
        Bind.lazySingleton((i) => SharedPreferencesApp(pref: i.get()))
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute,
            child: (context, args) => const HomePage()),
        ChildRoute('/detail',
            child: (context, args) => ProductDetailsPage(
                  product: args.data,
                )),
        ChildRoute('/favoriteProducts',
            child: (context, args) => const FavoriteProductsPage()),
        ChildRoute('/error',
            child: (context, args) => ErrorPage(
                  message: args.data,
                )),
      ];
}
