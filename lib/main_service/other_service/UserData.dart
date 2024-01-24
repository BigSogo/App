class UserData {
  final int id;
  final String profileImg;
  final String email;
  final String username;
  final String description;
  final List<String> major;

  UserData({
    required this.id,
    required this.profileImg,
    required this.email,
    required this.username,
    required this.description,
    required this.major,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? "id가 없음",
      profileImg: json['profile_img'] ?? "https://image.fmkorea.com/files/attach/new3/20230114/494354581/1107431219/5400131409/0aebe75d4c0c3c3abfc46310f834376a.png",
      email: json['email'] ?? "email이 비었습니다.",
      username: json['username'] ?? "ㅇㅇ",
      description: json['description'] ?? "우주 최강 귀요미 ><",
      major: List<String>.from(json['major'].map((major) => major as String)),
    );
  }
}
