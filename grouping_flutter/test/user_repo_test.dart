import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:grouping_project/model/auth/account_model.dart';
import 'package:grouping_project/model/photo_model.dart';
import 'package:grouping_project/model/repo/user_repo.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class FakeUri extends Mock implements Uri {}

void main() {
  group('user repo 功能測試:', () {
    setUp(() {
      registerFallbackValue(FakeUri());
    });
    tearDown(() => null);

    test("藉由 get 獲得預設的 account (default)", () async {
      // Arrange
      final client = MockClient();
      AccountModel account = AccountModel.defaultAccount;

      Map<String, dynamic> object = account.toJson();
      final responseAccount = jsonEncode(object);

      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(responseAccount, 200));

      final UserService userService = UserService(token: -1);
      userService.setClient(client);

      // Act
      final result = await userService.getUserData(uid: -1);

      // Assert
      expect(result, account);
    });

    test("藉由 get 獲得任意的 account", () async {
      // Arrange
      final client = MockClient();
      AccountModel account = AccountModel(
          name: 'test name',
          slogan: 'test slogan',
          photo:
              Photo(data: 'test url', photoId: -1, updateAt: DateTime.now()));

      Map<String, dynamic> object = account.toJson();
      final responseAccount = jsonEncode(object);

      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(responseAccount, 200));

      final UserService userService = UserService(token: -1);
      userService.setClient(client);

      // Act
      final result = await userService.getUserData(uid: -1);

      // Assert
      expect(result, account);
    });

    test("get account 的 id 不符合格式 (回傳 Exception)", () async {
      // Arrange
      final client = MockClient();
      AccountModel account = AccountModel(
          name: 'test name',
          slogan: 'test slogan',
          photo:
              Photo(data: 'test url', photoId: -1, updateAt: DateTime.now()));

      Map<String, dynamic> object = account.toJson();
      final responseAccount = jsonEncode(object);

      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(responseAccount, 400));

      final UserService userService = UserService(token: -1);
      userService.setClient(client);

      // Act
      // final result = await userService.getUserData(-1);

      // Assert
      expect(
          () async => await userService.getUserData(uid: -1),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: Invalid Syntax")));
    });

    test("get account 的 account 不存在 (回傳 Exception)", () async {
      // Arrange
      final client = MockClient();
      AccountModel account = AccountModel(
          name: 'test name',
          slogan: 'test slogan',
          photo:
              Photo(data: 'test url', photoId: -1, updateAt: DateTime.now()));

      Map<String, dynamic> object = account.toJson();
      final responseAccount = jsonEncode(object);

      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(responseAccount, 404));

      final UserService userService = UserService(token: -1);
      userService.setClient(client);

      // Act
      // final result = await userService.getUserData(-1);

      // Assert
      expect(
          () async => await userService.getUserData(uid: -1),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: The requesting data was not found")));
    });

    test("藉由 update 獲得更新後的 account", () async {
      // Arrange
      final client = MockClient();
      AccountModel account = AccountModel.defaultAccount;

      Map<String, dynamic> object = account.toJson();
      final responseAccount = jsonEncode(object);

      when(() => client.patch(any(), headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseAccount, 200));

      final UserService userService = UserService(token: -1);
      userService.setClient(client);

      // Act
      final result = await userService.updateUserData(account: account);

      // Assert
      expect(result, account);
    });

    test("update account 的 account 不符合格式 (回傳 Exception)", () async {
      // Arrange
      final client = MockClient();
      AccountModel account = AccountModel.defaultAccount;

      Map<String, dynamic> object = account.toJson();
      final responseAccount = jsonEncode(object);

      when(() => client.patch(any(), headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseAccount, 400));

      final UserService userService = UserService(token: -1);
      userService.setClient(client);

      // Act
      // final result = await userService.updateUserData(-1, account);

      // Assert
      expect(
          () async => await userService.updateUserData(account: account),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: Invalid Syntax")));
    });

    test("update account 的 account 不存在 (回傳 Exception)", () async {
      // Arrange
      final client = MockClient();
      AccountModel account = AccountModel.defaultAccount;

      Map<String, dynamic> object = account.toJson();
      final responseAccount = jsonEncode(object);

      when(() => client.patch(any(), headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseAccount, 404));

      final UserService userService = UserService(token: -1);
      userService.setClient(client);

      // Act
      // final result = await userService.updateUserData(-1, account);

      // Assert
      expect(
          () async => await userService.updateUserData(account: account),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: The requesting data was not found")));
    });
    
  });
}
