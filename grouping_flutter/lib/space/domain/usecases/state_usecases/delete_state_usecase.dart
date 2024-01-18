import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/data/models/mission_state_model.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/util/base_usecase.dart';
import 'package:grouping_project/space/domain/repositories/state_repository.dart';

class DeleteStateUsecase implements BaseUseCase<void, int> {
  final StateRepository _stateRepository;

  DeleteStateUsecase({required StateRepository stateRepository}): _stateRepository = stateRepository;

  /// 給予 [stateID] 來刪除此 [MissionState]
  @override
  Future<Either<Failure, void>> call(int stateID) async {
    return await _stateRepository.deleteState(stateID);
  }
}