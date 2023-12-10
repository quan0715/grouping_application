import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class GetMissionUseCase{
  final ActivityRepository _activityRepository ;
  
  GetMissionUseCase(this._activityRepository);

  Future<Either<Failure, MissionEntity>> call(int missionID) async {
    return await _activityRepository.getMission(missionID);
  } 
}