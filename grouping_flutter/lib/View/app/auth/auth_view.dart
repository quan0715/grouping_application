import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/auth/pages/login_page_view.dart';
import 'package:grouping_project/View/app/auth/pages/register_page_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key, this.mode = 'login'});
  final String mode;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      if (mode == 'login') {
        return WebLoginViewPage();
      } else if (mode == 'register') {
        return RegisterViewPage();
      } else {
        return WebLoginViewPage();
      }
      // return const WebSignInView();
    } else {
      return WebLoginViewPage();
    }
  }
}

