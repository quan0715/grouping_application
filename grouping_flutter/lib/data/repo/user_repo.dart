import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:grouping_project/data/repo/account_model.dart';
// import 'package:grouping_project/model/auth/auth_model_lib.dart';

/// The server backend IP of the database
const String baseURL = "http://ip"; // TODO: we need to know the django website

/// ## 這個 UserService 主要是負責處理 user 的功能操作
/// 
/// 此 service 可以 get, update user
///
class UserService {
  late final int _token;
  late final Map<String, String> headers;
  http.Client _client = http.Client();

  /// ## 這個 UserService 主要是負責處理 user 的功能操作
  /// 
  /// 此 service 可以 get, update user
  ///
  /// * [token] : 使用者的認證碼
  /// 
  /// ### Example
  /// ```dart
  /// UserService service = UserService(token: userToken);
  /// ```
  ///
  UserService({required int token}) {
    _token = token;
    headers = {
      "ContentType": "application/json",
      "Authorization":"Bearer $_token",
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
  /// 
  Future<AccountModel> getUserData({required int uid}) async {
    final response =
        await _client.get(Uri.parse("$baseURL/users/$uid"), headers: headers);

    if (response.statusCode == 200) {
      return AccountModel.fromJson(data: jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception("Invalid Syntax");
    } else if (response.statusCode == 404) {
      throw Exception("The requesting data was not found");
    } else {
      // TODO: raise Error
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
  Future<AccountModel> updateUserData({required AccountModel account}) async {
    final response = await _client.patch(Uri.parse("$baseURL/users/${account.id}"),
        headers: headers, body: jsonEncode(account));

    if (response.statusCode == 200) {
      return AccountModel.fromJson(data: jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception("Invalid Syntax");
    } else if (response.statusCode == 404) {
      throw Exception("The requesting data was not found");
    } else {
      // TODO: raise Error
      return AccountModel.defaultAccount;
    }
  }
}
