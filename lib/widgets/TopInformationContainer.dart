import 'package:flutter/material.dart';
import 'package:sigortadefterim/AppStyle.dart';

class TopInformationContainer extends StatelessWidget {
  final String imageUrl, adSoyad, riskOrani;
  //final String title;

  TopInformationContainer({this.imageUrl, this.adSoyad, this.riskOrani});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/ikonlar-2.png"),
              alignment: Alignment.topCenter,
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.topRight,
              stops: [0.1, 0.8],
              colors: [Color(0xff0047FD), Color(0xff0B1A3D)]),
          boxShadow: [BoxDecorationData.shadow]),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                    color: ColorData.renkSolukBeyaz, shape: BoxShape.circle),
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: 
                     CircleAvatar(backgroundColor: ColorData.renkKirmizi,backgroundImage: NetworkImage(imageUrl)),
                    ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(adSoyad, style: TextStyleData.boldBeyaz16),
                    //SizedBox(height: 2),
                    //Container(
                    //  alignment: Alignment.center,
                    //  padding: EdgeInsets.all(1),
                    //  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: ColorData.renkKirmizi),
                    //  child: Row(
                    //    crossAxisAlignment: CrossAxisAlignment.center,
                    //    children: <Widget>[
                    //      SizedBox(width: 1),
                    //      Icon(Icons.info_outline, color: ColorData.renkBeyaz, size: 16),
                    //      SizedBox(width: 4),
                    //      Padding(
                    //        padding: const EdgeInsets.only(top: 2),
                    //        child: Text("%$riskOrani", style: TextStyleData.boldBeyaz12),
                    //        ),
                    //      SizedBox(width: 2)
                    //    ],
                    //    ),
                    //  )
                  ],
                ),
              ),
            ],
          ),
          //Row(
          //  children: <Widget>[
          //    Padding(
          //      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          //      child: Text(title, style: TextStyleData.standartYesil24),
          //      ),
          //  ],
          //  )
        ],
      ),
    );
  }
}
