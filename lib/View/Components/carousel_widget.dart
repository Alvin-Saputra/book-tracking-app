import 'dart:io';

import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:book_tracker_app/View/Screens/detail_book_screen.dart';
import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class CarouselWidget extends StatelessWidget {
  CarouselWidget({
    super.key,
    required this.book,
    required this.enlargeCenterPage,
    required this.carouselHeight,
    required this.imageHeight,
    required this.imageWidth,
    required this.viewportFraction, required this.enlargeFactor,

  });

  final List<Book> book;
  final bool enlargeCenterPage;
  final double carouselHeight;
  final double imageHeight;
  final double imageWidth;
  final double viewportFraction;
  final double enlargeFactor;

  Widget _buildBookImage(Book book) {
    if (book.imageUrl.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.asset(book.imageUrl, fit: BoxFit.cover),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.file(File(book.imageUrl), fit: BoxFit.cover),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: carouselHeight, // overall carousel height
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: enlargeCenterPage,
        enlargeFactor: enlargeFactor,
        viewportFraction: viewportFraction,
        enableInfiniteScroll: true,
        scrollDirection: Axis.horizontal,
      ),
      items: book.map((bookItem) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return DetailBookScreen(book: bookItem);
                    },
                  ),
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    height: imageHeight, // control image height here
                    width: imageWidth,
                    child: _buildBookImage(bookItem),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: Text(
                      bookItem.title,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4.0),
                    child: Text(
                      bookItem.author,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppColors.text,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
