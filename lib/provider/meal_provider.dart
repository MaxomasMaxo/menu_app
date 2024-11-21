import 'dart:convert'; // Para convertir respuestas JSON a Mapas y Listas de Dart.
import 'package:http/http.dart' as http; // Paquete HTTP para hacer solicitudes.

class MealProvider {
  // URL base de la API de TheMealDB para filtrar comidas por categoría.
  final apiURL = 'https://www.themealdb.com/api/json/v1/1/';
  
  // Método para obtener una lista de comidas por categoría.
  Future<List<dynamic>> getMealsByCategory(String category) async {
    var url = Uri.parse(apiURL + 'filter.php?c=' + category);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)['meals'];
    } else {
      return [];
    }
  }

  // Método para obtener los detalles de una comida específica por su ID.
  Future<Map<String, dynamic>> getMealDetail(String mealId) async {
    var url = Uri.parse(apiURL + 'lookup.php?i=' + mealId);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)['meals'][0];
    } else {
      return {};
    }
  }

  // Método para obtener una comida aleatoria.
  Future<Map<String, dynamic>> getRandomMeal() async {
    var url = Uri.parse(apiURL + 'random.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)['meals'][0];
    } else {
      return {};
    }
  }

  // Método para obtener la imagen de una comida.
  String getMealImage(String mealId) {
    return 'https://www.themealdb.com/images/media/meals/$mealId.jpg/preview';
  }

  // Método para obtener los ingredientes de una comida.
  List<Map<String, String>> getIngredients(Map<String, dynamic> meal) {
    List<Map<String, String>> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      String? ingredient = meal['strIngredient$i'];
      String? measure = meal['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add({
          'name': ingredient,
          'measure': measure ?? '',
          'image': 'https://www.themealdb.com/images/ingredients/$ingredient-Small.png'
        });
      }
    }
    return ingredients;
  }

  // Método para obtener todas las categorías de la API.
  Future<List<String>> getCategories() async {
    var url = Uri.parse(apiURL + 'categories.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List categories = json.decode(response.body)['categories'];
      return categories.map<String>((category) => category['strCategory'] as String).toList();
    } else {
      return [];
    }
  }

  // Método para buscar comidas por nombre.
  Future<List<dynamic>> searchMealsByName(String name) async {
    var url = Uri.parse(apiURL + 'search.php?s=' + name);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)['meals'] ?? [];
    } else {
      return [];
    }
  }
}
