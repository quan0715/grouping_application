import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/workspace_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/workspace_remote_data_source.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
import 'package:grouping_project/space/domain/repositories/workspace_repository.dart';
import 'package:image_picker/image_picker.dart';

/// ## 這個 WorkspaceService 主要是負責處理 workspace 的功能操作
/// 
/// 此 service 可以 get, create, update, delete workspace
///
class WorkspaceRepositoryImpl extends WorkspaceRepository{

  final WorkspaceRemoteDataSource remoteDataSource;
  final WorkspaceLocalDataSource localDataSource;

  WorkspaceRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, WorkspaceEntity>> getWorkspace(int workspaceID) async {
    try {
      final WorkspaceModel workspaceModel = await remoteDataSource.getWorkspaceData(workspaceId: workspaceID);
      return Right(workspaceModel.toEntity());
    } on ServerException catch(error){
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, WorkspaceEntity>> createWorkspace(WorkspaceEntity workspace, XFile? image) async {
    try {
      final workspaceModel = await remoteDataSource.createWorkspaceData(workspace: WorkspaceModel.fromEntity(workspace), image: image);
      return Right(workspaceModel.toEntity());
    } on ServerException catch(error) {
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, WorkspaceEntity>> updateWorkspace(WorkspaceEntity workspace) async {
    // TODO: change update data?
    try {
      final WorkspaceModel workspaceModel = await remoteDataSource.updateWorkspaceData(workspace: WorkspaceModel.fromEntity(workspace));
      return Right(workspaceModel.toEntity());
    } on ServerException catch(error) {
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWorkspace(int workspaceID) async {
    try {
      await remoteDataSource.deleteWorkspaceData(workspaceId: workspaceID);
      return const Right(null);
    } on ServerException catch(error) {
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
  }
}