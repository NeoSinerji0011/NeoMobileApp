import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sigortadefterim/AppStyle.dart';

final List child = mapSliderPages<Widget>(
  [
    "assets/images/onboarding_1.jpg",
    "assets/images/onboarding_2.jpg",
    "assets/images/onboarding_3.jpg",
    "assets/images/onboarding_4.jpg",
    "assets/images/onboarding_5.jpg",
    "assets/images/onboarding_6.jpg",
    "assets/images/onboarding_7.jpg"
  ],
  (index, i) {
    return Stack(fit: StackFit.expand, children: <Widget>[
      //Image.network(i, fit: BoxFit.cover),
      Image.asset(i, fit: BoxFit.cover),
      Container(
        color: ColorData.renkSiyah.withOpacity(0.2),
        child: Text(""),
      ),
    ]);
  },
).toList();

List<T> mapSliderPages<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class BannerSlider extends StatefulWidget {
  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _current = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWight = MediaQuery.of(context).size.width;
    final bannerSlider = CarouselSlider(
      items: child,
      height: screenWight,
      autoPlay: true,
      enlargeCenterPage: true,
      viewportFraction: 1.0,
      aspectRatio: 2,
      onPageChanged: (index) {
        setState(() {
          _current = index;
        });
      },
    );
    var bannerSliderYukseklikOrani=1.18;
    return Container(
      height: screenWight/bannerSliderYukseklikOrani,
      width: screenWight,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.transparent],
                    ).createShader(Rect.fromLTRB(0, 0, rect.width/bannerSliderYukseklikOrani, rect.width/bannerSliderYukseklikOrani));
                  },
                  blendMode: BlendMode.dstATop,
                  child: bannerSlider)),
          Positioned(
            top: screenWight / 2,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: InkWell(
                  onTap: () => bannerSlider.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear),
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Image.asset(
                      "assets/images/ic_right_arrow.png",
                      height: 16,
                      color: ColorData.renkBeyaz,
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
          ),
          Positioned(
            top: screenWight / 2,
            right: 0,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: InkWell(
                  onTap: () => bannerSlider.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear),
                  child: Image.asset(
                    "assets/images/ic_right_arrow.png",
                    height: 16,
                    color: ColorData.renkBeyaz,
                    fit: BoxFit.cover,
                  ),
                )),
          ),
          Positioned(
            top: screenWight/bannerSliderYukseklikOrani - 50,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: mapSliderPages<Widget>(
                  [
                    "assets/images/onboarding_1.jpg",
                    "assets/images/onboarding_2.jpg",
                    "assets/images/onboarding_3.jpg",
                    "assets/images/onboarding_4.jpg",
                    "assets/images/onboarding_5.jpg",
                    "assets/images/onboarding_6.jpg",
                    "assets/images/onboarding_7.jpg"
                  ],
                  (index, url) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? ColorData.renkBeyaz
                              : Colors.transparent,
                          border: Border.all(color: ColorData.renkBeyaz)),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
