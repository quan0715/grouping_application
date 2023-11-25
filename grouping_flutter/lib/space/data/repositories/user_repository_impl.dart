import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
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
    final user = await remoteDataSource.getUserData(uid: 5);
    debugPrint(user.toString());
    // try {
     
    //   // localDataSource.cacheUser(user);
    //   // return Right(user);
    //   return Right();
    // } catch error on ServerException  {
    //   return Left(ServerFailure(errorMessage: ));
    // }
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}