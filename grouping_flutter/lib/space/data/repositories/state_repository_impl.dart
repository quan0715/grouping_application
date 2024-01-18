
import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/data/models/mission_state_model.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/state_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/state_remote_data_source.dart';
import 'package:grouping_project/space/domain/repositories/state_repository.dart';

class StateRepositoryImpl extends StateRepository {
  final StateRemoteDataSource remoteDataSource;
  final StateLocalDataSource localDataSource;

  StateRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, MissionState>> getState(int stateID) async {
    try {
      final missionState = await remoteDataSource.getStateData(stateID: stateID);

      return Right(missionState);
    }
    on ServerException catch(error) {
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
    on TypeError {
      return Left(ServerFailure(errorMessage: "given stateID cause TypeError"));
    }
  }

  @override
  Future<Either<Failure, MissionState>> createState(MissionState state) async {
    try {
      final missionState = await remoteDataSource.createStateData(state: state);

      return Right(missionState);
    }
    on ServerException catch(error) {
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
    on TypeError {
      return Left(ServerFailure(errorMessage: "Given state cause TypeError"));
    }
  }

  @override
  Future<Either<Failure, MissionState>> updateState(MissionState state) async {
    try {
      final missionState = await remoteDataSource.updateStateData(state: state);

      return Right(missionState);
    }
    on ServerException catch(error) {
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
    on TypeError {
      return Left(ServerFailure(errorMessage: "Given state cause TypeError"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteState(int stateID) async {
    try {
      await remoteDataSource.deleteStateData(stateID: stateID);

      return const Right(null);
    }
    on ServerException catch(error) {
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
    on TypeError {
      return Left(ServerFailure(errorMessage: "Given stateID cause TypeError"));
    }
  }
}