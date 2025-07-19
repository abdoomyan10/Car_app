import 'package:car_appp/featuers/auth/domain/usecase/login-user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final LoginParams params;

  LoginEvent({required this.params});
}
