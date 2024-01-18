import 'package:bigsogo/log_in/login_activity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Regist extends StatefulWidget {
  @override
  _RegistState createState() => _RegistState();
}

class _RegistState extends State<Regist> {
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _PasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String textFieldValue = "";
  String? _errorText;
  String? _errorTxt;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom),
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
                    onPressed: () {
                      String textFieldValue = _textFieldController.text;
                      if(textFieldValue.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "이메일이 비어있습니다.",
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 20,
                          toastLength: Toast.LENGTH_SHORT
                        );
                      } else if(textFieldValue.isValidEmailFormat()==false){
                        Fluttertoast.showToast(
                            msg: "이메일 형식이 잘못되었습니다.",
                            gravity: ToastGravity.BOTTOM,
                            fontSize: 20,
                            toastLength: Toast.LENGTH_SHORT
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: "인증번호를 발송했습니다.",
                            gravity: ToastGravity.BOTTOM,
                            fontSize: 20,
                            toastLength: Toast.LENGTH_SHORT
                        );
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
                    if(value.isEmpty){
                      _errorText = "값이 비어있습니다.";
                    } else if(value.isValidPassWordFormat()==false) {
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
                    if(chkValue.isEmpty){
                      _errorTxt = "값이 비어있습니다.";
                    } else if(chkValue!=_PasswordController.text) {
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
              margin: EdgeInsets.symmetric(horizontal: 16), // 좌우 마진 조절
              child: ElevatedButton(onPressed: () {

              },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // 각지게 만들기 위한 값
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFF4B66DC)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 16.0), // 좌우 16만큼의 패딩
                  ),
                  fixedSize: MaterialStateProperty.all<Size>(
                      Size.fromHeight(50)), // 높이는 고정, 가로는 디바이스에 맞추어 유동적으로
                ),
                child: Text("회원가입", style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                ),),
              ),),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("이미 계정이 있으신가요?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),),
                TextButton(
                  onPressed: () {
                    // TextButton 클릭 시 SecondScreen으로 이동
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
                        fontWeight: FontWeight.w700
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(padding: EdgeInsets.fromLTRB(100, 30, 0, 0),
                  child: Text(
                    "가입하면 ",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Text(
                    "이용약관, 개인정보취급방침",
                    style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Text(
                    "에 동의하게 됨.",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500
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