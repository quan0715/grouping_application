import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grouping_project/app/presentation/views/app.dart';
import 'package:grouping_project/core/shared/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  // await SharedPreferences.getInstance();
  await SharedPrefs.init();
  
  runApp(const App());
}

