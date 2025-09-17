import 'dart:io';

import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:book_tracker_app/View/Components/vertical_card.dart';
import 'package:book_tracker_app/View/Screens/detail_book_screen.dart';
import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class CarouselWidget2 extends StatelessWidget {
  CarouselWidget2({
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
            return VerticalCard(book: bookItem);
          },
        );
      }).toList(),
    );
  }
}
