import 'package:car_appp/core/error/failure.dart';
import 'package:car_appp/core/usecase/usecase.dart';
import 'package:car_appp/featuers/auth/domain/repos/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUser implements UseCase<void, NoParams> {
  final AuthRepo repo;

  LogoutUser({required this.repo});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repo.logout();
  }
}
