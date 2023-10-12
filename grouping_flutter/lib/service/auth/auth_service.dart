import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/config/config.dart';
import 'package:grouping_project/exceptions/auth_service_exceptions.dart';
import 'package:grouping_project/service/auth/line_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:grouping_project/service/auth/github_auth.dart';
import 'package:grouping_project/service/auth/google_auth.dart';

// flutter run --web-port 5000
enum AuthProvider {
  account(string: 'account'),
  google(string: 'google'),
  github(string: 'github'),
  line(string: 'line');

  final String string;
  const AuthProvider({required this.string});
}

class AuthService {
  final GoogleAuth _googleAuth = GoogleAuth();
  final GitHubAuth _gitHubAuth = GitHubAuth();
  final LineAuth _lineAuth = LineAuth();

  Future signUp(
      {required String account,
      required String password,
      String? username}) async {
    try {
      await PassToBackEnd.toAuthBabkend(
          provider: AuthProvider.account,
          account: account,
          password: password,
          username: username,
          register: true);
    } catch (e) {
      // debugPrint("In func. signUp: $e");
      rethrow;
    }
  }

  Future signIn({required String account, required String password}) async {
    // AccountAuth accountAuth = AccountAuth();
    // await accountAuth.signIn(account: account, password: password);
    try {
      await PassToBackEnd.toAuthBabkend(
          provider: AuthProvider.account,
          account: account,
          password: password,
          register: false);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future logOut() async {
    const storage = FlutterSecureStorage();

    await storage.delete(key: 'auth-provider');
    await storage.delete(key: 'auth-token');
    storage.readAll().then((value) => debugPrint(value.toString()));
  }

  Future thridPartyLogin(AuthProvider provider, BuildContext context) async {
    try {
      switch (provider) {
        case AuthProvider.google:
          googleSignIn();
          break;
        case AuthProvider.github:
          githubSignIn(context);
          break;
        case AuthProvider.line:
          lineSignIn(context);
          break;
        default:
      }
    } catch (e) {
      rethrow;
    }
  }

  Future googleSignIn() async {
    try {
      debugPrint(Platform.operatingSystem);
      if (kIsWeb) {
        await _googleAuth.signInWeb();
        await PassToBackEnd.toAuthBabkend(provider: AuthProvider.google);
      } else if (Platform.isAndroid || Platform.isIOS) {
        await _googleAuth.signInMobile();
        await PassToBackEnd.toAuthBabkend(provider: AuthProvider.google);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future githubSignIn(BuildContext context) async {
    try {
      // debugPrint(Platform.operatingSystem);
      await PassToBackEnd.toInformPlatform();
      _gitHubAuth.showLoginWindow(context);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future lineSignIn(BuildContext context) async {
    try {
      // debugPrint(Platform.operatingSystem);
      await PassToBackEnd.toInformPlatform();
      if (kIsWeb) {
        await _lineAuth.signInWeb(context);
        await Future.delayed(Duration(seconds: 3));
        await PassToBackEnd.toAuthBabkend(provider: AuthProvider.line);
      } else if (Platform.isAndroid || Platform.isIOS) {
        await _lineAuth.signInMobile(context);
      } else {
        await _lineAuth.signInWeb(context);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class PassToBackEnd {
  static Future toInformPlatform() async {
    String stringUrl;
    if (kIsWeb) {
      stringUrl = '${Config.baseUriWeb}/auth/platform/';
    } else if (Platform.isAndroid || Platform.isIOS) {
      stringUrl = '${Config.baseUriMobile}/auth/platform/';
    } else {
      stringUrl = '${Config.baseUriWeb}/auth/platform/';
    }
    http.Response response = await http.post(Uri.parse(stringUrl),
        body: {'platform': kIsWeb ? 'web' : 'mobile'});
  }

  static Future toAuthBabkend(
      {required AuthProvider provider,
      String? account,
      String? password,
      bool register = false,
      String? username}) async {
    Object body = {};
    try {
      Uri url;
      String stringUrl;
      if (kIsWeb) {
        stringUrl = '${Config.baseUriWeb}/auth/${provider.string}/';
      } else {
        stringUrl = '${Config.baseUriMobile}/auth/${provider.string}/';
      }

      if (provider == AuthProvider.account) {
        if (account == null) {
          throw Exception('Please enter account');
        }
        if (password == null) {
          throw Exception('Please enter password');
        }
        if (username != null && register == true) {
          body = {
            'account': account,
            'password': password,
            'username': username
          };
        } else {
          body = {'account': account, 'password': password};
        }
        if (register == true) {
          stringUrl += 'register/';
        } else {
          stringUrl += 'signin/';
        }
      }

      url = Uri.parse(stringUrl);

      http.Response response = await http.post(url, body: body);
      // debugPrint(response.body);
      if (response.statusCode == 401) {
        Map<String, dynamic> body = json.decode(response.body);
        throw AuthServiceException(
            code: body['error-code'], message: body['error']);
      } else if (response.statusCode == 200) {
        const storage = FlutterSecureStorage();

        await storage.write(key: 'auth-provider', value: provider.string);
        await storage.write(key: 'auth-token', value: response.body);

        storage.readAll().then((value) => debugPrint(value.toString()));
      } else if (response.statusCode < 600 && response.statusCode > 499) {
        throw Exception('Server exception: code ${response.statusCode}');
      } else {
        throw Exception('reponses status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("In func. toAuthBabkend: $e");
      rethrow;
    }
  }
}
