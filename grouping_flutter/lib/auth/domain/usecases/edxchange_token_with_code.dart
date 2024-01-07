import 'package:dartz/dartz.dart';
import 'package:grouping_project/auth/data/models/auth_token_model.dart';
import 'package:grouping_project/auth/domain/entities/code_entity.dart';
import 'package:grouping_project/auth/domain/repositories/auth_login_repositories.dart';
import 'package:grouping_project/core/errors/failure.dart';

class ThridPartyExchangeToken {
  final AuthRepository repository;

  ThridPartyExchangeToken(this.repository);

  Future<Either<Failure, AuthTokenModel>> call(CodeEntity entity) async {
    return await repository.thridPartyExchangeToken(entity);
  }
}
