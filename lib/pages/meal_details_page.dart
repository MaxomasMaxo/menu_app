import 'package:flutter/material.dart';
import 'package:menu_app/provider/meal_provider.dart';

class MealDetailsPage extends StatefulWidget {
  final String mealId; // Recibe el ID de la comida

  MealDetailsPage({Key? key, required this.mealId}) : super(key: key);

  @override
  _MealDetailsPageState createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  final MealProvider mealProvider = MealProvider();
  Map<String, dynamic>? meal;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  Future<void> fetchMealDetails() async {
    try {
      var fetchedMeal = await mealProvider.getMealDetail(widget.mealId);
      setState(() {
        meal = fetchedMeal;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los detalles de la comida: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal?['strMeal'] ?? 'Detalles de la comida'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : meal != null
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        meal!['strMealThumb'] ?? '',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.image_not_supported, size: 100);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Categoría: ${meal!['strCategory'] ?? 'Desconocido'}'),
                            SizedBox(height: 8),
                            Text('Área: ${meal!['strArea'] ?? 'Desconocido'}'),
                            SizedBox(height: 16),
                            Text('Ingredientes:', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            _buildIngredientsGrid(meal!),
                            SizedBox(height: 16),
                            Text('Instrucciones:', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text(meal!['strInstructions'] ?? 'Instrucciones no disponibles'),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: Text('No se encontraron detalles para esta comida')),
    );
  }

  Widget _buildIngredientsGrid(Map<String, dynamic> meal) {
    List<Map<String, String>> ingredients = mealProvider.getIngredients(meal);
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
      ),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                ingredients[index]['image']!,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.image_not_supported, size: 50);
                },
              ),
              SizedBox(height: 4),
              Text(
                ingredients[index]['name']!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              Text(
                ingredients[index]['measure']!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
