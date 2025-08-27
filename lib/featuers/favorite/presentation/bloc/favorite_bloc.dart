import 'package:car_appp/featuers/buy/data/model/car_model.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

@lazySingleton
class FavoriteBloc extends HydratedBloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteState()) {
    on<ToggleFavoriteEvent>((event, emit) {
      if (state.cars.contains(event.carListing)) {
        emit(state.copyWith(cars: List.of(state.cars)..remove(event.carListing)));
      } else {
        emit(state.copyWith(cars: List.of(state.cars)..add(event.carListing)));
      }
    });
  }

  @override
  FavoriteState? fromJson(Map<String, dynamic> json) {
    return FavoriteState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(FavoriteState state) {
    return state.toMap();
  }
}
