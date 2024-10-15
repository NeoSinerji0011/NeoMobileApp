import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/models/Destek.dart';

import 'package:sigortadefterim/utils/Utils.dart';

class ListViewDestek extends StatefulWidget {
  final List<Destek> listDestekIsim;

  ListViewDestek({
    @required this.listDestekIsim,
  });

  @override
  _ListViewDestekState createState() => _ListViewDestekState();
}

class _ListViewDestekState extends State<ListViewDestek> {
  List<bool> _subtitle;
  @override
  void initState() {
    super.initState();

    _subtitle = List<bool>.filled(widget.listDestekIsim.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: ColorData.renkSolukBeyaz.withOpacity(0.1),
        body: SizedBox(
          width: MediaQuery.of(context).size.width / 1,
          child: Container(
            color: ColorData.renkLacivert,
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: IntrinsicHeight(
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 16),
                              IconButton(
                                  icon: Image.asset(
                                      "assets/images/circle_arrow.png"),
                                  onPressed: () {
                                    Navigator.of(context).pop(null);
                                  }),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text("Destek",
                                    textAlign: TextAlign.end,
                                    style: TextStyleData.standartYesil36),
                              )),
                              SizedBox(width: 16),
                              SizedBox(
                                  width: 10,
                                  child: VerticalDivider(
                                      color: ColorData.renkYesil,
                                      thickness: 5)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 35),
                      Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: Divider(
                            color: Colors.white.withOpacity(0.9),
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child:
                   Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding:
                            const EdgeInsets.only(bottom: 20.0, right: 10.0),
                        child: SizedBox(
                            width: 400.0,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.listDestekIsim.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return 
                                  ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child:  
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [ 
                                          Flexible(
                                            child:
                                            Text(
                                                widget.listDestekIsim[index]
                                                    .destekIsim,
                                                textAlign: TextAlign.end,
                                                overflow: TextOverflow.fade,
                                                maxLines: 2,
                                                style: TextStyleData
                                                    .standartBeyaz36)),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              _subtitle[index] == false
                                                  ? "assets/images/ic_right_arrow.png"
                                                  : "assets/images/arrow.png",
                                              fit: BoxFit.contain,
                                              width: 30,
                                              height: 25,
                                              color: ColorData.renkYesil,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
 
                                    subtitle:
                                        widget.listDestekIsim[index].altisim !=
                                                ""
                                            ? _subtitle[index] == true
                                                ? 
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                        InkWell(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                                widget
                                                                    .listDestekIsim[
                                                                        index]
                                                                    .altisim,
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style: TextStyleData
                                                                    .standartBeyaz24),
                                                          ),
                                                          onTap: () async {
                                                            var _currentLocation =
                                                                await Utils
                                                                    .getCurrentLocation();

                                                            String
                                                                _locationLongitude =
                                                                _currentLocation
                                                                    .longitude
                                                                    .toString();
                                                            String
                                                                _locationlatitude =
                                                                _currentLocation
                                                                    .latitude
                                                                    .toString();

                                                            String destekTypeName = widget
                                                                    .listDestekIsim[
                                                                        index]
                                                                    .destekIsim
                                                                    .contains(
                                                                        "Yard")
                                                                ? widget
                                                                    .listDestekIsim[
                                                                        index]
                                                                    .destekIsim
                                                                    .substring(
                                                                        0,
                                                                        widget.listDestekIsim[index].destekIsim.length -
                                                                            7)
                                                                : widget
                                                                    .listDestekIsim[
                                                                        index]
                                                                    .destekIsim;

                                                            Utils.launchURL(
                                                                //    "https://www.google.com.tr/maps/search/{$destekTypeName}/@{$_locationLongitude},{$_locationlatitude}");
                                                                "https://www.google.com.tr/maps/search/$destekTypeName/@$_locationLongitude,$_locationlatitude");

                                                            // Navigator.of(context).push(
                                                            //     MaterialPageRoute(
                                                            //         builder: (context) => NearbyPlaces(
                                                            //             placeName:
                                                            //                 listDestekIsim[index])));
                                                          },
                                                        ),
                                                        InkWell(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                                widget
                                                                    .listDestekIsim[
                                                                        index]
                                                                    .altisim2,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyleData
                                                                    .standartBeyaz24),
                                                          ),
                                                          onTap: () async {
                                                            var _currentLocation =
                                                                await Utils
                                                                    .getCurrentLocation();

                                                            String
                                                                _locationLongitude =
                                                                _currentLocation
                                                                    .longitude
                                                                    .toString();
                                                            String
                                                                _locationlatitude =
                                                                _currentLocation
                                                                    .latitude
                                                                    .toString();

                                                            String
                                                                destekTypeName =
                                                                widget
                                                                    .listDestekIsim[
                                                                        index]
                                                                    .altisim2;

                                                            Utils.launchURL(
                                                                "https://www.google.com.tr/maps/search/$destekTypeName/@$_locationLongitude,$_locationlatitude");
                                                          },
                                                        ),
                                                      ])
                                                : Container()
                                            : Container(),
                                    onTap: () async {
                                      if (widget
                                              .listDestekIsim[index].altisim ==
                                          "") {
                                        var _currentLocation =
                                            await Utils.getCurrentLocation();
                                        String _locationLongitude =
                                            _currentLocation.longitude
                                                .toString();
                                        String _locationlatitude =
                                            _currentLocation.latitude
                                                .toString();

                                        String destekTypeName = widget
                                            .listDestekIsim[index].destekIsim;
                                        if (destekTypeName=="Assistans Firmaları") {
                                          destekTypeName="Assistans Hizmetleri";
                                        }
                                        Utils.launchURL(
                                            "https://www.google.com.tr/maps/search/$destekTypeName/@$_locationLongitude,$_locationlatitude");
                                      } else {
                                        setState(() {
                                          if (_subtitle[index] == false) {
                                            _subtitle[index] = true;
                                          } else {
                                            _subtitle[index] = false;
                                          }
                                        });
                                      }
                                    },
                                  );
                                }))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Api satın alınınca yakındaki yerleri gösteren sayfa
// class NearbyPlaces extends StatefulWidget {
//   final String placeName;
//   final List<Destek> placeList = [
//     Destek(
//         destekIsim: 'Acıbadem Hastanesi',
//         telNo: '0216 548 75 45',
//         mesafe: '175m uzaklıkta'),
//     Destek(
//         destekIsim: 'Çapa Hastanesi',
//         telNo: '0216 548 75 45',
//         mesafe: '12km uzaklıkta'),
//     Destek(
//         destekIsim: 'Acıbadem Hastanesi',
//         telNo: '0216 548 75 45',
//         mesafe: '175m uzaklıkta')
//   ];

//   NearbyPlaces({
//     this.placeName,
//   });

//   @override
//   _NearbyPlacesState createState() => _NearbyPlacesState();
// }

// class _NearbyPlacesState extends State<NearbyPlaces> {
//   List<Place> _places;

//   @override
//   void initState() {
//     super.initState();

//     // MapService.get().getNearbyPlaces().then((data) {
//     //   this.setState(() {
//     //     _places = data;
//     //   });
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//       child: Scaffold(
//         backgroundColor: ColorData.renkSolukBeyaz.withOpacity(0.1),
//         body: SizedBox(
//           width: MediaQuery.of(context).size.width / 1,
//           child: Container(
//             color: ColorData.renkLacivert,
//             child: Column(
//               children: <Widget>[
//                 Container(
//                   height: 200,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.only(right: 0),
//                         child: IntrinsicHeight(
//                           child: Row(
//                             children: <Widget>[
//                               SizedBox(width: 16),
//                               IconButton(
//                                   icon: Image.asset(
//                                       "assets/images/circle_arrow.png"),
//                                   onPressed: () {
//                                     Navigator.of(context).pop(null);
//                                   }),
//                               Expanded(
//                                   child: Padding(
//                                 padding: const EdgeInsets.only(top: 2),
//                                 child: Text(widget.placeName,
//                                     textAlign: TextAlign.end,
//                                     style: TextStyleData.standartYesil36),
//                               )),
//                               SizedBox(width: 16),
//                               SizedBox(
//                                   width: 10,
//                                   child: VerticalDivider(
//                                       color: ColorData.renkYesil,
//                                       thickness: 5)),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 35),
//                       Padding(
//                           padding: const EdgeInsets.only(right: 0),
//                           child: Divider(
//                             color: Colors.white.withOpacity(0.9),
//                           )),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.bottomRight,
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 20.0, right: 10.0),
//                       child: SizedBox(
//                           child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: _places.length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return ListTile(
//                                   title: Padding(
//                                     padding: const EdgeInsets.all(0.0),
//                                     child: Text(_places[index].name,
//                                         textAlign: TextAlign.end,
//                                         style: TextStyleData.standartBeyaz18),
//                                   ),
//                                   subtitle: Padding(
//                                     padding: const EdgeInsets.all(0.0),
//                                     child: Text(_places[index].vicinity,
//                                         textAlign: TextAlign.end,
//                                         style: TextStyleData.standartMavi),
//                                   ),
//                                   trailing: Image.asset(
//                                     "assets/images/ic_right_arrow.png",
//                                     fit: BoxFit.contain,
//                                     width: 12,
//                                     height: 12,
//                                     color: ColorData.renkYesil,
//                                   ),
//                                   onTap: () {
//                                     Navigator.of(context)
//                                         .push(MaterialPageRoute(
//                                             builder: (context) => PlaceDetails(
//                                                   placeIsim: widget
//                                                       .placeList[index]
//                                                       .destekIsim,
//                                                   placeKonum: widget
//                                                       .placeList[index].konum,
//                                                   placeTel: widget
//                                                       .placeList[index].telNo,
//                                                 )));
//                                   },
//                                 );
//                               })),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//Api satın alınınca yakındaki seçilen yerin konumunu haritada açan veya telefonla arayan sayfa
class PlaceDetails extends StatelessWidget {
  final String placeIsim;
  final String placeTel;
  final String placeKonum;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PlaceDetails({this.placeIsim, this.placeKonum, this.placeTel});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorData.renkLacivert,
        body: SizedBox(
          width: MediaQuery.of(context).size.width / 1,
          child: Container(
            color: ColorData.renkLacivert,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 200.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: IntrinsicHeight(
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 16),
                                  IconButton(
                                      icon: Image.asset(
                                          "assets/images/circle_arrow.png"),
                                      onPressed: () {
                                        Navigator.of(context).pop(null);
                                      }),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text('İletişim Bilgileri',
                                        textAlign: TextAlign.end,
                                        style: TextStyleData.standartYesil36),
                                  )),
                                  SizedBox(width: 16),
                                  SizedBox(
                                      width: 10,
                                      child: VerticalDivider(
                                          color: ColorData.renkYesil,
                                          thickness: 5)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        Center(
                          child: Text(
                            placeIsim,
                            style: TextStyleData.boldBeyaz24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  GestureDetector(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width:
                              300.0, //MediaQuery.of(context).size.width / 1.5,
                          height:
                              150.0, //MediaQuery.of(context).size.height / 2.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.transparent,
                              border: Border.all(color: ColorData.renkYesil)),
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 50.0,
                              color: ColorData.renkYesil,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                placeTel,
                                style: TextStyleData.standartBeyaz18,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    onTap: () {
                      if (placeTel == null || placeTel == '')
                        _showSnackBar("Tel Numarası Bulunamadı");
                      else
                        Utils.launchURL("tel:${placeTel}");
                    },
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  GestureDetector(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width:
                              300.0, //MediaQuery.of(context).size.width / 1.5,
                          height:
                              150.0, //MediaQuery.of(context).size.height / 2.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.transparent,
                              border: Border.all(color: ColorData.renkYesil)),
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.add_location,
                              size: 50.0,
                              color: ColorData.renkYesil,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Haritada gör',
                                style: TextStyleData.standartBeyaz18,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    onTap: () {
                      if (placeTel == null || placeTel == '')
                        _showSnackBar("Tel Numarası Bulunamadı");
                      else
                        Utils.launchURL("tel:${placeTel}");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message, style: TextStyleData.boldBeyaz),
      duration: Duration(seconds: 2),
    ));
  }
}
