part of 'buy_bloc.dart';

class BuyState {
  final RequestStatus carBuyStatus;
  final List<CarListing> cars;
  final RequestStatus requestBuyStatus;

  BuyState({
    this.carBuyStatus = RequestStatus.init,
    this.cars = const [],
    this.requestBuyStatus = RequestStatus.init,
  });

  BuyState copyWith({
    RequestStatus? carBuyStatus,
    List<CarListing>? cars,
    RequestStatus? requestBuyStatus,
  }) {
    return BuyState(
      carBuyStatus: carBuyStatus ?? this.carBuyStatus,
      cars: cars ?? this.cars,
      requestBuyStatus: requestBuyStatus ?? this.requestBuyStatus,
    );
  }
}
