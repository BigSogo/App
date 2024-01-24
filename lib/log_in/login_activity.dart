import 'package:bigsogo/BaseData.dart';
import 'package:bigsogo/log_in/regist_activity.dart';
import 'package:bigsogo/main_service/bottom_service/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';


class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn>{
  final logger = Logger();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? emailErrorText;
  String? passwordErrorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child:
        Padding(
            padding:const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
                children: <Widget> [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 125,),
                      const Text('로그인', textAlign: TextAlign.start, style: TextStyle(fontSize: 32, fontFamily: "Pretendard",fontWeight:FontWeight.bold)),
                      const SizedBox(height: 45,),
                      TextField(
                        controller: emailController,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        decoration:const InputDecoration(hintText: "example@sogo.com",

                            hintStyle:TextStyle(color:Color(0xFFB9B9B9),),
                            labelText: "이메일",
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF4B66DC))
                            ),
                            focusColor: Color(0xFF4B66DC)
                        ),
                        cursorColor: Color(0xFF4B66DC),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => FocusScope.of(context).unfocus(),
                        obscureText: true,

                        decoration:  InputDecoration(
                            hintText: "••••••••",
                            hintStyle:TextStyle(color:Color(0xFFB9B9B9)),
                            labelText: "비밀번호",
                            errorText: passwordErrorText,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF4B66DC))
                            ),
                            focusColor: Color(0xFF4B66DC)
                        ),
                        cursorColor: Color(0xFF4B66DC),
                          onChanged: (value) {
                            setState(() {
                              if(value.isEmpty){
                                passwordErrorText = "값이 비어있습니다.";
                              }
                            });
                          }
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 200),),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => BarControl()),
                            // );
                            login();
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0), // 각지게 만들기 위한 값
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF4B66DC)),
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 16.0), // 좌우 16만큼의 패딩
                            ),
                            fixedSize: MaterialStateProperty.all<Size>(Size.fromHeight(50)), // 높이는 고정, 가로는 디바이스에 맞추어 유동적으로
                          ),
                          child: const Text(
                            "로그인", style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Pretendard",
                            fontSize: 13,
                          ),),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          const Text("계정이 없으신가요?",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey
                            ),),
                          TextButton(
                            onPressed: () {
                              // TextButton 클릭 시 SecondScreen으로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Regist()),
                              );
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size(50, 50),
                            ),
                            child: const Text(
                              "회원가입",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF4B66DC),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ]
            )),
      ),

    );
  }

  @override void initState() {
    super.initState();
  }

  static final storage = FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
  dynamic userInfo = ''; // storage에 있는 유저 정보를 저장

  void login() async {
    final url = Uri.parse("http://10.1.8.72:8080/user/login");
    final Map<String, dynamic> body  = {
      "email": "${emailController.value.text}",
      "password": "${passwordController.value.text}"
    };
    final response = await http.post(url, body:json.encode(body), headers: {'Content-Type': 'application/json'});
    logger.d("statusCode : ${response.statusCode}");
    logger.d("body : ${response.body}");
    if (response.statusCode == 200){
      var result = BaseData<String>.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      logger.d("body : ${result.message}");
      await storage.write(
        key: 'login',
        value: result.data,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BarControl()),
      );
    }
    else{
      logger.e("message : ${response.body}");
    }
  }
}


