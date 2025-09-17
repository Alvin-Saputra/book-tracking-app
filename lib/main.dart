import 'package:book_tracker_app/Controller/book_controller.dart';
import 'package:book_tracker_app/Controller/user_controller.dart';
import 'package:book_tracker_app/Model/Local/book_dao.dart';
import 'package:book_tracker_app/View/Components/bottom_navigation_widget.dart';
import 'package:book_tracker_app/View/Screens/loading_screen.dart';
import 'package:book_tracker_app/View/Screens/login_screen.dart';
import 'package:book_tracker_app/View/Screens/registration_screen.dart';
import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final bookDao = BookDao();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return BookController(bookDao);
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return UserController();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.secondary),
          scaffoldBackgroundColor: AppColors.primary,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.secondary,
          ),
        ),
        home: Consumer<UserController>(
          builder:
              (BuildContext context, UserController controller, Widget? child) {
                if (controller.initializing) {
                  return LoadingScreen();
                } else if (controller.user.email.isEmpty || controller.user.email == "") {
                  return LoginScreen();
                } else {
                  return BottomNavigationWidget();
                }
              },
        ),
      ),
    );
  }
}
