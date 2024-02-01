import 'dart:convert';

import 'package:bigsogo/main_service/data/publickQ_data.dart';

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
      id: json['id'] ?? 0,
      profileImg: json['profile_img'] ?? "https://ifh.cc/g/62r3y3.jpg",
      email: json['email'] ?? "example@example.com",
      username: json['username'] ?? "이성은",
      description: json['description'] ?? "설명",
      major: List<String>.from(json['major'] ?? ["#Android"]),
    );
  }
}

class RandomData {
  int id;
  String profileImg;
  String email;
  String username;
  String description;
  List<String> major;

  RandomData({
    required this.id,
    required this.profileImg,
    required this.email,
    required this.username,
    required this.description,
    required this.major,
  });

  factory RandomData.fromJson(Map<String, dynamic> json) {
    return RandomData(
      id: json['id'] ?? 0,
      profileImg: json['profile_img'] ?? 'https://i.namu.wiki/i/PLPvWNd-tprjCCwKyBZ9P3gjIprUGXoFjFo5gYIYYcGwGCdKzrrE2wTcxne2I3NitZdhIIJ6CFkg28mTj4b0wQ.webp',
      email: json['email'] ?? '이메일이 없습니다.',
      username: json['username'] ?? '이름이 없습니다.',
      description: json['description'] ?? '설명이 없습니다.',
      major: List<String>.from(json['major'] ?? ["전공 없음"])
    );
  }
}

class RandomModel {
  int code;
  String message;
  List<RandomData> data;

  RandomModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory RandomModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<RandomData> randomData = dataList.map((e) => RandomData.fromJson(e)).toList();

    return RandomModel(
      code: json['code'],
      message: json['message'],
      data: randomData,
    );
  }
}
