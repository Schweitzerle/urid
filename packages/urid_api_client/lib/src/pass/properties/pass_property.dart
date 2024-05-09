import 'package:urid_api_client/src/pass/properties/localized_text_property.dart';

class PassProperty {
  late final String type;
  late final String title;
  late final String value;
  late final bool isPublic;
  late final LocalizedTextProperty label;

  PassProperty(
      {required this.type, required this.title, required this.value, required this.isPublic, required this.label});

  static PassProperty fromJsonMap(dynamic jsonMap) {
    return new PassProperty(
        type: jsonMap["class"],
        title: jsonMap["title"],
        value: jsonMap["value"],
        isPublic: jsonMap["public"] == "true" ? true : false,
        label: LocalizedTextProperty.fromJsonMap(jsonMap["label"]));
  }
}
