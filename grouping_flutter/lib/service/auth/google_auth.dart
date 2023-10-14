import "dart:io";

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grouping_project/config/config.dart';
import 'package:grouping_project/service/auth/auth_service.dart';

import 'oauth2_base.dart';

/// 1. [initializeOauthPlatform] is to initialize required parameter
/// 2. [showWindowAndListen] is to sho the tab/webView
/// 3. [handleCodeAndGetProfile] is to connect to backend and login
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
        usePkce: true);
    const storage = FlutterSecureStorage();

    await storage.write(
        key: 'auth-provider', value: AuthProvider.google.string);
    platformedOauth2.initialLoginFlow();
  }

  Future showWindowAndListen(BuildContext context) async {
    await platformedOauth2.showWindowAndListen(context);
  }

  Future handleCodeAndGetProfile() async {
    try {
      await platformedOauth2.requestProfile();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      platformedOauth2.grant.close();
    }
  }
}
