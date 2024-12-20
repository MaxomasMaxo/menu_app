import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'bottom_nav_page.dart'; 
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  // Controladores para los campos de texto de email y contraseña.
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
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xffff8b00),
                  child: const Icon(
                    Icons.restaurant_menu,
                    size: 60, 
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.person), // Icono que aparece antes del texto.
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true, // Oculta el texto ingresado (para seguridad).
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock), // Icono que aparece antes del texto.
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true, 
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 32), 
              ElevatedButton(
                onPressed: () async { 
                  String emailOrPhone = emailController.text.trim(); 
                  String password = passwordController.text.trim(); 

                  try {
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailOrPhone,
                      password: password,
                    );

                    print('Usuario autenticado: ${userCredential.user?.email}'); 
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const BottomNavPage()),
                    );
                  } on FirebaseAuthException catch (e) {
                    String message;
                    if (e.code == 'user-not-found') {
                      message = 'No hay ningún usuario registrado con este correo.'; 
                    } else if (e.code == 'wrong-password') {
                      message = 'La contraseña es incorrecta.'; 
                    } else {
                      message = 'Error al iniciar sesión. Intenta de nuevo.'; 
                    }
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
                  backgroundColor: const Color(0xffff8b00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), 
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0), 
                ),
                child: const Text(
                  'Iniciar Sesión', 
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), 
                ),
              ),
              SizedBox(height: 20), 
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text('¿No tienes una cuenta? Regístrate aquí'), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}