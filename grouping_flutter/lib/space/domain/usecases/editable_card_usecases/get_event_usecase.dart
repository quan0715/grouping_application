import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class GetEventUseCase{
  final ActivityRepository _activityRepository ;
  
  GetEventUseCase(this._activityRepository);

  Future<Either<Failure, EventEntity>> call(int eventID) async {
    try {
      return _activityRepository.getActivity(eventID) as Either<Failure, EventEntity>;
    } catch (error) {
      return Left(ServerFailure(errorMessage: "ID is not event ID"));
    }
  } 
}