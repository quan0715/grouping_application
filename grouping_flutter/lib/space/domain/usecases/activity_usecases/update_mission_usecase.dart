import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class UpdateMissionUseCase{
  final ActivityRepository _activityRepository ;
  
  UpdateMissionUseCase(this._activityRepository);

  Future<Either<Failure, MissionEntity>> call(MissionEntity entity) async {
    return await _activityRepository.updateMission(entity);
  } 
}