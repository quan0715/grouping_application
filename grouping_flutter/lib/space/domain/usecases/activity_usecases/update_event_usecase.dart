import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class UpdateEventUseCase{
  final ActivityRepository _activityRepository;
  
  UpdateEventUseCase(
      {required ActivityRepository activityRepository,})
      : _activityRepository = activityRepository;

  Future<Either<Failure, EventEntity>> call(EventEntity entity) async {
    return await _activityRepository.updateEvent(entity);
  }
}