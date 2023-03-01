class Card {
  String imageUrl;
  String createdBy;

  Card({
    required this.imageUrl,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      "imageUrl": imageUrl,
      "createdBy": createdBy,
    };
  }
}
