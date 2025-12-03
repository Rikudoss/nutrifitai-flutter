/// Authentication response model containing a JWT token.
class AuthenticationResponse {
  final String token;

  AuthenticationResponse({required this.token});

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    // Parse the token returned by the backend.
    return AuthenticationResponse(token: json['token'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'token': token};
  }
}
