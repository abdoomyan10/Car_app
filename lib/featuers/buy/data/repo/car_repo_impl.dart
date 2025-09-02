// lib/features/car_listings/data/repositories/car_listings_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repo/car_repo.dart';
import '../datasource/car_datasource.dart';
import '../model/car_model.dart';

@Injectable(as: CarListingsRepository)
class CarListingsRepositoryImpl implements CarListingsRepository {
  final CarListingsRemoteDataSource remoteDataSource;

  CarListingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CarListing>>> getCarListings() async {
    try {
      final carListings = await remoteDataSource.getCarListings();
      return Right(carListings);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CarListing>>> getCarListingsByFilters({
    String? status,
    String? type,
    String? city,
    String? carType,
  }) async {
    try {
      final carListings = await remoteDataSource.getCarListingsByFilters(
        status: status,
        type: type,
        city: city,
        carType: carType,
      );
      return Right(carListings);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCar(String id, Map<String, dynamic> map) async {
    try {
      await remoteDataSource.updateCar(id, map);
      return Right(Future.value());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? e.code));
    }
  }
}
