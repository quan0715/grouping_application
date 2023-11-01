import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:grouping_project/model/auth/account_model.dart';
// import 'package:grouping_project/model/auth/auth_model_lib.dart';

const String baseURL = "http://ip"; // TODO: we need to know the django website

class UserService {
  late final String _token;
  late final Map<String, String> headers;
  http.Client _client = http.Client();

  UserService({required String token}) {
    _token = token;
    headers = {
      "ContentType": "application/json",
      "Authorization":"Bearer $_token",
    };
  }

  void setClient(http.Client client) {
    _client = client;
  }

  http.Client getClient() {
    return _client;
  }

  // UserService({required String uid}): _uid = uid;

  /// get user data
  Future<AccountModel> getUserData(int uid) async {
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

  /// can only update real_name, user_name, slogan, introduction
  Future<AccountModel> updateUserData(int uid, AccountModel account) async {
    final response = await _client.patch(Uri.parse("$baseURL/users/$uid"),
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
