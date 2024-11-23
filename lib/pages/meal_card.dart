import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:menu_app/pages/meal_details_page.dart';

class MealCard extends StatelessWidget {
  final Map<String, dynamic> meal;

  const MealCard({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () => _showMealPopup(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                meal['strMealThumb'] ?? '',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 100);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal['strMeal'] ?? 'Nombre desconocido',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal['strCategory'] ?? 'Categoría desconocida',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMealPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                meal['strMealThumb'] ?? '',
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 100);
                },
              ),
              const SizedBox(height: 16),
              Text(
                meal['strMeal'] ?? 'Nombre desconocido',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(meal['strCategory'] ?? 'Categoría desconocida'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealDetailsPage(mealId: meal['idMeal']),
                        ),
                      );
                    },
                    child: const Text('Ver detalles'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _addToCart(meal);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Agregado al carrito')),
                      );
                    },
                    child: const Text('Agregar al carrito'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addToCart(Map<String, dynamic> meal) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    User? user = FirebaseAuth.instance.currentUser ;
    
    if (user != null) {
      await firestore.collection('users').doc(user.uid).collection('menu').add({
        'idMeal': meal['idMeal'],
        'strMeal': meal['strMeal'],
        'strCategory': meal['strCategory'],
        'strMealThumb': meal['strMealThumb'],
      });
    } else {
      print("No hay usuario autenticado.");
    }
  }
}
