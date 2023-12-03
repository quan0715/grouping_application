import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/space/domain/repositories/workspace_repository.dart';

class DeleteCurrentWorkspaceUseCase{
  final WorkspaceRepository _workspaceRepository ;
  
  DeleteCurrentWorkspaceUseCase(this._workspaceRepository);

  Future<Either<Failure, void>> call(int workspaceID) async {
    return _workspaceRepository.deleteWorkspace(workspaceID);
  } 
}