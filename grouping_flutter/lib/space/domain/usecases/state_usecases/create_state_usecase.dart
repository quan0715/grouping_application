import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/data/models/mission_state_model.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/util/base_usecase.dart';
import 'package:grouping_project/space/domain/repositories/state_repository.dart';

class CreateStateUsecase implements BaseUseCase<MissionState, MissionState> {
  final StateRepository _stateRepository;

  CreateStateUsecase({required StateRepository stateRepository}): _stateRepository = stateRepository;

  /// 給予 [MissionState] 來創建此 [missionState]
  @override
  Future<Either<Failure, MissionState>> call(MissionState missionState) async {
    return await _stateRepository.createState(missionState);
  }
}