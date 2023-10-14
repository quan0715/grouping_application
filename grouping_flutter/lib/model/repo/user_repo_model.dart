import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:grouping_project/model/repo/patch_enum.dart';
import 'package:http/http.dart' as http;
import 'package:grouping_project/model/auth/auth_model_lib.dart';

const String baseURL =
    "http://{ip}"; // TODO: we need to know the django website

class UserService {
  final Map<String, String> headers = {"ContentType": "application/json"};

  // UserService({required String uid}): _uid = uid;

  /// get user data
  Future<AccountModel> _getUserData(String uid) async {
    final response =
        await http.get(Uri.parse("$baseURL/users/$uid"), headers: headers);

    if (response.statusCode == 200) {
      return AccountModel.fromJson(data: jsonDecode(response.body));
    } else {
      // TODO: raise Error
      return AccountModel.defaultAccount;
    }
  }

  /// create a new user
  Future<AccountModel> _createUser() async {
    final response =
        await http.post(Uri.parse("$baseURL/users"), headers: headers);

    if (response.statusCode == 201) {
      return AccountModel.fromJson(data: jsonDecode(response.body));
    } else {
      // TODO: raise Error
      return AccountModel.defaultAccount;
    }
  }

  /// can only update real_name, user_name, slogan, introduction 
  void _patchData(String uid, UserCategory category) async {
    final response = await http.patch(Uri.parse("$baseURL/users/$uid"),
        headers: headers, body: {category.name.toString(): category.data});

    if (response.statusCode == 200){
      // do nothing
    }
    else {
      // TODO: raise Error
    }
  }

  // void _updateTags(String uid) async {
  //   final response = await http.patch(Uri.parse("$baseURL/users/$uid"), headers: headers);
  // }
}
