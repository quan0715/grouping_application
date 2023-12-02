import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grouping_project/app/presentation/providers/token_manager.dart';
import 'package:grouping_project/app/presentation/views/routes.dart';
import 'package:grouping_project/app/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget{
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final TokenManager tokenManager = TokenManager();
  late final AppRouter appRouter;

  @override
  void initState() {
    super.initState();
    tokenManager.init();
    appRouter = AppRouter(tokenManager: tokenManager);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeManager()),
        ChangeNotifierProvider<TokenManager>.value(value: tokenManager)
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) => 
          MaterialApp.router(
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: themeManager.colorSchemeSeed,
            ),
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter.goRoute,
          ),
        ),
    );
  }
}
