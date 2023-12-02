import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';

abstract class WorkspaceRepository {
  Future<Either<Failure, WorkspaceEntity>> getWorkspace(int workspaceID);
  Future<Either<Failure, WorkspaceEntity>> createWorkspace(WorkspaceEntity workspace);
  Future<Either<Failure, WorkspaceEntity>> updateWorkspace(WorkspaceEntity workspace);
  Future<Either<Failure, void>> deleteWorkspace(int workspaceID);
}