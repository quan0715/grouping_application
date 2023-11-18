import 'package:grouping_project/auth/data/models/sub_model.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';



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
  Future<void>? cacheToken(AuthTokenModel? tokenModel) async{
    final sharedPreferences = await SharedPreferences.getInstance();
    if(tokenModel?.token == null){
      throw CacheException(
        exceptionMessage: 'cache Token is null',
      );
    }else{
      // debugPrint('write token to cache ${tokenModel!.token}');
      await sharedPreferences.setString('auth-token', tokenModel!.token);
      // await storage.write(key: 'auth-token', value: tokenModel!.token);
    }
  }
  
  @override
  Future<AuthTokenModel> getCacheToken() async {
    // String? token = await storage.read(key: 'auth-token');
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('auth-token');
    // debugPrint('get token from cache $token');
    if (token != null) {
      return AuthTokenModel(token: token);
    } else {
      throw CacheException(
        exceptionMessage: 'Token is null',
      );
    }
  }
  
  @override
  Future<void> clearCacheToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
  
}