// lib/features/car_listings/domain/usecases/get_car_listings.dart
import 'package:car_appp/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../data/model/car_model.dart';
import '../repo/car_repo.dart';

@injectable
class GetSellCarListings implements UseCase<List<CarListing>, NoParams> {
  final CarListingsRepository repository;

  GetSellCarListings(this.repository);

  @override
  Future<Either<Failure, List<CarListing>>> call(NoParams params) async {
    return await repository.getCarListingsByFilters(status: 'accepted', type: 'sell');
  }
}
