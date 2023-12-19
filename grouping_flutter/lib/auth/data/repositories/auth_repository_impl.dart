import 'package:dartz/dartz.dart';
import 'package:grouping_project/auth/data/datasources/auth_local_data_source.dart';
import 'package:grouping_project/auth/data/datasources/auth_remote_data_source.dart';
import 'package:grouping_project/auth/data/models/auth_token_model.dart';
import 'package:grouping_project/auth/domain/entities/login_entity.dart';
import 'package:grouping_project/auth/domain/entities/register_entity.dart';
import 'package:grouping_project/auth/domain/repositories/auth_login_repositories.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthTokenModel>> passwordLogin(
      LoginEntity loginEntity) async {
    try {
      final token = await remoteDataSource.passwordLogin(loginEntity);
      await localDataSource.cacheToken(token);
      return Right(token);
    } on ServerException catch (error) {
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, AuthTokenModel>> userRegister(
      RegisterEntity registerEntity) async {
    try {
      final token = await remoteDataSource.register(registerEntity);
      await localDataSource.cacheToken(token);
      return Right(token);
    } on ServerException catch (error) {
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
  }

  @override
  Future<void> logOut() async {
    final authTokenModel = await localDataSource.getCacheToken();
    await remoteDataSource.logout(authTokenModel);
    await localDataSource.clearCacheToken();
  }
  
  @override
  Future<Either<Failure, AuthTokenModel>> getAccessToken() async {
    try {
      final token = await localDataSource.getCacheToken();
      return Right(token);
    } on CacheException catch (error) {
      return Left(CacheFailure(errorMessage: error.exceptionMessage));
    }
  }

}
