import 'package:flutter/material.dart';
import 'package:menu_app/pages/bottom_nav_page.dart';
import 'package:menu_app/provider/meal_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailsPage extends StatefulWidget {
  final String mealId; // Recibe el ID de la comida

  MealDetailsPage({Key? key, required this.mealId}) : super(key: key);

  @override
  _MealDetailsPageState createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  final MealProvider mealProvider = MealProvider();
  Map<String, dynamic>? meal; // Variable para almacenar los detalles de la comida
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  // Método asíncrono para obtener los detalles de la comida
  Future<void> fetchMealDetails() async {
    try {
      // Intenta obtener los detalles de la comida usando el ID
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

  // Método para abrir el enlace en el navegador
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url); // Asegúrate de usar Uri
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // Usa modo explícito
    } else {
      throw 'No se pudo abrir el enlace: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal?['strMeal'] ?? 'Detalles de la comida'),
        backgroundColor: const Color(0xffff8b00), // Color coherente con la app
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
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
                          return const Icon(Icons.image_not_supported, size: 100);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Categoría y Área
                            Text('Categoría: ${meal!['strCategory'] ?? 'Desconocido'}'),
                            const SizedBox(height: 8),
                            Text('Área: ${meal!['strArea'] ?? 'Desconocido'}'),
                            const SizedBox(height: 16),
                            // Ingredientes
                            const Text('Ingredientes:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            _buildIngredientsGrid(meal!),
                            const SizedBox(height: 16),
                            // Instrucciones
                            const Text('Instrucciones:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(meal!['strInstructions'] ?? 'Instrucciones no disponibles'),
                            const SizedBox(height: 16),
                            // Botón para ver en YouTube
                            if (meal!['strYoutube'] != null && meal!['strYoutube'].isNotEmpty)
                              ElevatedButton.icon(
                                onPressed: () => _launchURL(meal!['strYoutube']),
                                icon: const Icon(Icons.video_library),
                                label: const Text('Ver receta en YouTube'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffff8b00),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                ),
                              ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                       Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const BottomNavPage()),
                    );
                          },
                          child: const Text(' Volver al inicio'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffff8b00),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(child: Text('No se encontraron detalles para esta comida')),
    );
  }

  // Método para construir una cuadrícula de ingredientes
  Widget _buildIngredientsGrid(Map<String, dynamic> meal) {
    List<Map<String, String>> ingredients = mealProvider.getIngredients(meal);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  return const Icon(Icons.image_not_supported, size: 50);
                },
              ),
              const SizedBox(height: 4),
              Text(
                ingredients[index]['name']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                ingredients[index]['measure']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
