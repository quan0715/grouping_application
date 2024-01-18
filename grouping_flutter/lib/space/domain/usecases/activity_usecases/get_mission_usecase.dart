import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/util/base_usecase.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
import 'package:grouping_project/space/domain/repositories/activity_repository.dart';

class GetMissionUseCase implements BaseUseCase<MissionEntity, int> {
  final ActivityRepository _activityRepository;

  GetMissionUseCase(
      {required ActivityRepository activityRepository,})
      : _activityRepository = activityRepository;

  /// 給予 [missionID] 來去獲取此 [MissionEntity] 的資料
  @override
  Future<Either<Failure, MissionEntity>> call(int missionID) async {
    return await _activityRepository.getMission(missionID);
  }
}
