import 'package:car_appp/core/utils/requests_status.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final RequestStatus status;
  final User? user;
  const AuthState({this.status = RequestStatus.init, this.user});

  AuthState copyWith({RequestStatus? status, User? user}) {
    return AuthState(status: status ?? this.status, user: user ?? this.user);
  }
}
