import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grouping_project/core/config/config.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

abstract class WorkspaceRemoteDataSource {
  WorkspaceRemoteDataSource();
  Future<WorkspaceModel> getWorkspaceData({required int workspaceId});
  Future<WorkspaceModel> createWorkspaceData(
      {required WorkspaceModel workspace, XFile? image});
  Future<WorkspaceModel> updateWorkspaceData(
      {required WorkspaceModel workspace});
  Future<void> deleteWorkspaceData({required int workspaceId});
}

/// ## 這個 WorkspaceRemoteDataSourceImpl 主要負責處理 workspace 與後端的功能操作
///
/// 此 remote data source 可以 get, create, update, and delete workspace
class WorkspaceRemoteDataSourceImpl extends WorkspaceRemoteDataSource {
  late final String _token;
  late final Map<String, String> headers;
  http.Client _client = http.Client();

  /// ## 這個 WorkspaceRemoteDataSourceImpl 主要負責處理 workspace 與後端的功能操作
  ///
  /// 此 remote data source 可以 get, create, update, and delete workspace
  ///
  /// * [token] : 使用者的認證碼
  ///
  /// ### Example
  /// ```dart
  /// WorkspaceRemoteDataSource remoteDataSource = WorkspaceRemoteDataSourceImpl(token: userToken);
  /// ```
  ///
  WorkspaceRemoteDataSourceImpl({required String token}) {
    _token = token;
    headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  /// 設定當前 UserService 要對後端傳遞的**客戶(client)**
  void setClient(http.Client client) {
    _client = client;
  }

  /// 獲取當前 UserService 要對後端傳遞的**客戶(client)**
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
  /// WorkspaceRemoteDataSource remoteDataSource = WorkspaceRemoteDataSourceImp(token: userToken);
  /// WorkspaceModel workspace = await remoteDataSource.getWorkspaceData(workspaceId: -1);
  /// ```
  ///
  @override
  Future<WorkspaceModel> getWorkspaceData({required int workspaceId}) async {
    final response = await _client.get(
        Uri.parse("${Config.baseUriWeb}/api/workspaces/$workspaceId"),
        headers: headers);

    switch (response.statusCode) {
      case 200:
        return WorkspaceModel.fromJson(
            data: jsonDecode(utf8.decode(response.bodyBytes)));
      case 400:
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        throw ServerException(
            exceptionMessage: "The requesting data was not found");
      default:
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
  /// WorkspaceRemoteDataSource remoteDataSource = WorkspaceRemoteDataSourceImp(token: userToken);
  /// WorkspaceModel workspace = await remoteDataSource.createWorkspaceData(workspace: createDataOfWorkspace);
  /// ```
  ///
  @override
  Future<WorkspaceModel> createWorkspaceData(
      {required WorkspaceModel workspace, XFile? image}) async {
    Map<String, dynamic> workspaceBody = workspace.toJson();
    var api = Uri.parse("${Config.baseUriWeb}/api/workspaces/");

    workspaceBody.remove('photo_data');
    var response = await _client.post(api,
        headers: headers, body: jsonEncode(workspaceBody));
    WorkspaceModel temp;
    switch (response.statusCode) {
      case 201:
        temp = WorkspaceModel.fromJson(
            data: jsonDecode(utf8.decode(response.bodyBytes)));
        if (image == null) {
          return temp;
        }
        break;

      case 400:
        throw ServerException(exceptionMessage: "Invalid Syntax");
      default:
        throw ServerException(
            exceptionMessage: utf8.decode(response.bodyBytes));
    }

    api = Uri.parse("${Config.baseUriWeb}/api/workspaces/${temp.id}/");
    var request = http.MultipartRequest("PATCH", api);
    request.files.add(
      http.MultipartFile.fromBytes(
        'photo_data',
        await image.readAsBytes(),
        filename: '${image.path.split("/").last}.jpg',
      ),
    );
    workspaceBody.remove('photo_data');
    request.headers.addAll(headers);
    var streamedResponse = await request.send();
    response = await http.Response.fromStream(streamedResponse);

    switch (response.statusCode) {
      case 200:
        return WorkspaceModel.fromJson(
            data: jsonDecode(utf8.decode(response.bodyBytes)));
      case 400:
        throw ServerException(exceptionMessage: "Invalid Syntax");
      default:
        throw ServerException(
            exceptionMessage: utf8.decode(response.bodyBytes));
    }
    // debugPrint(response.body);
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
  /// WorkspaceRemoteDataSource remoteDataSource = WorkspaceRemoteDataSourceImp(token: userToken);
  /// WorkspaceModel workspace = await remoteDataSource.updateWorkspaceData(workspace: updateDataOfWorkspace);
  /// ```
  ///
  @override
  Future<WorkspaceModel> updateWorkspaceData(
      {required WorkspaceModel workspace}) async {
    Map<String, dynamic> workspaceBody = workspace.toJson();
    workspaceBody.remove('photo_data');
    // debugPrint(workspaceBody.toString());

    final response = await _client.patch(
        Uri.parse("${Config.baseUriWeb}/api/workspaces/${workspace.id}/"),
        headers: headers,
        body: jsonEncode(workspaceBody));

    switch (response.statusCode) {
      case 200:
        return WorkspaceModel.fromJson(
            data: jsonDecode(utf8.decode(response.bodyBytes)));
      case 400:
        debugPrint(response.body);
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        throw ServerException(
            exceptionMessage:
                "The requesting data was not found, ${response.body}");
      default:
        throw ServerException(
            exceptionMessage: "unKnown Error, ${response.body}");
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
  /// WorkspaceRemoteDataSource remoteDataSource = WorkspaceRemoteDataSourceImp(token: userToken);
  /// await remoteDataSource.deleteWorkspaceData(workspaceId: -1);
  /// ```
  ///
  @override
  Future<void> deleteWorkspaceData({required int workspaceId}) async {
    final response = await _client.delete(
        Uri.parse("${Config.baseUriWeb}/api/workspaces/$workspaceId"),
        headers: headers);
    switch (response.statusCode) {
      case 200:
        // do nothing
        return;
      case 400:
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        throw ServerException(
            exceptionMessage: "The requesting data was not found");
      default:
        // do nothing
        return;
    }
  }
}
