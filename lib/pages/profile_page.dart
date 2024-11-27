import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  String? displayName;
  String? email;
  final TextEditingController _newPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser ; // Obtener el usuario actual
    _fetchUserData(); 
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          displayName = userDoc['name']; 
          email = userDoc['email'];
        });
      }
    }
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await user!.updatePassword(_newPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña actualizada con éxito')),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la contraseña: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xffff8b00),
        centerTitle: true, 
        elevation: 2, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar información del usuario
            Text('Nombre: ${displayName ?? 'Cargando...'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Correo electrónico: ${email ?? 'Cargando...'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),

            // Formulario para cambiar la contraseña
            Text('Cambiar contraseña', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(labelText: 'Nueva contraseña'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una nueva contraseña';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _changePassword,
                    child: Text('Actualizar contraseña'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}