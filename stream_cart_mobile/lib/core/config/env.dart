import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get apiUrl => dotenv.env['API_URL'] ?? '';
}