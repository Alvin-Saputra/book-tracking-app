import 'package:book_tracker_app/View/Screens/add_book_screen.dart';
import 'package:book_tracker_app/View/Screens/home_screen.dart';
import 'package:book_tracker_app/View/Screens/library_screen.dart';
import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 0;
  late final List<Widget> _screens = [
    HomeScreen(),
    AddBookScreen(),
    LibraryScreen(),
  ];

  PreferredSizeWidget _buildAppBarTitle() {
    switch(_currentIndex){
      case 0:
        return AppBar(title: Text("Home", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),));
      case 1:
        return AppBar(title: Text("Add Book", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),));
      case 2:
        return AppBar(title: Text("Collections", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),));
      default:
        return AppBar(title: Text("Home", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBarTitle(),
      extendBody: true,
      body: _screens[_currentIndex], // Tampilkan screen sesuai index
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 72, right: 72, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 9),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: AppColors.primary,
            elevation: 0,
            selectedItemColor: AppColors.secondary,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false, // Sembunyikan label item terpilih
            showUnselectedLabels: false, // Sembunyikan label item lainnya
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmarks_rounded),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
