import 'package:bigsogo/main_service/bottom_service/question/QnA_fragment.dart';
import 'package:flutter/material.dart';

class QAnswer extends StatefulWidget {
  final List<String> clickQList; // 클릭한 질문의 데이터를 받을 변수 추가

  QAnswer(this.clickQList); // 생성자 수정


  @override
  _QAnswerState createState() => _QAnswerState();
}

class _QAnswerState extends State<QAnswer>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      body: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      " Q. " + widget.clickQList[1],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: widget.clickQList[4],
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Color(0xFF343434),
                          ),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.network(
                        widget.clickQList[2],
                        // "https://static-cdn.jtvnw.net/jtv_user_pictures/ecd6ee59-9f18-4eec-b8f3-63cd2a9127a5-profile_image-300x300.png",
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 270,
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.clickQList[3],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          height: 20,
                          width: 300,
                          child: RichText(
                            text: TextSpan(
                              text: widget.clickQList[5],
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),


      bottomNavigationBar: Row(
        children: [
          Expanded(
            flex: 6, // 첫 번째 Container가 차지하는 비율
            child: Container(
              color: Color(0xFFF5FBFF),
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "대충 저거쓰세여",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1, // 두 번째 Container가 차지하는 비율
            child: Container(

              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color : Color(0xFFA0B2EE),
                    width: 1
                  )
                ),
                color: Color(0xFFF5FBFF),
              ),

              height: 60,
              child: IconButton(
                onPressed: () {
                  // 검색 버튼을 눌렀을 때의 동작
                },
                icon: Icon(Icons.send),
              ),
            ),
          )
        ],
      ),

    );
  }
}