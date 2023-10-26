import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt_package;

import 'package:grouping_project/exceptions/auth_service_exceptions.dart';
import '../../config/config.dart';

class StringECBEncryptor {
  static Future<encrypt_package.Encrypted> encryptCode(
      String toBeEncrypted) async {
    await dotenv.load(fileName: ".env");
    return encrypt_package.Encrypter(encrypt_package.AES(
            encrypt_package.Key.fromUtf8(dotenv.get('ENCRYPT_KEY32')),
            mode: encrypt_package.AESMode.ecb,
            padding: null))
        .encrypt(toBeEncrypted, iv: encrypt_package.IV.fromSecureRandom(16));
  }
}

class StateGenerater {
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
      await StorageMethods.write(key: 'auth-token', value: response.body);

      StorageMethods.readAll().then((value) => debugPrint(value.toString()));
    } else {
      StorageMethods.delete(key: 'auth-provider');
      throw Exception('reponses status: ${response.statusCode}');
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