import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TabCestaPage extends StatefulWidget {
  const TabCestaPage({super.key});

  @override
  State<TabCestaPage> createState() => _TabCestaPageState();
}

class _TabCestaPageState extends State<TabCestaPage> {
  List meals = [];
  List selectedMeals = [];

  @override
  void initState() {
    super.initState();
    fetchMeals();
    fetchCartItems(); // Cargar elementos del carrito al iniciar
  }

  Future<void> fetchMeals() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/'));
    if (response.statusCode == 200) {
      setState(() {
        meals = json.decode(response.body)['meals'];
      });
    } else {
      // Manejo de errores
    }
  }

  Future<void> fetchCartItems() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser ;

    if (user != null) {
      QuerySnapshot snapshot = await firestore.collection('users').doc(user.uid).collection('menu').get();
      for (var doc in snapshot.docs) {
        setState(() {
          selectedMeals.add(doc.data() as Map<String, dynamic>);
        });
      }
    }
  }

  Future<void> addToCart(Map<String, dynamic> meal) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser ;

    if (user != null) {
      await firestore.collection('users').doc(user.uid).collection('menu').add(meal);
      setState(() {
        selectedMeals.add(meal);
      });
    } else {
      print("No hay usuario autenticado.");
    }
  }

  void confirmPurchase() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Compra Confirmada'),
          content: Text('Has comprado: ${selectedMeals.map((meal) => meal['strMeal']).join(', ')}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: selectedMeals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(selectedMeals[index]['strMeal']),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      setState(() {
                        selectedMeals.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: selectedMeals.isEmpty ? null : confirmPurchase,
              child: Text('Confirmar Compra'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí puedes agregar lógica para seleccionar comidas
          // Por ejemplo, abrir un diálogo o una nueva pantalla
          // Ejemplo: agregar la primera comida como demostración
          if (meals.isNotEmpty) {
            addToCart(meals[0]); // Agregar la primera comida como demostración
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Agregar Comida',
      ),
    );
  }
}