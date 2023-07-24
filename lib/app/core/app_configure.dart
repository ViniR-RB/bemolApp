import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AppConfigure {
  AppConfigure._();
  static String _get(String name) => dotenv.env[name] ?? '';
  static String get apiUrl => _get('API_URL');
}
