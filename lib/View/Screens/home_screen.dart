import 'dart:ffi';

import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:book_tracker_app/Model/Local/book_dao.dart';
import 'package:book_tracker_app/View/Components/horizontal_card.dart';
import 'package:book_tracker_app/View/Components/vertical_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Book>> listBookFuture;
  late List<Book> listBook;

  late Future<List<Book>> listBookFutureCurrentlyRead;
  late List<Book> listBookCurrentlyRead;

  Future<List<Book>> getBooksData() async {
    var dao = BookDao();
    var listBook = await dao.getBooks();
    print(listBook);
    return listBook;
  }

  Future<List<Book>> getBooksDataCurrentlyRead() async {
    var dao = BookDao();
    var listBook = await dao.getBooksCurrentlyRead();
    print(listBook);
    return listBook;
  }

  void initState() {
    super.initState();
    listBookFuture = getBooksData();
    listBookFutureCurrentlyRead = getBooksDataCurrentlyRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 24.0),
                  child: Text(
                    "BookShelf",
                    style: GoogleFonts.roboto(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    "Recently Added",
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: listBookFuture,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (snapshot.hasData) {
                  listBook = snapshot.data;
                  return SizedBox(
                    height: 354,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: listBook.length,
                      itemBuilder: (context, index) {
                        Book book = listBook[index];
                        return VerticalCard(book: book);
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, left: 12.0),
                  child: Text(
                    "Currently Read",
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: listBookFutureCurrentlyRead,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (snapshot.hasData) {
                  listBookCurrentlyRead = snapshot.data;
                  return Expanded(
                    child: ListView.separated(
                      itemCount: listBookCurrentlyRead.length,
                      itemBuilder: (context, index) {
                        Book book = listBookCurrentlyRead[index];
                        return HorizontalCard(book: book);
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
