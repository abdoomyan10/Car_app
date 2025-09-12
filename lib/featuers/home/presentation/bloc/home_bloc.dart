// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:car_appp/core/usecase/usecase.dart';
import 'package:car_appp/core/utils/requests_status.dart';
import 'package:car_appp/featuers/buy/data/model/car_model.dart';
import 'package:car_appp/featuers/buy/domain/usecase/get_sell_cars_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

@lazySingleton
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetSellCarListings getCarListings;
  HomeBloc(this.getCarListings) : super(HomeState()) {
    on<GetCarsEvent>((event, emit) async {
      emit(state.copyWith(carBuyStatus: RequestStatus.loading));
      final result = await getCarListings(NoParams());
      result.fold(
        (left) {
          emit(state.copyWith(carBuyStatus: RequestStatus.failed));
        },
        (right) {
          print(right);
          emit(
            state.copyWith(cars: right, carBuyStatus: RequestStatus.success),
          );
        },
      );
    });
  }
}
