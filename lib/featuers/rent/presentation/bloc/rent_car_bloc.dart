// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:car_appp/core/usecase/usecase.dart';
import 'package:car_appp/core/utils/requests_status.dart';
import 'package:car_appp/featuers/buy/data/model/car_model.dart';
import 'package:car_appp/featuers/rent/domain/use_cases/get_rent_cars_usecase.dart';
import 'package:car_appp/featuers/rent/domain/use_cases/rent_car_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'rent_car_event.dart';
part 'rent_car_state.dart';

@lazySingleton
class RentCarBloc extends Bloc<RentCarEvent, RentCarState> {
  final GetRentCarsUsecase getRentCarsUsecase;
  final RentCarUsecase rentCarUsecase;
  RentCarBloc(this.getRentCarsUsecase, this.rentCarUsecase)
    : super(RentCarState()) {
    on<RentNewCarEvent>((event, emit) async {
      emit(state.copyWith(rentNewCarStatus: RequestStatus.loading));
      final result = await rentCarUsecase.call(event.params);
      result.fold(
        (left) {
          emit(state.copyWith(rentNewCarStatus: RequestStatus.failed));
        },
        (right) {
          emit(state.copyWith(rentNewCarStatus: RequestStatus.success));
        },
      );
      add(GetRentCarEvent());
    });
    on<GetRentCarEvent>((event, emit) async {
      emit(state.copyWith(rentCarStatus: RequestStatus.loading));
      final result = await getRentCarsUsecase.call(NoParams());
      result.fold(
        (left) {
          emit(state.copyWith(rentCarStatus: RequestStatus.failed));
        },
        (right) {
          emit(
            state.copyWith(rentCarStatus: RequestStatus.success, cars: right),
          );
        },
      );
    });
  }
}
