import 'package:flutter/material.dart';

class SearchResult {
  final int code;
  final String message;
  final List<Question> data;

  SearchResult({
    required this.code,
    required this.message,
    required this.data,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      code: json['code'],
      message: json['message'],
      data: (json['data'] as List<dynamic>).map((item) => Question.fromJson(item)).toList(),
    );
  }
}

class Question {
  final int id;
  final String title;
  final String date;
  final Writer writer;
  final dynamic senior;

  Question({
    required this.id,
    required this.title,
    required this.date,
    required this.writer,
    required this.senior,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      writer: Writer.fromJson(json['writer']),
      senior: json['senior'],
    );
  }
}

class Writer {
  final int id;
  final String email;
  final String username;
  final String? description;
  final List<String> major;

  Writer({
    required this.id,
    required this.email,
    required this.username,
    required this.description,
    required this.major,
  });

  factory Writer.fromJson(Map<String, dynamic> json) {
    return Writer(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      description: json['description'],
      major: (json['major'] as List<dynamic>).map((item) => item.toString()).toList(),
    );
  }
}
