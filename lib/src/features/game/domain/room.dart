import 'enums/presence_object_type.dart';

class Room {
  late String id;
  late String title;
  late String createdBy;
  late bool isClosed;

  Room({
    required this.id,
    required this.title,
    required this.createdBy,
    this.isClosed = false,
  });

  Room.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    createdBy = data['created_by'];
    createdBy = data['is_closed'] ?? false;
  }

  Map<String, dynamic> toMap() {
    return {
      'object_type': PresenceObjectType.room,
      "id": id,
      "title": title,
      "created_by": createdBy,
      "is_closed": isClosed,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
