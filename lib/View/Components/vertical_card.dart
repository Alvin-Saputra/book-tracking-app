import 'dart:io';
import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:book_tracker_app/View/Screens/detail_book_screen.dart';
import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerticalCard extends StatelessWidget {
  const VerticalCard({
    super.key,
    required this.book,
    required this.onDataUpdated,
  });

  final Book book;
  final VoidCallback onDataUpdated;

  Widget _buildBookImage() {
    if (book.imageUrl.startsWith('assets/')) {
      return Image.asset(
        book.imageUrl,
        height: 270,
        width: 175,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(book.imageUrl),
        height: 270,
        width: 175,
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
        ).then((value) {
            onDataUpdated(); 
        });
      },
      child: SizedBox(
        width: 200,
        child: Card(
          elevation: 0,
          color: AppColors.primary,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: _buildBookImage(),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            book.author,
                            style: GoogleFonts.roboto(fontSize: 12, color: AppColors.text),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward, size: 18),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DetailBookScreen(book: book);
                              },
                            ),
                          ).then((value) {
                            if (value == true) {
                              onDataUpdated();
                            }
                          });
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: AppColors.primary,
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
