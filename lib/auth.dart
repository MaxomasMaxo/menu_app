import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> registerWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } catch (error) {
      if (error is FirebaseAuthException) {
        return error.message; 
      }
      return 'Error desconocido'; 
    }
  }

  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } catch (error) {
      if (error is FirebaseAuthException) {
        return error.message; 
      }
      return 'Error desconocido'; 
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}