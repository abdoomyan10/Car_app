// data/datasources/sell_car_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@injectable
class SellCarRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(XFile imageFile, String carId) async {
    try {
      // final ref = _storage.ref().child(
      //   'car_images/$carId/${DateTime.now().millisecondsSinceEpoch}',
      // );
      // await ref.putData(await imageFile.readAsBytes());
      // return await ref.getDownloadURL();
      return '';
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

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
  }) async {
    try {
      await _firestore.collection('car_listings').add({
        'carModel': carModel,
        'year': year,
        'price': price,
        'phone': phone,
        'carType': carType,
        'transmission': transmission,
        'description': description,
        'city': city,
        // 'imageUrls': imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending', // pending, approved, rejected
      });
    } catch (e) {
      throw Exception('Failed to submit car listing: $e');
    }
  }
}
