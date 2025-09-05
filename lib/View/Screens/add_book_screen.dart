import 'package:book_tracker_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return SafeArea(
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text(
                "Add Book",
                style: GoogleFonts.roboto(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  // color: Colors.black87,
                ),
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
                  SizedBox(height: 24.0), // Added spacing between fields
                  TextFormField(
                    validator: (value) =>
                        (value == null || value.isEmpty || value == '')
                        ? "Please enter author"
                        : null,
                    controller: controllerAuthor,
                    decoration: const InputDecoration(labelText: "Author"),
                  ),
                  SizedBox(height: 24.0),
                  TextFormField(
                    validator: (value) =>
                        (value == null || value.isEmpty || value == '')
                        ? "Please enter a genre"
                        : null,
                    controller: controllerGenre,
                    decoration: const InputDecoration(labelText: "Genre"),
                  ),
                  SizedBox(height: 24.0),
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
    );
  }
}
