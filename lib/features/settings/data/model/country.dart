class Country {
  late String name;
  late String code;

  Country({required this.name, required this.code});

  Country.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        code = json['code'];

  toMap() => ({"name": name, "code": code});
}