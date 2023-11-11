import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:grouping_project/service/auth/account.dart';
import 'package:grouping_project/service/auth/auth_helpers.dart';

void main() {
  group('api permission test', () async {
    test('account sign', () async {
      AccountAuth accountAuth = AccountAuth();
      try {
        await accountAuth.signIn(account: 'winnie', password: 'haha8787');
        // debugPrint(await StorageMethods.read(key: 'auth-token'));
        // http.get(Uri.parse('http://localhost:8000/api/'), headers: {});
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  });
}
