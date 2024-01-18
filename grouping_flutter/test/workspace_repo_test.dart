// import 'dart:convert';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:grouping_project/space/data/datasources/local_data_source/workspace_local_data_source.dart';
// import 'package:grouping_project/space/data/datasources/remote_data_source/workspace_remote_data_source.dart';
// import 'package:grouping_project/space/data/models/workspace_model.dart';
// import 'package:grouping_project/space/data/repositories/workspace_repository_impl.dart';
// import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
// import 'package:grouping_project/space/domain/repositories/workspace_repository.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:http/http.dart' as http;

// class MockClient extends Mock implements http.Client {}

// class FakeUri extends Mock implements Uri {}

// void main() {
//   group('workspace repo 功能測試:', () {
//     setUp(() {
//       registerFallbackValue(FakeUri());
//     });
//     tearDown(() => null);

//     test("藉由 get 獲得預設的 workspace (default)", () async {
//       // Arrange
//       final client = MockClient();
//       WorkspaceModel workspace = WorkspaceModel.defaultWorkspace;
//       WorkspaceEntity entity = workspace.toEntity();

//       Map<String, dynamic> object = workspace.toJson();
//       final responseAccount = jsonEncode(object);

//       when(() => client.get(any(), headers: any(named: 'headers')))
//           .thenAnswer((_) async => http.Response(responseAccount, 200));

//       final WorkspaceRemoteDataSource remoteDataSource =
//           WorkspaceRemoteDataSourceImpl(token: 'test');
//       (remoteDataSource as WorkspaceRemoteDataSourceImpl).setClient(client);
//       // final WorkspaceService workspaceService = WorkspaceService(token: "test");
//       // workspaceService.setClient(client);

//       final WorkspaceRepository repo = WorkspaceRepositoryImpl(
//           remoteDataSource: remoteDataSource,
//           localDataSource: WorkspaceLocalDataSourceImpl());

//       // Act
//       final result = await repo.getWorkspace(-1);

//       // Assert
//       expect(result, entity);
//     });
//     /*
//     test("藉由 get 獲得任意的 workspace", () async {
//       // Arrange
//       final client = MockClient();
//       WorkspaceModel workspace = WorkspaceModel(
//           name: 'test name',
//           themeColor: 0x7f2473,
//           photo: ImageModel(
//               data: 'test url', imageId: -1, updateAt: DateTime.now()));

//       Map<String, dynamic> object = workspace.toJson();
//       final responseAccount = jsonEncode(object);

//       when(() => client.get(any(), headers: any(named: 'headers')))
//           .thenAnswer((_) async => http.Response(responseAccount, 200));

//       final WorkspaceService workspaceService = WorkspaceService(token: "test");
//       workspaceService.setClient(client);

//       // Act
//       final result = await workspaceService.getWorkspace(workspaceId: -1);

//       // Assert
//       expect(result, workspace);
//     });
  
//     test("get workspace 的 id 不符合要求 (回傳 Exception)", () async {
//       // Arrange
//       final client = MockClient();
//       WorkspaceModel workspace = WorkspaceModel(
//           name: 'test name',
//           themeColor: 0x7f2473,
//           photo: ImageModel(
//               data: 'test url', imageId: -1, updateAt: DateTime.now()));

//       Map<String, dynamic> object = workspace.toJson();
//       final responseWorkspace = jsonEncode(object);

//       when(() => client.get(any(), headers: any(named: 'headers')))
//           .thenAnswer((_) async => http.Response(responseWorkspace, 400));

//       final WorkspaceService workspaceService = WorkspaceService(token: "test");
//       workspaceService.setClient(client);

//       // Act

//       // Assert
//       expect(
//           () async => await workspaceService.getWorkspace(workspaceId: -1),
//           throwsA(predicate((e) =>
//               e is Exception && e.toString() == "Exception: Invalid Syntax")));
//     });

//     test("get workspace 的 workspace 不存在 (回傳 Exception)", () async {
//       // Arrange
//       final client = MockClient();
//       WorkspaceModel workspace = WorkspaceModel(
//           name: 'test name',
//           themeColor: 0x7f2473,
//           photo: ImageModel(
//               data: 'test url', imageId: -1, updateAt: DateTime.now()));

//       Map<String, dynamic> object = workspace.toJson();
//       final responseWorkspace = jsonEncode(object);

//       when(() => client.get(any(), headers: any(named: 'headers')))
//           .thenAnswer((_) async => http.Response(responseWorkspace, 404));

//       final WorkspaceService workspaceService = WorkspaceService(token: "test");
//       workspaceService.setClient(client);

//       // Act

//       // Assert
//       expect(
//           () async => await workspaceService.getWorkspace(workspaceId: -1),
//           throwsA(predicate((e) =>
//               e is Exception &&
//               e.toString() == "Exception: The requesting data was not found")));
//     });

//     test("藉由 create 獲得預設的 workspace (default)", () async {
//       // Arrange
//       final client = MockClient();
//       WorkspaceModel workspace = WorkspaceModel.defaultWorkspace;

//       Map<String, dynamic> object = workspace.toJson();
//       final responseAccount = jsonEncode(object);

//       when(() => client.post(any(),
//               headers: any(named: 'headers'), body: any(named: 'body')))
//           .thenAnswer((_) async => http.Response(responseAccount, 201));

//       final WorkspaceService workspaceService = WorkspaceService(token: "test");
//       workspaceService.setClient(client);

//       // Act
//       final result =
//           await workspaceService.createWorkspace(workspace: workspace);

//       // Assert
//       expect(result, workspace);
//     });

//     test("藉由 create 獲得任意的 workspace", () async {
//       // Arrange
//       final client = MockClient();
//       WorkspaceModel workspace = WorkspaceModel(
//           name: 'test name',
//           themeColor: 0x7f2473,
//           photo: ImageModel(
//               data: 'test url', imageId: -1, updateAt: DateTime.now()));

//       Map<String, dynamic> object = workspace.toJson();
//       final responseAccount = jsonEncode(object);

//       when(() => client.post(any(),
//               headers: any(named: 'headers'), body: any(named: 'body')))
//           .thenAnswer((_) async => http.Response(responseAccount, 201));

//       final WorkspaceService workspaceService = WorkspaceService(token: "test");
//       workspaceService.setClient(client);

//       // Act
//       final result =
//           await workspaceService.createWorkspace(workspace: workspace);

//       // Assert
//       expect(result, workspace);
//     });

//     test("create workspace 的 workspace 不符合要求 (回傳 Exception)", () async {
//       // Arrange
//       final client = MockClient();
//       WorkspaceModel workspace = WorkspaceModel(
//           name: 'test name',
//           themeColor: 0x7f2473,
//           photo: ImageModel(
//               data: 'test url', imageId: -1, updateAt: DateTime.now()));

//       Map<String, dynamic> object = workspace.toJson();
//       final responseWorkspace = jsonEncode(object);

//       when(() => client.post(any(),
//               headers: any(named: 'headers'), body: any(named: 'body')))
//           .thenAnswer((_) async => http.Response(responseWorkspace, 400));

//       final WorkspaceService workspaceService = WorkspaceService(token: "test");
//       workspaceService.setClient(client);

//       // Act

//       // Assert
//       expect(
//           () async =>
//               await workspaceService.createWorkspace(workspace: workspace),
//           throwsA(predicate((e) =>
//               e is Exception && e.toString() == "Exception: Invalid Syntax")));
//     });

//     test("藉由 update 獲得更新後的 workspace", () async {
//       // Arrange
//       final client = MockClient();
//       WorkspaceModel workspace = WorkspaceModel(
//           name: 'test name',
//           themeColor: 0x7f2473,
//           photo: ImageModel(
//               data: 'test url', imageId: -1, updateAt: DateTime.now()));

//       Map<String, dynamic> object = workspace.toJson();
//       final responseAccount = jsonEncode(object);

//       when(() => client.patch(any(),
//               headers: any(named: 'headers'), body: any(named: 'body')))
//           .thenAnswer((_) async => http.Response(responseAccount, 200));

//       final WorkspaceService workspaceService = WorkspaceService(token: "test");
//       workspaceService.setClient(client);

//       // Act
//       final result =
//           await workspaceService.updateWorkspace(workspace: workspace);

//       // Assert
//       expect(result, workspace);
//     });

//     test("update workspace 的 workspace 不符合要求 (回傳 Exception)", () async {
//       // Arrange
//       final client = MockClient();
//       WorkspaceModel workspace = WorkspaceModel(
//           name: 'test name',
//           themeColor: 0x7f2473,
//           photo: ImageModel(
//               data: 'test url', imageId: -1, updateAt: DateTime.now()));

//       Map<String, dynamic> object = workspace.toJson();
//       final responseWorkspace = jsonEncode(object);

//       when(() => client.patch(any(),
//               headers: any(named: 'headers'), body: any(named: 'body')))
//           .thenAnswer((_) async => http.Response(responseWorkspace, 400));

//       final WorkspaceService workspaceService = WorkspaceService(token: "test");
//       workspaceService.setClient(client);

//       // Act

//       // Assert
//       expect(
//           () async =>
//               await workspaceService.updateWorkspace(workspace: workspace),
//           throwsA(predicate((e) =>
//               e is Exception && e.toString() == "Exception: Invalid Syntax")));
//     });

//     test("update workspace 的 workspace 不存在 (回傳 Exception)", () async {
//       // Arrange
//       final client = MockClient();
//       WorkspaceModel workspace = WorkspaceModel(
//           name: 'test name',
//           themeColor: 0x7f2473,
//           photo: ImageModel(
//               data: 'test url', imageId: -1, updateAt: DateTime.now()));

//       Map<String, dynamic> object = workspace.toJson();
//       final responseWorkspace = jsonEncode(object);

//       when(() => client.patch(any(),
//               headers: any(named: 'headers'), body: any(named: 'body')))
//           .thenAnswer((_) async => http.Response(responseWorkspace, 404));

//       final WorkspaceService workspaceService = WorkspaceService(token: "test");
//       workspaceService.setClient(client);

//       // Act

//       // Assert
//       expect(
//           () async =>
//               await workspaceService.updateWorkspace(workspace: workspace),
//           throwsA(predicate((e) =>
//               e is Exception &&
//               e.toString() == "Exception: The requesting data was not found")));
//     });

//     test("delete workspace 是否正確", () async {
//       // Arrange
//       final client = MockClient();

//       when(() => client.delete(any(), headers: any(named: 'headers')))
//           .thenAnswer((_) async => http.Response('', 200));

//       final WorkspaceService workspaceService = WorkspaceService(token: "test");
//       workspaceService.setClient(client);

//       // Act

//       // Assert
//       expect(
//           () async => await workspaceService.deleteWorkspace(workspaceId: -1),
//           isA<void>());
//     });

//     test("delete workspace 的 id 不符合格式 (回傳 exception)", () async {
//       // Arrange
//       final client = MockClient();

//       when(() => client.delete(any(), headers: any(named: 'headers')))
//           .thenAnswer((_) async => http.Response('', 400));

//       final WorkspaceService workspaceService = WorkspaceService(token: "test");
//       workspaceService.setClient(client);

//       // Act

//       // Assert
//       expect(
//           () async => await workspaceService.deleteWorkspace(workspaceId: -1),
//           throwsA(predicate((e) =>
//               e is Exception && e.toString() == "Exception: Invalid Syntax")));
//     });

//     test("delete workspace 的 id 不存在 (回傳 exception)", () async {
//       // Arrange
//       final client = MockClient();

//       when(() => client.delete(any(), headers: any(named: 'headers')))
//           .thenAnswer((_) async => http.Response('', 404));

//       final WorkspaceService workspaceService = WorkspaceService(token: "test");
//       workspaceService.setClient(client);

//       // Act

//       // Assert
//       expect(
//           () async => await workspaceService.deleteWorkspace(workspaceId: -1),
//           throwsA(predicate((e) =>
//               e is Exception &&
//               e.toString() == "Exception: The requesting data was not found")));
//     });
//   */
//   });
// }
