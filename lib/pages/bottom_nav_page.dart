import 'package:flutter/material.dart';
import 'package:menu_app/pages/information_page.dart';
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

  void _borrarCarrito() {
    print("Borrar carrito - Método en desarrollo");
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
                // Navegar a la pantalla del carrito (en desarrollo)
                print("Navegar al carrito - En desarrollo");
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Borrar Carrito'),
              onTap: () {
                Navigator.pop(context);
                _borrarCarrito();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Carrito borrado')),
                );
              },
            ),ListTile(
              leading: Icon(Icons.info),
              title: Text('Información'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InformationPage()), // Navega a InformationScreen
                );
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