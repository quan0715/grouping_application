import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/setting_entity.dart';
import 'package:grouping_project/space/domain/repositories/user_repository.dart';

class UpdateSettingUseCase {
  final UserRepository _repository;

  UpdateSettingUseCase(this._repository);

  Future<Either<Failure, void>> call(SettingEntity entity) async {
    return _repository.updateSetting(entity);
  }
}
