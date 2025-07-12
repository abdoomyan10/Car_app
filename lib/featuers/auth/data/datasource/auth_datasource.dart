import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDatasource {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password);
}

class AuthDatasourceimp1 implements AuthDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<User> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<User> register(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
