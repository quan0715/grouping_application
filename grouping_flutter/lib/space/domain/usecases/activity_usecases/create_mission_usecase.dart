import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class CreateMissionUseCase{
  final ActivityRepository _activityRepository ;
  
  CreateMissionUseCase(this._activityRepository);

  Future<Either<Failure, MissionEntity>> call(MissionEntity entity) async {
    return await _activityRepository.createMission(entity);
  } 
}