class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.userId,
  });

  final String accessToken;
  final int userId;
}
