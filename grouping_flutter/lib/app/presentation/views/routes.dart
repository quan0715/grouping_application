import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grouping_project/app/presentation/providers/token_manager.dart';
import 'package:grouping_project/auth/presentation/views/auth_view.dart';
import 'package:grouping_project/space/presentation/views/pages/user_page_view.dart';
import 'package:grouping_project/space/presentation/views/pages/workspace_page_view.dart';

class AppRouter {
  // bool isLogin = false;
  AppRouter({required this.tokenManager});

  GoRouter get goRoute => _goRouter;

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
          path: '/user/:userId',
          builder: (BuildContext context, GoRouterState state) {
            // debugPrint(state.pathParameters['userId'].toString());
            return const UserPageView();
          },
        ),
        GoRoute(
          path: '/workspace/:workspaceId',
          builder: (BuildContext context, GoRouterState state) {
            // debugPrint(state.pathParameters['workspaceId'].toString());
            return const WorkspacePageView();
          },
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) async {
        debugPrint(state.matchedLocation);
        // await tokenManager.updateToken();
        bool isInLoginPage = state.matchedLocation == '/login';
        bool isInRegisterPage = state.matchedLocation == '/register';
        // bool isInUserPage = state.matchedLocation.contains('/user/');
        // bool isInWorkspacePage = state.matchedLocation.contains('/workspace/');
        bool isLogin = tokenManager.isLogin;

        if (isInLoginPage || isInRegisterPage) {
          if (isLogin) {
            debugPrint("redirect to user page");
            return '/user/${tokenManager.tokenModel.userId}';
          }
          return null;
        } else {
          if (!isLogin) {
            debugPrint("redirect to login page");
            return '/login';
          }
        }

        return null;
      });
}
