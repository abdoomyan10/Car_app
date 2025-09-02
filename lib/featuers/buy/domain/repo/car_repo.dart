// lib/features/car_listings/domain/repositories/car_listings_repository.dart
import 'package:car_appp/featuers/buy/data/model/car_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class CarListingsRepository {
  Future<Either<Failure, List<CarListing>>> getCarListings();
  Future<Either<Failure, void>> updateCar(String id, Map<String, dynamic> map);
  Future<Either<Failure, List<CarListing>>> getCarListingsByFilters({
    String? status,
    String? type,
    String? city,
    String? carType,
  });
}
