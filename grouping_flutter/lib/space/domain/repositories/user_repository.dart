import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/setting_entity.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUser(int userID);
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user);
  Future<Either<Failure, SettingEntity>> getSetting();
  Future<Either<Failure, void>> updateSetting(SettingEntity settingEntity);
  Future<Either<Failure, UserEntity>> updateProfilePhoto(UserEntity user, XFile image);
}
