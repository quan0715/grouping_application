import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/data/models/mission_state_model.dart';
import 'package:grouping_project/core/errors/failure.dart';

abstract class StateRepository {
  Future<Either<Failure, MissionState>> getState(int stateID);
  Future<Either<Failure, MissionState>> createState(MissionState state);
  Future<Either<Failure, MissionState>> updateState(MissionState state);
  Future<Either<Failure, void>> deleteState(int stateID);
}