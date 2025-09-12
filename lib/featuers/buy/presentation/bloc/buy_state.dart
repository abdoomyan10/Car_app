part of 'buy_bloc.dart';

class BuyState {
  final RequestStatus carBuyStatus;
  final List<CarListing> cars;

  BuyState({this.carBuyStatus = RequestStatus.init, this.cars = const []});
  BuyState copyWith({RequestStatus? carBuyStatus, List<CarListing>? cars}) {
    return BuyState(carBuyStatus: carBuyStatus ?? this.carBuyStatus, cars: cars ?? this.cars);
  }
}
