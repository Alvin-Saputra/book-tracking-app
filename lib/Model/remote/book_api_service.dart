import 'dart:io';
import 'dart:convert';
import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<String> uploadImage(File imageFile) async {
  final cloudName = dotenv.env['CLOUD_NAME'] ?? 'NO_KEY_FOUND';
  final uploadPreset = dotenv.env['PRESET_NAME'] ?? 'NO_KEY_FOUND';

  final url = Uri.parse(
    "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
  );

  final request = http.MultipartRequest("POST", url)
    ..fields['upload_preset'] = uploadPreset
    ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

  final streamedResponse = await request.send().timeout(
    const Duration(seconds: 120),
  );

  var response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    return responseData['secure_url'] ?? 'Unknown';
  } else {
    print("Error: ${response.body}");
    throw Exception("Failed To Upload Image, Try Again Later");
  }
}

Future<bool> addBookRemote(Map<String, dynamic> bookMap) async {
  try {
    String userId = bookMap['user_id'].toString();
    String bookId = bookMap['id'].toString();

    Uri endpoint = Uri.parse(
      "https://bookly-fa5b2-default-rtdb.asia-southeast1.firebasedatabase.app/books/$userId/$bookId.json",
    );

    Map<String, dynamic> bookData = Map.of(bookMap);
    bookData.remove('id');
    bookData.remove('user_id');

    final response = await http.put(
      endpoint,
      body: jsonEncode(bookData),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 200;
  } on SocketException {
    throw Exception("No Internet Connection");
  } catch (e) {
    throw Exception("An error occurred while adding the task");
  }
}

Future<bool> deleteBookRemote(String userId, String bookId) async {
  try {
    Uri endpoint = Uri.parse(
      "https://bookly-fa5b2-default-rtdb.asia-southeast1.firebasedatabase.app/books/$userId/$bookId.json",
    );

    var response = await http.delete(endpoint);
    var responseBody = response.body;
    print("ini adalah body $responseBody");
    return jsonDecode(response.body) ==
        null; // If the response is null, the task was deleted successfully
  } on SocketException {
    throw Exception("No Internet Connection");
  } catch (e) {
    throw Exception("An error occurred while deleting the task");
  }
}

Future<bool> updateBookRemote(
  String userId,
  String bookId,
  Map<String, dynamic> bookMap,
) async {
  try {
    Uri endpoint = Uri.parse(
      "https://bookly-fa5b2-default-rtdb.asia-southeast1.firebasedatabase.app/books/$userId/$bookId.json",
    );

    var response = await http.patch(
      endpoint,
      body: jsonEncode(bookMap),
      headers: {'Content-Type': 'application/json'},
    );

    return response
        .body
        .isNotEmpty; // If the response body is not empty, the task was updated successfully
  } on SocketException {
    throw Exception("No Internet Connection");
  } catch (e) {
    throw Exception("An error occurred while deleting the task");
  }
}

Future<List<Book>> getBooksRemote(String userId) async {
  Uri endpoint = Uri.parse(
    "https://bookly-fa5b2-default-rtdb.asia-southeast1.firebasedatabase.app/books/$userId.json",
  );

  var response = await http.get(endpoint);

  if (response.statusCode != 200) {
    throw Exception("Failed to load books");
  }

  final decodedResponse = jsonDecode(response.body);

  if (decodedResponse == null || (decodedResponse as Map).isEmpty) {
    return []; 
  }

  List<Book> books = decodedResponse.entries.map<Book>((entry) {
    final data = entry.value as Map<String, dynamic>;
    return Book(
      id: entry.key, 
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      genre: data['genre'] ?? '',
      totalPage: data['total_page'] ?? 0,
      progress: data['progress'] ?? 0,
      readingStatus: data['reading_status'] ?? '',
      addedAt: data['added_at'] ?? 0,
      imageUrl: data['image_url'] ?? '',
      userId: userId, 
    );
  }).toList();

  return books;
}

