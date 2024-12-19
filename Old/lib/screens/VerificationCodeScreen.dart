import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sigortadefterim/AppStyle.dart';

class VerificationCodeScreen extends StatefulWidget {
  @override
  _VerificationCodeScreenState createState() => new _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> with SingleTickerProviderStateMixin {
  final int time = 180;
  AnimationController _controller;

  Size _screenSize;
  int _currentDigit;
  int _firstDigit;
  int _secondDigit;
  int _thirdDigit;
  int _fourthDigit;
  int _fifthDigit;
  int _sixthDigit;

  Timer timer;
  int totalTimeInSeconds;
  bool _hideResendButton;

  String userName = "";
  bool didReadNotifications = false;
  int unReadNotificationsCount = 0;

  get _getVerificationCodeLabel {
    return Padding(
      padding: const EdgeInsets.only(top:2.0),
      child: Text(
        "Doğrulama Kodu",
        textAlign: TextAlign.center,
        style: TextStyleData.standartBeyaz30,
      ),
    );
  }

  get _getEmailLabel {
    return  Text(
      "Üye olduğunuz telefon numarasına SMS ile gelen doğrulama kodunu giriniz",
      textAlign: TextAlign.center,
      style: TextStyleData.boldBeyaz18,
    );
  }

  get _getInputField {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _otpTextField(_firstDigit),
        _otpTextField(_secondDigit),
        _otpTextField(_thirdDigit),
        _otpTextField(_fourthDigit),
        _otpTextField(_fifthDigit),
        _otpTextField(_sixthDigit),
      ],
    );
  }

  get _getInputPart {
    return  Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                child: IconButton(
                    icon: Image.asset("assets/images/circle_arrow.png",color: ColorData.renkBeyaz,),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                ),
              ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                  child: Align(
                    alignment: Alignment.center,
                    child: _getVerificationCodeLabel,
                    )),
              ),
          ],
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child:
          _getEmailLabel,
        ),
        _getInputField,
        _hideResendButton ? _getTimerText : _getResendButton,
        _getOtpKeyboard
      ],
    );
  }

  get _getTimerText {
    return Container(
      height: 32,
      child:  Offstage(
        offstage: !_hideResendButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Icon(Icons.access_time,color: ColorData.renkBeyaz,),
             SizedBox(
              width: 5.0,
            ),
            OtpTimer(_controller, 15.0, ColorData.renkBeyaz)
          ],
        ),
      ),
    );
  }

  get _getResendButton {
    return InkWell(
      child: Container(
        height: 32,
        width: 120,
        decoration: BoxDecoration(color: ColorData.renkLacivert, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(30)),
        alignment: Alignment.center,
        child:  Text(
          "Tekrar Gönder",
          style: TextStyleData.boldBeyaz
        ),
      ),
      onTap: () {

      },
    );
  }

  get _getOtpKeyboard {
    return  Container(
        height: _screenSize.width - 80,
        child:  Column(
          children: <Widget>[
             Expanded(
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "1",
                      onPressed: () {
                        _setCurrentDigit(1);
                      }),
                  _otpKeyboardInputButton(
                      label: "2",
                      onPressed: () {
                        _setCurrentDigit(2);
                      }),
                  _otpKeyboardInputButton(
                      label: "3",
                      onPressed: () {
                        _setCurrentDigit(3);
                      }),
                ],
              ),
            ),
             Expanded(
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "4",
                      onPressed: () {
                        _setCurrentDigit(4);
                      }),
                  _otpKeyboardInputButton(
                      label: "5",
                      onPressed: () {
                        _setCurrentDigit(5);
                      }),
                  _otpKeyboardInputButton(
                      label: "6",
                      onPressed: () {
                        _setCurrentDigit(6);
                      }),
                ],
              ),
            ),
             Expanded(
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "7",
                      onPressed: () {
                        _setCurrentDigit(7);
                      }),
                  _otpKeyboardInputButton(
                      label: "8",
                      onPressed: () {
                        _setCurrentDigit(8);
                      }),
                  _otpKeyboardInputButton(
                      label: "9",
                      onPressed: () {
                        _setCurrentDigit(9);
                      }),
                ],
              ),
            ),
             Expanded(
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                   SizedBox(
                    width: 80.0,
                  ),
                  _otpKeyboardInputButton(
                      label: "0",
                      onPressed: () {
                        _setCurrentDigit(0);
                      }),
                  _otpKeyboardActionButton(
                      label:  Icon(
                        Icons.backspace,
                        color: ColorData.renkBeyaz,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_sixthDigit != null) {
                            _sixthDigit= null;
                          }else if (_fifthDigit != null) {
                            _fifthDigit = null;
                          } else if (_fourthDigit != null) {
                            _fourthDigit = null;
                          } else if (_thirdDigit != null) {
                            _thirdDigit = null;
                          } else if (_secondDigit != null) {
                            _secondDigit = null;
                          } else if (_firstDigit != null) {
                            _firstDigit = null;
                          }
                        });
                      }),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  void initState() {
    totalTimeInSeconds = time;
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: time))
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() {
            _hideResendButton = !_hideResendButton;
          });
        }
      });
    _controller.reverse(from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _startCountdown();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: ColorData.renkLacivert,
      body:  Container(
        width: _screenSize.width,
        child: _getInputPart,
      ),
    );
  }

  Widget _otpTextField(int digit) {
    return Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child:  Text(
        digit != null ? digit.toString() : "",
        style: TextStyleData.boldBeyaz30
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        width: 2.0,
        color: ColorData.renkBeyaz,
      ))),
    );
  }

  Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
    return  Material(
      color: Colors.transparent,
      child:  InkWell(
        onTap: onPressed,
        borderRadius:  BorderRadius.circular(40.0),
        child:  Container(
          height: 80.0,
          width: 80.0,
          decoration:  BoxDecoration(
            shape: BoxShape.circle,
          ),
          child:  Center(
            child:  Text(
              label,
              style: TextStyleData.boldBeyaz30
            ),
          ),
        ),
      ),
    );
  }

  _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
    return  InkWell(
      onTap: onPressed,
      borderRadius:  BorderRadius.circular(40.0),
      child:  Container(
        height: 80.0,
        width: 80.0,
        decoration:  BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: label,
        ),
      ),
    );
  }

  void _setCurrentDigit(int i) {
    setState(() {
      _currentDigit = i;
      if (_firstDigit == null) {
        _firstDigit = _currentDigit;
      } else if (_secondDigit == null) {
        _secondDigit = _currentDigit;
      } else if (_thirdDigit == null) {
        _thirdDigit = _currentDigit;
      } else if (_fourthDigit == null) {
        _fourthDigit = _currentDigit;
      } else if (_fifthDigit== null) {
        _fifthDigit = _currentDigit;
      } else if (_sixthDigit == null) {
        _sixthDigit = _currentDigit;

        var otp = _firstDigit.toString() + _secondDigit.toString() + _thirdDigit.toString() + _fourthDigit.toString() + _fifthDigit.toString()+_sixthDigit.toString();


      }
    });
  }

  Future<Null> _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  void clearOtp() {
    _sixthDigit = null;
    _fifthDigit = null;
    _fourthDigit = null;
    _thirdDigit = null;
    _secondDigit = null;
    _firstDigit = null;
    setState(() {});
  }
}

class OtpTimer extends StatelessWidget {
  final AnimationController controller;
  double fontSize;
  Color timeColor = ColorData.renkLacivert;

  OtpTimer(this.controller, this.fontSize, this.timeColor);

  String get timerString {
    Duration duration = controller.duration * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration get duration {
    Duration duration = controller.duration;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return  Text(
            timerString,
            style: TextStyleData.boldBeyaz18,
          );
        });
  }
}
