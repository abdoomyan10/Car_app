// lib/features/car_listings/domain/entities/car_listing.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CarListing extends Equatable {
  final String id;
  final String carModel;
  final int year;
  final double price;
  final String phone;
  final String carType;
  final String transmission;
  final String description;
  final String city;
  final List<String> imageUrls;
  final DateTime createdAt;
  final String status;
  final String type;

  const CarListing({
    required this.id,
    required this.carModel,
    required this.year,
    required this.price,
    required this.phone,
    required this.carType,
    required this.transmission,
    required this.description,
    required this.city,
    required this.imageUrls,
    required this.createdAt,
    required this.status,
    required this.type,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'carModel': carModel,
      'year': year,
      'price': price,
      'phone': phone,
      'carType': carType,
      'transmission': transmission,
      'description': description,
      'city': city,
      'imageUrls': imageUrls,
      'createdAt': (createdAt).toString(),
      'status': status,
      'type': type,
    };
  }

  // Create from Firestore document
  factory CarListing.fromMap(String id, Map<String, dynamic> map) {
    return CarListing(
      id: id,
      carModel: map['carModel'] ?? '',
      year: map['year'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      phone: map['phone'] ?? '',
      carType: map['carType'] ?? '',
      transmission: map['transmission'] ?? '',
      description: map['description'] ?? '',
      city: map['city'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
      type: map['type'] ?? 'sell',
    );
  }

  // Create from Firestore document
  factory CarListing.fromLocal(String id, Map<String, dynamic> map) {
    return CarListing(
      id: id,
      carModel: map['carModel'] ?? '',
      year: map['year'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      phone: map['phone'] ?? '',
      carType: map['carType'] ?? '',
      transmission: map['transmission'] ?? '',
      description: map['description'] ?? '',
      city: map['city'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      status: map['status'] ?? 'pending',
      type: map['type'] ?? 'sell',
    );
  }

  // Copy with method for immutability
  CarListing copyWith({
    String? id,
    String? carModel,
    int? year,
    double? price,
    String? phone,
    String? carType,
    String? transmission,
    String? description,
    String? city,
    List<String>? imageUrls,
    DateTime? createdAt,
    String? status,
    String? type,
  }) {
    return CarListing(
      id: id ?? this.id,
      carModel: carModel ?? this.carModel,
      year: year ?? this.year,
      price: price ?? this.price,
      phone: phone ?? this.phone,
      carType: carType ?? this.carType,
      transmission: transmission ?? this.transmission,
      description: description ?? this.description,
      city: city ?? this.city,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    carModel,
    year,
    price,
    phone,
    carType,
    transmission,
    description,
    city,
    imageUrls,
    createdAt,
    status,
    type,
  ];
}
