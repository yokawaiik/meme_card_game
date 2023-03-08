enum KindOfException { unknown }

class GameException implements Exception {
  String? title;
  String msg;

  KindOfException kindOfException;

  GameException(
    this.msg, [
    this.title,
    this.kindOfException = KindOfException.unknown,
  ]);

  @override
  String toString() {
    late String textError;
    if (title == null) {
      textError =
          "GameException: $msg, with kind of exception $kindOfException.";
    } else {
      textError =
          "GameException $title: $msg. Kind of exception $kindOfException.";
    }

    return textError;
  }
}
