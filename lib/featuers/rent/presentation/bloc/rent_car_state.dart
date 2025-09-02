// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'rent_car_bloc.dart';

class RentCarState {
  final RequestStatus rentCarStatus;
  final RequestStatus rentNewCarStatus;
  final List<CarListing> cars;
  RentCarState({
    this.rentCarStatus = RequestStatus.init,
    this.rentNewCarStatus = RequestStatus.init,
    this.cars = const [],
  });

  RentCarState copyWith({
    RequestStatus? rentCarStatus,
    RequestStatus? rentNewCarStatus,
    List<CarListing>? cars,
  }) {
    return RentCarState(
      rentCarStatus: rentCarStatus ?? this.rentCarStatus,
      rentNewCarStatus: rentNewCarStatus ?? this.rentNewCarStatus,
      cars: cars ?? this.cars,
    );
  }
}
