import 'package:dartz/dartz.dart';
import 'package:grouping_project/auth/data/models/auth_token_model.dart';
import 'package:grouping_project/auth/domain/repositories/auth_login_repositories.dart';
import 'package:grouping_project/core/errors/failure.dart';

class GetAccessToken{
  final AuthRepository repository;

  GetAccessToken(this.repository);

  Future<Either<Failure, AuthTokenModel>> call() async {
    return await repository.getAccessToken();
  }
}