import 'package:car_appp/core/error/failure.dart';
import 'package:car_appp/core/usecase/usecase.dart';
import 'package:car_appp/featuers/auth/domain/repos/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUsecase implements UseCase<User, LoginParams> {
  final AuthRepo repo;

  LoginUsecase({required this.repo});
  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repo.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;
  LoginParams({required this.email, required this.password});
}
