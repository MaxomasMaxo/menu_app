import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Crea una instancia de FirebaseAuth para manejar la autenticación
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Método para registrar un nuevo usuario con correo electrónico y contraseña
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
  // Método para iniciar sesión con correo electrónico y contraseña
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } catch (error) {
      if (error is FirebaseAuthException) {
        return error.message; // Devuelve el mensaje de error específico de Firebase
      }
      return 'Error desconocido'; 
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();// Llama al método signOut de FirebaseAuth
  }
}