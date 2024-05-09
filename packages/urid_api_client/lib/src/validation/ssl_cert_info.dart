import 'dart:io';

class SSLCertInformation {
  final String issuer;
  final String holder;
  final String url;
  final DateTime validSince;
  final DateTime validUntil;

  SSLCertInformation(this.issuer, this.holder, this.url, this.validSince, this.validUntil);

  bool isValid(String hostname) {
    if (hostname != this.url) {
      return false;
    }
    if (validSince.isAfter(DateTime.now())) {
      return false;
    }
    if (validUntil.isBefore(DateTime.now())) {
      return false;
    }
    return true;
  }

  static Future<SSLCertInformation> fromURI(Uri target) async {
    try {
      String hostname = target.host;
      SecureSocket socket = await SecureSocket.connect(hostname, 443);
      String? providerCountry = RegExp(r'(?<=C=)([^/]+)').firstMatch(socket.peerCertificate!.issuer)?[0];
      String? providerOrganization = RegExp(r'(?<=O=)([^/]+)').firstMatch(socket.peerCertificate!.issuer)?[0];
      String? providerName = RegExp(r'(?<=CN=)([^/]+)').firstMatch(socket.peerCertificate!.issuer)?[0];
      String? holderCountry = RegExp(r'(?<=C=)([^/]+)').firstMatch(socket.peerCertificate!.subject)?[0];
      String? holderState = RegExp(r'(?<=ST=)([^/]+)').firstMatch(socket.peerCertificate!.subject)?[0];
      // TODO Check why normal utf8 conversions (for Umlaute) do not work
      String? holderOrganization =
          RegExp(r'(?<=O=)([^/]+)').firstMatch(socket.peerCertificate!.subject)?[0]!.replaceAll("\\xC3\\xA4", "ä");
      String? url = RegExp(r'(?<=CN=)([^/]+)').firstMatch(socket.peerCertificate!.subject)?[0];
      return SSLCertInformation(
          "$providerOrganization ($providerName), $providerCountry",
          "$holderOrganization, $holderCountry ($holderState)",
          "$url",
          socket.peerCertificate!.startValidity,
          socket.peerCertificate!.endValidity);
    } catch (error) {
      return SSLCertInformationInvalid();
    }
  }
}

class SSLCertInformationInvalid extends SSLCertInformation {
  SSLCertInformationInvalid() : super("", "", "", DateTime.now(), DateTime.now());

  bool isValid(String hostname) {
    return false;
  }
}
