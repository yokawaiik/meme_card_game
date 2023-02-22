class Situation {
  late final String id;
  late final String description;

  Situation({
    required this.id,
    required this.description,
  });

  Situation.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    description = data["description"];
  }
}
