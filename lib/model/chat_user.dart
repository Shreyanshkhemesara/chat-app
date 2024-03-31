class ChatUser {
  ChatUser({
    required this.image,
    required this.name,
    required this.about,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.email,
    required this.pushToken,
    required this.username,
    required this.id,
  });
  late final String image;
  late final String name;
  late final String about;
  late final String createdAt;
  late final bool isOnline;
  late final String lastActive;
  late final String email;
  late final String pushToken;
  late String id;
  late final String username;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? ' ';
    name = json['name'] ?? ' ';
    about = json['about'] ?? ' ';
    id = json['id'] ?? '';
    createdAt = json['created_at'] ?? ' ';
    isOnline = json['is_online'] ?? ' ';
    lastActive = json['last_active'] ?? ' ';
    email = json['email'] ?? ' ';
    pushToken = json['push_token'] ?? ' ';
    username = json['username'] ?? ' ';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['about'] = about;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['id'] = id;
    data['push_token'] = pushToken;
    data['username'] = username;
    return data;
  }
}
