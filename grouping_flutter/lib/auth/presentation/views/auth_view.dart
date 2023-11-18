import 'package:flutter/material.dart';
import 'package:grouping_project/auth/presentation/views/pages/login_page_view.dart';
import 'package:grouping_project/auth/presentation/views/pages/register_page_view.dart';


class AuthView extends StatelessWidget {
  const AuthView({super.key, this.mode = 'login'});
  final String mode;

  @override
  Widget build(BuildContext context) {
    // if (kIsWeb) {
    if (mode == 'login') {
      return WebLoginViewPage();
    } else if (mode == 'register') {
      return RegisterViewPage();
    } else {
      return WebLoginViewPage();
    }
  }
}
