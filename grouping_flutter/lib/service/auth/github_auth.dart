// import 'package:oauth2/oauth2.dart' as oauth2;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:grouping_project/config/config.dart';
import 'package:grouping_project/service/auth/auth_service.dart';
import 'package:http/http.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

import 'oauth2_web.dart'
    if (Platform.isAndroid) 'oauth2_mobile.dart'
    if (Platform.isIOS) 'oauth2_mobile.dart';

/// 1. [initializeOauthPlatform] is to initialize required parameter
/// 2. [showWindowAndListen] is to sho the tab/webView
/// 3. [handleCodeAndGetProfile] is to connect to backend and login
class GitHubAuth {
  late BaseOauth platformedOauth2;

  Future initializeOauthPlatform() async {
    await dotenv.load(fileName: ".env");
    if (kIsWeb) {
      platformedOauth2 = BaseOauth(
        clientId: dotenv.env['GITHUB_CLIENT_ID_WEB']!,
        clientSecret: dotenv.env['GITHUB_CLIENT_SECRET_WEB']!,
        scopes: dotenv.env['GITHUB_SCOPES']!.split(','),
        authorizationEndpoint: Config.gitHubAuthEndpoint,
        tokenEndpoint: Config.gitHubTokenEndpoint,
        provider: AuthProvider.github,
      );
    } else {
      debugPrint('else');
      platformedOauth2 = BaseOauth(
        clientId: dotenv.env['GITHUB_CLIENT_ID_MOBILE']!,
        clientSecret: dotenv.env['GITHUB_CLIENT_SECRET_MOBILE']!,
        scopes: dotenv.env['GITHUB_SCOPES']!.split(','),
        authorizationEndpoint: Config.gitHubAuthEndpoint,
        tokenEndpoint: Config.gitHubTokenEndpoint,
        provider: AuthProvider.github,
      );
    }
    const storage = FlutterSecureStorage();

    await storage.write(
        key: 'auth-provider', value: AuthProvider.github.string);
    platformedOauth2.initialLoginFlow();
  }

  Future showWindowAndListen(BuildContext context) async {
    await platformedOauth2.showWindowAndListen(context);
  }

  Future handleCodeAndGetProfile() async {
    try {
      platformedOauth2.requestProfile();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      platformedOauth2.grant.close();
    }
  }
}
