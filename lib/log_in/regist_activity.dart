import 'dart:async';
import 'dart:convert';
// import 'dart:ffi';
import 'dart:ui' show Size;

import 'package:bigsogo/log_in/login_activity.dart';
import 'package:bigsogo/log_in/major_activity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Regist extends StatefulWidget {
  @override
  _RegistState createState() => _RegistState();
}

class _RegistState extends State<Regist> {
  // int countdown = 300;
  // late Timer _timer;
  //
  // @override
  // void initState() {
  //   super.initState();
  // }

  // void startTimer(){
  //   const oneSecond = Duration(seconds: 1);
  //   _timer =  Timer.periodic(oneSecond, (Timer timer) {
  //     if (countdown == 0) {
  //       timer.cancel();
  //     } else {
  //       setState(() {
  //         countdown--;
  //       });
  //     }
  //   });
  // }

  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _PasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _verificationCodeController = TextEditingController();

  String textFieldValue = "";
  String? _errorText;
  String? _errorTxt;

  bool isGood = false;

  Widget buildVerificationCodeTextField(
      TextEditingController verificationCodeController, bool isGood) {
    return isGood
        ? Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextField(
        controller: verificationCodeController,
        decoration: InputDecoration(
          labelText: "인증번호",
          hintText: "111111",
          focusColor: Color(0xFF4B66DC),
          hintStyle: TextStyle(color: Color(0xFFB9B9B9)),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF4B66DC)),
          ),
        ),
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Color(0xFF4B66DC),
        autofocus: true,
        textInputAction: TextInputAction.next,
      ),
    )
        : Container(); // 중복 검사를 통과하지 않은 경우 빈 컨테이너 반환
  }

  Future<void> sendUserDuplicateDataToServer() async {
    Widget verificationCodeWidget = buildVerificationCodeTextField(
      _verificationCodeController,
      isGood,
    );
    final url = Uri.parse('http://152.67.214.13:8080/user/email/duplicate').replace(
      queryParameters: {'email': _textFieldController.text.toString()},
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));

        if (responseData['data'] == true) {
          Fluttertoast.showToast(
            msg: "인증번호를 발송했습니다.",
            gravity: ToastGravity.BOTTOM,
            fontSize: 20,
            toastLength: Toast.LENGTH_SHORT,
          );

          // startTimer();

          setState(() {
            isGood = true; // 이 부분이 추가되었습니다.
            // countdown = 300;
          });

          print('중복 검사 통과: ${responseData['message']}');
          // 성공 시 추가적인 처리를 수행할 수 있습니다.
        } else {
          Fluttertoast.showToast(
            msg: "중복된 이메일입니다.",
            gravity: ToastGravity.BOTTOM,
            fontSize: 20,
            toastLength: Toast.LENGTH_SHORT,
          );
          print('중복 검사 실패: ${responseData['message']}');
          // 실패 시 처리를 수행할 수 있습니다.
        }
      } else if (response.statusCode == 422) {
        final Map<String, dynamic> errorData = json.decode(response.body);

        if (errorData.containsKey('detail')) {
          final List<dynamic> errorDetails = errorData['detail'];
          errorDetails.forEach((errorDetail) {
            print('유효성 검사 오류: ${errorDetail['msg']}');
            // 실패 시 메시지 출력 또는 사용자에게 알림을 표시할 수 있습니다.
          });
        } else {
          print('유효성 검사 오류: 서버에서 제공한 형식과 다른 응답입니다.');
        }
      } else {
        print('실패: ${response.statusCode}');
        // 실패 시 처리를 수행할 수 있습니다.
      }
    } catch (e) {
      print('오류 발생: $e');
      // 예외 처리를 수행할 수 있습니다.
    }
  }


  Future<void> sendUserCodeToServer() async {
    final url = Uri.parse('http://152.67.214.13/user/email/auth');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': _textFieldController,
          'code': _verificationCodeController
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));

        if (responseData['data'] == true) {
          Fluttertoast.showToast(
              msg: "인증 완료",
              gravity: ToastGravity.BOTTOM,
              fontSize: 20,
              toastLength: Toast.LENGTH_SHORT);
          print('인증코드 일치: ${responseData['message']}');
          // 성공 시 추가적인 처리를 수행할 수 있습니다.
        } else {
          print('인증코드 불일치: ${responseData['message']}');
          // 실패 시 처리를 수행할 수 있습니다.
        }
      } else if (response.statusCode == 422) {
        final Map<String, dynamic> errorData = json.decode(response.body);

        if (errorData.containsKey('detail')) {
          final List<dynamic> errorDetails = errorData['detail'];
          errorDetails.forEach((errorDetail) {
            print('유효성 검사 오류: ${errorDetail['msg']}');
            // 실패 시 메시지 출력 또는 사용자에게 알림을 표시할 수 있습니다.
          });
        } else {
          print('유효성 검사 오류: 서버에서 제공한 형식과 다른 응답입니다.');
        }
      } else {
        print('인증코드 인증 실패: ${response.statusCode}');
        // 실패 시 처리를 수행할 수 있습니다.
      }
    } catch (e) {
      print('오류 발생: $e');
      // 예외 처리를 수행할 수 있습니다.
    }
  }

  Future<void> sendUserDataToServer() async {
    if (!isGood) {
      Fluttertoast.showToast(
        msg: "이메일 인증이 필요합니다.",
        gravity: ToastGravity.BOTTOM,
        fontSize: 20,
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    final url = Uri.parse('http://152.67.214.13/user/email/auth');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': _textFieldController.text,
          'code': _verificationCodeController.text,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));

        if (responseData['data'] == true) {
          Fluttertoast.showToast(
            msg: "인증 완료",
            gravity: ToastGravity.BOTTOM,
            fontSize: 20,
            toastLength: Toast.LENGTH_SHORT,
          );
          print('인증코드 일치: ${responseData['message']}');
          // 성공 시 추가적인 처리를 수행할 수 있습니다.
        } else {
          print('인증코드 불일치: ${responseData['message']}');
          // 실패 시 처리를 수행할 수 있습니다.
        }
      } else if (response.statusCode == 422) {
        final Map<String, dynamic> errorData = json.decode(response.body);

        if (errorData.containsKey('detail')) {
          final List<dynamic> errorDetails = errorData['detail'];
          errorDetails.forEach((errorDetail) {
            print('유효성 검사 오류: ${errorDetail['msg']}');
            // 실패 시 메시지 출력 또는 사용자에게 알림을 표시할 수 있습니다.
          });
        } else {
          print('유효성 검사 오류: 서버에서 제공한 형식과 다른 응답입니다.');
        }
      } else {
        print('인증코드 인증 실패: ${response.statusCode}');
        // 실패 시 처리를 수행할 수 있습니다.
      }
    } catch (e) {
      print('오류 발생: $e');
      // 예외 처리를 수행할 수 있습니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 100,),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "회원가입",
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                  child: TextField(
                    controller: _textFieldController,
                    decoration: InputDecoration(
                      labelText: "이메일",
                      hintText: "sogo@sogo.com",
                      focusColor: Color(0xFF4B66DC),
                      hintStyle: TextStyle(color: Color(0xFFB9B9B9)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF4B66DC)),
                      ),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Color(0xFF4B44DC),
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Positioned(
                  right: 25,
                  top: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await sendUserDuplicateDataToServer();
                      await sendUserDataToServer();
                      String textFieldValue = _textFieldController.text;

                      if (textFieldValue.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "이메일이 비어있습니다.",
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 20,
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      } else if (!textFieldValue.isValidEmailFormat()) {
                        Fluttertoast.showToast(
                          msg: "이메일 형식이 잘못되었습니다.",
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 20,
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      } else {
                        setState(() {
                          isGood = true;
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)),
                    ),
                    child: Text(
                      "인증번호 발송",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  right: 25,
                  top: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      await sendUserDuplicateDataToServer();
                      String textFieldValue = _textFieldController.text;
                      String verificationCodeController = _verificationCodeController.text;
                      if (verificationCodeController.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "인증코드가 비어있습니다.",
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 20,
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      } else {
                        await sendUserCodeToServer();

                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)),
                    ),
                    child: Text(
                      "인증번호 발송",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Text(
            //   // '${countdown ~/ 60}:${(countdown%60).toString().padLeft(2, '0')}',
            //   // style: TextStyle(fontSize: 20),
            // ),

            isGood ? buildVerificationCodeTextField(_verificationCodeController, isGood) : Container(),

            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: _PasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "비밀번호",
                  hintText: "⦁ ⦁ ⦁ ⦁ ⦁ ⦁ ⦁ ⦁",
                  errorText: _errorText,
                  focusColor: Color(0xFF4B66DC),
                  hintStyle: TextStyle(color: Color(0xFFB9B9B9)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF4B66DC)),
                  ),
                ),
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Color(0xFF4B44DC),
                autofocus: true,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  setState(() {
                    textFieldValue = value;
                    if (value.isEmpty) {
                      _errorText = "값이 비어있습니다.";
                    } else if (!value.isValidPassWordFormat()) {
                      _errorText = "8자 이상, 대문자, 소문자, 숫자, 특수문자가 최소 1개씩 포함되어야 합니다.";
                    } else {
                      _errorText = null;
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "비밀번호 확인",
                  hintText: "⦁ ⦁ ⦁ ⦁ ⦁ ⦁ ⦁ ⦁",
                  errorText: _errorTxt,
                  focusColor: Color(0xFF4B66DC),
                  hintStyle: TextStyle(color: Color(0xFFB9B9B9)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF4B66DC)),
                  ),
                ),
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Color(0xFF4B44DC),
                autofocus: true,
                textInputAction: TextInputAction.next,
                onChanged: (chkValue) {
                  setState(() {
                    if (chkValue.isEmpty) {
                      _errorTxt = "값이 비어있습니다.";
                    } else if (chkValue != _PasswordController.text) {
                      _errorTxt = "비밀번호가 일치하지 않습니다.";
                    } else {
                      _errorTxt = null;
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "이름",
                  hintText: "대소고",
                  focusColor: Color(0xFF4B66DC),
                  hintStyle: TextStyle(color: Color(0xFFB9B9B9)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF4B66DC)),
                  ),
                ),
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Color(0xFF4B44DC),
                autofocus: true,
                textInputAction: TextInputAction.done,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 100)),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (isGood) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Major(
                          textFieldController: _textFieldController.text,
                          confirmPasswordController: _confirmPasswordController.text,
                          nameController: _nameController.text,
                        ),
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: "이메일 인증이 필요합니다.",
                      gravity: ToastGravity.BOTTOM,
                      fontSize: 20,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF4B66DC)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size.fromHeight(50),
                  ),
                ),
                child: Text(
                  "다음으로",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "이미 계정이 있으신가요?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogIn()),
                    );
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(50, 50),
                  ),
                  child: Text(
                    "로그인",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4B66DC),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(100, 30, 0, 0),
                  child: Text(
                    "가입하면 ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Text(
                    "이용약관, 개인정보취급방침",
                    style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Text(
                    "에 동의하게 됨.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}



extension InputValidate on String {
  //이메일 포맷 검증
  bool isValidEmailFormat() {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }

  bool isValidPassWordFormat() {
    // 최소 8자, 대문자, 소문자, 숫자, 특수문자가 최소 1개씩 포함
    return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>]).{8,}$')
        .hasMatch(this);
  }
}