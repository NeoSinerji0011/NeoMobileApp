import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/screens/MainScreen.dart';
import 'package:sigortadefterim/screens/WelcomeScreen.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';

class OnboardingScreen extends StatefulWidget {
  bool isLogin = false;
  OnboardingScreen();
  OnboardingScreen.isLogin(islogin) {
    this.isLogin = islogin;
  }

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 7;
  SharedPreferences prefs;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i <= _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  bool checkisLoginProcess = false, checkisLoginResult = false;
  @override
  void initState() {
    super.initState();
    print(widget.isLogin);
    //pageLoad();
  }

  Future pageLoad() async {
    await getSharedPreferences();
    if (prefs.getBool('remember')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        UtilsPolicy.onLoading(context);
        UtilsPolicy().getKullaniciInfo().whenComplete(() {
          WebAPI.refreshToken(token: UtilsPolicy.kullaniciInfo[3])
              .then((value) {
            if (value["message"] != "")
              Utils.setKullaniciInfo(
                UtilsPolicy.kullaniciInfo[0],
                UtilsPolicy.kullaniciInfo[1],
                UtilsPolicy.kullaniciInfo[2],
                value["message"],
                UtilsPolicy.kullaniciInfo[4],
                UtilsPolicy.kullaniciInfo[5],
                UtilsPolicy.kullaniciInfo[6],
                int.parse(UtilsPolicy.kullaniciInfo[7]),
                UtilsPolicy.kullaniciInfo[8],
                UtilsPolicy.kullaniciInfo[9],
                UtilsPolicy.kullaniciInfo[10],
                UtilsPolicy.kullaniciInfo[11],
                UtilsPolicy.kullaniciInfo[12],
                UtilsPolicy.kullaniciInfo[13],
                UtilsPolicy.kullaniciInfo[14],
              );
            checkisLoginResult = value["status"];
            checkisLoginProcess = true;
            UtilsPolicy.closeLoader(context);
          });
        });
      });
    } else
      checkisLoginProcess = true;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 1.0),
      height: 15.0,
      width: isActive ? 24.0 : 24.0,
      decoration: BoxDecoration(
        border: Border.all(color: ColorData.renkYesil),
        shape: BoxShape.circle,
        color: isActive ? Colors.white : ColorData.renkMavi,
        //borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                ColorData.renkLacivert.withOpacity(0.9),
                ColorData.renkMavi.withOpacity(0.9),
              ],
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: PageView(
                        physics: ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: <Widget>[
                          firstOnboardingScreen(),
                          buildOnboardingPage(
                              text: 'Bütün Sigortalarınız Bir Arada Cebinizde',
                              pageNo: '04',
                              image: 'assets/images/onboarding_6.jpg'),
                          buildOnboardingPage(
                              text:
                                  'Sigortasız kalmayın. Yenilemeleriniz için otomatik hatırlatma yapalım.',
                              pageNo: '07',
                              image: 'assets/images/onboarding_5.jpg'),
                          buildOnboardingPage(
                              text:
                                  'Tek tıkla, farklı acente ve sigorta şirketlerinden karşılaştırmalı fiyat teklifi alın.',
                              pageNo: '06',
                              image: 'assets/images/onboarding_4.jpg'),
                          buildOnboardingPage(
                              text:
                                  'Kaza sonrası, hasar dosyanızı uygulamadan anında kendiniz hazırlayıp otomatik iletin',
                              pageNo: '03',
                              image: 'assets/images/onboarding_3.jpg'),
                          buildOnboardingPage(
                              text:
                                  'Poliçenize bağlı en yakın ve en uygun tamir servislerini hastaneleri, eczaneleri vs. harita üzerinde görün.',
                              pageNo: '05',
                              image: 'assets/images/onboarding_7.jpg'),
                          buildOnboardingPage(
                              text:
                                  'Acil durumda sevdiklerinizi bilgilendirelim.',
                              pageNo: '01',
                              image: 'assets/images/onboarding_1.jpg'),
                          buildOnboardingPage(
                              text:
                                  'Sevdiklerinizin acil durumundan sizi haberdar edelim.',
                              pageNo: '02',
                              image: 'assets/images/onboarding_2.jpg'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _currentPage > 0
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 35.0, right: 10.0, bottom: 10.0, top: 15.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _buildPageIndicator(),
                        ),
                      ),
                    )
                  : Text(''),
            ],
          ),
        ),
      ),
      // bottomSheet: _currentPage == _numPages - 1
      //     ? Container(
      //         height: 100.0,
      //         width: double.infinity,
      //         color: Colors.white,
      //         child: GestureDetector(
      //           onTap: () => print('Get started'),
      //           child: Center(
      //             child: Padding(
      //               padding: EdgeInsets.only(bottom: 30.0),
      //               child: Text(
      //                 'Get started',
      //                 style: TextStyle(
      //                   color: Color(0xFF5B16D0),
      //                   fontSize: 20.0,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       )
      //     : Text(''),
    );
  }

  Widget buildOnboardingPage({String text, String pageNo, String image}) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                image,
              ),
            ),
          ),
          height: double.infinity,
        ),
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topRight,
              //   end: Alignment.bottomLeft,
              //   // stops: [0.1, 0.4, 0.7, 0.9],
              //   colors: [
              //     ColorData.renkLacivert.withOpacity(0.7),
              //     ColorData.renkMavi.withOpacity(0.7),
              //   ],
              // ),
              ),
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 9.0),
                      child: SizedBox(),
                    ),
                    GestureDetector(
                      child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 1.5, color: ColorData.renkYesil),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.close,
                              color: ColorData.renkYesil,
                            ),
                          )),
                      onTap: () {
                        if (widget.isLogin) {
                          Navigator.of(context).pop();
                        } else
                          checkIsLogin();
                      },
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyleData.standartYesil36,
                      ),
                    ),
                    // _currentPage == _numPages
                    //     ? Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: InkWell(
                    //           onTap: () {
                    //             Navigator.pushReplacement(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                     builder: (context) => WelcomeScreen()));
                    //           },
                    //           child: Text(
                    //             'Bitir',
                    //             style: TextStyle(
                    //               color: ColorData.renkYesil,
                    //               fontSize: 20.0,
                    //             ),
                    //             textAlign: TextAlign.left,
                    //           ),
                    //         ),
                    //     )
                    //     : Text(''),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('remember') == null) {
      prefs.setBool('remember', false);
    }
  }

  Future checkIsLogin() async {
    //if (!checkisLoginProcess) return;

    await getSharedPreferences();
    prefs.setBool("onboard", false);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => prefs.getBool('remember')
                ? checkisLoginResult
                    ? MainScreen(
                        currentIndex: 0,
                      )
                    : WelcomeScreen()
                : WelcomeScreen()));
  }

  Widget firstOnboardingScreen() {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topRight,
              //   end: Alignment.bottomLeft,
              //   // stops: [0.1, 0.4, 0.7, 0.9],
              //   colors: [
              //     ColorData.renkLacivert.withOpacity(0.7),
              //     ColorData.renkMavi.withOpacity(0.7),
              //   ],
              // ),
              ),
          child: Padding(
            padding: EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 9.0),
                      child: SizedBox(),
                    ),
                    GestureDetector(
                      child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 1.5, color: ColorData.renkYesil),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.close,
                              color: ColorData.renkYesil,
                            ),
                          )),
                      onTap: () {
                        if (widget.isLogin) {
                          Navigator.of(context).pop();
                        } else
                          checkIsLogin();
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '7 Adımda',
                      style: TextStyleData.extraBoldYesil40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Text(
                        'SigortaDefterim ne işe yarar?',
                        style: TextStyleData.standartYesil36,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        "",
                        style: TextStyleData.standartYesil36,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        "",
                        style: TextStyleData.standartYesil36,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: 
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Image(
                          image: AssetImage(
                            'assets/images/logo-2.png',
                          ),
                          height: 200.0,
                          width: 200.0,
                        )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _currentPage != _numPages - 1
                        ? Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              },
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Lütfen Kaydırınız >>',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: ColorData.renkYesil,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Text(''),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
