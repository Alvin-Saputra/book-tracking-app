import 'dart:ui' as BorderType;

import 'package:book_tracker_app/constant/color.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerAuthor = TextEditingController();
  TextEditingController controllerGenre = TextEditingController();
  TextEditingController controllerTotalPage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32.0, left: 32),
                  child: Text(
                    "Add Book",
                    style: GoogleFonts.roboto(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      // color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 32.0),
              height: 225,
              width: 175,
              decoration: BoxDecoration(
                color: AppColors.primary,
                border: DashedBorder.fromBorderSide(
                  side: BorderSide(color: Colors.black, width: 1.0),
                  dashLength: 4,
                ),
                borderRadius: BorderRadius.all(Radius.circular(24.0))
              ),
            
              child: const Center(
                child: Text(
                  "+ Book Cover",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) =>
                          (value == null || value.isEmpty || value == '')
                          ? "Please enter a title"
                          : null,
                      controller: controllerTitle,
                      decoration: const InputDecoration(labelText: "Title"),
                    ),
                    SizedBox(height: 12.0), // Added spacing between fields
                    TextFormField(
                      validator: (value) =>
                          (value == null || value.isEmpty || value == '')
                          ? "Please enter author"
                          : null,
                      controller: controllerAuthor,
                      decoration: const InputDecoration(labelText: "Author"),
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      validator: (value) =>
                          (value == null || value.isEmpty || value == '')
                          ? "Please enter a genre"
                          : null,
                      controller: controllerGenre,
                      decoration: const InputDecoration(labelText: "Genre"),
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      validator: (value) =>
                          (value == null || value.isEmpty || value == '')
                          ? "Please enter total page"
                          : null,
                      controller: controllerTotalPage,
                      decoration: const InputDecoration(labelText: "Total Page"),
                    ),
                    SizedBox(height: 32.0),
                    SizedBox(
                      width: double.infinity, // Bikin tombol selebar parent
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {}
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ), // Tinggi tombol
                        ),
                        child: const Text(
                          "Add Task",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
