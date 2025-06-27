class AuthenticationResult {
  final int code;
  final String responseMessage;
  final String accessToken;

  AuthenticationResult({
    required this.code,
    required this.responseMessage,
    required this.accessToken
  });

  factory AuthenticationResult.fromJson(Map<String, dynamic> json) {
    return AuthenticationResult(
        code: json['meta']['code'] as int,
        responseMessage: json['meta']['message'] as String,
        accessToken: json['data'] != null ? json['data']['accessToken'] as String : '');
  }
}