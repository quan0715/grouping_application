import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grouping_project/exceptions/auth_service_exceptions.dart';
import 'package:grouping_project/service/auth/account.dart';

void main() {
  group('account login check', () {
    AccountAuth accountAuth = AccountAuth();
    FlutterSecureStorage storage = FlutterSecureStorage();
    WidgetsFlutterBinding.ensureInitialized();

    test('user not exist', () {
      accountAuth
          .signIn(account: '876543231@123456789', password: 'testtest')
          .onError((error, stackTrace) {
        error as AuthServiceException;
        expect(error.code == 'user_does_not_exist', true);
      });
    });
    test('signUp', () {
      accountAuth
          .signUp(account: 'test', password: 'testtest', username: 'testestest')
          .whenComplete(() {
        storage
            .containsKey(key: 'auth-token')
            .then((value) => expect(value, true));
      }).onError((error, stackTrace) {
        error as AuthServiceException;
        expect(error.code == 'user_already_exist', true);
      });
    });

    test('logout', () {
      accountAuth.logOut().whenComplete(() {
        storage
            .containsKey(key: 'auth-token')
            .then((value) => expect(value, false));
      });
    });

    test('wrong password', () {
      accountAuth
          .signIn(account: 'test', password: '878787')
          .onError((error, stackTrace) {
        error as AuthServiceException;
        expect(error.code == 'wrong_password', true);
      });
    });

    test('sign in', () {
      accountAuth
          .signIn(account: 'test', password: 'testtest')
          .whenComplete(() {
        storage
            .containsKey(key: 'auth-token')
            .then((value) => expect(value, true));
      });
    });
  });
}
