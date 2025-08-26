import 'package:image_picker/image_picker.dart';

abstract class SellCarRepository {
  Future<List<String>> uploadImages(List<XFile> imageFiles, String carId);
  Future<void> submitCarListing({
    required String carModel,
    required int year,
    required double price,
    required String phone,
    required String carType,
    required String transmission,
    required String description,
    required String city,
    required List<String> imageUrls,
  });
}
