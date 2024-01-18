import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/util/base_usecase.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class GetEventUseCase implements BaseUseCase<EventEntity, int> {
  final ActivityRepository _activityRepository;

  GetEventUseCase(
      {required ActivityRepository activityRepository,})
      : _activityRepository = activityRepository;

  /// 給予 [eventID] 來去獲取此 [EventEntity] 的資料
  @override
  Future<Either<Failure, EventEntity>> call(int eventID) async {
    return await _activityRepository.getEvent(eventID);
  }
}
