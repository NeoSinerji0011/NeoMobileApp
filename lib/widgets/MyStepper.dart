import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as ResizedImage;
import 'package:image_picker/image_picker.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';
import 'package:sigortadefterim/widgets/MyVoiceRecorder.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:geocoding/geocoding.dart';

class MyStepper extends StatefulWidget {
  final Function(List<String>, List<String>, String, List<double>)
      onSelectionComplete;
  final bool isArac;
  final String testfile;

  const MyStepper({this.onSelectionComplete, this.isArac, this.testfile});

  @override
  _MyStepperState createState() => new _MyStepperState();
}

class _MyStepperState extends State<MyStepper> {
  int _currentStep = 0;
  String deneme = "ilk deneme";
  int lastPhotoIndex;

  List<bool> documentIsFilledList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  List<CustomButtonContainer> _customButtonList = List();
  List<CustomButtonContainer> _kendiruhsaticustomButtonList = List();
  List<CustomButtonContainer> _kendiehliyetcustomButtonList = List();
  List<CustomButtonContainer> _karsiruhsatcustomButtonList = List();
  List<CustomButtonContainer> _karsiehliyetcustomButtonList = List();
  List<CustomButtonContainer> _kazatutanakcustomButtonList = List();
  List<CustomButtonContainer> _digerbelgecustomButtonList = List();
  List<CustomButtonContainer> _hasarfotografcustomButtonList = List();

  List<bool> imageValidator = [false, false, false, false, false, false, false];

  List<String> selectedChipList = List();
  List<String> selectedImageList = List();
  //var testimagelist = [];
  List<String> chechimagesList = List();
  String _recordFile = "";

  Position userLocation;
  Placemark userPlacemark;
  bool isLocationRequested = false;
  int heightfotoContainer=0;
  @override
  Widget build(BuildContext context) {
     
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 36, top: 36),
          child: SizedBox(
              //height: userLocation == null ? 850 : 900,
              height:  MediaQuery.of(context).size.height+(widget.isArac?userLocation == null ?450:550:userLocation == null ?100:200)+heightfotoContainer,
              child: VerticalDivider(
                color: ColorData.renkMavi,
                thickness: 1.5,
              )),
        ),
        Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            ColorData.renkLacivert,
                            ColorData.renkMavi
                          ])),
                  child: Image.asset(
                    "assets/images/ic_atach.png",
                    height: 24,
                    width: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48, right: 36),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Gerekli Dökümanlar",
                          style: TextStyleData.standartLacivert24),
                      TextSpan(text: "\n\n"),
                      TextSpan(
                          text:
                              "Aşağıda istenilen fotoğrafları eksiksiz yükleyiniz.",
                          style: TextStyleData.boldLacivert16)
                    ])),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            widget.isArac
                ? Column(
                    children: <Widget>[
                      InkWell(
                        child: CustomButtonContainer(
                            title: "Kaza Tespit Tutanağı", isFilled: false),
                        onTap: () {
                          if (_kazatutanakcustomButtonList.length == 2)
                            UtilsPolicy.infoAlertBox(
                                "Tutanak Fotoğrafı 2 Adet Olabilir", context);
                          else
                            _pickImage(4);
                        },
                      ),
                      Column(
                        children: _kazatutanakcustomButtonList
                            .map((e) => InkWell(
                                  child: new CustomPreviewButtonContainer(
                                    isFilled: true,
                                    title: e.title,
                                  ),
                                  onTap: () {
                                    showAlertDialog(context,
                                        selectedImageList[e.index], true);
                                  },
                                ))
                            .toList(),
                      ),
                      InkWell(
                        child: CustomButtonContainer(
                            title: "Kendi Aracınızın Ruhsatı", isFilled: false),
                        onTap: () {
                          if (_kendiruhsaticustomButtonList.length == 2)
                            UtilsPolicy.infoAlertBox(
                                "Ruhsat Fotoğrafı 2 Adet Olabilir", context);
                          else
                            _pickImage(0);
                        },
                      ),
                      Column(
                        children: _kendiruhsaticustomButtonList
                            .map((e) => InkWell(
                                  child: new CustomPreviewButtonContainer(
                                    isFilled: true,
                                    title: e.title,
                                  ),
                                  onTap: () {
                                    showAlertDialog(context,
                                        selectedImageList[e.index], true);
                                  },
                                ))
                            .toList(),
                      ),
                      InkWell(
                        child: CustomButtonContainer(
                            title: "Kendi Ehliyetiniz", isFilled: false),
                        onTap: () {
                          if (_kendiehliyetcustomButtonList.length == 2)
                            UtilsPolicy.infoAlertBox(
                                "Ehliyet Fotoğrafı 2 Adet Olabilir", context);
                          else
                            _pickImage(1);
                        },
                      ),
                      Column(
                        children: _kendiehliyetcustomButtonList
                            .map((e) => InkWell(
                                  child: new CustomPreviewButtonContainer(
                                    isFilled: true,
                                    title: e.title,
                                  ),
                                  onTap: () {
                                    showAlertDialog(context,
                                        selectedImageList[e.index], true);
                                  },
                                ))
                            .toList(),
                      ),
                      InkWell(
                        child: CustomButtonContainer(
                            title: "Karşı Aracın Ruhsatı", isFilled: false),
                        onTap: () {
                          if (_karsiruhsatcustomButtonList.length == 2)
                            UtilsPolicy.infoAlertBox(
                                "Ruhsat Fotoğrafı 2 Adet Olabilir", context);
                          else
                            _pickImage(2);
                        },
                      ),
                      Column(
                        children: _karsiruhsatcustomButtonList
                            .map((e) => InkWell(
                                  child: new CustomPreviewButtonContainer(
                                    isFilled: true,
                                    title: e.title,
                                  ),
                                  onTap: () {
                                    showAlertDialog(context,
                                        selectedImageList[e.index], true);
                                  },
                                ))
                            .toList(),
                      ),
                      InkWell(
                        child: CustomButtonContainer(
                            title: "Karşı Sürücünün Ehliyeti", isFilled: false),
                        onTap: () {
                          if (_karsiehliyetcustomButtonList.length == 2)
                            UtilsPolicy.infoAlertBox(
                                "Ehliyet Fotoğrafı 2 Adet Olabilir", context);
                          else
                            _pickImage(3);
                        },
                      ),
                      Column(
                        children: _karsiehliyetcustomButtonList
                            .map((e) => InkWell(
                                  child: new CustomPreviewButtonContainer(
                                    isFilled: true,
                                    title: e.title,
                                  ),
                                  onTap: () {
                                    showAlertDialog(context,
                                        selectedImageList[e.index], true);
                                  },
                                ))
                            .toList(),
                      ),
                      
                      GestureDetector(
                        child: CustomButtonContainer(
                            title: "Varsa Diğer Belge", isFilled: false),
                        onTap: () {
                          if (_digerbelgecustomButtonList.length == 5)
                            UtilsPolicy.infoAlertBox(
                                "Diğer Belge Fotoğrafı 5 Adet Olabilir",
                                context);
                          else
                            _pickImage(5);
                        },
                      ),
                      Column(
                        children: _digerbelgecustomButtonList
                            .map((e) => InkWell(
                                  child: new CustomPreviewButtonContainer(
                                    isFilled: true,
                                    title: e.title,
                                  ),
                                  onTap: () {
                                    showAlertDialog(context,
                                        selectedImageList[e.index], true);
                                  },
                                ))
                            .toList(),
                      ),
                    ],
                  )
                : Container(),
            Column(
              children: <Widget>[
                /*  
                Container( 
                  child: chechimagesList.length>0?chechimagesList.contains("6")?null: Text("Hasar Fotoğrafı Giriniz"):null,
                ), */
                InkWell(
                  child: CustomButtonContainer(
                    title: "Hasar Fotoğraf",
                    isFilled: false,
                  ),
                  onTap: () {
                    if (_hasarfotografcustomButtonList.length == 10)
                      UtilsPolicy.infoAlertBox(
                          "Hasar Fotoğrafı 10 Adet Olabilir", context);
                    else
                      _pickImage(6);
                  },
                ),
                Column(
                  
                  children: _hasarfotografcustomButtonList
                      .map((e) => InkWell(
                            child: new CustomPreviewButtonContainer(
                              isFilled: true,
                              title: e.title,
                            ),
                            onTap: () {
                              showAlertDialog(
                                  context, selectedImageList[e.index], true);
                              print(e.index);
                            },
                          ))
                      .toList(),
                )
              ],
            ),
            Column(
              children: _customButtonList
                  .map((e) => InkWell(
                        child: new CustomButtonContainer(
                          isFilled: documentIsFilledList[e.indexFilled],
                          title: e.title,
                        ),
                        onTap: () {
                          _pickImage(e.index);
                        },
                      ))
                  .toList(),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            ColorData.renkLacivert,
                            ColorData.renkMavi
                          ])),
                  child: Image.asset(
                    "assets/images/ic_voice.png",
                    height: 24,
                    width: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 65, right: 36),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Ses Kaydı",
                          style: TextStyleData.standartLacivert24),
                      TextSpan(text: "\n\n"),
                      TextSpan(
                          text:
                              "İsteğe bağlı ses kaydı göndermek için kayıt simgesine dokunarak maksimum 1 dakikalık ses kaydı yollayabilirsiniz.",
                          style: TextStyleData.boldLacivert)
                    ])),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            MyVoiceRecorder(
                recordName: "tc", 
                onSelectionComplete: (recordFile,heightfotoContainer2) { 
                  setState(() {
                    this.heightfotoContainer+=heightfotoContainer2;
                  });
                  widget.onSelectionComplete(
                      selectedImageList,
                      chechimagesList,
                      _recordFile = recordFile,
                      userLocation == null
                          ? List<double>()
                          : [userLocation.latitude, userLocation.longitude]);
                }),
            SizedBox(
              height: 4,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            ColorData.renkLacivert,
                            ColorData.renkMavi
                          ])),
                  child: Image.asset(
                    "assets/images/ic_location.png",
                    height: 24,
                    width: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48, right: 36),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Konum Bilgisi",
                          style: TextStyleData.standartLacivert24),
                      TextSpan(text: "\n\n"),
                      TextSpan(
                          text:
                              "Kaza yerinde iseniz konum bilgisi ekleyebilirsiniz.",
                          style: TextStyleData.boldLacivert)
                    ])),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: ColorData.renkYesil),
                child: isLocationRequested
                    ? Visibility(
                        visible: isLocationRequested,
                        child: CircularProgressIndicator(
                          backgroundColor: ColorData.renkLacivert,
                        ))
                    : Image.asset(
                        userLocation == null
                            ? "assets/images/ic_location-2.png"
                            : "assets/images/ic_delete.png",
                        height: 36,
                        width: 36,
                      ),
              ),
              onTap: () {
                if (userLocation == null) {
                  openLocationSettings().then((value) {
                    if (!value) return;
                    if (value) {
                      isLocationServiceEnabled().then((value) {
                        checkLocationService().then((value) {
                          if (!value) return; 
                          setState(() {
                            isLocationRequested = true;
                          });
                          Utils.getCurrentLocation().then((position) {
                            
                            Utils.getCurrentPlacemark(
                                    position.latitude, position.longitude)
                                .then((placemark) {
                              setState(() {
                                userPlacemark = placemark;
                                userLocation = position;
                                isLocationRequested = false;
                              });
                            }).whenComplete(() => widget.onSelectionComplete(
                                    selectedImageList,
                                    chechimagesList,
                                    _recordFile,
                                    userLocation == null
                                        ? List<double>()
                                        : [
                                            userLocation.latitude,
                                            userLocation.longitude
                                          ]));
                          });
                        });
                      });
                    }
                  });
                } else {
                  setState(() {
                    userLocation = null;
                  });
                  widget.onSelectionComplete(
                      selectedImageList,
                      chechimagesList,
                      _recordFile,
                      userLocation == null
                          ? List<double>()
                          : [userLocation.latitude, userLocation.longitude]);
                }
              },
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              userLocation == null ? "KONUM EKLE" : "SİL",
              style: TextStyleData.boldLacivert,
            ),
            userLocation == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: 90),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "KONUM",
                          style: TextStyleData.standartLacivert,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 8),
                          child: Text("Enlem: ${userLocation.latitude}",
                              style: TextStyleData.boldLacivert),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 4),
                          child: Text("Boylam: ${userLocation.longitude}",
                              style: TextStyleData.boldLacivert),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        userPlacemark == null
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "ADRES",
                                    style: TextStyleData.standartLacivert,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 8, top: 8),
                                    child: Text(
                                      "${userPlacemark.subLocality} ${userPlacemark.thoroughfare} ${userPlacemark.postalCode} ${userPlacemark.subAdministrativeArea} ${userPlacemark.administrativeArea} ${userPlacemark.country}",
                                      style: TextStyleData.boldLacivert,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ), 
          ],
        ),
      ],
    );
  }

  bool checkLocationServiceEnabled = false;
  Future<bool> isLocationServiceEnabled() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) await Geolocator.openLocationSettings();
    return false;
  }

  Future<bool> checkLocationService() async {
    checkLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    return checkLocationServiceEnabled;
  }

  Future<bool> openLocationSettings() async {
    LocationPermission permissionCheck = await Geolocator.checkPermission(),
        permission;
    if (permissionCheck.index < 1) {
      permission = await Geolocator.requestPermission();
    }

    return permissionCheck.index > 0
        ? true
        : permission.index > 0
            ? true
            : false;
  }

  showAlertDialog(BuildContext context, imageBase64, process) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    var content = null;
    if (process) {
      content = Image.memory(base64Decode(imageBase64));
    }
    /*  content = Center(
        heightFactor: 10,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation(Colors.black),
        ),
      ); */
    AlertDialog alert = AlertDialog(
      title: process ? Text("Ön İzleme") : null,
      content: content,
      actions: process ? [continueButton] : null,
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _pickImage(int index) async {
    final imageSource = await showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog(
              dialogKind: "ImagePick",
            ));

    UtilsPolicy.onLoading(context);
    if (imageSource != null) {
      final file = await ImagePicker.pickImage(
          source: imageSource, maxHeight: 500, maxWidth: 700);
      if (file != null) {
        final List<int> imageFile = file.readAsBytesSync();

        String img64 = base64Encode(imageFile);

        setState(() {
          
          switch (index) {
            case 0:
              _kendiruhsaticustomButtonList.add(CustomButtonContainer(
                title: "Ruhsat " +
                    (_kendiruhsaticustomButtonList.length + 1).toString(),
                index: selectedImageList.length,
              ));

              break;
            case 1:
              _kendiehliyetcustomButtonList.add(CustomButtonContainer(
                title: "Ehliyet " +
                    (_kendiehliyetcustomButtonList.length + 1).toString(),
                index: selectedImageList.length,
              ));
              break;
            case 2:
              _karsiruhsatcustomButtonList.add(CustomButtonContainer(
                title: "Ruhsat " +
                    (_karsiruhsatcustomButtonList.length + 1).toString(),
                index: selectedImageList.length,
              ));
              break;
            case 3:
              _karsiehliyetcustomButtonList.add(CustomButtonContainer(
                title: "Ehliyet " +
                    (_karsiehliyetcustomButtonList.length + 1).toString(),
                index: selectedImageList.length,
              ));
              break;
            case 4:
              _kazatutanakcustomButtonList.add(CustomButtonContainer(
                title: "Tutanak " +
                    (_kazatutanakcustomButtonList.length + 1).toString(),
                index: selectedImageList.length,
              ));
              break;
            case 5:
              _digerbelgecustomButtonList.add(CustomButtonContainer(
                title: "Belge " +
                    (_digerbelgecustomButtonList.length + 1).toString(),
                index: selectedImageList.length,
              ));
              break;
            case 6:
              _hasarfotografcustomButtonList.add(CustomButtonContainer(
                title: "Hasar " +
                    (_hasarfotografcustomButtonList.length + 1).toString(),
                index: selectedImageList.length,
              ));

              break;

            default:
              break;
          }

          //testimagelist.add([index,img64]);
          heightfotoContainer+=60;
          selectedImageList.add(img64);
          if (!chechimagesList.contains(index.toString())) {
            chechimagesList.add(index.toString());
            
          }
          // print(testimagelist[0][1]);
          widget.onSelectionComplete(
              selectedImageList,
              chechimagesList,
              _recordFile,
              userLocation == null
                  ? List<double>()
                  : [userLocation.latitude, userLocation.longitude]);
        });
      }
    }
    //Navigator.of(context).pop();
    UtilsPolicy.closeLoader(context);
  }
}

class CustomButtonContainer extends StatelessWidget {
  final String title;
  final int indexFilled;
  final bool isFilled;

  final int index;

  CustomButtonContainer(
      {@required this.title, this.isFilled, this.indexFilled, this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
          color: isFilled ? ColorData.renkLacivert : ColorData.renkMavi,
          borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 8, 0, 8),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 150,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleData.boldBeyaz18),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color:
                      isFilled ? ColorData.renkLacivert : ColorData.renkBeyaz,
                  borderRadius: BorderRadius.circular(100)),
              child: Padding(
                padding: EdgeInsets.all(isFilled ? 4 : 10.0),
                child: Image.asset(isFilled
                    ? "assets/images/ic_tick.png"
                    : "assets/images/ic_add-4.png"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomPreviewButtonContainer extends StatelessWidget {
  final String title;
  final int indexFilled;
  final bool isFilled;

  final int index;

  CustomPreviewButtonContainer(
      {@required this.title, this.isFilled, this.indexFilled, this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 55, right: 16, bottom: 16),
      decoration: BoxDecoration(
          color: isFilled ? ColorData.renkLacivert : ColorData.renkMavi,
          borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 8, 0, 8),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 150,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleData.boldBeyaz18),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color:
                      isFilled ? ColorData.renkLacivert : ColorData.renkBeyaz,
                  borderRadius: BorderRadius.circular(100)),
              child: Padding(
                padding: EdgeInsets.all(isFilled ? 4 : 10.0),
                child: Image.asset(isFilled
                    ? "assets/images/ic_tick.png"
                    : "assets/images/ic_add-4.png"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
