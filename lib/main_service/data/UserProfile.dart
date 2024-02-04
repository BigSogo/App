
class BaseProfileData{
  final int code;
  final String message;
  final UserProfile data;

  BaseProfileData({
    required this.code,
    required this.message,
    required this.data
  });

  factory BaseProfileData.fromJson(Map<String, dynamic> json){
    return BaseProfileData(
        code: json['code'],
        message: json['message'],
        data: UserProfile.fromJson(json['data'])
    );
  }
}

class UserProfile{
  final UserDataJS user;
  final List<ProfileProfilesData> profiles;

  UserProfile({
    required this.user,
    required this.profiles
  });

  factory UserProfile.fromJson(Map<String, dynamic> json){
    return UserProfile(
        user: UserDataJS.fromJson(json['user']),
        profiles: List<ProfileProfilesData>.from(json['profiles'])
    );
  }
}

class UserDataJS{
  final int id;
  final String profile_img;
  final String email;
  final String username;
  final String? description;
  final List<String> major;

  UserDataJS({
    required this.id,
    required this.profile_img,
    required this.email,
    required this.username,
    required this.description,
    required this.major
  });

  factory UserDataJS.fromJson(Map<String, dynamic> json){
    return UserDataJS(
        id: json['id'] ?? 0,
        profile_img: json['profile_img'] ?? "https://static.wikia.nocookie.net/p__/images/8/8a/Shiro_.png/revision/latest?cb=20210703182454&path-prefix=protagonist",
        email: json['email'] ?? "",
        username: json['username'] ?? "",
        description: json['description'] ?? "설명이 없엉요",
        major: List<String>.from(json['major']),
    );
  }
}

class ProfileProfilesData{
  final int id;
  final String subject;
  final String content;
  final String portfolio_url;

  ProfileProfilesData({
    required this.id,
    required this.subject,
    required this.content,
    required this.portfolio_url
  });

  factory ProfileProfilesData.fromJson(Map<String, dynamic> json){
    return ProfileProfilesData(
        id: json['id'],
        subject: json['subject'],
        content: json['content'],
        portfolio_url: json['portfolio_url']
    );
  }
}