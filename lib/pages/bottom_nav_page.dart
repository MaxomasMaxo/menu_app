import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:menu_app/pages/information_page.dart';
import 'package:menu_app/pages/login_page.dart';
import 'package:menu_app/pages/tab_cesta_page.dart';
import 'package:menu_app/pages/tab_home_page.dart';
import 'package:menu_app/pages/tab_minuta_page.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _currentIndex = 1;

  late List<Map<String, dynamic>> _paginas;

  @override
  void initState() {
    super.initState();
    _updatePages();
  }

  void _updatePages() {
    _paginas = [
      {'pagina': TabMinutaPage(), 'texto': 'Busqueda', 'color': 0xffff8b00, 'icono': Icons.calendar_month},
      {'pagina': TabHomePage(), 'texto': 'Inicio', 'color': 0xffff8b00, 'icono': Icons.home},
      {'pagina': TabCestaPage(), 'texto': 'Cesta', 'color': 0xffff8b00, 'icono': Icons.shopping_cart},
    ];
  }

  Future<void> _borrarCarrito() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser ;

    if (user != null) {
      CollectionReference menuCollection = firestore.collection('users').doc(user.uid).collection('menu');

      QuerySnapshot snapshot = await menuCollection.get();

      for (var doc in snapshot.docs) {
        await menuCollection.doc(doc.id).delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Carrito borrado')),
      );
    } else {
      print("No hay usuario autenticado.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_paginas[_currentIndex]['texto'], style: TextStyle(color: Colors.white)),
        backgroundColor: Color(_paginas[_currentIndex]['color']),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.menu,
                    color: Color(_paginas[_currentIndex]['color']),
                  ),
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(_paginas[_currentIndex]['color']),
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Carrito de Compras'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 2; 
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Borrar Carrito'),
              onTap: () {
                Navigator.pop(context);
                _borrarCarrito(); 
              },
            ),
            ListTile(
              leading: Icon(Icons.info ),
              title: Text('Información'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InformationPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar Sesión'),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } catch (e) {
                  print('Error al cerrar sesión: $e');
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content: const Text('No se pudo cerrar sesión. Intenta de nuevo.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cerrar'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: _paginas[_currentIndex]['pagina'],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Busqueda'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'Cesta'),
        ],
      ),
    );
  }
}