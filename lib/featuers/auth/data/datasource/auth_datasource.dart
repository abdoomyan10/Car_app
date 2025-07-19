import 'package:car_appp/core/error/exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDatasource {
  Future<User> login(String email, String password);
}

class AuthDatasourceImpl implements AuthDatasource {
  @override
  Future<User> login(String email, String password) async {
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user.user == null) {
        throw ServerException('User Not Found');
      } else {
        return user.user!;
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'User Not Found');
    }
  }
}
