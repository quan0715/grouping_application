import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:grouping_project/model/auth/account_model.dart';
import 'package:grouping_project/model/photo_model.dart';
import 'package:grouping_project/model/repo/user_repo_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class FakeUri extends Mock implements Uri {}

void main(){
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

      final UserService userService = UserService();
      userService.setClient(client);

      // Act
      final result = await userService.getUserData(-1);

      // Assert
      expect(result, account);
    });

    test("藉由 get 獲得任意的 account", () async {
      // Arrange
      final client = MockClient();
      AccountModel account = AccountModel(name: 'test name', slogan: 'test slogan', photo: Photo(data: 'test url', photoId: -1, updateAt: DateTime.now()));

      Map<String, dynamic> object = account.toJson();
      final responseAccount = jsonEncode(object);

      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(responseAccount, 200));

      final UserService userService = UserService();
      userService.setClient(client);

      // Act
      final result = await userService.getUserData(-1);

      // Assert
      expect(result, account);
    });

  });
}