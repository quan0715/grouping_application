import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grouping_project/exceptions/auth_service_exceptions.dart';
import 'package:grouping_project/service/auth/account.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('account login check', () {
    WidgetsFlutterBinding.ensureInitialized();
    AccountAuth accountAuth = AccountAuth();
    FlutterSecureStorage storage = FlutterSecureStorage();
    test('signup', () async {
      accountAuth
          .signUp(
              account: 'test', password: 'testtest', username: 'test account')
          .whenComplete(() {
        storage
            .containsKey(key: 'auth-token')
            .then((value) => expect(value, true));
      }).onError((error, stackTrace) {
        error as AuthServiceException;
        expect(error.code == 'user_already_exist', true);
        log(error.toString());
      });
    });

    test('logout', () async {
      accountAuth.logOut().whenComplete(() {
        storage
            .containsKey(key: 'auth-token')
            .then((value) => expect(value, false));
      });
    });

    test('wrong password', () async {
      accountAuth
          .signIn(account: 'test', password: '878787')
          .onError((error, stackTrace) {
        error as AuthServiceException;
        expect(error.code == 'wrong_password', true);
      });
    });

    test('sign in', () async {
      accountAuth
          .signIn(account: 'test', password: 'testtest')
          .whenComplete(() {
        storage
            .containsKey(key: 'auth-token')
            .then((value) => expect(value, true));
      });
    });
  });
  // group('Google login test', () {
  //   AuthService authService = AuthService();
  //   authService.googleSignIn().then((value) => Placeholder());
  // });
}
