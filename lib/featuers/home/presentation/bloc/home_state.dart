// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

class HomeState {
  final RequestStatus carBuyStatus;
  final List<CarListing> cars;
  HomeState({this.carBuyStatus = RequestStatus.init, this.cars = const []});

  HomeState copyWith({RequestStatus? carBuyStatus, List<CarListing>? cars}) {
    return HomeState(carBuyStatus: carBuyStatus ?? this.carBuyStatus, cars: cars ?? this.cars);
  }
}
