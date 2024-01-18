import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/util/base_usecase.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class UpdateMissionUseCase implements BaseUseCase<MissionEntity, MissionEntity> {
  final ActivityRepository _activityRepository;
  
  UpdateMissionUseCase(
      {required ActivityRepository activityRepository,})
      : _activityRepository = activityRepository;

  /// 給予 [MissionEntity] 來去更新此 [entity] 的資料
  @override
  Future<Either<Failure, MissionEntity>> call(MissionEntity entity) async {
    return await _activityRepository.updateMission(entity);
  } 
}