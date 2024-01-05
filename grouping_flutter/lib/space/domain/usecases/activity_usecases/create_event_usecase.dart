import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class CreateEventUseCase{
  final ActivityRepository _activityRepository;
  
  CreateEventUseCase(
      {required ActivityRepository activityRepository,})
      : _activityRepository = activityRepository;

  Future<Either<Failure, EventEntity>> call(EventEntity entity) async {
    return await _activityRepository.createEvent(entity);
  } 
}