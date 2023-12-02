import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grouping_project/app/presentation/views/app.dart';
import 'package:grouping_project/core/shared/app_shared_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  // await SharedPreferences.getInstance();
  await AppSharedData.init();
  
  runApp(const App());
}

