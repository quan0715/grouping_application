import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:grouping_project/app/presentation/providers/login_manager.dart';
import 'package:grouping_project/auth/presentation/views/auth_view.dart';
import 'package:provider/provider.dart';

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginManager>(
      builder: (context, loginManager, child) {
        return FutureBuilder(
          future: loginManager.checkLoginState(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!loginManager.isLogin) {
                context.go('/login');
              } else {
                context.go('/user/${loginManager.userAccessToken}');
              }
              return const SizedBox();
            } else {
              return const AuthView();
            }
          },
        );
      },
    );
    // return const WorkspaceView();
  }
}
