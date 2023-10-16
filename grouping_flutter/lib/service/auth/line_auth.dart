// import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:grouping_project/config/config.dart';
import 'package:grouping_project/service/auth/auth_service.dart';

import 'web_oauth2.dart'
    if (Platfrom.isAndroid) 'mobile_oauth2.dart'
    if (Platfrom.isIOS) 'mobile_oauth2.dart';

/// 1. [initializeOauthPlatform] is to initialize required parameter
/// 2. [informParameters] is to set up django's parameters
/// 3. [showWindowAndListen] is to sho the tab/webView
/// 4. [handleCodeAndGetProfile] is to connect to backend and login
class LineAuth {
  late final BaseOauth platformedOauth2;

  Future initializeOauthPlatform() async {
    await dotenv.load(fileName: ".env");
    if (kIsWeb) {
      platformedOauth2 = BaseOauth(
          clientId: dotenv.env['LINE_CLIENT_ID_WEB']!,
          clientSecret: dotenv.env['LINE_CLIENT_SECRET_WEB']!,
          scopes: dotenv.env['LINE_SCOPES']!.split(','),
          authorizationEndpoint: Config.lineAuthEndPoint,
          tokenEndpoint: Config.lineTokenEndpoint,
          provider: AuthProvider.line,
          useState: true,
          usePkce: true);
    } else {
      {
        await dotenv.load(fileName: ".env");
        platformedOauth2 = BaseOauth(
            clientId: dotenv.env['LINE_CLIENT_ID_MOBILE']!,
            clientSecret: dotenv.env['LINE_CLIENT_SECRET_MOBILE']!,
            scopes: dotenv.env['LINE_SCOPES']!.split(','),
            authorizationEndpoint: Config.lineAuthEndPoint,
            tokenEndpoint: Config.lineTokenEndpoint,
            provider: AuthProvider.line,
            useState: true,
            usePkce: true);
      }
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
      debugPrint("getting profile");
      await platformedOauth2.requestProfile();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
