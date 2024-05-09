import 'base_response.dart';

class AuthResponse extends URIDResponse {
  late final String token;
  late final DateTime expires;

  AuthResponse(
      {required this.token,
      required this.expires,
      required super.status,
      required super.description,
      required super.createdAt});
}
