import 'dart:convert';

class Writer {
  int id;
  String profileImg;
  String email;
  String username;
  String description;
  List<String> major;
  Profile profile;

  Writer({
    required this.id,
    required this.profileImg,
    required this.email,
    required this.username,
    required this.description,
    required this.major,
    required this.profile,
  });

  factory Writer.fromJson(Map<String, dynamic> json) {
    return Writer(
      id: json['id'],
      profileImg: json['profile_img'] ?? 'https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfODMg/MDAxNjA0MjI4ODc1MDgz.gQ3xcHrLXaZyxcFAoEcdB7tJWuRs7fKgOxQwPvsTsrUg.0OBtKHq2r3smX5guFQtnT7EDwjzksz5Js0wCV4zjfpcg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%EB%B3%B4%EB%9D%BC.jpg?type=w400',
      email: json['email'] ?? '값이 없습니다.',
      username: json['username'] ?? '익명',
      description: json['description'] ?? '우주 최강 귀요미 ><',
      major: List<String>.from(json['major'] ?? []),
      profile: Profile.fromJson(json['profile'] ?? {
        'id': 0,
        'subject': '주제 없음',
        'content': '내용 없음',
        'portfolio_url': 'https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfODMg/MDAxNjA0MjI4ODc1MDgz.gQ3xcHrLXaZyxcFAoEcdB7tJWuRs7fKgOxQwPvsTsrUg.0OBtKHq2r3smX5guFQtnT7EDwjzksz5Js0wCV4zjfpcg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%EB%B3%B4%EB%9D%BC.jpg?type=w400',
      }),
    );
  }
}

class Profile {
  int id;
  String subject;
  String content;
  String portfolioUrl;

  Profile({
    required this.id,
    required this.subject,
    required this.content,
    required this.portfolioUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      subject: json['subject'],
      content: json['content'],
      portfolioUrl: json['portfolio_url'],
    );
  }
}

class Senior {
  int id;
  String profileImg;
  String email;
  String username;
  String description;
  List<String> major;
  Profile profile;

  Senior({
    required this.id,
    required this.profileImg,
    required this.email,
    required this.username,
    required this.description,
    required this.major,
    required this.profile,
  });

  factory Senior.fromJson(Map<String, dynamic> json) {
    return Senior(
      id: json['id'] ?? 0,
      profileImg: json['profile_img'] ?? '값이 없음',
      email: json['email'] ?? '값이 없습니다.',
      username: json['username'] ?? 'ㅇㅇ',
      description: json['description'] ?? '우주 최강 귀요미 ><',
      major: List<String>.from(json['major'] ?? []),
      profile: Profile.fromJson(json['profile'] ?? {
        'id': 0,
        'subject': '기본 주제',
        'content': '기본 내용',
        'portfolio_url': '기본 포트폴리오 URL',
      }),
    );
  }
}

class Data {
  int id;
  String title;
  String content;
  DateTime date;
  Writer writer;
  Senior senior;

  Data({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.writer,
    required this.senior,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] ?? 0,
      title: json['title'] ?? '제목 없음',
      content: json['content'] ?? '글의 상세 내용이 존재하지 않습니다.',
      date: DateTime.parse(json['date'] ?? '2022-01-18T00:00:00Z'),
      writer: Writer.fromJson(json['writer'] ?? {}),
      senior: Senior.fromJson(json['senior'] ?? {}),
    );
  }
}

class MyModel {
  int code;
  String message;
  List<Data> data;

  MyModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory MyModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<Data> data = dataList.map((e) => Data.fromJson(e)).toList();

    return MyModel(
      code: json['code'],
      message: json['message'],
      data: data,
    );
  }
}

void main() {
  String jsonString = '''
    // Your JSON string here
  ''';

  Map<String, dynamic> jsonMap = json.decode(jsonString);

  MyModel myModel = MyModel.fromJson(jsonMap);

  // Now you can access the parsed data using myModel object
  print(myModel.code);
  print(myModel.message);
  print(myModel.data[0].title);
  print(myModel.data[0].writer.username);
  print(myModel.data[0].senior.username);
}