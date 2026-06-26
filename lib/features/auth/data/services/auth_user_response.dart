class AuthUserResponse {
  const AuthUserResponse({
    required this.id,
  });

  factory AuthUserResponse.fromJson(Map<String, dynamic> json) {
    return AuthUserResponse(id: json['id'] as int? ?? 0);
  }

  final int id;
}
