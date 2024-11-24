import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia de FirebaseAuth para gestionar la autenticación.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Instancia de Firestore para gestionar la base de datos.

  // Controladores de texto para capturar la entrada del usuario.
  final TextEditingController _emailController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController(); 
  final TextEditingController _nameController = TextEditingController(); 
  final TextEditingController _lastnameController = TextEditingController();

  // Método para registrar un nuevo usuario.
  void _register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text, 
        password: _passwordController.text, 
      );
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text, 
        'email': _emailController.text, 
        'lastname': _lastnameController.text, 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario registrado con éxito!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController, 
              decoration: InputDecoration(labelText: 'Nombre'), 
            ),
            TextField(
              controller: _lastnameController, 
              decoration: InputDecoration(labelText: 'Apellido'), 
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'), 
            ),
            TextField(
              controller: _passwordController, 
              decoration: InputDecoration(labelText: 'Contraseña'), 
              obscureText: true, // Oculta el texto ingresado (para la contraseña).
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Registrar'), 
            ),
          ],
        ),
      ),
    );
  }
}