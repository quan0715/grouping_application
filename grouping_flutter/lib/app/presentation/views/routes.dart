import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grouping_project/app/presentation/providers/token_manager.dart';
import 'package:grouping_project/auth/presentation/views/auth_view.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/space/presentation/views/pages/user_page_view.dart';
import 'package:grouping_project/space/presentation/views/pages/workspace_page_view.dart';
import 'package:provider/provider.dart';

class AppRouter {
  // bool isLogin = false;
  AppRouter({required this.tokenManager});

  GoRouter get goRoute => _goRouter;

  UserDataProvider getUserDataProvider(BuildContext context) {
    // debugPrint('create user data provider');
    return UserDataProvider(
      tokenModel: Provider.of<TokenManager>(context, listen: false).tokenModel,
    )..init();
  }

  DashboardPageType getDashboardPath(String pageType) {
    return switch(pageType){
      'home' => DashboardPageType.home,
      'activities' => DashboardPageType.activities,
      'threads' => DashboardPageType.threads,
      'settings' => DashboardPageType.settings,
      _ => DashboardPageType.none, 
    };
  }
  

  late final TokenManager tokenManager;
  late final GoRouter _goRouter = GoRouter(
      initialLocation: '/',
      refreshListenable: tokenManager,
      routes: [
        GoRoute(
            path: '/',
            redirect: (BuildContext context, GoRouterState state) => '/login'),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) {
            return const AuthView();
          },
        ),
        GoRoute(
          path: '/register',
          builder: (BuildContext context, GoRouterState state) {
            return const AuthView(mode: 'register');
          },
        ),
        GoRoute(
          path: '/app',
          redirect: (context, state){
            DashboardPageType pageType = getDashboardPath(state.pathParameters['pageType']!);
            if(pageType == DashboardPageType.none){
              return '/app/user/${tokenManager.tokenModel.userId}/home';
            }
            return null;
          },
          routes: [
            GoRoute(
              path: 'user/:userId/:pageType',
              builder: (context, state){
                debugPrint('build user page');
                DashboardPageType pageType = getDashboardPath(state.pathParameters['pageType']!);
                return ChangeNotifierProvider<UserDataProvider>(
                  create: (context) => getUserDataProvider(context)..init(),
                  child: UserPageView(pageType: pageType),
                );
              },
            ),
            GoRoute(
              path: 'workspace/:workspaceId',
              builder: (BuildContext context, GoRouterState state) {
                // debugPrint(state.pathParameters['workspaceId'].toString());
                return const WorkspacePageView();
              },
            ),
          ]
        )
      ],
      redirect: (BuildContext context, GoRouterState state) async {
        // debugPrint(state.matchedLocation);
        // await tokenManager.updateToken();
        bool isInLoginPage = state.matchedLocation == '/login';
        bool isInRegisterPage = state.matchedLocation == '/register';
        // bool isInUserPage = state.matchedLocation.contains('/user/');
        // bool isInWorkspacePage = state.matchedLocation.contains('/workspace/');
        bool isLogin = tokenManager.isLogin;

        if (isInLoginPage || isInRegisterPage) {
          if (isLogin) {
            // debugPrint("redirect to user page");
            return '/app/user/${tokenManager.tokenModel.userId}/home';
          }
          return null;
        } else {
          if (!isLogin) {
            // debugPrint("redirect to login page");
            return '/login';
          }
        }
        // debugPrint('by pass token check, no need to redirect');
        return null;
      });
}
