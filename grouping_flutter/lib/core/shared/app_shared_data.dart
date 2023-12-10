// import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

class AppSharedData {
  static late final SharedPreferencesPlugin _instance;

  static SharedPreferencesPlugin get instance => _instance;

  static Future<SharedPreferencesPlugin> init() async =>
      _instance = SharedPreferencesPlugin();
}