// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:car_appp/featuers/buy/domain/repo/car_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';

@injectable
class RentCarUsecase implements UseCase<void, RentCarParams> {
  final CarListingsRepository repo;

  RentCarUsecase({required this.repo});
  @override
  Future<Either<Failure, void>> call(RentCarParams params) async {
    return await repo.updateCar(params.id, params.toMap());
  }
}

class RentCarParams {
  final String id;
  final String status;
  final String period;

  RentCarParams({required this.id, required this.status, required this.period});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'status': status, 'period': period};
  }
}
