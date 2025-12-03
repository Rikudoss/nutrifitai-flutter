import 'package:dio/dio.dart';

import '../models/auth_request.dart';
import '../models/auth_response.dart';
import 'api_client.dart';

/// Handles authentication calls to the backend.
class AuthService {
  final ApiClient apiClient;

  AuthService(this.apiClient);

  /// Register a new user and return the issued token.
  Future<AuthenticationResponse> register(RegisterRequest request) async {
    final response = await apiClient.client.post(
      '/api/auth/register',
      data: request.toJson(), // Body sent to the backend
    );
    return AuthenticationResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Log in an existing user and retrieve the token.
  Future<AuthenticationResponse> login(LoginRequest request) async {
    final response = await apiClient.client.post(
      '/api/auth/login',
      data: request.toJson(), // Body sent to the backend
    );
    return AuthenticationResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
