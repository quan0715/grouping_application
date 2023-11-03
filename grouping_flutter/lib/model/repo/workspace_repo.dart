import 'dart:convert';

import 'package:grouping_project/model/workspace/workspace_model.dart';
import 'package:http/http.dart' as http;

/// The server backend IP of the database
const String baseURL = "http://ip"; // TODO: we need to know the django website

/// ## 這個 WorkspaceService 主要是負責處理 workspace 的功能操作
/// 
/// 此 service 可以 get, create, update, delete workspace
///
class WorkspaceService{
  late final String _token;
  late final Map<String, String> headers;
  http.Client _client = http.Client();

  /// ## 這個 WorkspaceService 主要是負責處理 workspace 的功能操作
  /// 
  /// 此 service 可以 get, create, update, delete workspace
  /// 
  /// * [token] : 使用者的認證碼
  /// 
  /// ### Example
  /// ```dart
  /// WorkspaceService service = WorkspaceService(token: userToken);
  /// ```
  ///
  WorkspaceService({required String token}) {
    _token = token;
    headers = {
      "ContentType": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  /// 設定當前 WorkspaceService 要對後端傳遞的**客戶(client)** 
  void setClient(http.Client client) {
    _client = client;
  }

  /// 獲取當前 WorkspaceService 要對後端傳遞的**客戶(client)**
  http.Client getClient() {
    return _client;
  }

  /// ## 獲取想要的 workspace 的資訊
  /// 
  /// 傳入 [workspaceId] 來獲取 [WorkspaceModel]\
  /// 若未出錯則回傳 [WorkspaceModel]\
  /// 若 [workspaceId] 有格式錯誤則會丟出 [Exception]\
  /// 若 [workspaceId] 所對應的 [WorkspaceModel] 不存在則會丟出 [Exception]
  /// 
  /// ### Example
  /// ```dart
  /// WorkspaceModel workspace = await WorkspaceService.getWorkspace(workspaceId: -1);
  /// ```
  /// 
  Future<WorkspaceModel> getWorkspace({required int workspaceId}) async {
    final response =
        await _client.get(Uri.parse("$baseURL/workspaces/$workspaceId"), headers: headers);

    if (response.statusCode == 200) {
      return WorkspaceModel.fromJson(data: jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception("Invalid Syntax");
    } else if (response.statusCode == 404) {
      throw Exception("The requesting data was not found");
    } else {
      // TODO: raise Error
      return WorkspaceModel.defaultWorkspace;
    }
  }

  /// ## 創立一個 workspace
  /// 
  /// 傳入 [WorkspaceModel] 來建立一個 [WorkspaceModel]\
  /// 若未出錯則回傳 [WorkspaceModel]\
  /// 若 [workspace] 有格式錯誤則會丟出 [Exception]
  /// 
  /// ### Example
  /// ```dart
  /// WorkspaceModel workspace = await WorkspaceService.createWorkspace(workspace: createDataOfWorkspace);
  /// ```
  /// 
  Future<WorkspaceModel> createWorkspace({required WorkspaceModel workspace}) async {
    Map<String, dynamic> workspaceBody = workspace.toJson();

    final response = await _client.post(
        Uri.parse("$baseURL/workspaces"),
        headers: headers,
        body: jsonEncode(workspaceBody));

    // successfully set up new data
    if (response.statusCode == 201) {
      return WorkspaceModel.fromJson(data: jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception("Invalid Syntax");
    } else {
      // TODO: raise Error
      return WorkspaceModel.defaultWorkspace;
    }
  }

  /// ## 更新 workspace 的資訊
  /// 
  /// 傳入 [WorkspaceModel] 來更新資料\
  /// 若未出錯則回傳更新後的 [WorkspaceModel]\
  /// 若 [workspace] 有格式錯誤則會丟出 [Exception]\
  /// 若 [workspace] 所對應的 [WorkspaceModel] 不存在則會丟出 [Exception]
  /// 
  /// ### Example
  /// ```dart
  /// WorkspaceModel workspace = await WorkspaceService.updateWorkspace(workspace: updateModelofWorkspace);
  /// ```
  /// 
  Future<WorkspaceModel> updateWorkspace({required WorkspaceModel workspace}) async {
    Map<String, dynamic> eventBody = workspace.toJson();

    final response = await _client.patch(
        Uri.parse("$baseURL/workspaces/${workspace.id}"),
        headers: headers,
        body: jsonEncode(eventBody));

    // successfully set up new data
    if (response.statusCode == 200) {
      return WorkspaceModel.fromJson(data: jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception("Invalid Syntax");
    } else if (response.statusCode == 404) {
      throw Exception("The requesting data was not found");
    } else {
      // TODO: raise Error
      return WorkspaceModel.defaultWorkspace;
    }
  }

  /// ## 刪除 workspace
  /// 
  /// 傳入 [workspaceId] 來刪除所對應的 [WorkspaceModel]\
  /// 若未出錯則不回傳\
  /// 若 [workspaceId] 有格式錯誤則會丟出 [Exception]\
  /// 若 [workspaceId] 所對應的 [WorkspaceModel] 不存在則會丟出 [Exception]
  /// 
  /// ### Example
  /// ```dart
  /// await WorkspaceService.deleteWorkspace(workspaceId: -1);
  /// ```
  /// 
  Future<void> deleteWorkspace({required int workspaceId}) async {
    final response = await _client.delete(
        Uri.parse("$baseURL/workspaces/$workspaceId"),
        headers: headers);

    // successfully delete data
    if (response.statusCode == 200) {
      // do nothing
    } else if (response.statusCode == 400) {
      throw Exception("Invalid Syntax");
    } else if (response.statusCode == 404) {
      throw Exception("The requesting data was not found");
    } else {
      // TODO: raise Error
    }
  }
}