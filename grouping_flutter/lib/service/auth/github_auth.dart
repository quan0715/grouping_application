// import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:grouping_project/config/config.dart';
import 'package:grouping_project/service/auth/auth_helpers.dart';

import 'web_oauth2.dart' if (dart.library.io) 'mobile_oauth2.dart';

/// 1. [initializeOauthPlatform] is to initialize required parameter
/// 2. [informParameters] is to set up django's parameters
/// 3. [showWindowAndListen] is to sho the tab/webView
/// 4. [handleCodeAndGetProfile] is to connect to backend and login
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
          usePkce: false,
          useState: false);
    } else {
      platformedOauth2 = BaseOauth(
          clientId: dotenv.env['GITHUB_CLIENT_ID_MOBILE']!,
          clientSecret: dotenv.env['GITHUB_CLIENT_SECRET_MOBILE']!,
          scopes: dotenv.env['GITHUB_SCOPES']!.split(','),
          authorizationEndpoint: Config.gitHubAuthEndpoint,
          tokenEndpoint: Config.gitHubTokenEndpoint,
          provider: AuthProvider.github,
          usePkce: false,
          useState: false);
    }
    const storage = FlutterSecureStorage();

    await storage.write(key: 'auth-provider', value: AuthProvider.line.string);
  }

  Future informParameters() async {
    await platformedOauth2.initialLoginFlow();
  }

  Future showWindowAndListen(BuildContext context) async {
    await platformedOauth2.showWindowAndListen(context);
  }

  Future handleCodeAndGetProfile() async {
    try {
      await platformedOauth2.getAccessToken();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
