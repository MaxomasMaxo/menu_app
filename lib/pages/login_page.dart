import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bottom_nav_page.dart'; // Asegúrate de importar la página de navegación inferior

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: buildLoginForm(context),
      ),
    );
  }

  Widget buildLoginForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email/Número de Teléfono',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.0), // Espaciado entre campos
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        SizedBox(height: 16.0), // Espaciado entre campos
        ElevatedButton(
          onPressed: () async {
            String emailOrPhone = emailController.text;
            String password = passwordController.text;

            try {
              // Autenticación con Firebase
              UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailOrPhone,
                password: password,
              );

              // Si la autenticación es exitosa, navega a BottomNavPage
              print('Usuario autenticado: ${userCredential.user?.email}');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BottomNavPage()),
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
                  title: Text('Error'),
                  content: Text(message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cerrar'),
                    ),
                  ],
                ),
              );
            }
          },
          child : Text("Iniciar Sesión"),
        ),
      ],
    );
  }
}