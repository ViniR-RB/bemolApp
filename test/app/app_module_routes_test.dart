import 'package:bemol/app/app_module.dart';
import 'package:bemol/app/app_widget.dart';
import 'package:bemol/app/core/models/product_model.dart';
import 'package:bemol/app/core/services/shared_prefrence.dart';
import 'package:bemol/app/modules/home/home.repository.dart';
import 'package:bemol/app/modules/home/home_controller.dart';
import 'package:bemol/app/modules/home/home_state.dart';
import 'package:bemol/app/modules/home/pages/home_page.dart';
import 'package:bemol/app/modules/home/widgets/card_product.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart' as modular;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:modular_test/modular_test.dart' as modular_test;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

class ModularNavigateMock extends Mock implements modular.IModularNavigator {}

class DioMock extends Mock implements Dio {}

class HomeRepositoryMock extends Mock implements HomeRepository {}

class HomeControllerMock extends Mock implements HomeController {}

class SharedPreferencesMock extends Mock implements Future<SharedPreferences> {}

class SharedPreferencesAppMock extends Mock implements SharedPreferencesApp {}

void main() {
  late Dio dio;
  late HomeRepository repository;
  late HomeController controller;
  late Future<SharedPreferences> preferences;
  late SharedPreferencesApp preferencesApp;
  late modular.IModularNavigator navigate;

  group('not use network', () {
    setUpAll(() {
      dio = DioMock();
      repository = HomeRepositoryMock();
      controller = HomeControllerMock();
      preferences = SharedPreferencesMock();
      preferencesApp = SharedPreferencesAppMock();
      navigate = ModularNavigateMock();
      modular.Modular.navigatorDelegate = navigate;
    });
    setUp(() {
      modular_test.initModule(AppModule(), replaceBinds: [
        modular.Bind.instance<Dio>(dio),
        modular.Bind.instance<HomeRepository>(repository),
        modular.Bind.instance<HomeController>(controller),
        modular.Bind.instance<Future<SharedPreferences>>(preferences),
        modular.Bind.instance<SharedPreferencesApp>(preferencesApp),
      ]);
      dotenv.load().then((value) => value);
    });
    testWidgets('should navigate to HomePage when initial route is accessed',
        (tester) async {
      await tester.pumpWidget((modular.ModularApp(
        module: AppModule(),
        child: const AppWidget(),
      )));
      when(() => navigate.navigate(modular.Modular.initialRoute))
          .thenAnswer((_) => Future.value());
      when(() => controller.notifier)
          .thenReturn(ValueNotifier(HomeInitialState()));
      when(() => controller.getAllProducts()).thenAnswer((_) => Future.value());
      await tester.pumpAndSettle();
      final home = find.byType(HomePage);
      expect(home, findsOneWidget);
      verifyNever(() => navigate.navigate(modular.Modular.initialRoute));
    });
  });
  tearDown(() {
    dio.close();
    repository;
    controller;
    preferences;
    preferencesApp;
    navigate;
    modular.Modular.navigatorDelegate;
  });
  group('use network', () {
    setUpAll(() {
      dio = DioMock();
      repository = HomeRepositoryMock();
      controller = HomeControllerMock();
      preferences = SharedPreferencesMock();
      preferencesApp = SharedPreferencesAppMock();
      navigate = ModularNavigateMock();
      modular.Modular.navigatorDelegate = navigate;
    });
    setUp(() {
      modular.Modular.navigatorDelegate = navigate;
      modular_test.initModule(AppModule(), replaceBinds: [
        modular.Bind.instance<Dio>(dio),
        modular.Bind.instance<HomeRepository>(repository),
        modular.Bind.instance<HomeController>(controller),
        modular.Bind.instance<Future<SharedPreferences>>(preferences),
        modular.Bind.instance<SharedPreferencesApp>(preferencesApp),
      ]);
      dotenv.load().then((value) => value);
    });
    testWidgets(
        'should navigate to ProductDetailsPage when /detail is accessed',
        (tester) async {
      // Simule o carregamento de imagens de rede com mocktail_image_network
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          modular.ModularApp(
            module: AppModule(),
            child: const AppWidget(),
          ),
        );

        /* Chama a HomePage */
        when(() => navigate.navigate(any())).thenAnswer((_) {});
        when(() => controller.getAllProducts())
            .thenAnswer((_) => Future.value());
        verifyNever(() => controller.getAllProducts());
        final ProductModel productModel = productsModelList[0];
        when(() => controller.checkExistingProduct(productModel))
            .thenAnswer((_) async => true);
        when(() => controller.notifier).thenReturn(ValueNotifier(
            HomeGetAllProductsLoadedState(products: productsList)));
        when(() => controller.getProductFavoriteNotifier(productsList[0]))
            .thenReturn(ValueNotifier(true));

        // Atualize o widget e aguarde o término do carregamento
        await tester.pumpAndSettle();
        final cardProductFinder = find.byType(CardProduct);
        expect(cardProductFinder, findsWidgets);
        when(() =>
                navigate.pushNamed(any(), arguments: any(named: 'arguments')))
            .thenAnswer((_) => Future.value());
        await tester.tap(cardProductFinder);
        await tester.pumpAndSettle();
        verify(() => navigate.pushNamed('/detail', arguments: productsList[0]))
            .called(1);
      });
    });

    testWidgets(
        'should navigate to FavoriteProductsPage when /favoriteProducts is accessed',
        (tester) async {
      await tester.pumpWidget((modular.ModularApp(
        module: AppModule(),
        child: const AppWidget(),
      )));
      when(() => navigate.navigate(any())).thenAnswer((_) => Future.value());
      when(() => controller.notifier)
          .thenReturn(ValueNotifier(HomeInitialState()));
      when(() => controller.getAllProducts()).thenAnswer((_) => Future.value());
      await tester.pumpAndSettle();
      final iconButtonFinder = find.byIcon(Icons.favorite_outline);
      expect(iconButtonFinder, findsOneWidget);
      when(() => navigate.pushNamed(any()))
          .thenAnswer((invocAtion) => Future.value());
      await tester.tap(iconButtonFinder);
      await tester.pumpAndSettle();
      verify(() => navigate.pushNamed('/favoriteProducts')).called(1);
    });
    testWidgets('should navigate to ErrorPage when /error route is accessed',
        (tester) async {
      await tester.pumpWidget((modular.ModularApp(
        module: AppModule(),
        child: const AppWidget(),
      )));
      // Configurar a simulação para o método navigate com um comportamento padrão de retorno void
      when(() => navigate.navigate(any())).thenAnswer((_) {});
      verifyNever(() => navigate.navigate(any()));
      when(() => controller.notifier).thenReturn(
          ValueNotifier(HomeGetAllProductsErrorState(message: 'message')));
      when(() => controller.getAllProducts()).thenAnswer((_) => Future.value());
      await tester.pumpAndSettle();
      verify(
          () => navigate.navigate(any(), arguments: any(named: 'arguments')));
    });
  });
}
