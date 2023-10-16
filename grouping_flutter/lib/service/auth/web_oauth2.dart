import 'dart:convert';
import 'dart:js_util';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grouping_project/exceptions/auth_service_exceptions.dart';
import 'package:grouping_project/service/auth/auth_service.dart';
import 'package:http/http.dart';
import 'dart:html' as html;
import 'package:pkce/pkce.dart';
import 'package:encrypt/encrypt.dart' as encryptP;

import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:webview_flutter/webview_flutter.dart';
import '../../config/config.dart';

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
  final AuthProvider provider;
  final String clientId;
  final Uri authorizationEndpoint;
  final Uri tokenEndpoint;
  final String? clientSecret;
  late final Uri authorizationUrl;
  late final Uri redirectedUrl;
  // Uri redirectedUrl = Uri.parse('${Config.baseUriMobile}/auth/callback/');
  final List<String> scopes;
  late final bool pkceSupported;
  late final bool stateSupported;
  final PkcePair _pkcePair = PkcePair.generate(length: 96);
  final String _stateCode = String.fromCharCodes(Iterable.generate(
      32,
      (_) => 'abcdefghijklmnopqrstuvwxyz0123456789'
          .codeUnitAt(Random().nextInt(26))));
  ValueNotifier<html.WindowBase> authWindowNotifier =
      ValueNotifier(newObject());

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
      bool? usePkce,
      bool? useState}) {
    pkceSupported = usePkce ?? true;
    stateSupported = useState ?? false;
    redirectedUrl =
        Uri.parse(kIsWeb ? Config.frontEndUrlWeb : Config.frontEndUrlMobile);
  }

  encryptP.Encrypted get pkcePairVerifier => encryptP.Encrypter(encryptP.AES(
          encryptP.Key.fromUtf8("haha8787 I am not sure fjkfjkfjk"),
          mode: encryptP.AESMode.ecb,
          padding: null))
      .encrypt(_pkcePair.codeVerifier, iv: encryptP.IV.fromSecureRandom(16));

  encryptP.Encrypted get statePairVerifier => encryptP.Encrypter(encryptP.AES(
          encryptP.Key.fromUtf8("haha8787 I am not sure fjkfjkfjk"),
          mode: encryptP.AESMode.ecb,
          padding: null))
      .encrypt(_stateCode, iv: encryptP.IV.fromSecureRandom(16));

  _getSignInGrant() {
    if (pkceSupported) {
      grant = oauth2.AuthorizationCodeGrant(
          clientId, authorizationEndpoint, tokenEndpoint,
          secret: clientSecret,
          httpClient: JsonFormatHttpClient(),
          codeVerifier: _pkcePair.codeVerifier);
      // debugPrint("Pkcepair Verifier: ${_pkcePair.codeVerifier}");
    } else {
      grant = oauth2.AuthorizationCodeGrant(
          clientId, authorizationEndpoint, tokenEndpoint,
          secret: clientSecret, httpClient: JsonFormatHttpClient());
    }
  }

  Future _informVerifierToBackend() async {
    String stringUrl;

    if (kIsWeb) {
      stringUrl = '${Config.baseUriWeb}/auth/verifier/';
    } else {
      stringUrl = '${Config.baseUriMobile}/auth/verifier/';
    }

    if (pkceSupported) {
      // debugPrint(pkceSupported.toString());
      Response response = await post(Uri.parse(stringUrl),
          body: {'verifier': pkcePairVerifier.base64});
    }
  }

  Future _informStateToBackend() async {
    String stringUrl;

    if (kIsWeb) {
      stringUrl = '${Config.baseUriWeb}/auth/state/';
    } else {
      stringUrl = '${Config.baseUriMobile}/auth/state/';
    }

    if (stateSupported) {
      // debugPrint(stateSupported.toString());
      debugPrint("stateCode: $_stateCode");
      Response response = await post(Uri.parse(stringUrl),
          body: {'state': statePairVerifier.base64});
    }
  }

  Future _informPlatform() async {
    String stringUrl;

    if (kIsWeb) {
      stringUrl = '${Config.baseUriWeb}/auth/platform/';
    } else {
      stringUrl = '${Config.baseUriMobile}/auth/platform/';
    }

    Response response = await post(Uri.parse(stringUrl),
        body: {'platform': kIsWeb ? 'web' : 'mobile'});
  }

  Future _informCode() async {
    String stringUrl;
    if (kIsWeb) {
      stringUrl = '${Config.baseUriWeb}/auth/callback/';
    } else {
      stringUrl = '${Config.baseUriMobile}/auth/callback/';
    }
    FlutterSecureStorage storage = FlutterSecureStorage();

    String? code = await storage.read(key: 'code');
    debugPrint(code);

    await get(Uri.parse(stringUrl).replace(queryParameters: {'code': code!}));
  }

  Future initialLoginFlow() async {
    _getSignInGrant();
    if (stateSupported) {
      authorizationUrl = grant.getAuthorizationUrl(redirectedUrl,
          scopes: scopes, state: _stateCode);
    } else {
      authorizationUrl =
          grant.getAuthorizationUrl(redirectedUrl, scopes: scopes);
    }
    await _informPlatform();
    await _informVerifierToBackend();
    await _informStateToBackend();
    grant.close();
  }

  // TODO: this is view, no context here
  Future showWindowAndListen(BuildContext context) async {
    html.WindowBase window;
    grant.close();
    window = html.window.open(authorizationUrl.toString(), "_self");
    authWindowNotifier.value = window;
    // while (window.closed != null && !window.closed!) {
    //   await Future.delayed(Duration(seconds: 1));
    // }
  }

  Future requestProfile() async {
    await _informCode();
    Object body = {};
    try {
      Uri url;
      String stringUrl;
      if (kIsWeb) {
        stringUrl = '${Config.baseUriWeb}/auth/${provider.string}/';
      } else {
        stringUrl = '${Config.baseUriMobile}/auth/${provider.string}/';
      }

      debugPrint(stringUrl);

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

        await storage.deleteAll();
        await storage.write(key: 'auth-token', value: response.body);

        storage.readAll().then((value) => debugPrint(value.toString()));
      } else {
        const storage = FlutterSecureStorage();

        await storage.delete(key: 'auth-provider');
        throw Exception('reponses status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("In oauth2_web: $e");
      // rethrow;
    }
  }
}
