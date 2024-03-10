import 'package:image_picker/image_picker.dart';
import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/user_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/user_remote_data_source.dart';
import 'package:grouping_project/space/data/models/setting_model.dart';
// import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/domain/entities/setting_entity.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> getUser(int userID) async {
    try {
      final userModel = await remoteDataSource.getUserData(uid: userID);
      return Right(userModel.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user) async {
    try {
      final userModel =
          await remoteDataSource.updateUserData(account: user.toModel());
      return Right(userModel.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, SettingEntity>> getSetting() async {
    try {
      final settingModel = await localDataSource.getCacheSetting();
      return Right(SettingEntity.fromModel(settingModel));
    } on CacheException catch (error) {
      return Left(CacheFailure(errorMessage: error.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, void>> updateSetting(
      SettingEntity settingEntity) async {
    try {
      await localDataSource
          .cacheSetting(SettingModel.fromEntity(settingEntity));
      return const Right(null);
    } on CacheException catch (error) {
      return Left(CacheFailure(errorMessage: error.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfilePhoto(
      UserEntity user, XFile image) async {
    try {
      final userModel = await remoteDataSource.updateUserProfileImage(
          account: user.toModel(), image: image);
      return Right(userModel.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
  }
}
