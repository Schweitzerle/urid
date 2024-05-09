class LocalizedTextProperty {
  late final Map<String, String> values;

  LocalizedTextProperty({required this.values});

  String? get({lang = "de"}) {
    return this.values[lang];
  }

  static LocalizedTextProperty fromJsonMap(dynamic jsonMap, {String value = ""}) {
    if (value == "") {
      return new LocalizedTextProperty(values: {
        "de": jsonMap["de"],
        "en": jsonMap["en"],
      });
    }
    return new LocalizedTextProperty(values: {
      "de": jsonMap["de"][value],
      "en": jsonMap["en"][value],
    });
  }
}
