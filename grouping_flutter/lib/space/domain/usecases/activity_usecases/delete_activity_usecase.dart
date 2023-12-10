import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class DeleteActivityUseCase{
  final ActivityRepository _activityRepository ;
  
  DeleteActivityUseCase(this._activityRepository);

  Future<Either<Failure, void>> call(int activityID) async {
    return await _activityRepository.deleteActivity(activityID);
  } 
}