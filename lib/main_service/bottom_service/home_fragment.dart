import 'dart:convert';

import 'package:bigsogo/main_service/other_service/search_result.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:bigsogo/main_service/other_service/notification_activity.dart';

import '../other_service/publickQ_data.dart';
import 'QnA_fragment.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

List<List<String>> canViewQList = [];
String majorList = "";

class _HomeState extends State<Home> {
  void initState() {
    super.initState();
    fetchData(); // initState에서 fetchData 호출
  }
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<String> conferenceList = [
    "https://opgg-com-image.akamaized.net/attach/images/20210403150845.1322668.jpg",
    "https://i.ytimg.com/vi/D_BpfOnsayc/maxresdefault.jpg",
    "https://image.fmkorea.com/files/attach/new2/20210318/494354581/2042844561/3461045214/b3539dea40cfe92d0e8cfa926a1fcc4a.png"
  ];

  Future<List<Data>> fetchData() async {
    try {
      final response = await http.get(
        // Uri.parse('http://10.1.8.72:8080/question/list'),
        Uri.parse('http://152.67.214.13:8080/question/list'),

      );
      if (response.statusCode == 200) {
        final MyModel myModel =
        MyModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));

        List<Data> dataList = myModel.data;
        setState(() {
          canViewQList.clear(); // 기존 데이터를 지우고 다시 초기화
          majorList = ""; // 기존 데이터를 지우고 다시 초기화

          for (int i = 0; i < dataList.length; i++) {
            List<String> row = [];
            row.add(dataList[i].id.toString());
            row.add(dataList[i].title);
            row.add(dataList[i].writer.profileImg);
            row.add(dataList[i].writer.username);
            row.add(dataList[i].content);

            canViewQList.add(row);

            for (int j = 0; j < dataList[i].writer.major.length; j++) {
              majorList += " #" + (dataList[i].writer.major[j]);
            }
          }
          print("canViewList : $canViewQList");

        });

        return dataList;
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Widget sliderWidget() {
    return CarouselSlider(
      carouselController: _controller,
      items: conferenceList.map(
          (imgLink) {
            return Builder(
                builder: (context) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        imgLink,
                      ),
                    ),
                  );
                }
            );
          }
      ).toList(),
      options: CarouselOptions(
        height: 225,
        viewportFraction: 1.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        }
      ),
    );
  }

  Widget sliderIndicator() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: conferenceList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF4B66DC).withOpacity(_current == entry.key ? 0.9 : 0.4),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  sliderWidget(),
                  sliderIndicator(),
                ],
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: EdgeInsets.only(right: 380),
              child: Text(
                "추천 프로필",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                  color: Color(0xFFE0F3FF),
              ),
              height: 75,
            ),

            SizedBox(height: 5,),

            Container(
              decoration: BoxDecoration(
                color: Color(0xFFE0F3FF),
              ),
              height: 75,
            ),

            SizedBox(height: 5,),

            Container(
              decoration: BoxDecoration(
                color: Color(0xFFE0F3FF),
              ),
              height: 75,
            ),

            SizedBox(height: 10,),

            Padding(
              padding: EdgeInsets.only(right: 390),
              child: Text(
                "최신 QnA",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),

            Container(
              alignment: Alignment.centerLeft,
              child: Text( " Q. "+ canViewQList[0][0], style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),),
              decoration: BoxDecoration(
                color: Color(0xFFE0F3FF),
              ),
              height: 60,
            ),

            SizedBox(height: 5,),

            Container(
              alignment: Alignment.centerLeft,
              child: Text( " Q. "+ canViewQList[0][1], style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),),
              decoration: BoxDecoration(
                color: Color(0xFFE0F3FF),
              ),
              height: 60,
            ),

            SizedBox(height: 5,),

            Container(
              alignment: Alignment.centerLeft,
              child: Text( " Q. "+ canViewQList[0][2], style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),),
              decoration: BoxDecoration(
                color: Color(0xFFE0F3FF),
              ),
              height: 60,
            ),

            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}
