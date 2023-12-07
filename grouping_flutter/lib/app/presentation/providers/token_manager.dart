import 'package:flutter/material.dart';
import 'package:grouping_project/auth/data/datasources/auth_local_data_source.dart';
import 'package:grouping_project/auth/data/models/auth_token_model.dart';

class TokenManager extends ChangeNotifier {
  // String? userAccessToken = '';
  AuthTokenModel tokenModel = AuthTokenModel(token: '', refresh: '');
  bool get isLogin => tokenModel.isValid;

  Future<void> updateToken() async {
    // debugPrint("TokenManager getAccessToken");
    AuthLocalDataSource authLocalDataSource = AuthLocalDataSourceImpl();
    // AuthLocalDataSource authLocalDataSource = AuthLocalDataSource();
    try {
      final token = await authLocalDataSource.getCacheToken();
      // debugPrint("TokenManager getAccessToken token: ${token.token}");
      debugPrint("update token");
      tokenModel = token;
      notifyListeners();
      // return token;
    } catch (e) {
      debugPrint(e.toString());
      tokenModel = AuthTokenModel(token: '', refresh: '');
      notifyListeners();
    }
  }

  void updateTokenModel(AuthTokenModel token) {
    tokenModel = token;
    notifyListeners();
  }

  Future<void> init() async {
    await updateToken();
  }
}
