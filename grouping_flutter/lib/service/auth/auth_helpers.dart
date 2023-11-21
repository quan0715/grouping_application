import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt_package;

import 'package:grouping_project/exceptions/auth_service_exceptions.dart';
import 'package:grouping_project/config/config.dart';

enum AuthProvider {
  account(string: 'account'),
  google(string: 'google'),
  github(string: 'github'),
  line(string: 'line');

  final String string;
  const AuthProvider({required this.string});
}

(String, String) getAuthProviderKeyAndSecret(AuthProvider provider) {
  switch (provider) {
    case AuthProvider.account:
      return (
        dotenv.env['ACCOUNT_CLIENT_ID']!,
        dotenv.env['ACCOUNT_CLIENT_SECRET']!
      );

    case AuthProvider.google:
      if (kIsWeb) {
        return (
          dotenv.env['GOOGLE_CLIENT_ID_WEB']!,
          dotenv.env['GOOGLE_CLIENT_SECRET_WEB']!
        );
      } else if (Platform.isAndroid) {
        return (
          dotenv.env['GOOGLE_CLIENT_ID_ANDROID']!,
          dotenv.env['GOOGLE_CLIENT_SECRET_ANDROID']!
        );
      } else if (Platform.isIOS) {
        return (
          dotenv.env['GOOGLE_CLIENT_ID_IOS']!,
          dotenv.env['GOOGLE_CLIENT_SECRET_IOS']!
        );
      } else {
        throw Exception('Unsupported platform');
      }

    case AuthProvider.github:
      if (kIsWeb) {
        return (
          dotenv.env['GITHUB_CLIENT_ID_WEB']!,
          dotenv.env['GITHUB_CLIENT_SECRET_WEB']!
        );
      } else {
        return (
          dotenv.env['GITHUB_CLIENT_ID_MOBILE']!,
          dotenv.env['GITHUB_CLIENT_SECRET_MOBILE']!
        );
      }

    case AuthProvider.line:
      if (kIsWeb) {
        return (
          dotenv.env['LINE_CLIENT_ID_WEB']!,
          dotenv.env['LINE_CLIENT_SECRET_WEB']!
        );
      } else {
        return (
          dotenv.env['LINE_CLIENT_ID_MOBILE']!,
          dotenv.env['LINE_CLIENT_SECRET_MOBILE']!
        );
      }
  }
}

class StringECBEncryptor {
  static Future<encrypt_package.Encrypted> encryptCode(
      String toBeEncrypted) async {
    return encrypt_package.Encrypter(encrypt_package.AES(
            encrypt_package.Key.fromUtf8(dotenv.get('ENCRYPT_KEY32')),
            mode: encrypt_package.AESMode.ecb,
            padding: null))
        .encrypt(toBeEncrypted, iv: encrypt_package.IV.fromSecureRandom(16));
  }
}

class StateGenerator {
  static String generateLength32State() {
    return String.fromCharCodes(Iterable.generate(
        32,
        (_) => 'abcdefghijklmnopqrstuvwxyz0123456789'
            .codeUnitAt(Random().nextInt(26))));
  }
}

class EndPointGetter {
  static String getAuthBackendEndpoint(String endPoint) {
    return '${getBackendEndpoint()}/auth/$endPoint/';
  }

  static String getFrontEndpoint() {
    if (kIsWeb) {
      return Config.frontEndUrlWeb;
    } else {
      return Config.frontEndUrlMobile;
    }
  }

  static String getBackendEndpoint() {
    if (kIsWeb) {
      return Config.baseUriWeb;
    } else {
      return Config.baseUriMobile;
    }
  }
}

class StorageMethods {
  static FlutterSecureStorage storage = const FlutterSecureStorage();
  static Future<void> write(
      {required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  static Future<String?> read({required String key}) async {
    return await storage.read(key: key);
  }

  static Future<void> delete({required String key}) async {
    await storage.delete(key: key);
  }

  static Future<void> deleteAll() async {
    await storage.deleteAll();
  }

  static Future<Map<String, String>> readAll() async {
    return await storage.readAll();
  }
}

class ResponseHandling {
  static Future<void> authHandling(Response response) async {
    if (response.statusCode == 401) {
      await StorageMethods.delete(key: 'auth-provider');

      Map<String, dynamic> body = json.decode(response.body);
      throw AuthServiceException(
          code: body['error-code'], message: body['error']);
    } else if (response.statusCode == 200) {
      await StorageMethods.deleteAll();
      await StorageMethods.write(
          key: 'auth-token', value: json.decode(response.body)['auth-token']);
    } else {
      StorageMethods.delete(key: 'auth-provider');
      throw Exception('response status: ${response.statusCode}');
    }
  }
}

class JsonFormatHttpClient extends BaseClient {
  final httpClient = Client();
  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers['Accept'] = 'application/Json';
    return httpClient.send(request);
  }
}
