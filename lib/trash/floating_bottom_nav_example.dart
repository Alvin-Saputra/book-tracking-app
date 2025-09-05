import 'package:flutter/material.dart';

class CustomFloatingBottomNav extends StatefulWidget {
  @override
  _CustomFloatingBottomNavState createState() =>
      _CustomFloatingBottomNavState();
}

class _CustomFloatingBottomNavState extends State<CustomFloatingBottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text("Home Page")),
    Center(child: Text("Search Page")),
    Center(child: Text("Profile Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false, // Sembunyikan label item terpilih
            showUnselectedLabels: false, // Sembunyikan label item lainnya
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
            ],
          ),
        ),
      ),
    );
  }
}
