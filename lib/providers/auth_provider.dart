import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../core/token_storage.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';
import '../services/auth_service.dart';

/// Provider that holds authentication state and token.
/// Keeps token in memory and also persists it through [TokenStorage].
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final TokenStorage _tokenStorage;

  String? _token;
  bool _isLoading = false;
  bool _isInitialized = false;

  AuthProvider(this._authService, this._tokenStorage);

  String? get token => _token;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  /// Try to load a previously stored token on app start.
  Future<void> loadToken() async {
    _token = await _tokenStorage.getToken();
    _isInitialized = true;
    notifyListeners();
  }

  /// Register and save the token.
  Future<void> register(RegisterRequest request) async {
    _isLoading = true;
    notifyListeners();
    try {
      final AuthenticationResponse response = await _authService.register(request);
      await _saveToken(response.token);
    } on DioException catch (e) {
      throw e.response?.data?['message'] ?? 'Registration failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login and save the token.
  Future<void> login(LoginRequest request) async {
    _isLoading = true;
    notifyListeners();
    try {
      final AuthenticationResponse response = await _authService.login(request);
      await _saveToken(response.token);
    } on DioException catch (e) {
      throw e.response?.data?['message'] ?? 'Login failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear token when logging out or session expires.
  Future<void> logout() async {
    _token = null;
    await _tokenStorage.clearToken();
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    _token = token;
    await _tokenStorage.saveToken(token);
    notifyListeners();
  }
}
