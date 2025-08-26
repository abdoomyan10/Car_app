part of 'sell_car_bloc.dart';

sealed class SellCarEvent extends Equatable {
  const SellCarEvent();

  @override
  List<Object> get props => [];
}

class SubmitCarListingEvent extends SellCarEvent {
  final String carModel;
  final int year;
  final double price;
  final String phone;
  final String carType;
  final String transmission;
  final String description;
  final String city;
  final List<XFile> imageFiles;

  const SubmitCarListingEvent({
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

  @override
  List<Object> get props => [
    carModel,
    year,
    price,
    phone,
    carType,
    transmission,
    description,
    city,
    imageFiles,
  ];
}
