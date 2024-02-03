import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView>{
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
      body : Center(
        child: Text("업데이트 예정입니다.", style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20
        ),),
      )

      // Container(
      //   height: 130,
      //   margin: EdgeInsets.only(bottom: 10),
      //   width: double.infinity,
      //   color: Color(0xFFE0F3FF),
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Column(
      //       children: [
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             Text("Q. 씹덕이여도 성공할 수 있을까요..?", style: TextStyle(
      //               fontWeight: FontWeight.w600,
      //               fontSize: 20
      //             ),),
      //           ],
      //         ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             Text("A. 애니를 시청하는 것은 개발자의 기본 소양이.....", style: TextStyle(
      //                 fontWeight: FontWeight.w600,
      //                 fontSize: 16
      //             ),),
      //           ],
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.end,
      //             children: [
      //               TextButton(
      //                 onPressed: () {
      //                   // 버튼 클릭 시 수행할 동작 추가
      //                 },
      //                 style: ButtonStyle(
      //                   backgroundColor:
      //                   MaterialStateProperty.all<Color>(Color(0xFF4B66DC)),
      //                   shape: MaterialStateProperty.all<OutlinedBorder>(
      //                     RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(5.0),
      //                     ),
      //                   ),
      //                 ),
      //                 child: Text(
      //                   "엄성민님의 답글 보기",
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),

    );
  }
}