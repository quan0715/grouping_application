import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:grouping_project/core/config/config.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:grouping_project/space/data/models/account_model.dart';

/// The server backend IP of the database
/// ## 這個 UserService 主要是負責處理 user 的功能操作
/// 
/// 此 service 可以 get, update user

abstract class UserRemoteDataSource{
  UserRemoteDataSource({String token = ""});
  Future<AccountModel> getUserData({required int uid});
  Future<AccountModel> updateUserData({required AccountModel account});
  
}
class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  late final String _token;
  late final Map<String, String> headers;
  http.Client _client = http.Client();

  /// ## 這個 UserService 主要是負責處理 user 的功能操作
  /// r
  /// 此 service 可以 get, update user
  ///
  /// * [token] : 使用者的認證碼
  /// 
  /// ### Example
  /// ```dart
  /// UserService service = UserService(token: userToken);
  /// ```
  ///
  UserRemoteDataSourceImpl({required String token}) {
    _token = token;
    headers = {
      "Content-Type": "application/json",
      "Authorization":"Bearer $_token",
    };
  }

  // / 設定當前 UserService 要對後端傳遞的**客戶(client)** 
  void setClient(http.Client client) {
    _client = client;
  }

  /// 獲取當前 UserService 要對後端傳遞的**客戶(client)**
  http.Client getClient() {
    return _client;
  }

  /// ## 獲取想要的 user 的資訊
  /// 
  /// 傳入 [uid] 來獲取 [AccountModel]\
  /// 若未出錯則回傳 [AccountModel]\
  /// 若 [uid] 有格式錯誤則會丟出 [Exception]\
  /// 若 [uid] 所對應的 [AccountModel] 不存在則會丟出 [Exception]
  /// 
  /// ### Example
  /// ```dart
  /// AccountModel account = await UserService.getUserData(uid: -1);
  /// ```
  
  @override
  Future<AccountModel> getUserData({required int uid}) async {
    final apiUri = Uri.parse("${Config.baseUriWeb}/api/users/$uid");
    final response = await _client.get(apiUri, headers: headers);
    switch (response.statusCode) {
        case 200:
        // To avoid chinese character become unicode, we need to decode response.bodyBytes to utf-8 format first
          return AccountModel.fromJson(data: jsonDecode(utf8.decode(response.bodyBytes)));
        case 400:
          throw ServerException(exceptionMessage: "Invalid Syntax");
        case 404:
          throw ServerException(exceptionMessage: "The requesting data was not found");
        default:
          return AccountModel.defaultAccount;
    }
  }

  /// ## 更新 user 的資訊
  /// 
  /// 傳入 [AccountModel] 來更新資料\
  /// 若未出錯則回傳更新後的 [AccountModel]\
  /// 若 [account] 有格式錯誤則會丟出 [Exception]\
  /// 若 [account] 所對應的 [AccountModel] 不存在則會丟出 [Exception]
  /// 
  /// ### Example
  /// ```dart
  /// AccountModel account = await UserService.updateUserData(account: updateModelOfAccount);
  /// ```
  /// 
  @override
  Future<AccountModel> updateUserData({required AccountModel account}) async {
    final apiUri = Uri.parse("${Config.baseUriWeb}/api/users/${account.id}");
    final response = await _client.patch(apiUri, headers: headers, body: jsonEncode(account));

    switch (response.statusCode) {
      case 200:
        return AccountModel.fromJson(data: jsonDecode(response.body));
      case 400:
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        throw ServerException(exceptionMessage: "The requesting data was not found");
      default:
        return AccountModel.defaultAccount;
    }
  }
}
