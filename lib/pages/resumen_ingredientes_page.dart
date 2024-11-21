import 'package:flutter/material.dart';

class ResumenIngredientesPage extends StatelessWidget {
  final List selectedMeals;

  const ResumenIngredientesPage({Key? key, required this.selectedMeals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen de Ingredientes'),
      ),
      body: ListView.builder(
        itemCount: selectedMeals.length,
        itemBuilder: (context, index) {
          final meal = selectedMeals[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal['strMeal'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Ingredientes:'),
                  for (int i = 1; i <= 20; i++)
                    if (meal['strIngredient$i'] != '' && meal['strIngredient$i'] != null)
                      Text('${meal['strIngredient$i']} - ${meal['strMeasure$i']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}