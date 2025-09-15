import 'package:book_tracker_app/Model/Local/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/Local/book.dart';
import '../Model/Local/book_dao.dart';

class UserController with ChangeNotifier {
  late User _user;
  User get user => _user;

  late SharedPreferences _preferences;
  bool initializing = false;

  final String keyEmail = 'email';
  final String keyLocalId = 'localId';
  final String keyIdToken = 'idToken';
  final String keyrRefreshToken = 'refreshToken';
  final String keyExpiresIn = 'expiresIn';

  UserController() {
    initialize();
  }

  void initialize() async {
    initializing = true;
    _preferences = await SharedPreferences.getInstance();
    initializing = false;
    fetchUserData();
  }

  void fetchUserData() {
    String email = _preferences.getString(keyEmail) ?? "";
    String userId = _preferences.getString(keyLocalId) ?? "";
    String idToken = _preferences.getString(keyIdToken) ?? "";
    String refreshToken = _preferences.getString(keyrRefreshToken) ?? "";
    String expiresIn = _preferences.getString(keyExpiresIn) ?? "";

    _user = User(
      email: email,
      userId: userId,
      idToken: idToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );
    print("=== Fetch User Data from SharedPreferences ===");
    print("Email: $email");
    print("LocalId: $userId");
    print("IdToken: $idToken");
    print("RefreshToken: $refreshToken");
    print("ExpiresIn: $expiresIn");
    print("=============================================");

    notifyListeners();
  }

  Future<bool> storeUserData(Map data) async {
    await _preferences.setString(keyIdToken, data[keyIdToken]);
    await _preferences.setString(keyEmail, data[keyEmail]);
    await _preferences.setString(keyrRefreshToken, data[keyrRefreshToken]);
    await _preferences.setString(keyExpiresIn, data[keyExpiresIn]);
    await _preferences.setString(keyLocalId, data[keyLocalId]);

    fetchUserData();
    notifyListeners();
    return true;
  }

  Future<bool> clearData() async {
    await _preferences.clear();
    fetchUserData();

    notifyListeners();
    return true;
  }
}
