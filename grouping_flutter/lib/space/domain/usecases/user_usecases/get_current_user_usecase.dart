import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/domain/repositories/user_repository.dart';

class GetCurrentUserUseCase{
  final UserRepository _userRepository;
  
  GetCurrentUserUseCase(this._userRepository);

  Future<Either<Failure, UserEntity>> call(int userID) async {
    return _userRepository.getUser(userID);
  } 
}