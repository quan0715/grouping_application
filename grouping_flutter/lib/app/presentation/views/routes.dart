import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grouping_project/app/presentation/views/app_view.dart';
import 'package:grouping_project/auth/presentation/views/auth_view.dart';
import 'package:grouping_project/auth/presentation/views/pages/welcome_message_page_view.dart';
import 'package:grouping_project/space/presentation/views/pages/user_page_view.dart';
import 'package:grouping_project/space/presentation/views/workspace_view.dart';

final applicationRoute = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AppView();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const AuthView();
          },
        ),
        GoRoute(
          path: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return const AuthView(mode: 'register');
          },
        ),
        GoRoute(
          path: 'welcome',
          builder: (BuildContext context, GoRouterState state) {
            return const WelcomeView();
          },
        ),
        GoRoute(
          path: 'user/:userId',
          builder: (BuildContext context, GoRouterState state) {
            // debugPrint(state.pathParameters['userId'].toString());
            return const UserPageView();
          },
        ),
        GoRoute(
          path: 'workspace/:workspaceId',
          builder: (BuildContext context, GoRouterState state) {
            // debugPrint(state.pathParameters['workspaceId'].toString());
            return const WorkspaceView();
          },
        ),
      ],
    ),
  ],
);
