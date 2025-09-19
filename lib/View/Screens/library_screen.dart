import 'package:book_tracker_app/Controller/book_controller.dart';
import 'package:book_tracker_app/Controller/user_controller.dart';
import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:book_tracker_app/Model/Local/book_dao.dart';
import 'package:book_tracker_app/View/Components/vertical_card.dart';
import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  LibraryScreen({super.key, this.onNavigateToAddBook});

  Function? onNavigateToAddBook;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BookController>(context, listen: false).fetchBooks(Provider.of<UserController>(context, listen: false).user.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookController>(
      builder: (BuildContext context, controller, Widget? child) {
        return (controller.books.isNotEmpty)
            ? Padding(
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
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.center,
                        widthFactor: 0.65, 
                        heightFactor: 0.65, 
                        child: Lottie.asset('assets/animation/Book.json'),
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onNavigateToAddBook!();
                      },
                      child: Text("Add Your First Book"),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }
}
