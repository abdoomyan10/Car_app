// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'favorite_bloc.dart';

class FavoriteState {
  final List<CarListing> cars;
  const FavoriteState({this.cars = const []});

  FavoriteState copyWith({List<CarListing>? cars}) {
    return FavoriteState(cars: cars ?? this.cars);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'cars': cars.map((x) => x.toMap()).toList()};
  }

  factory FavoriteState.fromMap(Map<String, dynamic> map) {
    return FavoriteState(
      cars: List<CarListing>.from(
        (map['cars']).map<CarListing>((x) => CarListing.fromLocal(x['id'], x)),
      ),
    );
  }
}
