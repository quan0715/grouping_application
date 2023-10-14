// import 'package:oauth2/oauth2.dart' as oauth2;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:grouping_project/config/config.dart';
import 'package:grouping_project/service/auth/auth_service.dart';

import 'oauth2_base.dart';

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
      );
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
        );
      }
    }
    const storage = FlutterSecureStorage();

    await storage.write(key: 'auth-provider', value: AuthProvider.line.string);
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
