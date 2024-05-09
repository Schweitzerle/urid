class ContactProperty {
  late final String name;
  late final String mail;
  late final String phone;
  late final String street;
  late final String areaCode;
  late final String city;
  late final String country;

  ContactProperty(
      {required this.name,
      required this.mail,
      required this.phone,
      required this.street,
      required this.areaCode,
      required this.city,
      required this.country});

  static ContactProperty fromJsonMap(dynamic jsonMap) {
    return new ContactProperty(
        name: jsonMap["name"],
        mail: jsonMap["mail"],
        phone: jsonMap["phone"],
        street: jsonMap["street"],
        areaCode: (jsonMap["areacode"] as int).toString(),
        city: jsonMap["city"],
        country: jsonMap["country"]);
  }
}
