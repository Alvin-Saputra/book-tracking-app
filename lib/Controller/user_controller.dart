import 'package:book_tracker_app/Model/Local/user.dart';
import 'package:book_tracker_app/Model/remote/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/Local/book.dart';
import '../Model/Local/book_dao.dart';

class UserController with ChangeNotifier {
  late User _user;
  User get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
    notifyListeners();
  }

  Future<void> storeUserData(Map data) async {
    await _preferences.setString(keyIdToken, data[keyIdToken]);
    await _preferences.setString(keyEmail, data[keyEmail]);
    await _preferences.setString(keyrRefreshToken, data[keyrRefreshToken]);
    await _preferences.setString(keyExpiresIn, data[keyExpiresIn]);
    await _preferences.setString(keyLocalId, data[keyLocalId]);

    fetchUserData();
    notifyListeners();
  }

  Future<bool> clearData() async {
    bool isSuccess = await _preferences.clear();
    if (isSuccess) {
      fetchUserData();
      notifyListeners();
      return isSuccess;
    } else {
      return false;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> dataToSend = {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      };

      final responseData = await loginService(dataToSend);
      await storeUserData(responseData);

      _isLoading = false;
      notifyListeners();
      return true; // <-- Kembalikan true saat sukses
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> registrationUser(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> dataToSend = {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      };

      final responseData = await registrationService(dataToSend);
      if (responseData.isNotEmpty) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
