import 'package:book_tracker_app/Controller/book_controller.dart';
import 'package:book_tracker_app/Model/Local/book_dao.dart';
import 'package:book_tracker_app/View/Components/custom_drop_down_field.dart';
import 'package:book_tracker_app/View/Components/custom_input_text_field.dart';
import 'package:book_tracker_app/constant/color.dart';
import 'package:book_tracker_app/utils/image_cropper_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  late File? croppedImage = null;
  bool _isProcessing = false;

  final List<String> readingStatus = ['Not Started', 'Started', 'Finished'];
  String? selectedReadingStatus;

  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerAuthor = TextEditingController();
  final TextEditingController controllerGenre = TextEditingController();
  final TextEditingController controllerTotalPage = TextEditingController();
  final TextEditingController controllerProgress = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedReadingStatus = readingStatus[0];
  }

  Future<void> pickFromGallery() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) {
      setState(() {
        _isProcessing = false;
      });
      return;
    }

    File? croppedResult = await cropImage(File(image.path));

    // ✅ 1. KONDISI DIPERBAIKI: Periksa hasil crop, bukan state
    if (croppedResult != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = path.extension(croppedResult.path);
      final newFileName = 'cover_$timestamp$fileExtension';

      final permanentFilePath = path.join(appDir.path, newFileName);
      final permanentFile = await croppedResult.copy(permanentFilePath);

      setState(() {
        croppedImage = permanentFile;
        print('Gambar disimpan di path: ${croppedImage!.path}');
      });
    }

    setState(() {
      _isProcessing = false;
    });
  }



  void clearForm() {
    setState(() {
      controllerTitle.clear();
      controllerAuthor.clear();
      controllerGenre.clear();
      controllerTotalPage.clear();
      controllerProgress.clear();
      selectedReadingStatus = readingStatus[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: pickFromGallery,
              borderRadius: BorderRadius.circular(24.0),
              child: Container(
                margin: const EdgeInsets.only(top: 32.0),
                height: 275,
                width: 175,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  border: DashedBorder.fromBorderSide(
                    side: const BorderSide(color: Colors.black, width: 1.0),
                    dashLength: 4,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  image: (croppedImage != null)
                      ? DecorationImage(
                          image: FileImage(croppedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Center(
                  child: (croppedImage == null)
                      ? Text(
                          "+ Book Cover",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        )
                      : null,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomInputField(
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Please enter a title"
                          : null,
                      controller: controllerTitle,
                      // ✅ Gunakan dekorasi kustom
                      label: 'Title',
                    ),
                    const SizedBox(height: 16.0), // Jarak antar field
                    CustomInputField(
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Please enter an author"
                          : null,
                      controller: controllerAuthor,
                      // ✅ Gunakan dekorasi kustom
                      label: 'Author',
                    ),
                    const SizedBox(height: 16.0),
                    CustomInputField(
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Please enter a genre"
                          : null,
                      controller: controllerGenre,
                      // ✅ Gunakan dekorasi kustom
                      label: 'Genre',
                    ),
                    const SizedBox(height: 16.0),
                    CustomInputField(
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Please enter total pages"
                          : null,
                      controller: controllerTotalPage,
                      keyboardType: TextInputType.number, // Keyboard numerik
                      // ✅ Gunakan dekorasi kustom
                      label: 'Total Pages',
                    ),
                    SizedBox(height: 16.0),
                    CustomDropdownField(
                      label: 'Reading Status',
                      value: selectedReadingStatus,
                      items: readingStatus,
                      onChanged: (newValue) {
                        setState(() {
                          selectedReadingStatus = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a genre' : null,
                    ),
                    if (selectedReadingStatus == 'Started') ...[
                      SizedBox(height: 16.0),
                      CustomInputField(
                        validator: (value) => (value == null || value.isEmpty)
                            ? "Please enter pages progress"
                            : null,
                        controller: controllerProgress,
                        keyboardType: TextInputType.number, // Keyboard numerik
                        label: 'Progress',
                      ),
                    ],
                    const SizedBox(height: 32.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final totalPage =
                                int.tryParse(controllerTotalPage.text) ?? 0;
                            final progress =
                                int.tryParse(controllerProgress.text) ?? 0;

                            String? insertedReadingStatus;

                            switch (selectedReadingStatus) {
                              case 'Not Started':
                                insertedReadingStatus = 'not_started';
                                break;

                              case 'Started':
                                insertedReadingStatus = 'started';
                                break;

                              case 'Finished':
                                insertedReadingStatus = 'finished';
                                break;
                            }

                            Map<String, dynamic> bookMap = {
                              'title': controllerTitle.text,
                              'author': controllerAuthor.text,
                              'genre': controllerGenre.text,
                              'total_page': totalPage,
                              'progress': progress,
                              'reading_status': insertedReadingStatus,
                              'added_at':
                                  "${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}",
                              'image_url': croppedImage?.path.toString() ?? '',
                            };

                            int row = await Provider.of<BookController>(context, listen: false).addBook(bookMap);

                            if (row > 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Book Added Successfully'),
                                ),
                              );
                              clearForm();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to Add Book'),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: const Text(
                          "Add Book",
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
