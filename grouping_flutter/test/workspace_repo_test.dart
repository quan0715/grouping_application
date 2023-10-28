import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:grouping_project/model/workspace/workspace_model.dart';
import 'package:grouping_project/model/photo_model.dart';
import 'package:grouping_project/model/repo/workspace_repo.dart';
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

    test("藉由 get 獲得預設的 workspace (default)", () async {
      // Arrange
      final client = MockClient();
      WorkspaceModel workspace = WorkspaceModel.defaultWorkspace;

      Map<String, dynamic> object = workspace.toJson();
      final responseAccount = jsonEncode(object);

      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(responseAccount, 200));

      final WorkspaceService workspaceService = WorkspaceService(token: "test");
      workspaceService.setClient(client);

      // Act
      final result = await workspaceService.getWorkspace(-1);

      // Assert
      expect(result, workspace);
    });

    test("藉由 get 獲得任意的 workspace", () async {
      // Arrange
      final client = MockClient();
      WorkspaceModel workspace = WorkspaceModel(
          name: 'test name',
          themeColor: 0x7f2473,
          photo:
              Photo(data: 'test url', photoId: -1, updateAt: DateTime.now()));

      Map<String, dynamic> object = workspace.toJson();
      final responseAccount = jsonEncode(object);

      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(responseAccount, 200));

      final WorkspaceService workspaceService = WorkspaceService(token: "test");
      workspaceService.setClient(client);

      // Act
      final result = await workspaceService.getWorkspace(-1);

      // Assert
      expect(result, workspace);
    });

    test("藉由 create 獲得預設的 workspace (default)", () async {
      // Arrange
      final client = MockClient();
      WorkspaceModel workspace = WorkspaceModel.defaultWorkspace;

      Map<String, dynamic> object = workspace.toJson();
      final responseAccount = jsonEncode(object);

      when(() => client.post(any(), headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseAccount, 201));

      final WorkspaceService workspaceService = WorkspaceService(token: "test");
      workspaceService.setClient(client);

      // Act
      final result = await workspaceService.createWorkspace(workspace);

      // Assert
      expect(result, workspace);
    });

    test("藉由 create 獲得任意的 workspace", () async {
      // Arrange
      final client = MockClient();
      WorkspaceModel workspace = WorkspaceModel(
          name: 'test name',
          themeColor: 0x7f2473,
          photo:
              Photo(data: 'test url', photoId: -1, updateAt: DateTime.now()));

      Map<String, dynamic> object = workspace.toJson();
      final responseAccount = jsonEncode(object);

      when(() => client.post(any(), headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseAccount, 201));

      final WorkspaceService workspaceService = WorkspaceService(token: "test");
      workspaceService.setClient(client);

      // Act
      final result = await workspaceService.createWorkspace(workspace);

      // Assert
      expect(result, workspace);
    });

    // test("呼叫 deleteWorkspace 來刪除", () async {
    //   // Arrange
    //   final client = MockClient();
    //   // WorkspaceModel workspace = WorkspaceModel(
    //   //     name: 'test name',
    //   //     themeColor: 0x7f2473,
    //   //     photo:
    //   //         Photo(data: 'test url', photoId: -1, updateAt: DateTime.now()));

    //   // Map<String, dynamic> object = workspace.toJson();
    //   // final responseAccount = jsonEncode(object);

    //   when(() => client.delete(any(), headers:  any(named: 'headers'))).thenAnswer((_) async => http.Response('', 200));
    //   // when(() => client.post(any(), headers: any(named: 'headers'), body: any(named: 'body')))
    //   //     .thenAnswer((_) async => http.Response(responseAccount, 200));

    //   final WorkspaceService workspaceService = WorkspaceService(token: "test");
    //   workspaceService.setClient(client);

    //   // Act
    //   fn() => workspaceService.deleteWorkspace(-1);

    //   // Assert
    //   // expect(result, workspace);
    // });
  });
}
