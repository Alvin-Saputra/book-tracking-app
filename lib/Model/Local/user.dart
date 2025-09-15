class User {
  String email = '';
  String userId = '';
  String idToken = '';
  String refreshToken = '';
  String expiresIn = '';

  User({
    required this.email,
    required this.userId,
    required this.idToken,
    required this.refreshToken,
    required this.expiresIn
  });
}
