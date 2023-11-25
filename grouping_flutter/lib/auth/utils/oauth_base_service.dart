import 'package:flutter/foundation.dart';
import 'package:grouping_project/auth/utils/auth_helpers.dart';
import 'package:grouping_project/auth/utils/auth_provider_enum.dart';
import 'package:http/http.dart';
import 'package:pkce/pkce.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class BaseOAuthService {
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
  final String _stateCode = StateGenerator.generateLength32State();
  // ValueNotifier<WebViewWidget> authWidgetNotifier = ValueNotifier(newObject());

  /// 1. [initialLoginFlow] is to acquire url for authentication page and inform pkce verifier to DRF server
  /// 2. [showWindowAndListen] is to show new tab, need context as parameter
  /// 3. [requestProfile] is to get profile at backend and login
  BaseOAuthService(
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
    redirectedUrl = Uri.parse(EndPointGetter.getFrontEndpoint());
  }

  Future get pkcePairVerifier async {
    return await StringECBEncryptor.encryptCode(_pkcePair.codeVerifier);
  }

  Future get statePairVerifier async {
    return await StringECBEncryptor.encryptCode(_stateCode);
  }

  _getSignInGrant() {
    if (pkceSupported) {
      grant = oauth2.AuthorizationCodeGrant(
          clientId, authorizationEndpoint, tokenEndpoint,
          secret: clientSecret,
          httpClient: JsonFormatHttpClient(),
          codeVerifier: _pkcePair.codeVerifier);
    } else {
      grant = oauth2.AuthorizationCodeGrant(
          clientId, authorizationEndpoint, tokenEndpoint,
          secret: clientSecret, httpClient: JsonFormatHttpClient());
    }
  }

  // Future _informCode() async {
  //   String stringUrl = EndPointGetter.getAuthBackendEndpoint('callback');

  //   String? code = await StorageMethods.read(key: 'code');

  //   await get(Uri.parse(stringUrl).replace(queryParameters: {'code': code!}));
  // }

  Future initialLoginFlow() async {
    _getSignInGrant();
    if (stateSupported) {
      authorizationUrl = grant.getAuthorizationUrl(redirectedUrl,
          scopes: scopes, state: _stateCode);
    } else {
      authorizationUrl =
          grant.getAuthorizationUrl(redirectedUrl, scopes: scopes);
    }

    await _informParams();
    grant.close();
  }

  Future _informParams() async {
    String stringUrl = EndPointGetter.getAuthBackendEndpoint('exchange_params');

    Map<String, String> body = {
      'state': stateSupported
          ? (await StringECBEncryptor.encryptCode(_stateCode)).base64
          : '',
      'verifier': pkceSupported
          ? (await StringECBEncryptor.encryptCode(_pkcePair.codeVerifier))
              .base64
          : '',
      'platform': kIsWeb ? 'web' : 'mobile'
    };
    await post(Uri.parse(stringUrl), body: body);
  }

  Future getAccessToken() async {
    // await _informCode();
    Object body = {"code": await StorageMethods.read(key: 'code')};
    try {
      Uri url;
      String stringUrl = EndPointGetter.getAuthBackendEndpoint(provider.string);

      url = Uri.parse(stringUrl);

      Response response = await post(url, body: body);
      await ResponseHandling.authHandling(response);
    } catch (e) {
      debugPrint("In oauth2_web: $e");
      // rethrow;
    }
  }
}
