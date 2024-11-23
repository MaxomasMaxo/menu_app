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
  Map<String, dynamic>? randomMeal;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
    fetchRandomMeal();
  }

  Future<void> _fetchUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser ;
    if (user != null) {
      for (final providerProfile in user.providerData) {
        final emailAddress = providerProfile.email;

        setState(() {
          _userEmail = emailAddress;
        });
      }
    }
  } 

  Future<void> fetchRandomMeal() async {
    var meal = await mealProvider.getRandomMeal();
    if (mounted){
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
          '¡Hola, $_userEmail!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        if (randomMeal != null)
          MealCard(meal: randomMeal!)
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