// import 'package:oauth2/oauth2.dart' as oauth2;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:grouping_project/config/config.dart';
import 'package:grouping_project/service/auth/auth_service.dart';

import 'oauth2_web.dart'
    if (Platform.isAndroid) 'oauth2_mobile.dart'
    if (Platform.isIOS) 'oauth2_mobile.dart';

class GitHubAuth {
  late BaseOauth _oauth2;

  Future _initializeOauthPlatform() async {
    await dotenv.load(fileName: ".env");
    if (kIsWeb) {
      _oauth2 = BaseOauth(
        clientId: dotenv.env['GITHUB_CLIENT_ID_WEB']!,
        clientSecret: dotenv.env['GITHUB_CLIENT_SECRET_WEB']!,
        scopes: dotenv.env['GITHUB_SCOPES']!.split(','),
        authorizationEndpoint: Config.gitHubAuthEndpoint,
        tokenEndpoint: Config.gitHubTokenEndpoint,
        provider: AuthProvider.github,
      );
    } else {
      debugPrint('else');
      _oauth2 = BaseOauth(
        clientId: dotenv.env['GITHUB_CLIENT_ID_MOBILE']!,
        clientSecret: dotenv.env['GITHUB_CLIENT_SECRET_MOBILE']!,
        scopes: dotenv.env['GITHUB_SCOPES']!.split(','),
        authorizationEndpoint: Config.gitHubAuthEndpoint,
        tokenEndpoint: Config.gitHubTokenEndpoint,
        provider: AuthProvider.github,
      );
    }
  }

  Future showLoginWindow(BuildContext context) async {
    await _initializeOauthPlatform();
    await _oauth2.showWindowAndListen(context);
  }
}
