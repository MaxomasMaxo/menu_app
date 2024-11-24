import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; 
import 'package:menu_app/pages/meal_card.dart'; 
import 'package:menu_app/provider/meal_provider.dart'; 

class TabHomePage extends StatefulWidget {
  const TabHomePage({super.key});

  @override
  _TabHomePageState createState() => _TabHomePageState(); 
}

class _TabHomePageState extends State<TabHomePage> {
  MealProvider mealProvider = MealProvider(); 
  Map<String, dynamic>? randomMeal; // Variable para almacenar una comida aleatoria.
  String? _userEmail; // Variable para almacenar el correo electrónico del usuario autenticado.

  @override
  void initState() {
    super.initState(); 
    _fetchUserInfo(); 
    fetchRandomMeal(); 
  }

  // Método para obtener la información del usuario autenticado.
  Future<void> _fetchUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser ; // Obtiene el usuario actual de Firebase.
    if (user != null) { 
      for (final providerProfile in user.providerData) { // Itera sobre los datos del proveedor del usuario.
        final emailAddress = providerProfile.email; // Obtiene la dirección de correo electrónico.

        setState(() { 
          _userEmail = emailAddress;
        });
      }
    }
  } 

  // Método para obtener una comida aleatoria.
  Future<void> fetchRandomMeal() async {
    var meal = await mealProvider.getRandomMeal();
    if (mounted) { // Verifica si el widget aún está montado.
      setState(() { 
        randomMeal = meal;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          '¡Hola, $_userEmail!', // Muestra un saludo con el correo electrónico del usuario.
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        if (randomMeal != null)
          MealCard(meal: randomMeal!) // Muestra la tarjeta de comida con la comida aleatoria.
        else
          CircularProgressIndicator(),
        ElevatedButton(
          onPressed: () { 
            fetchRandomMeal();
          },
          child: Text('Descubre'), 
        ),
      ],
    );
  }
}