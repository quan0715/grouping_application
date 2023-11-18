import 'package:flutter/material.dart';
import 'package:grouping_project/ViewModel/workspace/event_view_model.dart';
import 'package:grouping_project/app/presentation/providers/login_manager.dart';
import 'package:grouping_project/app/presentation/views/routes.dart';
import 'package:grouping_project/app/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget{
  const App({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 呼叫 theme_manager.dart
        // ChangeNotifierProvider(create: (context) => LoginManager()),
        // ChangeNotifierProvider(create: (context) => MessageService()),
        ChangeNotifierProvider(create: (context) => ThemeManager()),
        ChangeNotifierProvider(create: (context) => EventSettingViewModel()),
        ChangeNotifierProvider(create: (context) => LoginManager()..checkLoginState()),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) => MaterialApp.router(
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: themeManager.colorSchemeSeed,
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: applicationRoute,
        ),
      ),
    );
  }
}
