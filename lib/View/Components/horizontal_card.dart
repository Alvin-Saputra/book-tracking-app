import 'dart:io';

import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:book_tracker_app/View/Screens/detail_book_screen.dart';
import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HorizontalCard extends StatefulWidget {
  const HorizontalCard({super.key, required this.book});

  final Book book;

  @override
  State<HorizontalCard> createState() => _HorizontalCardState();
}

class _HorizontalCardState extends State<HorizontalCard> {
  Widget _buildBookImage() {
    // Cek jika path adalah asset atau file dari penyimpanan
    if (widget.book.imageUrl.startsWith('assets/')) {
      // Jika path dimulai dengan 'assets/', gunakan Image.asset
      return Image.asset(
        widget.book.imageUrl,
        height: 116,
        width: 86,
        fit: BoxFit.cover,
      );
    } else {
      // Jika tidak, itu adalah file dari penyimpanan, gunakan Image.file
      return Image.file(
        File(widget.book.imageUrl),
        height: 116,
        width: 86,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:() {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DetailBookScreen(book: widget.book,);
              },
            ),
          ).then((value) {
            // Refresh the task list after adding a new task
            setState(() {
             
            });
          });
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
                    widget.book.title,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // color: Colors.black87,
                    ),
                  ),
                  Text(
                    widget.book.author,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey[600],
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
                                0.5, // nanti bisa dihubungkan dengan book.currentPage / book.totalPage
                            backgroundColor: Colors.grey[300],
                            // color: Colors.black,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "50%",
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
