
class BaseUserData{
  final int code;
  final String message;
  final UserDataModel data;

  BaseUserData({
    required this.code,
    required this.message,
    required this.data
  });

  factory BaseUserData.fromJson(Map<String, dynamic> json){
    return BaseUserData(
      code: json['code'],
      message: json['message'],
      data: UserDataModel.fromJson(json['data']) ,
    );
  }
}

class UserDataModel {
  final int id;
  final String? profile_img;
  final String email;
  final String username;
  final String? description;
  final List<String> major;

  const UserDataModel({
    required this.id,
    required this.profile_img,
    required this.email,
    required this.username,
    required this.description,
    required this.major
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json){
    return UserDataModel(
      id : json['id'],
      profile_img: json['profile_img'],
      email: json['email'],
      username: json['username'],
      description: json['description'],
      major: List<String>.from(json['major']),
    );
  }
}
