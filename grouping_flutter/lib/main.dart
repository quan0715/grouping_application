import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:grouping_project/View/app/app_view.dart';
import 'package:grouping_project/View/app/auth/auth_view.dart';
import 'package:grouping_project/View/repo_view.dart';
import 'package:grouping_project/View/theme/theme_manager.dart';
import 'package:grouping_project/ViewModel/workspace/event_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    storage.deleteAll();
    return MultiProvider(
      providers: [
        // 呼叫 theme_manager.dart
        ChangeNotifierProvider(create: (context) => ThemeManager()),
        ChangeNotifierProvider(create: (context) => EventSettingViewModel())
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) => MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: themeManager.colorSchemeSeed,
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            // 呼叫 home_page.dart
            '/': (context) => const AppView(),
            '/login': (context) => const AuthView(),
            '/register': (context) => const AuthView(mode: 'register'),
            '/test': (context) => MyHomePage(
                title: 'Flutter with Django',
                themeManager: themeManager,
              ),
          },
          initialRoute: '/',
          // 呼叫 home_page.dart
          // home: const AppView()
        ),
      ),
    );
  }
}
