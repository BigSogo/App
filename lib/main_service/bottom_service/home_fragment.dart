import 'package:bigsogo/main_service/other_service/search_result.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:bigsogo/main_service/other_service/notification_activity.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<String> conferenceList = [
    "https://opgg-com-image.akamaized.net/attach/images/20210403150845.1322668.jpg",
    "https://i.ytimg.com/vi/D_BpfOnsayc/maxresdefault.jpg",
    "https://image.fmkorea.com/files/attach/new2/20210318/494354581/2042844561/3461045214/b3539dea40cfe92d0e8cfa926a1fcc4a.png"
  ];

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
      body: Column(
        children: [
          SizedBox(
            height: 225,
            child: Stack(
              children: [
                sliderWidget(),
                sliderIndicator(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
