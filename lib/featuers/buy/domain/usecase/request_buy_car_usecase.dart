import 'package:car_appp/core/error/failure.dart';
import 'package:car_appp/core/usecase/usecase.dart';
import 'package:car_appp/featuers/buy/domain/repo/car_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class RequestBuyCarUsecase implements UseCase<void, RequestBuyParams> {
  final CarListingsRepository repo;

  RequestBuyCarUsecase({required this.repo});

  @override
  Future<Either<Failure, void>> call(RequestBuyParams params) async {
    return await repo.updateCar(params.id, {'status': 'buy_pending'});
  }
}

class RequestBuyParams {
  final String id;

  RequestBuyParams({required this.id});
}
