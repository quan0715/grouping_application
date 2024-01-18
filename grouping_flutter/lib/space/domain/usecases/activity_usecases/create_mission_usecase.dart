import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/util/base_usecase.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class CreateMissionUseCase implements BaseUseCase<MissionEntity, MissionEntity> {
  final ActivityRepository _activityRepository;
  
  CreateMissionUseCase(
      {required ActivityRepository activityRepository,})
      : _activityRepository = activityRepository;

  /// 給予 [MissionEntity] 來去創建此 [entity] 的資料
  @override
  Future<Either<Failure, MissionEntity>> call(MissionEntity entity) async {
    return await _activityRepository.createMission(entity);
  } 
}