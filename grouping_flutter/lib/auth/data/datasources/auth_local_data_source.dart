import 'package:grouping_project/auth/data/models/auth_token_model.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:grouping_project/core/shared/shared_prefs.dart';



abstract class AuthLocalDataSource {
  Future<void>? cacheToken(AuthTokenModel? token);
  Future<AuthTokenModel> getCacheToken();
  Future<void> clearCacheToken();
}

// const cachedPokemon = 'CACHED_POKEMON';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  
  @override
  Future<void>? cacheToken(AuthTokenModel? tokenModel) async{
    final sharedPreferences = SharedPrefs.instance;
    if(tokenModel?.token == null){
      throw CacheException(
        exceptionMessage: 'cache Token is null',
      );
    }else if(tokenModel!.isExpired){
      throw CacheException(
        exceptionMessage: 'cache Token is expired',
      );
    } else{
      await sharedPreferences.setValue("String", 'auth-token', tokenModel!.token);
    }
  }
  
  @override
  Future<AuthTokenModel> getCacheToken() async {
    // String? token = await storage.read(key: 'auth-token');
    final sharedPreferences = SharedPrefs.instance;
    final tokenString = (await sharedPreferences.getAllWithPrefix(''))['auth-token'] ?? "";

    // debugPrint('get token from cache $data');
    final tokenModel = AuthTokenModel(token: tokenString as String);
    // debugPrint('get token from cache $tokenModel');
    if (tokenModel.token.isEmpty) {
      throw CacheException(
        exceptionMessage: 'cache Token is empty',
      );
    }
    else if(tokenModel.isExpired){
      throw CacheException(
        exceptionMessage: 'cache Token is expired',
      );
    } else {
      return tokenModel;
    }
  }
  
  @override
  Future<void> clearCacheToken() async {
    final sharedPreferences = SharedPrefs.instance;
    await sharedPreferences.remove('auth-token');
  }
  
}