import 'package:book_tracker_app/Model/Local/book.dart';
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

class DetailBookScreen extends StatefulWidget {
  const DetailBookScreen({super.key, required this.book});

  final Book book;

  @override
  State<DetailBookScreen> createState() => _DetailBookScreenState();
}

class _DetailBookScreenState extends State<DetailBookScreen> {
  final _formKey = GlobalKey<FormState>();

  late File? croppedImage = null;
  bool _isProcessing = false;

  final List<String> readingStatus = ['Not Started', 'Started', 'Finished'];
  String? selectedReadingStatus;

  late Book bookInfo;

  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerAuthor = TextEditingController();
  final TextEditingController controllerGenre = TextEditingController();
  final TextEditingController controllerTotalPage = TextEditingController();
  final TextEditingController controllerProgress = TextEditingController();

  @override
  void initState() {
    super.initState();
    bookInfo = widget.book;

    controllerTitle.text = bookInfo.title;
    controllerAuthor.text = bookInfo.author;
    controllerGenre.text = bookInfo.genre;
    controllerTotalPage.text = bookInfo.totalPage.toString();
    controllerProgress.text = bookInfo.progress.toString();

    var reading_progress = bookInfo.readingStatus;
    print(reading_progress);

    switch (bookInfo.readingStatus) {
      case 'not_started':
        selectedReadingStatus = readingStatus[0];
        break;

      case 'started':
        selectedReadingStatus = readingStatus[1];
        break;

      case 'finished':
        selectedReadingStatus = readingStatus[2];
        break;

      default:
        selectedReadingStatus = readingStatus[0];
        break;
    }
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

  Future<bool> _updateBookDB(int bookId, Map<String, dynamic> bookMap) async {
    var dao = BookDao();
    var success = await dao.updateBook(bookId, bookMap);
    return success;
  }

    Future<bool> _deleteBookDB(int bookId) async {
    var dao = BookDao();
    var success = await dao.deleteBook(bookId);
    return success;
  }

  DecorationImage _buildBookImage() {
    if (bookInfo.imageUrl.startsWith('assets/')) {
      return DecorationImage(
        image: AssetImage(bookInfo.imageUrl),
        fit: BoxFit.cover,
      );
    } else {
      return DecorationImage(
        image: FileImage(File(bookInfo.imageUrl)),
        fit: BoxFit.cover,
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Book'),
          content: const Text(
              'Are you sure you want to delete this book? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Mengembalikan false
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(true); // Mengembalikan true
              },
            ),
          ],
        );
      },
    );

    // Lanjutkan hanya jika pengguna menekan 'Delete'
    if (shouldDelete == true) {
      bool isSuccess = await _deleteBookDB(bookInfo.id!);
      
      if (mounted) {
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book Deleted Successfully')),
          );
          Navigator.of(context).pop(); 
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to Delete Book')),
          );
        }
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Book Details",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
        actions: [IconButton(icon: Icon(Icons.delete_outline), onPressed: () {
         _showDeleteConfirmationDialog();
        })],
      ),
      body: SingleChildScrollView(
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
                        : _buildBookImage(),
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
                          keyboardType:
                              TextInputType.number, // Keyboard numerik
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

                              File? bookImage;

                              if (croppedImage == null) {
                                bookImage = File(bookInfo.imageUrl);
                              } else {
                                bookImage = croppedImage;
                              }

                              Map<String, dynamic> bookMap = {
                                'title': controllerTitle.text,
                                'author': controllerAuthor.text,
                                'genre': controllerGenre.text,
                                'total_page': totalPage,
                                'progress': progress,
                                'reading_status': insertedReadingStatus,
                                'image_url': bookImage?.path.toString() ?? '',
                              };

                              bool isSuccess = await _updateBookDB(
                                bookInfo.id!,
                                bookMap,
                              );

                              if (isSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Book Updated Successfully'),
                                  ),
                                );
                                
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to Update Book'),
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
                            "Update Book",
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
      ),
    );
  }
}
