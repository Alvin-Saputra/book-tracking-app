import 'package:book_tracker_app/Controller/book_controller.dart';
import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:book_tracker_app/Model/Local/book_dao.dart';
import 'package:book_tracker_app/View/Components/vertical_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BookController>(context, listen: false).fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookController>(
      builder: (BuildContext context, controller, Widget? child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: GridView.builder(
            padding: const EdgeInsets.only(
              top: 0.0,
              bottom: kBottomNavigationBarHeight + 10,
            ),
            itemCount: controller.books.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              mainAxisExtent: 360,
            ),
            itemBuilder: (context, index) {
              Book book = controller.books[index];
              return VerticalCard(book: book);
            },
          ),
        );
      },
    );
  }
}
