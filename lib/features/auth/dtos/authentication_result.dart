class AuthenticationResult {
  // final int code;
  // final String responseMessage;
  final String accessToken;

  AuthenticationResult({
    // required this.code,
    // required this.responseMessage,
    required this.accessToken
  });

  factory AuthenticationResult.fromJson(Map<String, dynamic> json) {
    return AuthenticationResult(
        // code: json['code'] as int,
        // responseMessage: json['response_message'] as String,
        accessToken: json['accessToken'] as String);
  }
}