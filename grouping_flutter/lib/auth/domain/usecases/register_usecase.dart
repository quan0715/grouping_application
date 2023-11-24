import 'package:dartz/dartz.dart';
import 'package:grouping_project/auth/data/models/sub_model.dart';
import 'package:grouping_project/auth/domain/entities/register_entity.dart';
import 'package:grouping_project/auth/domain/repositories/auth_login_repositories.dart';
import 'package:grouping_project/core/errors/failure.dart';

class UserRegisterUseCase{

  final AuthRepository repository;
  UserRegisterUseCase({required this.repository});

  Future<Either<Failure, AuthTokenModel>> call(RegisterEntity entity) async{
    return await repository.userRegister(entity);
  }
}