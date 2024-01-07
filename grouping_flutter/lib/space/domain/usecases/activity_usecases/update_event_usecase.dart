import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/util/base_usecase.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class UpdateEventUseCase extends BaseUseCase<EventEntity, EventEntity> {
  final ActivityRepository _activityRepository;
  
  UpdateEventUseCase(
      {required ActivityRepository activityRepository,})
      : _activityRepository = activityRepository;

  /// 給予 [EventEntity] 來去更新此 [entity] 的資料
  @override
  Future<Either<Failure, EventEntity>> call(EventEntity entity) async {
    return await _activityRepository.updateEvent(entity);
  }
}