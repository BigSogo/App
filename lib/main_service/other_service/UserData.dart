class UserData {
  final int id;
  final String email;
  final String username;
  final String description;
  final List<String> major;

  UserData({
    required this.id,
    required this.email,
    required this.username,
    required this.description,
    required this.major,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      description: json['description'] as String,
      major: List<String>.from(json['major'].map((major) => major as String)),
    );
  }
}
