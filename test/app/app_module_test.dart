import 'package:bemol/app/app_module.dart';
import 'package:bemol/app/core/services/shared_prefrence.dart';
import 'package:bemol/app/modules/home/home.repository.dart';
import 'package:bemol/app/modules/home/home_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart' as modular;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart' as modular_test;
import 'package:shared_preferences/shared_preferences.dart';

class DioMock extends Mock implements Dio {}

class HomeRepositoryMock extends Mock implements HomeRepository {}

class HomeControllerMock extends Mock implements HomeController {}

class SharedPreferencesMock extends Mock implements Future<SharedPreferences> {}

class SharedPreferencesAppMock extends Mock implements SharedPreferencesApp {}

class ModularNavigateMock extends Mock implements IModularNavigator {}

void main() {
  late Dio dio;
  late HomeRepository repository;
  late HomeController controller;
  late Future<SharedPreferences> preferences;
  late SharedPreferencesApp preferencesApp;
  late final ModularNavigateMock navigate;
  setUpAll(() {
    dio = DioMock();
    repository = HomeRepositoryMock();
    controller = HomeControllerMock();
    preferences = SharedPreferencesMock();
    preferencesApp = SharedPreferencesAppMock();
    navigate = ModularNavigateMock();
    Modular.navigatorDelegate = navigate;
    modular_test.initModule(AppModule(), replaceBinds: [
      modular.Bind.instance<Dio>(dio),
      modular.Bind.instance<HomeRepository>(repository),
      modular.Bind.instance<HomeController>(controller),
      modular.Bind.instance<Future<SharedPreferences>>(preferences),
      modular.Bind.instance<SharedPreferencesApp>(preferencesApp),
    ]);
  });
  test('should me return Dio instance', () {
    final Dio controller = modular.Modular.get();
    expect(controller, isA<Dio>());
  });
  test('should me return HomeRepository instance', () {
    final HomeRepository controller = modular.Modular.get();
    expect(controller, isA<HomeRepository>());
  });
  test('should me return HomeController instance', () {
    final HomeController controller = modular.Modular.get();
    expect(controller, isA<HomeController>());
  });
  test('should me return Future SharedPreferences instance', () {
    final Future<SharedPreferences> controller = modular.Modular.get();
    expect(controller, isA<Future<SharedPreferences>>());
  });
  test('should me returnSharedPreferencesApp instance', () {
    final SharedPreferencesApp controller = modular.Modular.get();
    expect(controller, isA<SharedPreferencesApp>());
  });
}
