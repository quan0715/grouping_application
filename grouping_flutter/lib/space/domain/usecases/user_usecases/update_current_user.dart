import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/domain/repositories/user_repository.dart';
import 'package:image_picker/image_picker.dart';

class UpdateUserUseCase {
  final UserRepository _userRepository;

  UpdateUserUseCase(this._userRepository);

  Future<Either<Failure, UserEntity>> call(UserEntity user) async {
    return await _userRepository.updateUser(user);
  }
}

class UpdateUserProfilePhotoUseCase {
  final UserRepository _userRepository;

  UpdateUserProfilePhotoUseCase(this._userRepository);

  Future<Either<Failure, UserEntity>> call(UserEntity user, XFile image) async {
    return await _userRepository.updateProfilePhoto(user, image);
  }
}