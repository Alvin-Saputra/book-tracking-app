import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:book_tracker_app/Model/Local/book_dao.dart';
import 'package:book_tracker_app/View/Components/vertical_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<Book>> listBookFuture;

  Future<List<Book>> getAllBooksData() async {
    var dao = BookDao();
    return await dao.getAllBooks();
  }

  @override
  void initState() {
    super.initState();
    listBookFuture = getAllBooksData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: listBookFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
    
        List<Book> listBook = snapshot.data!;
    
        return CustomScrollView(
          slivers: [
            // // ✅ Header
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: const EdgeInsets.only(top: 48.0, bottom: 8.0, left: 16.0),
            //     child: Text(
            //       "Collections",
            //       style: GoogleFonts.roboto(
            //         fontSize: 28,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
    
            // ✅ GridView jadi SliverGrid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  Book book = listBook[index];
                  return VerticalCard(book: book);
                }, childCount: listBook.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  mainAxisExtent: 360,
                ),
              ),
            ),
    
            // ✅ Tambahkan SliverToBoxAdapter untuk memberi ruang bawah
            const SliverToBoxAdapter(
              child: SizedBox(
                height: kBottomNavigationBarHeight + 10,
              ), // tinggi kira-kira setara dengan navbar
            ),
          ],
        );
      },
    );
  }
}
