// import "dart:io";

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:grouping_project/config/config.dart';
// import 'package:grouping_project/service/auth/auth_helpers.dart';

// import 'web_oauth2.dart' if (dart.library.io) 'mobile_oauth2.dart';

// /// 1. [initializeOauthPlatform] is to initialize required parameter
// /// 2. [informParameters] is to set up django's parameters
// /// 3. [showWindowAndListen] is to sho the tab/webView
// /// 4. [handleCodeAndGetProfile] is to connect to backend and login
// class GoogleAuth {
//   bool isLoading = false;
//   late final BaseOauth platformedOauth2;

//   void initializeOauthPlatform() async {
//     platformedOauth2 = BaseOauth(
//         clientId: getAuthProviderKeyAndSecret(AuthProvider.google).$1,
//         clientSecret: getAuthProviderKeyAndSecret(AuthProvider.google).$2,
//         scopes: Config.googleScopes,
//         authorizationEndpoint: Config.googleAuthEndpoint,
//         tokenEndpoint: Config.googleTokenEndpoint,
//         provider: AuthProvider.google,
//         usePkce: true,
//         useState: false);
//   }

//   Future informParameters() async {
//     await platformedOauth2.initialLoginFlow();
//   }

//   Future showWindowAndListen(BuildContext context) async {
//     await platformedOauth2.showWindowAndListen(context);
//   }

//   Future handleCodeAndGetProfile() async {
//     try {
//       await platformedOauth2.getAccessToken();
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }
// }
