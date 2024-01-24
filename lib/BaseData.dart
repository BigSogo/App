
class BaseData<T>{
  final int code;
  final String message;
  final T data;

  BaseData({
    required this.code,
    required this.message,
    required this.data
  });

  factory BaseData.fromJson(Map<String, dynamic> json){
    return BaseData(
      code: json['code'],
      message: json['message'],
      data: json['data'] ,
    );
  }
}