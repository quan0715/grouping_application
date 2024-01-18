import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/data/models/mission_state_model.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/util/base_usecase.dart';
import 'package:grouping_project/space/domain/repositories/state_repository.dart';

class GetStateUsecase implements BaseUseCase<MissionState, int> {
  final StateRepository _stateRepository;

  GetStateUsecase({required StateRepository stateRepository}): _stateRepository = stateRepository;

  /// 給予 [stateID] 來獲取此 [MissionState]
  @override
  Future<Either<Failure, MissionState>> call(int stateID) async {
    return await _stateRepository.getState(stateID);
  }
}