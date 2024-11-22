import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bottom_nav_page.dart'; 

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xffff8b00), 
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              // Icono o logo central
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xffff8b00),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Campo de email/teléfono
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email o Teléfono',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),
              // Campo de contraseña
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 32),
              // Botón de inicio de sesión
              ElevatedButton(
                onPressed: () async {
                  // Obtiene las credenciales del usuario
                  String emailOrPhone = emailController.text.trim();
                  String password = passwordController.text.trim();

                  try {
                    // Autenticación con Firebase
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailOrPhone,
                      password: password,
                    );

                    // Si la autenticación es exitosa, navega a BottomNavPage
                    print('Usuario autenticado: ${userCredential.user?.email}');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const BottomNavPage()),
                    );
                  } on FirebaseAuthException catch (e) {
                    // Manejo de errores de autenticación
                    String message;
                    if (e.code == 'user-not-found') {
                      message = 'No hay ningún usuario registrado con este correo.';
                    } else if (e.code == 'wrong-password') {
                      message = 'La contraseña es incorrecta.';
                    } else {
                      message = 'Error al iniciar sesión. Intenta de nuevo.';
                    }
                    // Muestra un mensaje de error
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: Text(message),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cerrar'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffff8b00), // Botón inicio
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(color:Colors.white,fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
