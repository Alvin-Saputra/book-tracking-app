import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerticalCard extends StatelessWidget {
  const VerticalCard({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // <-- Tambahkan SizedBox di sini
      width: 200, // <--- Sesuaikan lebar yang Anda inginkan untuk seluruh card
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Biarkan ini agar Column tidak mengambil tinggi penuh
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                child: Image.asset(
                  book.imageUrl,
                  height: 270,
                  width: 175, // Lebar gambar
                  fit: BoxFit.cover,
                ),
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
                          book.title,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Tambahkan ini jika teks terlalu panjang
                          maxLines: 1, // Batasi jumlah baris
                        ),
                        Text(
                          book.author,
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
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
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
    );
  }
}
