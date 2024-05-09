import '../pass/wallet_pass.dart';
import 'base_response.dart';

class WalletResponse extends URIDResponse {
  late final List<URIDPass> passes;

  WalletResponse({required this.passes, required super.status, required super.description, required super.createdAt});
}
