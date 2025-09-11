import 'dart:ffi';
import 'package:book_tracker_app/Controller/book_controller.dart';
import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:book_tracker_app/Model/Local/book_dao.dart';
import 'package:book_tracker_app/View/Components/horizontal_card.dart';
import 'package:book_tracker_app/View/Components/vertical_card.dart';
import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Book>> listBookFutureCurrentlyRead;
  List<Book> listBookCurrentlyRead = [];

  Future<List<Book>> getBooksDataCurrentlyRead() async {
    var dao = BookDao();
    var listBook = await dao.getBooksCurrentlyRead();
    print(listBook);
    return listBook;
  }

  void initState() {
    super.initState();
    Provider.of<BookController>(context, listen: false).fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: SingleChildScrollView(
        child: SafeArea(
          child: (Provider.of<BookController>(context, listen: false).isLoading)
              ? Column(
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
                            "Recently Added",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Consumer<BookController>(
                      builder:
                          (BuildContext context, controller, Widget? child) {
                            return SizedBox(
                              height: 354,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.recentlyAddedBooks.length,
                                itemBuilder: (context, index) {
                                  Book book =
                                      controller.recentlyAddedBooks[index];
                                  return VerticalCard(book: book);
                                },
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },
                              ),
                            );
                          },
                    ),
                    SizedBox(height: 12.0),
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Consumer<BookController>(
                      builder: (BuildContext context, controller, Widget? child) {
                        return ListView.separated(
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
                        );
                      },
                    ),
                  ],
                )
              : Center(child: LinearProgressIndicator()),
        ),
      ),
    );
  }
}
