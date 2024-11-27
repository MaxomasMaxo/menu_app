import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:menu_app/pages/meal_details_page.dart';

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
    }
  }

  Future<void> fetchCartItems() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser ;

    if (user != null) {
      QuerySnapshot snapshot = await firestore.collection('users').doc(user.uid).collection('menu').get();
      setState(() {
        selectedMeals = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    }
  }

  Future<void> clearCart() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser ;

    if (user != null) {
      // Obtener todos los documentos en la colección 'menu'
      QuerySnapshot snapshot = await firestore.collection('users').doc(user.uid).collection('menu').get();
      for (var doc in snapshot.docs) {
        await firestore.collection('users').doc(user.uid).collection('menu').doc(doc.id).delete();
      }
      // Actualizar la lista local
      setState(() {
        selectedMeals.clear();
      });
    } else {
      print("No hay usuario autenticado.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comidas seleccionadas'),
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
                    icon: Icon(Icons.info),
                    onPressed: () {
                        print(selectedMeals[index]['idMeal']);
                        Navigator.pop(context );
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealDetailsPage(mealId: selectedMeals[index]['idMeal']), 
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: selectedMeals.isEmpty ? null : clearCart,
              child: Text('Borrar Cesta'),
            ),
          ),
        ],
      ),
    );
  }
}