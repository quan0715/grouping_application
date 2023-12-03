import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
import 'package:grouping_project/space/domain/repositories/workspace_repository.dart';

class CreateCurrentWorkspaceUseCase{
  final WorkspaceRepository _workspaceRepository ;
  
  CreateCurrentWorkspaceUseCase(this._workspaceRepository);

  Future<Either<Failure, WorkspaceEntity>> call(WorkspaceEntity entity) async {
    return _workspaceRepository.createWorkspace(entity);
  } 
}