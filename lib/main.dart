import 'package:book_tracker_app/View/Components/bottom_navigation_widget.dart';
import 'package:book_tracker_app/trash/floating_bottom_nav_example.dart';
import 'package:book_tracker_app/View/Screens/home_screen.dart';
import 'package:book_tracker_app/View/Screens/library_screen.dart';
import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.secondary),
        scaffoldBackgroundColor: AppColors.primary,
      ),
      home: BottomNavigationWidget(),
    );
  }
}


