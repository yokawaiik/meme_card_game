class AvatarGeneratorException implements Exception {
  String title;
  String msg;

  AvatarGeneratorException(
    this.title,
    this.msg,
  );

  @override
  String toString() => "$title: $msg.";
}
