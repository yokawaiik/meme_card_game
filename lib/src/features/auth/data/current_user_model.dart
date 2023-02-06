class CurrentUser {
  late String id;
  late String login;
  late String? imageUrl;
  late String? email;

  CurrentUser({
    required this.id,
    required this.login,
    required this.email,
    required this.imageUrl,
  });

  CurrentUser.fromMap(Map<String, dynamic> userRaw) {
    id = userRaw['id'];
    login = userRaw['login'];
    email = userRaw['email'];
    imageUrl = userRaw['imageUrl'];
  }
}
