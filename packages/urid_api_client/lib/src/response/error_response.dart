import '../../urid_api_client.dart';
import 'base_response.dart';

class ErrorResponse extends URIDResponse {
  late final URIDError error;

  ErrorResponse({required this.error, required super.status, required super.description, required super.createdAt});
}
