import 'package:book_tracker_app/Controller/book_controller.dart';
import 'package:book_tracker_app/Controller/user_controller.dart';
import 'package:book_tracker_app/View/Screens/add_book_screen.dart';
import 'package:book_tracker_app/View/Screens/home_screen.dart';
import 'package:book_tracker_app/View/Screens/library_screen.dart';
import 'package:book_tracker_app/View/Screens/login_screen.dart';
import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 0;
  late final List<Widget> _screens = [
    HomeScreen(onNavigateToAddBook: _goToAddBook),
    AddBookScreen(onNavigateToHome: _goToHome),
    LibraryScreen(onNavigateToAddBook: _goToAddBook),
  ];

  void _goToAddBook() {
    setState(() {
      _currentIndex = 1;
    });
  }

    void _goToHome() {
    setState(() {
      _currentIndex = 0;
    });
  }


  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    switch (_currentIndex) {
      case 0:
        appBarTitle = "Home";
        break;
      case 1:
        appBarTitle = "Add Book";
        break;
      case 2:
        appBarTitle = "Collections";
        break;
      default:
        appBarTitle = "Book Tracker";
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: GoogleFonts.roboto(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        actions: <Widget>[
          Consumer<UserController>(
            builder:
                (
                  BuildContext context,
                  UserController controller,
                  Widget? child,
                ) {
                  return PopupMenuButton<String>(
                    icon: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.secondary, 
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.secondary,
                      ),
                    ),
                    onSelected: (String result) async {
                      if (result == 'logout') {
                        await Provider.of<BookController>(context, listen: false).deleteAllBooks();
                        await controller.clearData();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'email',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.email_outlined,
                                  color: AppColors.secondary,
                                ),
                                const SizedBox(width: 8),
                                Text(controller.user.email),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: AppColors.secondary),
                                SizedBox(width: 8),
                                Text('Logout'),
                              ],
                            ),
                          ),
                        ],
                  );
                },
          ),
        ],
      ),
      extendBody: true,
      body: _screens[_currentIndex], // tampilkan screen sesuai index
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 72, right: 72, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
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
            showSelectedLabels: false,
            showUnselectedLabels: false,
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
