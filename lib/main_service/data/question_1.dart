import 'dart:convert';

class Question1 {
  final int code;
  final String message;
  final QuestionData data;

  Question1({required this.code, required this.message, required this.data});

  factory Question1.fromJson(Map<String, dynamic> json) {
    return Question1(
      code: json['code'],
      message: json['message'],
      data: QuestionData.fromJson(json['data'] ?? {}), // Use {} as a default value when data is null
    );
  }
}

class QuestionData {
  final int id;
  final String title;
  final String content;
  final String date;
  final UserData writer;
  final SeniorData senior;
  final List<CommentData?> comments;

  QuestionData({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.writer,
    required this.senior,
    required this.comments,
  });

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      id: json['id'] ?? "id",
      title: json['title'] ?? "제목",
      content: json['content'] ?? "내용",
      date: json['date'] ?? "날짜",
      writer: UserData.fromJson(json['writer'] ?? {}),
      senior: SeniorData.fromJson(json['senior'] ?? {}),
      comments: List<CommentData?>.from(json['comments'].map(
            (comment) => comment != null ? CommentData.fromJson(comment) : CommentData(
          id: 0,
          content: "오류",
          date: "2024-01-01T00:00:00",
          writer: UserData(
            id: 0,
            profileImg: "오류",
            email: "오류",
            username: "오류",
            description: "오류",
            major: ["오류"],
          ),
        ),
      )),
    );
  }
}

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
      id: json['id'],
      profileImg: json['profile_img'] ?? "https://static-cdn.jtvnw.net/jtv_user_pictures/ecd6ee59-9f18-4eec-b8f3-63cd2a9127a5-profile_image-300x300.png",
      email: json['email'] ?? "imsi@gmail.com",
      username: json['username'] ?? "익명",
      description: json['description'] ?? "우주 최강 귀요미 ><",
      major: List<String>.from(json['major'] ?? {}),
    );
  }
}

class SeniorData {
  final int id;
  final String profileImg;
  final String email;
  final String username;
  final String description;
  final List<String> major;

  SeniorData({
    required this.id,
    required this.profileImg,
    required this.email,
    required this.username,
    required this.description,
    required this.major,
  });

  factory SeniorData.fromJson(Map<String, dynamic> json) {
    return SeniorData(
      id: json['id'] ?? 0,
      profileImg: json['profile_img'] ?? "https://static-cdn.jtvnw.net/jtv_user_pictures/ecd6ee59-9f18-4eec-b8f3-63cd2a9127a5-profile_image-300x300.png",
      email: json['email'] ?? "imsi@gmail.com",
      username: json['username'] ?? "익명",
      description: json['description'] ?? "우주 최강 귀요미 ><",
      major: List<String>.from(json['major']?? {}),
    );
  }
}

class CommentData {
  final int id;
  final String content;
  final String date;
  final UserData writer;

  CommentData({
    required this.id,
    required this.content,
    required this.date,
    required this.writer,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      id: json['id'],
      content: json['content'] ?? "",
      date: json['date'] ?? "",
      writer: UserData.fromJson(json['writer'] ?? {}),
    );
  }
}
