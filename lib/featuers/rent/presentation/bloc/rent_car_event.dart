// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'rent_car_bloc.dart';

@immutable
abstract class RentCarEvent {}

class GetRentCarEvent extends RentCarEvent {}

class RentNewCarEvent extends RentCarEvent {
  final RentCarParams params;
  RentNewCarEvent({required this.params});
}
