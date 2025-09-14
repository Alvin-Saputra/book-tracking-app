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

Future<String> loginService(Map<dynamic, dynamic> loginData) async {
  final apiKey = dotenv.env['API_KEY'] ?? 'NO_KEY_FOUND';
  // Buat multipart request
  var response = await http.post(
    Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey',
    ),
    body: jsonEncode(loginData),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    return 'success';
  } else {
    return 'failed';
  }
}
