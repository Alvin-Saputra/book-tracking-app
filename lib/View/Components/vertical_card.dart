import 'dart:io';

import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:book_tracker_app/View/Screens/detail_book_screen.dart';
import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerticalCard extends StatefulWidget {
  VerticalCard({super.key, required this.book});

  final Book book;

  @override
  State<VerticalCard> createState() => _VerticalCardState();
}

class _VerticalCardState extends State<VerticalCard> {
  Widget _buildBookImage() {
    // Cek jika path adalah asset atau file dari penyimpanan
    if (widget.book.imageUrl.startsWith('assets/')) {
      // Jika path dimulai dengan 'assets/', gunakan Image.asset
      return Image.asset(
        widget.book.imageUrl,
        height: 270,
        width: 175,
        fit: BoxFit.cover,
      );
    } else {
      // Jika tidak, itu adalah file dari penyimpanan, gunakan Image.file
      return Image.file(
        File(widget.book.imageUrl),
        height: 270,
        width: 175,
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
      child: SizedBox(
        // <-- Tambahkan SizedBox di sini
        width: 200, // <--- Sesuaikan lebar yang Anda inginkan untuk seluruh card
        child: Card(
          elevation: 0,
          color: AppColors.primary,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Biarkan ini agar Column tidak mengambil tinggi penuh
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  child: _buildBookImage(),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Ini akan bekerja sekarang
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      // Bungkus Column dengan Expanded agar mengambil sisa ruang yang tersedia setelah IconButton
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.book.title,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow
                                .ellipsis, // Tambahkan ini jika teks terlalu panjang
                            maxLines: 1, // Batasi jumlah baris
                          ),
                          Text(
                            widget.book.author,
                            style: GoogleFonts.roboto(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward, size: 18),
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: AppColors.primary,
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero, // Hapus padding default
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
