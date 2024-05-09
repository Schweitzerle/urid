import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:urid_api_client/src/response/base_response.dart';
import 'package:urid_api_client/src/response/error_response.dart';
import 'package:urid_api_client/src/validation/ssl_cert_info.dart';

import 'error/urid_error.dart';
import 'response/auth_response.dart';
import 'response/response_wrapper.dart';
import 'response/wallet_response.dart';
import 'dummyData//dummy_data.dart';

enum ClientState { unauthenticated, authenticated }

class URIDClient {
  late final String _url;
  late ClientState _state;
  late String _token;

  URIDClient({url = "https://id.uni-regensburg.de/api/v1", token = ""}) {
    this._url = url;
    this._state = ClientState.unauthenticated;
    this._token = token;
  }

  Map<String, dynamic> dummyData = DummyData.getErikaMusterfrau();

  Future<SSLCertInformation> _validateServerIntegrity() async {
    SSLCertInformation sslInformation = await SSLCertInformation.fromURI(Uri.parse(this._url));
    if (!sslInformation.isValid(Uri.parse(this._url).host)) {
      throw CouldNotValidateServerIntegrity();
    }
    return sslInformation;
  }

  Future<URIDResponse> authenticate({required String username, required String password}) async {
    SSLCertInformation sslInformation = await _validateServerIntegrity();
    Response response = await http.post(Uri.parse("${this._url}/auth"),
        headers: {"Content-Type": "application/json"}, body: jsonEncode({"username": username, "password": password}));
    URIDResponseWrapper responseWrapper =
        new URIDResponseWrapper(response: response, sslCertInformation: sslInformation);
    if (responseWrapper.body() != null /*.ok()*/) {
      AuthResponse response = responseWrapper.parse(ResponseType.auth) as AuthResponse;
      this._state = ClientState.authenticated;
      this._token = response.token;
      return response;
    } else {
      return responseWrapper.parse(ResponseType.error) as ErrorResponse;
    }
  }

  Future<URIDResponse> fetchPasses() async {
    if (this._state == ClientState.unauthenticated) {
      throw ClientNotAuthenticated();
    }

    String dummyJsonResponse = '''
    ${DummyData.getErikaMusterfrau()}
  ''';

    // Parse the dummy JSON response
    dynamic parsedResponse = json.decode(dummyJsonResponse);

    // Create a fake HTTP response with your dummy data
    Response response = Response(json.encode(parsedResponse), 200);

    print('Responge ${response.toString()}');
    SSLCertInformation sslInformation = await _validateServerIntegrity();
    /*
    Response response = await http
        .get(Uri.parse("${this._url}/wallet?token=${this._token}"), headers: {"Content-Type": "application/json"});
    */

    URIDResponseWrapper responseWrapper =
        new URIDResponseWrapper(response: response, sslCertInformation: sslInformation);
    if (responseWrapper.ok()) {
      return responseWrapper.parse(ResponseType.wallet) as WalletResponse;
    } else {
      return responseWrapper.parse(ResponseType.error) as ErrorResponse;
    }
  }

  /*Future<URIDResponse> fetchPasses() async {
    if (this._state == ClientState.unauthenticated) {
      throw ClientNotAuthenticated();
    }
    SSLCertInformation sslInformation = await _validateServerIntegrity();
    Response response = await http
        .get(Uri.parse("${this._url}/wallet?token=${this._token}"), headers: {"Content-Type": "application/json"});
    print(': ${response.headers}');
    URIDResponseWrapper responseWrapper =
    new URIDResponseWrapper(response: response, sslCertInformation: sslInformation);
    if (responseWrapper.ok()) {
      return responseWrapper.parse(ResponseType.wallet) as WalletResponse;
    } else {
      return responseWrapper.parse(ResponseType.error) as ErrorResponse;
    }
  }*/
}
