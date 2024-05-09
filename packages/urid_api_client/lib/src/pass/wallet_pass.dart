import 'package:urid_api_client/src/pass/properties/contact_property.dart';
import 'package:urid_api_client/src/pass/properties/localized_text_property.dart';
import 'package:urid_api_client/src/pass/properties/pass_property.dart';
import 'package:urid_api_client/src/validation/ssl_cert_info.dart';

class URIDPass {
  late final String type;
  late final String id;
  late final LocalizedTextProperty title;
  late final LocalizedTextProperty description;
  late final String providerID;
  late final String providerLogo;
  late final LocalizedTextProperty providerFacility;
  late final LocalizedTextProperty providerDepartment;
  late final ContactProperty legalContact;
  late final ContactProperty supportContact;
  late final Map<String, PassProperty> properties;
  late final bool isValid;
  late final LocalizedTextProperty isValidDescription;
  late final DateTime createdAt;
  late final SSLCertInformation? sslInformation;

  URIDPass(
      {required this.type,
      required this.id,
      required this.title,
      required this.description,
      required this.providerID,
      required this.providerLogo,
      required this.providerFacility,
      required this.providerDepartment,
      required this.legalContact,
      required this.supportContact,
      required this.properties,
      required this.isValid,
      required this.isValidDescription,
      required this.createdAt,
      this.sslInformation});

  bool hasProperty(String key) {
    PassProperty? property = this.properties[key];
    if (property != null) {
      return true;
    }
    return false;
  }

  PassProperty? getProperty(String key) {
    PassProperty? property = this.properties[key];
    return property;
  }

  static URIDPass empty() {
    return new URIDPass(
        type: "",
        id: "",
        title: new LocalizedTextProperty(values: {}),
        description: new LocalizedTextProperty(values: {}),
        providerID: "",
        providerLogo: "",
        providerFacility: new LocalizedTextProperty(values: {}),
        providerDepartment: new LocalizedTextProperty(values: {}),
        legalContact:
            new ContactProperty(name: "", mail: "", phone: "", street: "", areaCode: "", city: "", country: ""),
        supportContact:
            new ContactProperty(name: "", mail: "", phone: "", street: "", areaCode: "", city: "", country: ""),
        properties: new Map(),
        isValid: false,
        isValidDescription: new LocalizedTextProperty(values: {}),
        createdAt: new DateTime.now(),
        sslInformation: SSLCertInformationInvalid());
  }

  static URIDPass fromJsonMap(dynamic jsonMap, DateTime createdAt) {
    String type = jsonMap["class"];
    String id = jsonMap["id"];
    LocalizedTextProperty title = LocalizedTextProperty.fromJsonMap(jsonMap["title"]);
    LocalizedTextProperty description = LocalizedTextProperty.fromJsonMap(jsonMap["description"]);
    String providerID = jsonMap["provider"]["id"];
    String providerLogo = jsonMap["provider"]["logo"];
    LocalizedTextProperty providerFacility =
        LocalizedTextProperty.fromJsonMap(jsonMap["provider"]["description"], value: "facility");
    LocalizedTextProperty providerDepartment =
        LocalizedTextProperty.fromJsonMap(jsonMap["provider"]["description"], value: "department");
    ContactProperty legalContact = ContactProperty.fromJsonMap(jsonMap["provider"]["contact"]["legal"]);
    ContactProperty supportContact = ContactProperty.fromJsonMap(jsonMap["provider"]["contact"]["support"]);
    bool isValid = jsonMap["validation"]["isValid"];
    LocalizedTextProperty isValidDescription = LocalizedTextProperty.fromJsonMap(jsonMap["validation"]["description"]);
    Map<String, PassProperty> properties = new Map();
    List<dynamic> rawPropertiesSources = jsonMap["properties"];
    rawPropertiesSources.forEach((source) {
      properties[source["title"]] = PassProperty.fromJsonMap(source);
    });
    return new URIDPass(
        type: type,
        id: id,
        title: title,
        description: description,
        providerID: providerID,
        providerLogo: providerLogo,
        providerFacility: providerFacility,
        providerDepartment: providerDepartment,
        legalContact: legalContact,
        supportContact: supportContact,
        properties: properties,
        isValid: isValid,
        isValidDescription: isValidDescription,
        createdAt: createdAt,
    );
  }
}
