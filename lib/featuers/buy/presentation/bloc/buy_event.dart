part of 'buy_bloc.dart';

@immutable
abstract class BuyEvent {}

class GetBuyCarEvent extends BuyEvent {}

class RequestBuyCarEvent extends BuyEvent {
  final String id;
  RequestBuyCarEvent({required this.id});
}
