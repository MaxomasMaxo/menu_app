import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  void addToCart(meal) {
    setState(() {
      selectedMeals.add(meal);
    });
  }

  void confirmPurchase() {
    // Aquí puedes implementar la lógica para confirmar la compra
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
        },
        child: Icon(Icons.add),
        tooltip: 'Agregar Comida',
      ),
    );
  }
}