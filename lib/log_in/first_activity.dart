import 'package:flutter/material.dart';

import 'package:bigsogo/log_in/regist_activity.dart';
import 'login_activity.dart';

class StartActivity extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<StartActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Image(
                    image: AssetImage('image/Logo.png'),
                    width: 150,
                    height: 190,
                  ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("궁금했지만 하지못한 ", style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                    ),),
                    Text("질문", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black
                    ),),
                    Text("들", style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("나는 ", style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                    ),),
                    Text("어떻게", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black
                    ),),
                    Text(" 직장에 가야할까?", style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 200)),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 16), // 좌우 마진 조절
                  child: ElevatedButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => (Regist())),
                    );
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
                      child: Text("시작하기", style: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                        ),)),
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Text("이미 계정이 있으신가요?",
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
                          MaterialPageRoute(builder: (context) => LogIn()),
                        );
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size(50, 50),
                      ),
                      child: Text(
                        "로그인",
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
          ),

      ),
    );
  }
}