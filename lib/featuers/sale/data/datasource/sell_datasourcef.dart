// data/datasources/sell_car_remote_data_source.dart
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@injectable
class SellCarRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImage(XFile imageFile, String carId) async {
    try {
      final image = base64Encode(await imageFile.readAsBytes());
      final response = await post(
        Uri.parse('https://api.imgbb.com/1/upload'),
        body: {'key': '8597717602852ffc6b20f68e54d3fec0', 'image': image, 'name': imageFile.name},
      );
      print(jsonDecode(response.body)['data']['url']);
      return jsonDecode(response.body)['data']['url'];
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
      print(imageUrls);
      await _firestore.collection('car_listings').add({
        'carModel': carModel,
        'year': year,
        'price': price,
        'phone': phone,
        'carType': carType,
        'transmission': transmission,
        'description': description,
        'city': city,
        'imageUrls': imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending', // pending, approved, rejected
        'type': 'sell', // pending, approved, rejected
      });
    } catch (e) {
      throw Exception('Failed to submit car listing: $e');
    }
  }
}
