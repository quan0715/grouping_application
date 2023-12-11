import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/setting_entity.dart';
import 'package:grouping_project/space/domain/repositories/user_repository.dart';

class GetSettingUseCase {
  final UserRepository _repository;

  GetSettingUseCase(this._repository);

  Future<Either<Failure, SettingEntity>> call() async {
    return _repository.getSetting();
  }
}
