import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/sell_car_usecase.dart';

part 'sell_car_event.dart';
part 'sell_car_state.dart';

@lazySingleton
class SellCarBloc extends Bloc<SellCarEvent, SellCarState> {
  final SubmitCarListing submitCarListing;

  SellCarBloc({required this.submitCarListing}) : super(SellCarInitial()) {
    on<SubmitCarListingEvent>(_onSubmitCarListing);
  }

  Future<void> _onSubmitCarListing(
    SubmitCarListingEvent event,
    Emitter<SellCarState> emit,
  ) async {
    emit(SellCarLoading());
    try {
      await submitCarListing(
        SubmitCarListingParams(
          carModel: event.carModel,
          year: event.year,
          price: event.price,
          phone: event.phone,
          carType: event.carType,
          transmission: event.transmission,
          description: event.description,
          city: event.city,
          imageFiles: event.imageFiles,
        ),
      );
      emit(SellCarSuccess());
    } catch (e) {
      emit(SellCarFailure(error: e.toString()));
    }
  }
}
