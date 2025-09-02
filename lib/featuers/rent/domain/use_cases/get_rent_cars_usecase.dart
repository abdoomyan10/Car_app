import 'package:car_appp/core/usecase/usecase.dart';
import 'package:car_appp/featuers/buy/data/model/car_model.dart';
import 'package:car_appp/featuers/buy/domain/repo/car_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';

@injectable
class GetRentCarsUsecase implements UseCase<List<CarListing>, NoParams> {
  final CarListingsRepository repo;

  GetRentCarsUsecase({required this.repo});
  @override
  Future<Either<Failure, List<CarListing>>> call(NoParams params) async {
    return await repo.getCarListingsByFilters(status: 'accepted', type: 'rent');
  }
}
