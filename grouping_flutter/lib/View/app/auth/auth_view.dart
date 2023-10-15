import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grouping_project/View/app/auth/pages/login_page_view.dart';
import 'package:grouping_project/View/app/auth/pages/register_page_view.dart';
import 'package:grouping_project/service/auth/auth_service.dart';
import 'package:grouping_project/service/auth/github_auth.dart';
import 'package:grouping_project/service/auth/google_auth.dart';
import 'package:grouping_project/service/auth/line_auth.dart';

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
