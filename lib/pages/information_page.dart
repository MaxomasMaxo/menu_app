import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información del Equipo', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xffff8b00),
        centerTitle: true, 
        elevation: 2, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Equipo de Desarrollo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildTeamMember('Maxo', 'assets/images/member1.png'),
            _buildTeamMember('Cristian Sarabia', 'assets/images/member2.png'),
            _buildTeamMember('Yang', 'assets/images/member3.png'),
            SizedBox(height: 20),
            Text(
              'Información sobre Flutter:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10), 
            Text(
              'Flutter es un framework de UI de código abierto creado por Google. Permite crear aplicaciones nativas para móviles, web y escritorio a partir de una única base de código.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            Text(
              'Información sobre la API:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'TheMealDB: An open, crowd-sourced database of Recipes from around the world.',
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  // Método construir la representación de un miembro del equipo
  Widget _buildTeamMember(String name, String imagePath) {
    return Row(
      children: [
        // Avatar circular que muestra la imagen del miembro del equipo
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(width: 10),
        Text(name, style: TextStyle(fontSize: 18)),
      ],
    );
  }
}