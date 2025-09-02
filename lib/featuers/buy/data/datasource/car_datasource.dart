// lib/features/car_listings/data/datasources/car_listings_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../model/car_model.dart';

abstract class CarListingsRemoteDataSource {
  Future<void> updateCar(String id, Map<String, dynamic> map);
  Future<List<CarListing>> getCarListings();
  Future<List<CarListing>> getCarListingsByFilters({
    String? status,
    String? type,
    String? city,
    String? carType,
  });
}

@Injectable(as: CarListingsRemoteDataSource)
class CarListingsRemoteDataSourceImpl implements CarListingsRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<CarListing>> getCarListings() async {
    return getCarListingsByFilters();
  }

  @override
  Future<List<CarListing>> getCarListingsByFilters({
    String? status,
    String? type,
    String? city,
    String? carType,
  }) async {
    try {
      Query query = firestore.collection('car_listings');

      // Apply filters
      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      if (type != null) {
        query = query.where('type', isEqualTo: type);
      }

      if (city != null) {
        query = query.where('city', isEqualTo: city);
      }

      if (carType != null) {
        query = query.where('carType', isEqualTo: carType);
      }
      query = query.limit(10);
      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) {
        return CarListing.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw ServerFailure('Failed to fetch car listings: $e');
    }
  }

  @override
  Future<void> updateCar(String id, Map<String, dynamic> map) async {
    try {
      await firestore.collection('car_listings').doc(id).update(map);
    } on FirebaseException {
      rethrow;
    }
  }
}
