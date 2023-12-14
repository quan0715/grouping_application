import 'package:dartz/dartz.dart';
import 'package:grouping_project/auth/data/models/auth_token_model.dart';
import 'package:grouping_project/auth/domain/entities/login_entity.dart';
import 'package:grouping_project/auth/domain/entities/register_entity.dart';
import 'package:grouping_project/core/errors/failure.dart';

abstract class AuthRepository{
  Future<Either<Failure, AuthTokenModel>> passwordLogin(LoginEntity loginEntity);
  Future<Either<Failure, AuthTokenModel>> userRegister(RegisterEntity loginEntity);
  Future<void> logOut();
  Future<Either<Failure, AuthTokenModel>> getAccessToken();
}