// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:car_appp/core/utils/requests_status.dart';
import 'package:car_appp/core/utils/toaster.dart';
import 'package:car_appp/featuers/auth/domain/usecase/login-user.dart';
import 'package:car_appp/featuers/auth/domain/usecase/register_user.dart';
import 'package:car_appp/featuers/auth/presentation/bloc/auth_event.dart';
import 'package:car_appp/featuers/auth/presentation/bloc/auth_state.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  AuthBloc(this.loginUsecase, this.registerUsecase) : super(AuthState()) {
    on<LoginEvent>((event, emit) async {
      emit(state.copyWith(status: RequestStatus.loading));
      final result = await loginUsecase(event.params);
      result.fold(
        (left) {
          emit(state.copyWith(status: RequestStatus.failed));
          Toaster.showToast(left.message);
        },
        (right) {
          emit(state.copyWith(status: RequestStatus.success, user: right));
        },
      );
    });
    on<RegisterEvent>((event, emit) async {
      emit(state.copyWith(status: RequestStatus.loading));
      final result = await registerUsecase(event.params);
      result.fold(
        (left) {
          emit(state.copyWith(status: RequestStatus.failed));
          Toaster.showToast(left.message);
        },
        (right) {
          emit(state.copyWith(status: RequestStatus.success, user: right));
        },
      );
    });
  }
}
