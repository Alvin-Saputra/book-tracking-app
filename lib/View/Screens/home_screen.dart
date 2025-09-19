import 'dart:ffi';
import 'package:book_tracker_app/Controller/book_controller.dart';
import 'package:book_tracker_app/Controller/user_controller.dart';
import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:book_tracker_app/Model/Local/book_dao.dart';
import 'package:book_tracker_app/View/Components/carousel_widget.dart';
import 'package:book_tracker_app/View/Components/horizontal_card.dart';
import 'package:book_tracker_app/View/Components/vertical_card.dart';
import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, this.onNavigateToAddBook});

  final VoidCallback? onNavigateToAddBook;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    super.initState();
    Provider.of<BookController>(context, listen: false).fetchBooks(Provider.of<UserController>(context, listen: false).user.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Consumer<BookController>(
            builder:
                (
                  BuildContext context,
                  BookController controller,
                  Widget? child,
                ) {
                  final recentlyAddedBooks = controller.recentlyAddedBooks;
                  final currentlyReadBooks = controller.currentlyReadBooks;
                  final hasRecentlyAddedBooks = recentlyAddedBooks.isNotEmpty;
                  final hasCurrentlyReadBooks = currentlyReadBooks.isNotEmpty;

                  if (controller.isLoading) {
                    return Center(child: LinearProgressIndicator());
                  } else {
                    if (hasRecentlyAddedBooks && hasCurrentlyReadBooks) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12.0,
                                  bottom: 24.0,
                                  // top: 32.0,
                                ),
                                child: Text(
                                  "Recently Added",
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          CarouselWidget(
                            book: controller.books,
                            enlargeCenterPage: true,
                            carouselHeight: 475,
                            imageHeight: 375,
                            imageWidth: 225,
                            viewportFraction: 0.65, 
                            enlargeFactor: 0.15,
                          ),
                          // SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 4.0,
                                  left: 12.0,
                                ),
                                child: Text(
                                  "Currently Read",
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.currentlyReadBooks.length,
                            itemBuilder: (context, index) {
                              Book book = controller.currentlyReadBooks[index];
                              return HorizontalCard(book: book);
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                          ),
                        ],
                      );
                    } else if (hasRecentlyAddedBooks) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  // left: 12.0,
                                  bottom: 32.0,
                                  top: 32.0,
                                ),
                                child: Text(
                                  "Recently Added",
                                  style: GoogleFonts.roboto(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          CarouselWidget(
                            book: controller.books,
                            enlargeCenterPage: true,
                            carouselHeight: 575,
                            imageHeight: 400,
                            imageWidth: 225,
                            viewportFraction: 0.6, enlargeFactor: 0.3,
                          ),
                        ],
                      );
                    } else if (hasCurrentlyReadBooks) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12.0,
                                  bottom: 4.0,
                                  top: 8.0,
                                ),
                                child: Text(
                                  "Currently Read",
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.currentlyReadBooks.length,
                            itemBuilder: (context, index) {
                              Book book = controller.currentlyReadBooks[index];
                              return HorizontalCard(book: book);
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                          ),
                        ],
                      );
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: ClipRect(
                                child: Align(
                                  alignment: Alignment.center,
                                  widthFactor: 0.65, // ambil 50% lebar animasi
                                  heightFactor:
                                      0.65, // ambil 50% tinggi animasi
                                  child: Lottie.asset(
                                    'assets/animation/Book.json',
                                  ),
                                ),
                              ),
                            ),
                            // Center(child: Text("No Book Added")),
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
                        ),
                      );
                    }
                  }
                },
          ),
        ),
      ),
    );
  }
}
