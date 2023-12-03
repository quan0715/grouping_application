import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
import 'package:grouping_project/space/domain/repositories/workspace_repository.dart';

class GetCurrentWorkspaceUseCase{
  final WorkspaceRepository _workspaceRepository ;
  
  GetCurrentWorkspaceUseCase(this._workspaceRepository);

  Future<Either<Failure, WorkspaceEntity>> call(int workspaceID) async {
    return _workspaceRepository.getWorkspace(workspaceID);
  } 
}