import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grouping_project/service/auth/auth_helpers.dart';

// flutter run --web-port 5000

class AccountAuth {
  Future signUp(
      {required String account,
      required String password,
      required String username}) async {
    try {
      String stringUrl;
      stringUrl = EndPointGetter.getAuthBackendEndpoint('register');
      // debugPrint(stringUrl);

      Map<String, String> body = {
        'account': account,
        'password': password,
        'username': username
      };

      Uri url = Uri.parse(stringUrl);

      http.Response response = await http.post(url, body: body);

      await ResponseHandling.authHandling(response);
    } catch (e) {
      debugPrint("sign UP error");
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future signIn({required String account, required String password}) async {
    // AccountAuth accountAuth = AccountAuth();
    // await accountAuth.signIn(account: account, password: password);
    try {
      String stringUrl;
      stringUrl = EndPointGetter.getAuthBackendEndpoint('signin');

      Map<String, String> body = {
        'account': account,
        'password': password,
      };

      Uri url = Uri.parse(stringUrl);

      http.Response response = await http.post(url, body: body);

      await ResponseHandling.authHandling(response);
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
}
