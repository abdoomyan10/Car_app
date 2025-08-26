// domain/usecases/submit_car_listing.dart
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../repo/sell_repo.dart';

class SubmitCarListingParams {
  final String carModel;
  final int year;
  final double price;
  final String phone;
  final String carType;
  final String transmission;
  final String description;
  final String city;
  final List<XFile> imageFiles;

  SubmitCarListingParams({
    required this.carModel,
    required this.year,
    required this.price,
    required this.phone,
    required this.carType,
    required this.transmission,
    required this.description,
    required this.city,
    required this.imageFiles,
  });
}

@injectable
class SubmitCarListing {
  final SellCarRepository repository;

  SubmitCarListing({required this.repository});

  Future<void> call(SubmitCarListingParams params) async {
    // Generate a unique ID for this car listing
    final carId = DateTime.now().millisecondsSinceEpoch.toString();

    // Upload images first
    final imageUrls = await repository.uploadImages(params.imageFiles, carId);

    // Then submit the listing with image URLs
    return await repository.submitCarListing(
      carModel: params.carModel,
      year: params.year,
      price: params.price,
      phone: params.phone,
      carType: params.carType,
      transmission: params.transmission,
      description: params.description,
      city: params.city,
      imageUrls: imageUrls,
    );
  }
}
