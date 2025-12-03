import 'package:shared_preferences/shared_preferences.dart';

/// A small helper to persist JWT tokens between sessions.
/// SharedPreferences is used to keep the implementation simple and
/// available across platforms.
class TokenStorage {
  static const _tokenKey = 'auth_token';

  /// Stores the JWT locally after login/registration.
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Retrieves the token so that it can be added to request headers.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Clears the token when the user logs out or the session expires.
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
