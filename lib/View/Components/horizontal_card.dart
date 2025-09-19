import 'dart:io';

import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:book_tracker_app/View/Screens/detail_book_screen.dart';
import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HorizontalCard extends StatelessWidget {
  const HorizontalCard({super.key, required this.book});

  final Book book;
  Widget _buildBookImage() {
    // Cek jika path adalah asset atau file dari penyimpanan
    if (book.imageUrl.startsWith('assets/')) {
      // Jika path dimulai dengan 'assets/', gunakan Image.asset
      return Image.asset(
        book.imageUrl,
        height: 116,
        width: 86,
        fit: BoxFit.cover,
      );
    } else {
      // Jika tidak, itu adalah file dari penyimpanan, gunakan Image.file
      return Image.network(
        book.imageUrl,
        height: 116,
        width: 86,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailBookScreen(book: book);
            },
          ),
        );
      },
      child: Card(
        color: AppColors.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: _buildBookImage(),
              ),
              const SizedBox(width: 24.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Genre atau kategori
                  Text(
                    book.title,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    book.author,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: AppColors.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 175,
                          child: LinearProgressIndicator(
                            value:
                                (book.totalPage/book.progress!)*0.1, // nanti bisa dihubungkan dengan book.currentPage / book.totalPage
                            backgroundColor: AppColors.quaternary,
                            color: AppColors.secondary,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${(book.progress! / book.totalPage * 100).toStringAsFixed(0)} %",
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
