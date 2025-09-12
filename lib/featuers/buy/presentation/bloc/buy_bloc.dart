// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:car_appp/core/usecase/usecase.dart';
import 'package:car_appp/featuers/buy/domain/usecase/get_sell_cars_usecase.dart';
import 'package:car_appp/featuers/buy/domain/usecase/request_buy_car_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/utils/requests_status.dart';
import '../../data/model/car_model.dart';

part 'buy_event.dart';
part 'buy_state.dart';

@lazySingleton
class BuyBloc extends Bloc<BuyEvent, BuyState> {
  final GetSellCarListings getSellCarListings;
  final RequestBuyCarUsecase requestBuyCarUsecase;
  BuyBloc(this.getSellCarListings, this.requestBuyCarUsecase)
    : super(BuyState()) {
    on<GetBuyCarEvent>((event, emit) async {
      emit(state.copyWith(carBuyStatus: RequestStatus.loading));
      final result = await getSellCarListings(NoParams());
      result.fold(
        (failure) {
          emit(state.copyWith(carBuyStatus: RequestStatus.failed));
        },
        (cars) {
          emit(state.copyWith(carBuyStatus: RequestStatus.success, cars: cars));
        },
      );
    });
    on<RequestBuyCarEvent>((event, emit) async {
      emit(state.copyWith(requestBuyStatus: RequestStatus.loading));
      final result = await requestBuyCarUsecase(RequestBuyParams(id: event.id));
      result.fold(
        (failure) {
          emit(state.copyWith(requestBuyStatus: RequestStatus.failed));
        },
        (_) {
          emit(state.copyWith(requestBuyStatus: RequestStatus.success));
          add(GetBuyCarEvent());
        },
      );
      emit(state.copyWith(requestBuyStatus: RequestStatus.init));
    });
  }
}
