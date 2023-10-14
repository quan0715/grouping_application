import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grouping_project/View/app/auth/pages/login_page_view.dart';
import 'package:grouping_project/View/app/auth/pages/register_page_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key, this.mode = 'login'});
  final String mode;

  @override
  Widget build(BuildContext context) {
    if (Uri.base.queryParametersAll.containsKey('code')) {
      FlutterSecureStorage storage = FlutterSecureStorage();

      storage
          .write(key: 'code', value: Uri.base.queryParameters['code'])
          .whenComplete(() => SystemNavigator.pop());
    }
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
