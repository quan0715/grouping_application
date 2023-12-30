import 'package:flutter/material.dart';
import 'package:grouping_project/auth/data/models/auth_token_model.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:grouping_project/core/shared/app_shared_data.dart';

abstract class AuthLocalDataSource {
  Future<void>? cacheToken(AuthTokenModel? token);
  Future<AuthTokenModel> getCacheToken();
  Future<void> clearCacheToken();
}

// const cachedPokemon = 'CACHED_POKEMON';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  // final FlutterSecureStorage storage;

  AuthLocalDataSourceImpl();

  @override
  Future<void>? cacheToken(AuthTokenModel? tokenModel) async {
    final sharedPreferences = AppSharedData.instance;
    if (tokenModel?.token == null) {
      throw CacheException(
        exceptionMessage: 'cache Token is null',
      );
    } else if (tokenModel!.isExpired) {
      throw CacheException(
        exceptionMessage: 'cache Token is expired',
      );
    } else {
      await sharedPreferences.setValue(
          "String", 'auth-token', tokenModel.token);
      debugPrint("auth-token: ${tokenModel.token}");
      await sharedPreferences.setValue(
          "String", "refresh-token", tokenModel.refresh);
      debugPrint("refresh-token: ${tokenModel.refresh}");
    }
  }

  @override
  Future<AuthTokenModel> getCacheToken() async {
    // String? token = await storage.read(key: 'auth-token');
    final sharedPreferences = AppSharedData.instance;
    final tokenString =
        (await sharedPreferences.getAllWithPrefix(''))['auth-token'] ?? "";
    final refreshString =
        (await sharedPreferences.getAllWithPrefix(''))['refresh-token'] ?? "";

    debugPrint(tokenString.toString());
    debugPrint(refreshString.toString());
    // debugPrint('get token from cache $data');
    final tokenModel = AuthTokenModel(
      token: tokenString as String,
      refresh: refreshString as String,
    );
    // debugPrint('get token from cache $tokenModel');
    if (tokenModel.token.isEmpty) {
      throw CacheException(
        exceptionMessage: 'cache Token is empty',
      );
    } else if (tokenModel.isExpired) {
      throw CacheException(
        exceptionMessage: 'cache Token is expired',
      );
    } else {
      return tokenModel;
    }
  }

  @override
  Future<void> clearCacheToken() async {
    final sharedPreferences = AppSharedData.instance;
    await sharedPreferences.remove('auth-token');
    await sharedPreferences.remove('refresh-token');
  }
}
