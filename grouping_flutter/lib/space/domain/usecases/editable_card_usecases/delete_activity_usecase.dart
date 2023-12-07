import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class CreateMissionUseCase{
  final ActivityRepository _activityRepository ;
  
  CreateMissionUseCase(this._activityRepository);

  Future<Either<Failure, void>> call(int activityID) async {
    return await _activityRepository.deleteActivity(activityID);
  } 
}