part of 'sell_car_bloc.dart';

abstract class SellCarState extends Equatable {
  const SellCarState();

  @override
  List<Object> get props => [];
}

class SellCarInitial extends SellCarState {}

class SellCarLoading extends SellCarState {}

class SellCarSuccess extends SellCarState {}

class SellCarFailure extends SellCarState {
  final String error;

  const SellCarFailure({required this.error});

  @override
  List<Object> get props => [error];
}
