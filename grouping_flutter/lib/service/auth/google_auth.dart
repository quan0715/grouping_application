import "dart:io";

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grouping_project/config/config.dart';
import 'package:grouping_project/service/auth/auth_service.dart';

import 'web_oauth2.dart' if (dart.library.io) 'mobile_oauth2.dart';

/// 1. [initializeOauthPlatform] is to initialize required parameter
/// 2. [informParameters] is to set up django's parameters
/// 3. [showWindowAndListen] is to sho the tab/webView
/// 4. [handleCodeAndGetProfile] is to connect to backend and login
class GoogleAuth {
  bool isLoading = false;
  late final BaseOauth platformedOauth2;

  Future<String> _getCorrectGoogleClientId() async {
    await dotenv.load(fileName: ".env");
    if (kIsWeb) {
      return dotenv.env['GOOGLE_CLIENT_ID_WEB']!;
    } else if (Platform.isAndroid) {
      return dotenv.env['GOOGLE_CLIENT_ID_ANDROID']!;
    } else if (Platform.isIOS) {
      return dotenv.env['GOOGLE_CLIENT_ID_IOS']!;
    } else {
      throw Exception('Unsupported platform');
    }
  }

  Future<String?> _getCorrectGoogleClientSecret() async {
    await dotenv.load(fileName: ".env");
    if (kIsWeb) {
      return dotenv.env['GOOGLE_CLIENT_SECRET_WEB'];
    } else if (Platform.isAndroid) {
      return dotenv.env['GOOGLE_CLIENT_SECRET_ANDROID'];
    } else if (Platform.isIOS) {
      return dotenv.env['GOOGLE_CLIENT_SECRET_IOS'];
    } else {
      throw Exception('Unsupported platform');
    }
  }

  Future initializeOauthPlatform() async {
    await dotenv.load(fileName: ".env");

    platformedOauth2 = BaseOauth(
        clientId: await _getCorrectGoogleClientId(),
        clientSecret: await _getCorrectGoogleClientSecret(),
        scopes: dotenv.env['GOOGLE_SCOPES']!.split(','),
        authorizationEndpoint: Config.googleAuthEndpoint,
        tokenEndpoint: Config.googleTokenEndpoint,
        provider: AuthProvider.google,
        usePkce: true,
        useState: false);
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
