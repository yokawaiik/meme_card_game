enum KindOfException {
  unknown,
}

class RealtimeException implements Exception {
  String? title;
  String msg;

  KindOfException kindOfException;

  RealtimeException(
    this.title,
    this.msg, [
    this.kindOfException = KindOfException.unknown,
  ]);

  @override
  String toString() => "$title: $msg, with kind of exception $kindOfException";
}
