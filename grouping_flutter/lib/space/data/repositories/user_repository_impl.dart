import 'package:dartz/dartz.dart';
import 'package:grouping_project/core/errors/failure.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:grouping_project/space/data/datasources/user_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/user_remote_data_source.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> getUser(int userID) async {
    try {
     final userModel = await remoteDataSource.getUserData(uid: 5);
      // debugPrint(user.toString());
      return Right(UserEntity.fromModel(userModel));
    } on ServerException catch(error) {
      return Left(ServerFailure(errorMessage: error.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}