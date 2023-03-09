class Situation {
  String description;
  String createdBy;

  Situation({
    required this.description,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "createdBy": createdBy,
    };
  }
}
