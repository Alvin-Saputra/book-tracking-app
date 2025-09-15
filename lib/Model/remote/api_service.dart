import 'dart:io';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<String> registrationService(Map<dynamic, dynamic> signUpData) async {
  final apiKey = dotenv.env['API_KEY'] ?? 'NO_KEY_FOUND';
  var response = await http.post(
    Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey',
    ),
    body: jsonEncode(signUpData),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    return 'success';
  } else {
    return 'failed';
  }
}

Future<Map<String, dynamic>> loginService(Map<String, dynamic> loginData) async {
  final apiKey = dotenv.env['API_KEY'] ?? 'NO_KEY_FOUND';

  final response = await http.post(
    Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey',
    ),
    body: jsonEncode(loginData),
    headers: {'Content-Type': 'application/json'},
  );

  final responseData = jsonDecode(response.body);

  // Cek jika status code bukan 200
  if (response.statusCode != 200) {
    String errorMessage = 'Some error occurred, please try again later';

    if (responseData['error'] != null) {
      switch (responseData['error']['message']) {
        case 'EMAIL_NOT_FOUND':
          errorMessage = 'Email is not registered';
          break;
        case 'INVALID_PASSWORD':
          errorMessage = 'Invalid password';
          break;
        case 'USER_DISABLED':
          errorMessage = 'This account has been disabled';
          break;
      }
    }

    throw Exception(errorMessage);
  }

  // Jika sukses, return data
  return responseData as Map<String, dynamic>;
}
