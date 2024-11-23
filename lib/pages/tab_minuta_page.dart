import 'package:flutter/material.dart';
import 'package:menu_app/pages/meal_details_page.dart';
import 'package:menu_app/provider/meal_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TabMinutaPage extends StatefulWidget {
  const TabMinutaPage({Key? key}) : super(key: key);

  @override
  _TabMinutaPageState createState() => _TabMinutaPageState();
}

class _TabMinutaPageState extends State<TabMinutaPage> {
  final MealProvider mealProvider = MealProvider();
  String selectedCategory = 'Beef'; // Categoría inicial
  List meals = [];
  List<String> categories = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchMealsByCategory();
  }

  Future<void> fetchCategories() async {
    try {
      var fetchedCategories = await mealProvider.getCategories();
      setState(() {
        categories = fetchedCategories;
        if (categories.isNotEmpty) {
          selectedCategory = categories[0];
        }
      });
    } catch (e) {
      print('Error al cargar las categorías: $e');
    }
  }

  Future<void> fetchMealsByCategory() async {
    if (searchController.text.isNotEmpty) return; 
    try {
      var fetchedMeals = await mealProvider.getMealsByCategory(selectedCategory);
      setState(() {
        meals = fetchedMeals;
      });
    } catch (e) {
      print('Error al cargar los platos: $e');
    }
  }

  Future<void> searchMealsByName(String query) async {
    if (query.isEmpty) {
      fetchMealsByCategory();
      return;
    }
    try {
      var fetchedMeals = await mealProvider.searchMealsByName(query);
      print('Fetched meals by name: $fetchedMeals');
      setState(() {
        meals = fetchedMeals;
      });
    } catch (e) {
      print('Error al buscar los platos: $e');
    }
  }

  Future<void> addToCart(Map<String, dynamic> meal) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser ;

    if (user != null) {
      await firestore.collection('users').doc(user.uid).collection('menu').add(meal);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${meal['strMeal']} agregado al carrito')),
      );
    } else {
      print("No hay usuario autenticado.");
    }
  }

  void _showMealPopup(BuildContext context, Map<String, dynamic>? meal) {
    if (meal == null || meal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo cargar la información de la comida')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(meal['strMealThumb'] ?? '', height: 200, errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.image_not_supported, size: 200);
              }),
              const SizedBox(height: 16),
              Text(meal['strMeal'] ?? 'Nombre desconocido', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(meal['strCategory'] ?? 'Categoría desconocida'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      print("Meal details selected: $meal"); Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealDetailsPage(mealId: meal['idMeal']),
                        ),
                      );
                    },
                    child: const Text('Ver detalles'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      addToCart(meal);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por ingrediente o nombre',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    searchMealsByName(searchController.text);
                  },
                ),
              ),
              onSubmitted: (query) => searchMealsByName(query),
            ),
          ),
          if (categories.isNotEmpty && searchController.text.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButton<String>(
                value: selectedCategory,
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newCategory) {
                  if (newCategory != null) {
                    setState(() {
                      selectedCategory = newCategory;
                    });
                    fetchMealsByCategory();
                  }
                },
              ),
            ),
          Expanded(
            child: meals.isNotEmpty
                ? GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return GestureDetector(
                        onTap: () => _showMealPopup(context, meal),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Image.network(
                                  meal['strMealThumb'] ?? '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  meal['strMeal'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: Text('No se encontraron resultados')),
          ),
        ],
      ),
    );
  }
}