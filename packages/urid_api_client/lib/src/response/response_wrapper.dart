import 'dart:convert';

import 'package:http/http.dart';
import 'package:urid_api_client/src/response/error_response.dart';
import 'package:urid_api_client/src/validation/ssl_cert_info.dart';

import '../dummyData/dummy_data.dart';
import '../error/urid_error.dart';
import '../pass/wallet_pass.dart';
import 'auth_response.dart';
import 'base_response.dart';
import 'wallet_response.dart';

enum ResponseType { auth, wallet, error }

AuthResponse createAuthResponse(URIDResponseWrapper wrapper) {
  String status = wrapper.body()["status"];
  String description = wrapper.body()["description"];
  DateTime createdAt = DateTime.parse(wrapper.body()["createdAt"]);
  String token = wrapper.payload()["token"];
  DateTime expires = DateTime.parse(wrapper.payload()["expires"]);
  return new AuthResponse(
      token: token, expires: expires, status: status, description: description, createdAt: createdAt);
}

WalletResponse createWalletResponse(URIDResponseWrapper wrapper) {
  String status = wrapper.body()["status"];
  String description = wrapper.body()["description"];
  DateTime createdAt = DateTime.parse(wrapper.body()["createdAt"]);
  List<URIDPass> passes = [];
  List<dynamic> rawPassSources = wrapper.payload()["passes"];
  rawPassSources.forEach((source) {
    passes.add(URIDPass.fromJsonMap(source, createdAt));
  });
  return new WalletResponse(
      passes: passes.reversed.toList(), status: status, description: description, createdAt: createdAt);
}

ErrorResponse createErrorResponse(URIDResponseWrapper wrapper) {
  String status = "API Error";
  String description = "An error occured while the client tried to request data from the server.";
  DateTime createdAt = DateTime.now();
  URIDError error = wrapper.error();
  return new ErrorResponse(error: error, status: status, description: description, createdAt: createdAt);
}

class URIDResponseWrapper {
  late final Response response;
  late final SSLCertInformation sslCertInformation;

  URIDResponseWrapper({required this.response, required this.sslCertInformation});

  bool ok() {
    return this.response.statusCode == 200;
  }

  dynamic body() {
    var jsonBody = json.decode(response.body);
    return jsonBody;
  }

  dynamic payload() {
    return this.body()["data"];
  }

  URIDError error() {
    if (this.ok()) {
      throw Error();
    }
    String type = this.body()["type"];
    String description = this.body()["description"];
    String advice = this.body()["advice"];
    switch (type) {
      case "SessionNotFound":
        return new SessionNotFoundError(description: description, advice: advice);
      case "SessionNotAvailable":
        return new SessionNotFoundError(description: description, advice: advice);
      case "SessionTimeoutError":
        return new SessionNotFoundError(description: description, advice: advice);
      case "LDAPUserCredentialsMissing":
        return new UserCredentialsMissing(description: description, advice: advice);
      case "LDAPCredentialsInvalid":
        return new UserCredentialsInvalid(description: description, advice: advice);
    }
    return URIDError(description: description, advice: advice);
  }

  URIDResponse parse(ResponseType type) {
    switch (type) {
      case ResponseType.auth:
        return createAuthResponse(this);
      case ResponseType.wallet:
        return createWalletResponse(this);
      case ResponseType.error:
        return createErrorResponse(this);
      default:
        throw Error();
    }
  }
}
