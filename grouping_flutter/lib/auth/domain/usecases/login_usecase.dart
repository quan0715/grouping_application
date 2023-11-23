import 'package:dartz/dartz.dart';
import 'package:grouping_project/auth/data/models/sub_model.dart';
import 'package:grouping_project/auth/domain/entities/login_entity.dart';
import 'package:grouping_project/auth/domain/repositories/auth_login_repositories.dart';
import 'package:grouping_project/core/errors/failure.dart';

class PasswordLoginUseCase{

  final AuthRepository repository;
  PasswordLoginUseCase({required this.repository});

  Future<Either<Failure, AuthTokenModel>> call(LoginEntity loginEntity) async{
    return await repository.passwordLogin(loginEntity);
  }
}