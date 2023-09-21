class Currency {
  String name;
  String shortName;

  Currency({
    required this.name,
    required this.shortName,
  });

  factory Currency.fromJson(Map<String, dynamic> json) =>
      Currency(name: json["name"], shortName: json["short_name"]);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['short_name'] = shortName;
    return map;
  }
}
