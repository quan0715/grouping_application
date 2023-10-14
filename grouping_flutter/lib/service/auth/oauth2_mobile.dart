import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart';
import 'package:pkce/pkce.dart';
import 'package:encrypt/encrypt.dart' as encryptP;

import '../../config/config.dart';
import 'package:grouping_project/exceptions/auth_service_exceptions.dart';
import 'package:grouping_project/service/auth/auth_service.dart';

// Import for Android features.
import ''
    if (Platform.isAndroid) 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'
    if (Platform.isAndroid) 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.

class JsonFormatHttpClient extends BaseClient {
  final httpClient = Client();
  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers['Accept'] = 'application/Json';
    return httpClient.send(request);
  }
}

class BaseOauth {
  late oauth2.AuthorizationCodeGrant grant;
  late Map<String, String> parameters;
  final AuthProvider provider;
  final String clientId;
  final Uri authorizationEndpoint;
  final Uri tokenEndpoint;
  final String? clientSecret;
  late final Uri authorizationUrl;
  Uri redirectedUrl = Uri.parse('${Config.baseUriMobile}/auth/callback/');
  final List<String> scopes;
  late final bool pkceSupported;
  final PkcePair _pkcePair = PkcePair.generate(length: 96);

  /// 1. [initialLoginFlow] is to acquire url for authentication page and inform pkce verifier to DRF server
  /// 2. [showWindowAndListen] is to show new tab, need context as parameter
  /// 3. [requestProfile] is to get profile at backend and login
  BaseOauth(
      {required this.clientId,
      required this.authorizationEndpoint,
      required this.tokenEndpoint,
      this.clientSecret,
      required this.scopes,
      required this.provider,
      usePkce}) {
    pkceSupported = usePkce ?? true;
  }
  encryptP.Encrypted get pkcePairVerifier => encryptP.Encrypter(encryptP.AES(
          encryptP.Key.fromUtf8("haha8787 I am not sure fjkfjkfjk"),
          mode: encryptP.AESMode.ecb,
          padding: null))
      .encrypt(_pkcePair.codeVerifier, iv: encryptP.IV.fromSecureRandom(16));

  _getSignInGrant() {
    if (pkceSupported) {
      grant = oauth2.AuthorizationCodeGrant(
          clientId, authorizationEndpoint, tokenEndpoint,
          secret: clientSecret,
          httpClient: JsonFormatHttpClient(),
          codeVerifier: _pkcePair.codeVerifier);
      debugPrint("Pkcepair Verifier: ${_pkcePair.codeVerifier}");
    } else {
      grant = oauth2.AuthorizationCodeGrant(
          clientId, authorizationEndpoint, tokenEndpoint,
          secret: clientSecret, httpClient: JsonFormatHttpClient());
    }
  }

  Future _informVerifierToBackend() async {
    String stringUrl;

    stringUrl = '${Config.baseUriMobile}/auth/verifier/';

    if (pkceSupported) {
      debugPrint(pkceSupported.toString());
      Response response = await post(Uri.parse(stringUrl),
          body: {'verifier': pkcePairVerifier.base64});
    }
  }

  initialLoginFlow() {
    _getSignInGrant();
    authorizationUrl = grant.getAuthorizationUrl(redirectedUrl, scopes: scopes);
    _informVerifierToBackend();
  }

  Future showWindowAndListen(BuildContext context) async {
    try {
      WebViewController controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onWebResourceError: (WebResourceError error) {
              // TODO: Do some error handling
              debugPrint(
                  "===============================> onWebResourceError:");
              debugPrint(error.errorType.toString());
              debugPrint(error.errorCode.toString());
              debugPrint(error.description);
            },
            onUrlChange: (change) {
              if (change.url!.contains("code")) {
                Navigator.of(context).pop();
                // TODO: pass to back end needed to change
                grant.close();
              }
            },
          ),
        )
        ..loadRequest(authorizationUrl);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return WebViewWidget(controller: controller);
          },
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      grant.close();
    }
  }

  Future requestProfile() async {
    Object body = {};
    try {
      Uri url;
      String stringUrl;
      stringUrl = '${Config.baseUriMobile}/auth/${provider.string}/';

      url = Uri.parse(stringUrl);

      Response response = await post(url, body: body);
      // debugPrint(response.body);
      if (response.statusCode == 401) {
        const storage = FlutterSecureStorage();

        await storage.delete(key: 'auth-provider');
        Map<String, dynamic> body = json.decode(response.body);
        throw AuthServiceException(
            code: body['error-code'], message: body['error']);
      } else if (response.statusCode == 200) {
        const storage = FlutterSecureStorage();

        await storage.write(key: 'auth-token', value: response.body);

        storage.readAll().then((value) => debugPrint(value.toString()));
      } else if (response.statusCode < 600 && response.statusCode > 499) {
        const storage = FlutterSecureStorage();

        await storage.delete(key: 'auth-provider');
        throw Exception('Server exception: code ${response.statusCode}');
      } else {
        const storage = FlutterSecureStorage();

        await storage.delete(key: 'auth-provider');
        throw Exception('reponses status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("In func. toAuthBabkend: $e");
      rethrow;
    }
  }

  Future _informPlatform() async {
    String stringUrl;

    stringUrl = '${Config.baseUriMobile}/auth/platform/';

    Response response =
        await post(Uri.parse(stringUrl), body: {'platform': 'mobile'});
  }
}
