import 'package:car_appp/core/error/exception.dart';
import 'package:car_appp/core/error/failure.dart';
import 'package:car_appp/featuers/auth/data/datasource/auth_datasource.dart';
import 'package:car_appp/featuers/auth/domain/repos/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthDatasource datasource;

  AuthRepoImpl({required this.datasource});
  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      return Right(await datasource.login(email, password));
    } on ServerException catch (e) {
      print(e);
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      print(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register(String email, String password) async {
    try {
      return Right(await datasource.register(email, password));
    } on ServerException catch (e) {
      print(e);
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      print(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await datasource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      print(e);
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      print(e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
