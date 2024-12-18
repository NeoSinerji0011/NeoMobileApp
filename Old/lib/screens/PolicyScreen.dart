import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart'; 

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sigortadefterim/models/Acente.dart';
import 'package:sigortadefterim/models/AracKullanimTarzi.dart';
import 'package:sigortadefterim/models/AracMarka.dart';
import 'package:sigortadefterim/models/AracTip.dart';
import 'package:sigortadefterim/models/IL.dart';
import 'package:sigortadefterim/models/ILCE.dart';
import 'package:sigortadefterim/models/Meslek.dart';
import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';
import 'package:sigortadefterim/models/SigortaSirketi.dart';
import 'package:sigortadefterim/models/SigortaTuru.dart';
import 'package:sigortadefterim/models/Ulke.dart';
import 'package:sigortadefterim/screens/MainScreen.dart';
import 'package:sigortadefterim/screens/RenewPolicy.dart';
import 'package:sigortadefterim/screens/ReportDamage.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/widgets/Drawers.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';
import 'package:sigortadefterim/widgets/MyExpansionTile.dart';
import 'package:sigortadefterim/models/Policy/AllPolicyResponse.dart';
import 'package:sigortadefterim/models/UlkeTipi.dart';
import 'package:sigortadefterim/models/BinaKullanimSekli.dart';
import 'package:sigortadefterim/models/YapiTarzi.dart';
import 'package:sigortadefterim/models/YapimYili.dart';

import 'package:pdf/widgets.dart' as PDF;
import 'package:image/image.dart' as ResizedImage;
import 'PolicyDetailScreen.dart';

class PolicyScreen extends StatefulWidget {
  int currentIndex = 0;
  bool isOffer = false;

  PolicyScreen({
    this.currentIndex,
    this.isOffer,
  });

  @override
  _PolicyScreenState createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen>
    with TickerProviderStateMixin {
  List<PolicyResponse> _tumuPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _tumuGuncelPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _tumuGecmisPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _aracPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _trafikPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _kaskoPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _konutPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _daskPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _saglikPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _genelSaglikPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _tamamlayiciSaglikPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _seyahatPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _digerPolicyList = List<PolicyResponse>();

  List<PolicyResponse> _geciciManuelList = List<PolicyResponse>();

  List<double> _location = List<double>();

  SigortaSirketi _sigortaSirketiforPDF =
      SigortaSirketi(sirketAdi: "Sigorta Şirketi");
  SigortaTuru _sigortaTuru = SigortaTuru(bransAdi: "Sigorta Türü");
  AracMarka _marka = AracMarka(markaAdi: "Marka");
  AracTip _aracTipi = AracTip(tipAdi: "Araç Tipi");
  AracKullanimTarzi _kullanimTarzi =
      AracKullanimTarzi(kullanimTarzi: "Kullanım Tarzı");

  String _kisiSayisi;
//  String _ulkeTuru = "Seyahat Edilicek Ülke Türü";
  UlkeTipi _ulkeTuru = UlkeTipi(ulkeTipiAdi: "Seyahat Edilicek Ülke Türü");
  Ulke _gidilenUlke = Ulke(ulkeAdi: "Seyahat Edilicek Ülke");

  BinaKullanimSekli _binaKullanimSekli =
      BinaKullanimSekli(binaKullanimTarziAdi: "Kullanım Tarzı");
  YapiTarzi _yapiTarzi = YapiTarzi(yapiTarziAdi: "Yapı Tarzı");
  YapimYili _yapimYili = YapimYili(yapimYiliAdi: "Yapım Yılı");
  IL _il = IL(ilAdi: "İl");
  ILCE _ilce = ILCE(ilceAdi: "İlçe");

  Meslek _meslek = Meslek(meslekAdi: "Meslek");

  List _sigortaSirketi = List();
  List _acente = List();
  List _aracTip = List();
  List _aracMarka = List();
  List _ilList = List();
  List _ilceList = List();
  List _meslekList = List();
  List _ulkeList = List();
  List _sigortaTurList = List();
  GlobalKey _topPartKey = GlobalKey();
  Size _topPartSize = Size(0, 0);

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _tumuRefreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _tumuGuncelRefreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _tumuGecmisRefreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _aracRefreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _konutRefreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _daskRefreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _saglikRefreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _seyahatRefreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _digerRefreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  TabController _tumuTabController;
  TabController _aracTabController;
  TabController _saglikTabController;
  TabController _digerTabController;
  List _digerTabItems;

  List<String> _kullaniciInfo = List<String>();
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();

    currentIndex = widget.currentIndex;
    WidgetsBinding.instance.addPostFrameCallback(_onBuildCompleted);
    _tumuTabController = TabController(
        length: (widget.isOffer ? 1 : 2), initialIndex: 0, vsync: this);
    _aracTabController = TabController(length: 3, initialIndex: 0, vsync: this);
    _saglikTabController =
        TabController(length: 3, initialIndex: 0, vsync: this);

    _kullaniciInfo.addAll(["", "", "11111111111", "", ""]);

    getPolicyInformation().whenComplete(() {
      _getTumuPoliciesList();
    });
  }

  @override
  void dispose() {
    if (_aracTabController != null)
      _aracTabController.removeListener(() => this);
    if (_tumuTabController != null)
      _tumuTabController.removeListener(() => this);
    if (_digerTabController != null)
      _digerTabController.removeListener(() => this);
    if (_saglikTabController != null)
      _saglikTabController.removeListener(() => this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorData.renkSolukBeyaz,
        drawer:
            MenuDrawer(adSoyad: _kullaniciInfo[0] + " " + _kullaniciInfo[1]),
        body: Column(
          children: <Widget>[
            Container(
              //margin: EdgeInsets.only(top:15),
              key: _topPartKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          widget.isOffer == false
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 36,
                                        bottom: 16,
                                        left: 16,
                                        right: 16),
                                    child: IconButton(
                                        icon: Image.asset(
                                            "assets/images/ic_menu.png"),
                                        onPressed: () {
                                          _scaffoldKey.currentState
                                              .openDrawer();
                                        }),
                                  ),
                                )
                              : Container(),
                          widget.isOffer == true
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 36, bottom: 16, left: 16, right: 16),
                                  child: InkWell(
                                    onTap: () => Navigator.of(context)
                                        .pop() /*  Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => MainScreen(
                                                  currentIndex: 0,
                                                ))) */
                                    ,
                                    child: Image.asset(
                                      "assets/images/circle_arrow.png",
                                      height: 30,
                                      fit: BoxFit.cover,
                                      color: ColorData.renkLacivert,
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 36, bottom: 16, left: 16, right: 16),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                widget.isOffer == false
                                    ? "Poliçeler"
                                    : "Teklif Talep Listem",
                                style: TextStyleData.standartLacivert24,
                              ),
                            )),
                      ),
                    ],
                  ),
                  _getTopSlider(),
                  SizedBox(height: 8),
                  !widget.isOffer
                      ? currentIndex == 0
                          ? _getTumuTabBar()
                          : Container()
                      : Container(),
                  currentIndex == 1 ? _getAracTabBar() : Container(),
                  //widget.currentIndex == 6 ? _getDigerTabBar() : Container(),
                  currentIndex == 4 ? _getSaglikTabBar() : Container(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height -
                          (_topPartSize.height + 50)),
                  height: 200,
                  child: _getUrunList()),
            )
          ],
        ),
      ),
    );
  }

  Widget _getAracTabBar() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Divider(
            color: ColorData.renkLacivert.withOpacity(.3),
            endIndent: 120,
            indent: 120,
            thickness: 2,
          ),
        ),
        Center(
          child: TabBar(
              tabs: [
                Tab(text: 'TÜMÜ'),
                Tab(text: 'KASKO'),
                Tab(text: 'TRAFİK')
              ],
              controller: _aracTabController,
              labelStyle: TextStyleData.boldLacivert12,
              unselectedLabelStyle: TextStyleData.boldLacivert12,
              indicator: UnderlineTabIndicator(
                  borderSide:
                      BorderSide(color: ColorData.renkLacivert, width: 4),
                  insets: EdgeInsets.only(bottom: 8)),
              labelColor: ColorData.renkLacivert,
              unselectedLabelColor: ColorData.renkLacivert,
              indicatorColor: ColorData.renkMavi,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              onTap: (value) {
                setState(() {});
              }),
        ),
      ],
    );
  }

  Widget _getTumuTabBar() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Divider(
            color: ColorData.renkLacivert.withOpacity(.3),
            endIndent: 120,
            indent: 120,
            thickness: 2,
          ),
        ),
        Center(
          child: TabBar(
              tabs: [
                Tab(text: 'GÜNCEL'),
                Tab(text: 'GEÇMİŞ'),
              ],
              controller: _tumuTabController,
              labelStyle: TextStyleData.boldLacivert12,
              unselectedLabelStyle: TextStyleData.boldLacivert12,
              indicator: UnderlineTabIndicator(
                  borderSide:
                      BorderSide(color: ColorData.renkLacivert, width: 4),
                  insets: EdgeInsets.only(bottom: 8)),
              labelColor: ColorData.renkLacivert,
              unselectedLabelColor: ColorData.renkLacivert,
              indicatorColor: ColorData.renkMavi,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              onTap: (value) {
                setState(() {});
              }),
        ),
      ],
    );
  }

  Widget _getSaglikTabBar() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Divider(
            color: ColorData.renkLacivert.withOpacity(.5),
            endIndent: 60,
            indent: 60,
            thickness: 2,
          ),
        ),
        Center(
          child: TabBar(
            tabs: [
              Tab(text: 'TÜMÜ'),
              Tab(text: 'GENEL SAĞLIK'),
              Tab(text: 'TAMAMLAYICI SAĞLIK')
            ],
            controller: _saglikTabController,
            labelStyle: TextStyleData.boldLacivert12,
            unselectedLabelStyle: TextStyleData.boldLacivert12,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: ColorData.renkLacivert, width: 4),
                insets: EdgeInsets.only(bottom: 8)),
            labelColor: ColorData.renkLacivert,
            unselectedLabelColor: ColorData.renkLacivert,
            indicatorColor: ColorData.renkMavi,
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            onTap: (value) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _getDigerTabBar() {
    _digerTabItems = UtilsPolicy.findSigortaTuru(-1, true);
    _digerTabController = TabController(
        length: _digerTabItems.length + 1, initialIndex: 0, vsync: this);
    return TabBar(
      tabs: _getDigerTabItems(),
      controller: _digerTabController,
      labelStyle: TextStyleData.boldLacivert24,
      unselectedLabelStyle: TextStyleData.boldLacivert16,
      indicator: BoxDecoration(
          color: ColorData.renkKoyuGri,
          borderRadius: BorderRadius.circular(30)),
      labelColor: ColorData.renkLacivert,
      indicatorColor: ColorData.renkMavi,
      indicatorSize: TabBarIndicatorSize.tab,
      isScrollable: true,
    );
  }

  List<Tab> _getDigerTabItems() {
    List<Tab> items = List<Tab>();
    items.add(Tab(text: "Hepsi"));

    _digerTabItems.forEach((item) {
      items.add(Tab(text: item.bransAdi));
    });
    return items;
  }

  List<Widget> _getDigerTabView() {
    List<Widget> items = List<Widget>();

    items.add(RefreshIndicator(
      key: _digerRefreshIndicatorKey,
      onRefresh: () => _getDigerPoliciesList(),
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _digerPolicyList.length,
          itemBuilder: (BuildContext bContext, index) {
            var item = _digerPolicyList[index];
            return InkWell(
              child: _createDigerListItem(item),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PolicyDetailScreen(
                              policyResponse: item,
                              isTitleOffer: widget.isOffer,
                            )));
              },
            );
          }),
    ));

    _digerTabItems.forEach((item) {
      items.add(
        ListView.builder(
            itemCount: _digerPolicyList.length,
            itemBuilder: (BuildContext bContext, index) {
              var item = _digerPolicyList[index];
              return InkWell(
                child: _createDigerListItem(item),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PolicyDetailScreen(
                                policyResponse: item,
                                isTitleOffer: widget.isOffer,
                              )));
                },
              );
            }),
      );
    });
    return items;
  }

  Widget _getUrunList() {
    switch (currentIndex) {
      case 0:
        return _tumuList();
      case 1:
        return _aracList();
      case 2:
        return _konutList();
      case 3:
        return _daskList();
      case 4:
        return _saglikList();
      case 5:
        return _seyahatList();
      case 6:
        return _digerList();
      default:
        return _tumuList();
    }
  }

  List<Widget> tumuListHeader() {
    List<Widget> temp = List<Widget>();
    if (!widget.isOffer) {
      temp.add(RefreshIndicator(
        key: _tumuGuncelRefreshIndicatorKey,
        onRefresh: () => _getTumuPoliciesList(),
        child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: _tumuGuncelPolicyList.length,
            itemBuilder: (BuildContext bContext, index) {
              var item = _tumuGuncelPolicyList[index];
              return InkWell(
                child: _createTumuListItem(item),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PolicyDetailScreen(
                                policyResponse: item,
                                isTitleOffer: widget.isOffer,
                              )));
                },
              );
            }),
      ));
      temp.add(RefreshIndicator(
        key: _tumuGecmisRefreshIndicatorKey,
        onRefresh: () => _getTumuPoliciesList(),
        child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: _tumuGecmisPolicyList.length,
            itemBuilder: (BuildContext bContext, index) {
              var item = _tumuGecmisPolicyList[index];
              return InkWell(
                child: _createTumuListItem(item),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PolicyDetailScreen(
                                policyResponse: item,
                                isTitleOffer: widget.isOffer,
                              )));
                },
              );
            }),
      ));
    } else {
      temp.add(RefreshIndicator(
        key: _tumuGuncelRefreshIndicatorKey,
        onRefresh: () => _getTumuPoliciesList(),
        child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: _tumuPolicyList.length,
            itemBuilder: (BuildContext bContext, index) {
              var item = _tumuPolicyList[index];
              return InkWell(
                child: _createTumuListItem(item),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PolicyDetailScreen(
                                policyResponse: item,
                                isTitleOffer: widget.isOffer,
                              )));
                },
              );
            }),
      ));
    }
    return temp;
  }

  Widget _tumuList() {
    return TabBarView(
      controller: _tumuTabController,
      children: tumuListHeader(),
    );
  }

  Widget _aracList() {
    return TabBarView(
      controller: _aracTabController,
      children: <Widget>[
        RefreshIndicator(
          key: _aracRefreshIndicatorKey,
          onRefresh: () => refreshList(),
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _aracPolicyList.length,
              itemBuilder: (BuildContext bContext, index) {
                var item = _aracPolicyList[index];
                return InkWell(
                  child: _createAracListItem(item),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PolicyDetailScreen(
                                  policyResponse: item,
                                  isTitleOffer: widget.isOffer,
                                )));
                  },
                );
              }),
        ),
        RefreshIndicator(
          onRefresh: () =>
              AllPolicyResponse(widget.isOffer).getAracPolicyList(),
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _kaskoPolicyList.length,
              itemBuilder: (BuildContext bContext, index) {
                var item = _kaskoPolicyList[index];
                return InkWell(
                  child: _createAracListItem(item),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PolicyDetailScreen(
                                  policyResponse: item,
                                  isTitleOffer: widget.isOffer,
                                )));
                  },
                );
              }),
        ),
        RefreshIndicator(
          onRefresh: () =>
              AllPolicyResponse(widget.isOffer).getAracPolicyList(),
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _trafikPolicyList.length,
              itemBuilder: (BuildContext bContext, index) {
                var item = _trafikPolicyList[index];
                return InkWell(
                  child: _createAracListItem(item),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PolicyDetailScreen(
                                  policyResponse: item,
                                  isTitleOffer: widget.isOffer,
                                )));
                  },
                );
              }),
        ),
      ],
    );
  }

  Widget _konutList() {
    return RefreshIndicator(
      key: _konutRefreshIndicatorKey,
      onRefresh: () => refreshList(),
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _konutPolicyList.length,
          itemBuilder: (BuildContext bContext, index) {
            var item = _konutPolicyList[index];
            return InkWell(
              child: _createKonutListItem(item),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PolicyDetailScreen(
                              policyResponse: item,
                              isTitleOffer: widget.isOffer,
                            )));
              },
            );
          }),
    );
  }

  Widget _daskList() {
    return RefreshIndicator(
      key: _daskRefreshIndicatorKey,
      onRefresh: () => refreshList(),
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _daskPolicyList.length,
          itemBuilder: (BuildContext bContext, index) {
            var item = _daskPolicyList[index];
            return InkWell(
              child: _createDaskListItem(item),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PolicyDetailScreen(
                              policyResponse: item,
                              isTitleOffer: widget.isOffer,
                            )));
              },
            );
          }),
    );
  }

  Widget _saglikList() {
    return TabBarView(
      controller: _saglikTabController,
      children: <Widget>[
        RefreshIndicator(
          key: _saglikRefreshIndicatorKey,
          onRefresh: () => refreshList(),
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _saglikPolicyList.length,
              itemBuilder: (BuildContext bContext, index) {
                var item = _saglikPolicyList[index];
                return InkWell(
                  child: _createSaglikListItem(item),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PolicyDetailScreen(
                                  policyResponse: item,
                                  isTitleOffer: widget.isOffer,
                                )));
                  },
                );
              }),
        ),
        RefreshIndicator(
          onRefresh: () => refreshList(),
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _genelSaglikPolicyList.length,
              itemBuilder: (BuildContext bContext, index) {
                var item = _genelSaglikPolicyList[index];
                return InkWell(
                  child: _createSaglikListItem(item),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PolicyDetailScreen(
                                  policyResponse: item,
                                  isTitleOffer: widget.isOffer,
                                )));
                  },
                );
              }),
        ),
        RefreshIndicator(
          onRefresh: () => refreshList(),
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _tamamlayiciSaglikPolicyList.length,
              itemBuilder: (BuildContext bContext, index) {
                var item = _tamamlayiciSaglikPolicyList[index];
                return InkWell(
                  child: _createSaglikListItem(item),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PolicyDetailScreen(
                                  policyResponse: item,
                                  isTitleOffer: widget.isOffer,
                                )));
                  },
                );
              }),
        ),
      ],
    );
  }

  Widget _seyahatList() {
    return RefreshIndicator(
      key: _seyahatRefreshIndicatorKey,
      onRefresh: () => refreshList(),
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _seyahatPolicyList.length,
          itemBuilder: (BuildContext bContext, index) {
            var item = _seyahatPolicyList[index];
            return InkWell(
              child: _createSeyahatListItem(item),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PolicyDetailScreen(
                              policyResponse: item,
                              isTitleOffer: widget.isOffer,
                            )));
              },
            );
          }),
    );
  }

  Widget _digerList() {
    return RefreshIndicator(
      key: _digerRefreshIndicatorKey,
      onRefresh: () => refreshList(),
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _digerPolicyList.length,
          itemBuilder: (BuildContext bContext, index) {
            var item = _digerPolicyList[index];
            return InkWell(
              child: _createDigerListItem(item),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PolicyDetailScreen(
                              policyResponse: item,
                              isTitleOffer: widget.isOffer,
                            )));
              },
            );
          }),
    );
  }

  Future<Null> refreshList() async {
    switch (currentIndex) {
      case 0:
        break;
      case 1:
        AllPolicyResponse(widget.isOffer).getAracPolicyList().whenComplete(() {
          if (mounted) {
            setState(() {
              _trafikPolicyList = AllPolicyResponse.staticTrafikPolicyList
                  .where((x) => x.teklifPolice == (widget.isOffer ? 1 : 0))
                  .toList();
              _kaskoPolicyList = AllPolicyResponse.staticKaskoPolicyList
                  .where((x) => x.teklifPolice == (widget.isOffer ? 1 : 0))
                  .toList();
              _aracPolicyList = AllPolicyResponse.staticAracPolicyList
                  .where((x) => x.teklifPolice == (widget.isOffer ? 1 : 0))
                  .toList();
              if (widget.isOffer) {
                /* var temp = _trafikPolicyList
                    .where((element) => element.teklifIslemNo == null)
                    .toList();
                 
                _trafikPolicyList = _trafikPolicyList
                    .where((x) => x.teklifIslemNo != null)
                    .toList();
                _trafikPolicyList
                    .sort((b, a) => a.teklifIslemNo.compareTo(b.teklifIslemNo)); */
                _trafikPolicyList =
                    UtilsPolicy.sortArrayList(_trafikPolicyList);
                _kaskoPolicyList = UtilsPolicy.sortArrayList(_kaskoPolicyList);
                _aracPolicyList = UtilsPolicy.sortArrayList(_aracPolicyList);

                /*  _kaskoPolicyList
                    .where((x) => x.teklifIslemNo != null)
                    .toList()
                    .sort((b, a) => a.teklifIslemNo.compareTo(b.teklifIslemNo));
                _aracPolicyList
                    .where((x) => x.teklifIslemNo != null)
                    .toList()
                    .sort((b, a) => a.teklifIslemNo.compareTo(b.teklifIslemNo)); */
              }
            });
          }
        });
        break;
      case 2:
        AllPolicyResponse(widget.isOffer)
            .getKonutPolicyList()
            .whenComplete(() => setState(() {
                  _konutPolicyList = AllPolicyResponse.staticKonutPolicyList
                      .where((x) => x.teklifPolice == (widget.isOffer ? 1 : 0))
                      .toList();
                  if (widget.isOffer) {
                    _konutPolicyList =
                        UtilsPolicy.sortArrayList(_konutPolicyList);
                    /* _konutPolicyList.sort(
                        (b, a) => a.teklifIslemNo.compareTo(b.teklifIslemNo)); */
                  }
                }));
        break;
      case 3:
        AllPolicyResponse(widget.isOffer)
            .getDaskPolicyList()
            .whenComplete(() => setState(() {
                  _daskPolicyList = AllPolicyResponse.staticDaskPolicyList
                      .where((x) => x.teklifPolice == (widget.isOffer ? 1 : 0))
                      .toList();
                  if (widget.isOffer) {
                    _daskPolicyList =
                        UtilsPolicy.sortArrayList(_daskPolicyList);
                    /*  _daskPolicyList.sort(
                        (b, a) => a.teklifIslemNo.compareTo(b.teklifIslemNo)); */
                  }
                }));
        break;
      case 4:
        AllPolicyResponse(widget.isOffer)
            .getSaglikPolicyList()
            .whenComplete(() => setState(() {
                  _saglikPolicyList = AllPolicyResponse.staticSaglikPolicyList
                      .where((x) => x.teklifPolice == (widget.isOffer ? 1 : 0))
                      .toList();
                  _tamamlayiciSaglikPolicyList = AllPolicyResponse
                      .staticTamamlayiciSaglikPolicyList
                      .where((x) => x.teklifPolice == (widget.isOffer ? 1 : 0))
                      .toList();
                  _genelSaglikPolicyList = AllPolicyResponse
                      .staticGenelSaglikPolicyList
                      .where((x) => x.teklifPolice == (widget.isOffer ? 1 : 0))
                      .toList();
                  if (widget.isOffer) {
                    _saglikPolicyList =
                        UtilsPolicy.sortArrayList(_saglikPolicyList);
                    _tamamlayiciSaglikPolicyList =
                        UtilsPolicy.sortArrayList(_tamamlayiciSaglikPolicyList);
                    _genelSaglikPolicyList =
                        UtilsPolicy.sortArrayList(_genelSaglikPolicyList);

                    /* _saglikPolicyList.sort(
                        (b, a) => a.teklifIslemNo.compareTo(b.teklifIslemNo));
                    _tamamlayiciSaglikPolicyList.sort(
                        (b, a) => a.teklifIslemNo.compareTo(b.teklifIslemNo));
                    _genelSaglikPolicyList.sort(
                        (b, a) => a.teklifIslemNo.compareTo(b.teklifIslemNo)); */
                  }
                }));
        break;
      case 5:
        AllPolicyResponse(widget.isOffer)
            .getSeyahatPolicyList()
            .whenComplete(() => setState(() {
                  _seyahatPolicyList = AllPolicyResponse.staticSeyahatPolicyList
                      .where((x) => x.teklifPolice == (widget.isOffer ? 1 : 0))
                      .toList();
                  if (widget.isOffer) {
                    _seyahatPolicyList =
                        UtilsPolicy.sortArrayList(_seyahatPolicyList);
                    /* _seyahatPolicyList.sort(
                        (b, a) => a.teklifIslemNo.compareTo(b.teklifIslemNo)); */
                  }
                }));
        break;
      case 6:
        AllPolicyResponse(widget.isOffer)
            .getDigerPolicyList()
            .whenComplete(() => setState(() {
                  _digerPolicyList = AllPolicyResponse.staticDigerPolicyList
                      .where((x) => x.teklifPolice == (widget.isOffer ? 1 : 0))
                      .toList();
                  if (widget.isOffer) {
                    _digerPolicyList =
                        UtilsPolicy.sortArrayList(_digerPolicyList);
                    /* _digerPolicyList.sort(
                        (b, a) => a.teklifIslemNo.compareTo(b.teklifIslemNo)); */
                  }
                }));
        break;
      default:
        break;
    }
  }

  Widget _createTumuListItem(PolicyResponse item) {
    switch (item.bransKodu) {
      case 1:
        return _createAracListItem(item);
      case 2:
        return _createAracListItem(item);
      case 4:
        return _createSaglikListItem(item);
      case 11:
        return _createDaskListItem(item);
      case 21:
        return _createSeyahatListItem(item);
      case 22:
        return _createKonutListItem(item);
      default:
        return _createDigerListItem(item);
    }
  }

  Widget _createAracListItemOldVersion(PolicyResponse item) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () => UtilsPolicy.showSnackBar(_scaffoldKey,
                "\"Poliçe Ekle\" ile kayıt edilen poliçeleri simgeler."),
            child: Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.all(8),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: ColorData.renkYesil,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset("assets/images/ic_hand.png"),
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: ColorData.renkBeyaz,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [BoxDecorationData.shadow]),
            child: MyExpansionTile(
              key: Key("${item.policeNumarasi}/${item.yenilemeNo}"),
              backgroundColor: Colors.transparent,
              initiallyExpanded: false,
              leading: Image.asset(
                  "assets/car_icons/${item.markaKodu == null ? "no_image" : (item.markaKodu)}.png",
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            item.markaKodu == null
                                ? "Bulunamadı"
                                : UtilsPolicy.findMarka(item.markaKodu),
                            style: TextStyleData.standartLacivert14),
                        Text(
                            item.tipKodu == null
                                ? "Bulunamadı"
                                : UtilsPolicy.findModel(
                                    item.tipKodu, item.markaKodu),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyleData.boldLacivert),
                        Container(
                          padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                          decoration: BoxDecoration(
                              color: ColorData.renkGri,
                              borderRadius: BorderRadius.circular(33)),
                          child: Text(
                              item.plaka == null ? "Bulunmadı" : item.plaka,
                              style: TextStyleData.boldLacivert),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                          decoration: BoxDecoration(
                              color: ColorData.renkKoyuYesil,
                              borderRadius: BorderRadius.circular(33)),
                          child: Text("  Başlangıç  ",
                              style: TextStyleData.boldBeyaz12)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                        child: Text(
                            item.baslangicTarihi == null
                                ? "Bulunamadı"
                                : DateFormat("dd/MM/yyyy").format(
                                    DateTime.parse(item.baslangicTarihi)),
                            style: TextStyleData.boldSiyah12),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                          decoration: BoxDecoration(
                              color: ColorData.renkKirmizi,
                              borderRadius: BorderRadius.circular(33)),
                          child: Text("       Bitiş       ",
                              style: TextStyleData.boldBeyaz12)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                        child: Text(
                            item.bitisTarihi == null
                                ? "Bulunamadı"
                                : DateFormat("dd/MM/yyyy")
                                    .format(DateTime.parse(item.bitisTarihi)),
                            style: TextStyleData.boldSiyah12),
                      )
                    ],
                  )
                ],
              ),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: ColorData.renkGri,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        width: 75,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                            color: ColorData.renkKoyuGri,
                                            borderRadius:
                                                BorderRadius.circular(33)),
                                        child: Text("Acente",
                                            style: TextStyleData.boldLacivert)),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          150,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
                                      child: Text(
                                          item.acenteUnvani == null
                                              ? "Portal Üyesi Değil"
                                              : _findAcente(item.acenteUnvani)
                                                  .unvani,
                                          style:
                                              TextStyleData.standartLacivert),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
                                      child: InkWell(
                                        child: Icon(Icons.phone_forwarded,
                                            color: ColorData.renkLacivert),
                                        onTap: () {
                                          if (item.acenteUnvani == null)
                                            UtilsPolicy.showSnackBar(
                                                _scaffoldKey,
                                                "Acentenin telefon bilgisi bulunamadı");
                                          else
                                            Utils.launchURL(
                                                "tel:${_findAcente(item.acenteUnvani).telefon}");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        width: 75,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                            color: ColorData.renkKoyuGri,
                                            borderRadius:
                                                BorderRadius.circular(33)),
                                        child: Text("Sigorta Şirketi",
                                            style: TextStyleData.boldLacivert,
                                            textAlign: TextAlign.center)),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          150,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
                                      child: Text(
                                          item.sirketKodu == null
                                              ? "Bulunamadı"
                                              : UtilsPolicy.findSirket(
                                                      item.sirketKodu)
                                                  .sirketAdi,
                                          style:
                                              TextStyleData.standartLacivert),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
                                      child: InkWell(
                                        child: Icon(Icons.phone_forwarded,
                                            color: ColorData.renkLacivert),
                                        onTap: () {
                                          if (item.sirketKodu == null)
                                            UtilsPolicy.showSnackBar(
                                                _scaffoldKey,
                                                "şirketin telefon bilgisi bulunamadı");
                                          else
                                            Utils.launchURL(
                                                "tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        width: 75,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                            color: ColorData.renkKoyuGri,
                                            borderRadius:
                                                BorderRadius.circular(33)),
                                        child: Text(
                                          "Tip",
                                          style: TextStyleData.boldLacivert,
                                        )),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          150,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
                                      child: Text(
                                          item.tipKodu == null
                                              ? "Bulunamadı"
                                              : UtilsPolicy.findModel(
                                                  item.tipKodu, item.markaKodu),
                                          style:
                                              TextStyleData.standartLacivert),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 75,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
                                      decoration: BoxDecoration(
                                          color: ColorData.renkKoyuGri,
                                          borderRadius:
                                              BorderRadius.circular(33)),
                                      child: Text("Model",
                                          style: TextStyleData.boldLacivert),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
                                      child: Text(
                                          item.modelYili == null
                                              ? "Bulunamadı"
                                              : item.modelYili.toString(),
                                          style:
                                              TextStyleData.standartLacivert),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width: 75,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                            color: ColorData.renkKoyuGri,
                                            borderRadius:
                                                BorderRadius.circular(33)),
                                        child: Text(
                                          "Açıklama",
                                          style: TextStyleData.boldLacivert,
                                          textAlign: TextAlign.center,
                                        )),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
                                      child: Text(
                                          item.aciklama == null
                                              ? "Girilmemiş"
                                              : item.aciklama.toString(),
                                          style:
                                              TextStyleData.standartLacivert),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  boxShadow: [BoxDecorationData.shadow]),
                              child: OutlineButton(
                                child: Text("Yenile",
                                    style: TextStyleData.boldLacivert),
                                shape: StadiumBorder(),
                                borderSide: BorderSide(
                                    color: ColorData.renkLacivert,
                                    style: BorderStyle.solid,
                                    width: 2),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          RenewPolicy(policyResponse: item)));
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  boxShadow: [BoxDecorationData.shadow]),
                              child: OutlineButton(
                                child: Text("Hasar bildir",
                                    style: TextStyleData.boldLacivert),
                                shape: StadiumBorder(),
                                borderSide: BorderSide(
                                    color: ColorData.renkLacivert,
                                    style: BorderStyle.solid,
                                    width: 2),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ReportDamage(policyResponse: item)));
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  boxShadow: [BoxDecorationData.shadow]),
                              child: OutlineButton(
                                child: Text("PDF",
                                    style: TextStyleData.boldLacivert),
                                shape: StadiumBorder(),
                                borderSide: BorderSide(
                                    color: ColorData.renkLacivert,
                                    style: BorderStyle.solid,
                                    width: 2),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ],
    );
  }

  Widget _createAracListItem(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: ColorData.renkBeyaz,
            borderRadius: BorderRadius.circular(33),
            boxShadow: [BoxDecorationData.shadow]),
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                      child: Image.asset("assets/images/ic_car.png"),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //Text(item.markaKodu == null ? "Bulunamadı" : _findMarka(item.markaKodu), style: TextStyleData.standartLacivert14),
                          Text(
                              item.tipKodu == null
                                  ? "Bulunamadı"
                                  : UtilsPolicy.findMarka(item.markaKodu),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldMavi18),
                        ],
                      ),
                    ),
                    item.teklifPolice == 1
                        ? Column(
                            children: [
                              /* item.teklifPolice != 1
                                  ? InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          "assets/images/ic_hand.png",
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              MyDialog(
                                            dialogKind: "ManuelPoliceInfo",
                                          ),
                                        );
                                      },
                                    )
                                  : Container(), */
                              InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.picture_as_pdf,
                                      color: ColorData.renkLacivert,
                                    )),
                                onTap: () {
                                  pdfButtonClick(item);
                                },
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
                item.teklifPolice == 1
                    ? Row(
                        children: <Widget>[
                          SizedBox(width: 62),
                          SizedBox(
                              width: 75,
                              child: Text("Teklif Talep No",
                                  style: TextStyleData.boldSolukGri)),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 48),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: ColorData.renkGri,
                                  borderRadius: BorderRadius.circular(33)),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                    item.teklifIslemNo == null
                                        ? "Bulunamadı"
                                        : item.teklifIslemNo.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyleData.boldAcikSiyah),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Tip", style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.tipKodu == null
                                  ? "Bulunamadı"
                                  : UtilsPolicy.findModel(
                                      item.tipKodu, item.markaKodu),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Plaka", style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.plaka == null ? "Bulunmadı" : item.plaka,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Başlangıç",
                            style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.baslangicTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(item.baslangicTarihi)),
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Bitiş", style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 0),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 2,
                          ),
                          child: Text(
                              item.bitisTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy")
                                      .format(DateTime.parse(item.bitisTarihi)),
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 48.0,
                      child: InkWell(
                        child: Image.asset("assets/images/ic_info-2.png",
                            height: 20.0,
                            width: 20.0,
                            color: UtilsPolicy.chooseDateColor(
                                bitisTarihi: item.bitisTarihi)),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => MyDialog(
                              dialogKind: "PoliceDayInfo",
                              color: UtilsPolicy.chooseDateColor(
                                  bitisTarihi: item.bitisTarihi),
                              body: UtilsPolicy.chooseTextInfo(
                                  bitisTarihi: item.bitisTarihi),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
            Image.asset(
              "assets/images/ic_right_arrow.png",
              fit: BoxFit.contain,
              width: 12,
              height: 12,
              color: ColorData.renkMavi,
            ),
          ],
        ));
  }

  void pdfButtonClick(item) {
    if (widget.isOffer) {
      if (item.pdfUrl == null || item.pdfUrl == "")
        UtilsPolicy.showSnackBar(_scaffoldKey, "Dosya Bulunamadı");
      else {
        var tempContext = context;
        UtilsPolicy.onLoading(tempContext,
            body: "Pdf yükleniyor lütfen bekleyiniz...");
        showDialog(
          context: context,
          builder: (BuildContext context) => MyDialog(
            createPDF: (i) async{
              if (i == 1) {
               await UtilsPolicy.openPdfPrintingFromUrl(item.pdfUrl).then((value) {
                  if (!value) {
                    UtilsPolicy.showSnackBar(_scaffoldKey, "Dosya Bulunamadı");
                  }
                });
              }
              UtilsPolicy.closeLoader(tempContext);
            },
            dialogKind: "PdfSoru",
          ),
        );
      }
    } else
      showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog(
          createPDF: (i) {
            if (i == 1) {
              getPolicyInformationWithCode(item)
                  .whenComplete(() => pdfCreate(item));
            }
          },
          dialogKind: "PdfSoru",
        ),
      );
  }

  Widget _createKonutListItemOldVersion(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: ColorData.renkBeyaz,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxDecorationData.shadow]),
        child: MyExpansionTile(
          key: Key("${item.policeNumarasi}/${item.yenilemeNo}"),
          backgroundColor: Colors.transparent,
          initiallyExpanded: false,
          leading: Image.asset("assets/images/ic_apartment.png",
              width: 50, height: 50, fit: BoxFit.contain),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        item.ilKodu == null
                            ? "Bulunamadı"
                            : "${UtilsPolicy.findIL(item.ilKodu)}/${UtilsPolicy.findILCE(item.ilceKodu)}",
                        style: TextStyleData.standartLacivert14),
                    Text(item.adres == null ? "Bulunamadı" : item.adres,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyleData.boldLacivert),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      decoration: BoxDecoration(
                          color: ColorData.renkKoyuYesil,
                          borderRadius: BorderRadius.circular(33)),
                      child: Text("  Başlangıç  ",
                          style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(
                        item.baslangicTarihi == null
                            ? "Bulunamadı"
                            : DateFormat("dd/MM/yyyy")
                                .format(DateTime.parse(item.baslangicTarihi)),
                        style: TextStyleData.boldSiyah12),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      decoration: BoxDecoration(
                          color: ColorData.renkKirmizi,
                          borderRadius: BorderRadius.circular(33)),
                      child: Text("       Bitiş       ",
                          style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(
                        item.bitisTarihi == null
                            ? "Bulunamadı"
                            : DateFormat("dd/MM/yyyy")
                                .format(DateTime.parse(item.bitisTarihi)),
                        style: TextStyleData.boldSiyah12),
                  )
                ],
              )
            ],
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: ColorData.renkGri,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 75,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: ColorData.renkKoyuGri,
                                      borderRadius: BorderRadius.circular(33)),
                                  child: Text("Acente",
                                      style: TextStyleData.boldLacivert),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.acenteUnvani == null
                                          ? "Portal Üyesi Değil"
                                          : _findAcente(item.acenteUnvani)
                                              .unvani,
                                      style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded,
                                        color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.acenteUnvani == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,
                                            "Acentenin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL(
                                            "tel:${_findAcente(item.acenteUnvani).telefon}");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 75,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: ColorData.renkKoyuGri,
                                      borderRadius: BorderRadius.circular(33)),
                                  child: Text("Sigorta Şirketi",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.sirketKodu == null
                                          ? "Bulunamadı"
                                          : UtilsPolicy.findSirket(
                                                  item.sirketKodu)
                                              .sirketAdi,
                                      style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded,
                                        color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.sirketKodu == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,
                                            "şirketin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL(
                                            "tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: ColorData.renkKoyuGri,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Text(
                                      "Adres",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.adres == null
                                          ? "Girilmemiş"
                                          : item.adres,
                                      style: TextStyleData.standartLacivert),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: ColorData.renkKoyuGri,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Text(
                                      "Bina Bedeli",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.binaBedeli == null
                                          ? "Bulunamadı"
                                          : NumberFormat("###,###,###,###")
                                              .format(item.binaBedeli),
                                      style: TextStyleData.standartLacivert),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: ColorData.renkKoyuGri,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Text(
                                      "Eşya Bedeli",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.esyaBedeli == null
                                          ? "Bulunamadı"
                                          : NumberFormat("###,###,###,###")
                                              .format(item.esyaBedeli),
                                      style: TextStyleData.standartLacivert),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: ColorData.renkKoyuGri,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Text(
                                      "Açıklama",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.aciklama == null
                                          ? "Girilmemiş"
                                          : item.aciklama.toString(),
                                      style: TextStyleData.standartLacivert),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxDecorationData.shadow]),
                          child: OutlineButton(
                            child: Text("Yenile",
                                style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                                color: ColorData.renkLacivert,
                                style: BorderStyle.solid,
                                width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      RenewPolicy(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxDecorationData.shadow]),
                          child: OutlineButton(
                            child: Text("Hasar bildir",
                                style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                                color: ColorData.renkLacivert,
                                style: BorderStyle.solid,
                                width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ReportDamage(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxDecorationData.shadow]),
                          child: OutlineButton(
                            child:
                                Text("PDF", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                                color: ColorData.renkLacivert,
                                style: BorderStyle.solid,
                                width: 2),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget _createKonutListItem(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: ColorData.renkBeyaz,
            borderRadius: BorderRadius.circular(33),
            boxShadow: [BoxDecorationData.shadow]),
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                      child: Image.asset("assets/images/ic_apartment.png"),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              item.ilKodu == null
                                  ? "Bulunamadı"
                                  : "${UtilsPolicy.findIL(item.ilKodu)}/${UtilsPolicy.findILCE(item.ilceKodu)}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyleData.boldMavi18),
                        ],
                      ),
                    ),
                    item.teklifPolice == 1
                        ? Column(
                            children: [
                              /* InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "assets/images/ic_hand.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => MyDialog(
                                      dialogKind: "ManuelPoliceInfo",
                                    ),
                                  );
                                },
                              ), */
                              InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.picture_as_pdf,
                                      color: ColorData.renkLacivert,
                                    )),
                                onTap: () {
                                  pdfButtonClick(item);
                                },
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
                SizedBox(height: 8),
                item.teklifPolice == 1
                    ? Row(
                        children: <Widget>[
                          SizedBox(width: 62),
                          SizedBox(
                              width: 75,
                              child: Text("Teklif Talep No",
                                  style: TextStyleData.boldSolukGri)),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 48),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: ColorData.renkGri,
                                  borderRadius: BorderRadius.circular(33)),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                    item.teklifIslemNo == null
                                        ? "Bulunamadı"
                                        : item.teklifIslemNo.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyleData.boldAcikSiyah),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Adres", style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.adres == null ? "Bulunamadı" : item.adres,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Başlangıç",
                            style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.baslangicTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(item.baslangicTarihi)),
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Bitiş", style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.bitisTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy")
                                      .format(DateTime.parse(item.bitisTarihi)),
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 48.0,
                      child: InkWell(
                        child: Image.asset("assets/images/ic_info-2.png",
                            height: 20.0,
                            width: 20.0,
                            color: UtilsPolicy.chooseDateColor(
                                bitisTarihi: item.bitisTarihi)),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => MyDialog(
                              dialogKind: "PoliceDayInfo",
                              color: UtilsPolicy.chooseDateColor(
                                  bitisTarihi: item.bitisTarihi),
                              body: UtilsPolicy.chooseTextInfo(
                                  bitisTarihi: item.bitisTarihi),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
            Image.asset(
              "assets/images/ic_right_arrow.png",
              fit: BoxFit.contain,
              width: 12,
              height: 12,
              color: ColorData.renkMavi,
            ),
          ],
        ));
  }

  Widget _createDaskListItemOldVersion(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: ColorData.renkBeyaz,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxDecorationData.shadow]),
        child: MyExpansionTile(
          key: Key("${item.policeNumarasi}/${item.yenilemeNo}"),
          backgroundColor: Colors.transparent,
          initiallyExpanded: false,
          leading: Image.asset("assets/images/ic_dask.png",
              width: 50, height: 50, fit: BoxFit.contain),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        item.ilKodu == null
                            ? "Bulunamadı"
                            : "${UtilsPolicy.findIL(item.ilKodu)}/${UtilsPolicy.findILCE(item.ilceKodu)}",
                        style: TextStyleData.standartLacivert14),
                    Text(item.adres == null ? "Bulunamadı" : item.adres,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyleData.boldLacivert),
                    Container(
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      decoration: BoxDecoration(
                          color: ColorData.renkGri,
                          borderRadius: BorderRadius.circular(33)),
                      child: Text(
                          item.daireBrut == null
                              ? "Bulunmadı"
                              : "${item.daireBrut.toString()} m²",
                          style: TextStyleData.boldLacivert),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      decoration: BoxDecoration(
                          color: ColorData.renkKoyuYesil,
                          borderRadius: BorderRadius.circular(33)),
                      child: Text("  Başlangıç  ",
                          style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(
                        item.baslangicTarihi == null
                            ? "Bulunamadı"
                            : DateFormat("dd/MM/yyyy")
                                .format(DateTime.parse(item.baslangicTarihi)),
                        style: TextStyleData.boldSiyah12),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      decoration: BoxDecoration(
                          color: ColorData.renkKirmizi,
                          borderRadius: BorderRadius.circular(33)),
                      child: Text("       Bitiş       ",
                          style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(
                        item.bitisTarihi == null
                            ? "Bulunamadı"
                            : DateFormat("dd/MM/yyyy")
                                .format(DateTime.parse(item.bitisTarihi)),
                        style: TextStyleData.boldSiyah12),
                  )
                ],
              )
            ],
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: ColorData.renkGri,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 75,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: ColorData.renkKoyuGri,
                                      borderRadius: BorderRadius.circular(33)),
                                  child: Text("Acente",
                                      style: TextStyleData.boldLacivert),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.acenteUnvani == null
                                          ? "Portal Üyesi Değil"
                                          : _findAcente(item.acenteUnvani)
                                              .unvani,
                                      style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded,
                                        color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.acenteUnvani == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,
                                            "Acentenin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL(
                                            "tel:${_findAcente(item.acenteUnvani).telefon}");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 75,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: ColorData.renkKoyuGri,
                                      borderRadius: BorderRadius.circular(33)),
                                  child: Text("Sigorta Şirketi",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.sirketKodu == null
                                          ? "Bulunamadı"
                                          : UtilsPolicy.findSirket(
                                                  item.sirketKodu)
                                              .sirketAdi,
                                      style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded,
                                        color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.sirketKodu == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,
                                            "şirketin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL(
                                            "tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: ColorData.renkKoyuGri,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Text(
                                      "Adres",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.adres == null
                                          ? "Girilmemiş"
                                          : item.adres,
                                      style: TextStyleData.standartLacivert),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: ColorData.renkKoyuGri,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Text(
                                      "Yapı Tarzı",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.binaYapiTarzi == null
                                          ? "Bulunamadı"
                                          : Utils.getYapiTarzi(
                                              index: item.binaYapiTarzi),
                                      style: TextStyleData.standartLacivert),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: ColorData.renkKoyuGri,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Text(
                                      "Yapım Yılı",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.binaYapimYili == null
                                          ? "Bulunamadı"
                                          : item.binaYapimYili.toString(),
                                      style: TextStyleData.standartLacivert),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: ColorData.renkKoyuGri,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Text(
                                      "Kullanım Şekli",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.binaKullanimSekli == null
                                          ? "Bulunamadı"
                                          : Utils.getBinaKullanimSekli(
                                              index: item.binaKullanimSekli),
                                      style: TextStyleData.standartLacivert),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: ColorData.renkKoyuGri,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Text(
                                      "Açıklama",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.aciklama == null
                                          ? "Girilmemiş"
                                          : item.aciklama.toString(),
                                      style: TextStyleData.standartLacivert),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxDecorationData.shadow]),
                          child: OutlineButton(
                            child: Text("Yenile",
                                style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                                color: ColorData.renkLacivert,
                                style: BorderStyle.solid,
                                width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      RenewPolicy(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxDecorationData.shadow]),
                          child: OutlineButton(
                            child: Text("Hasar bildir",
                                style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                                color: ColorData.renkLacivert,
                                style: BorderStyle.solid,
                                width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ReportDamage(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxDecorationData.shadow]),
                          child: OutlineButton(
                            child:
                                Text("PDF", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                                color: ColorData.renkLacivert,
                                style: BorderStyle.solid,
                                width: 2),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget _createDaskListItem(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: ColorData.renkBeyaz,
            borderRadius: BorderRadius.circular(33),
            boxShadow: [BoxDecorationData.shadow]),
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                      child: Image.asset("assets/images/ic_dask.png"),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              item.ilKodu == null
                                  ? "Bulunamadı"
                                  : "${UtilsPolicy.findIL(item.ilKodu)}/${UtilsPolicy.findILCE(item.ilceKodu)}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyleData.boldMavi18),
                        ],
                      ),
                    ),
                    item.teklifPolice == 1
                        ? Column(
                            children: [
                              /* InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "assets/images/ic_hand.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => MyDialog(
                                      dialogKind: "ManuelPoliceInfo",
                                    ),
                                  );
                                },
                              ), */
                              InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.picture_as_pdf,
                                      color: ColorData.renkLacivert,
                                    )),
                                onTap: () {
                                  pdfButtonClick(item);
                                },
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
                SizedBox(height: 8),
                item.teklifPolice == 1
                    ? Row(
                        children: <Widget>[
                          SizedBox(width: 62),
                          SizedBox(
                              width: 75,
                              child: Text("Teklif Talep No",
                                  style: TextStyleData.boldSolukGri)),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 48),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: ColorData.renkGri,
                                  borderRadius: BorderRadius.circular(33)),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                    item.teklifIslemNo == null
                                        ? "Bulunamadı"
                                        : item.teklifIslemNo.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyleData.boldAcikSiyah),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Daire m²",
                            style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.daireBrut == null
                                  ? "Bulunamadı"
                                  : item.daireBrut.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Adres", style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.adres == null ? "Bulunamadı" : item.adres,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Başlangıç",
                            style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.baslangicTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(item.baslangicTarihi)),
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Bitiş", style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.bitisTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy")
                                      .format(DateTime.parse(item.bitisTarihi)),
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 48.0,
                      child: InkWell(
                        child: Image.asset("assets/images/ic_info-2.png",
                            height: 20.0,
                            width: 20.0,
                            color: UtilsPolicy.chooseDateColor(
                                bitisTarihi: item.bitisTarihi)),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => MyDialog(
                              dialogKind: "PoliceDayInfo",
                              color: UtilsPolicy.chooseDateColor(
                                  bitisTarihi: item.bitisTarihi),
                              body: UtilsPolicy.chooseTextInfo(
                                  bitisTarihi: item.bitisTarihi),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
            Image.asset(
              "assets/images/ic_right_arrow.png",
              fit: BoxFit.contain,
              width: 12,
              height: 12,
              color: ColorData.renkMavi,
            ),
          ],
        ));
  }

  Widget _createSaglikListItemOldVersion(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: ColorData.renkBeyaz,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxDecorationData.shadow]),
        child: MyExpansionTile(
          key: Key("${item.policeNumarasi}/${item.yenilemeNo}"),
          backgroundColor: Colors.transparent,
          initiallyExpanded: false,
          leading: Image.asset("assets/images/ic_healt.png",
              width: 50, height: 50, fit: BoxFit.contain),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Meslek", style: TextStyleData.standartLacivert14),
                    Text(
                        item.meslek == null
                            ? "Bulunamadı"
                            : "${UtilsPolicy.findMeslek(item.meslek)}",
                        style: TextStyleData.boldLacivert),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      decoration: BoxDecoration(
                          color: ColorData.renkKoyuYesil,
                          borderRadius: BorderRadius.circular(33)),
                      child: Text("  Başlangıç  ",
                          style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(
                        item.baslangicTarihi == null
                            ? "Bulunamadı"
                            : DateFormat("dd/MM/yyyy")
                                .format(DateTime.parse(item.baslangicTarihi)),
                        style: TextStyleData.boldSiyah12),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      decoration: BoxDecoration(
                          color: ColorData.renkKirmizi,
                          borderRadius: BorderRadius.circular(33)),
                      child: Text("       Bitiş       ",
                          style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(
                        item.bitisTarihi == null
                            ? "Bulunamadı"
                            : DateFormat("dd/MM/yyyy")
                                .format(DateTime.parse(item.bitisTarihi)),
                        style: TextStyleData.boldSiyah12),
                  )
                ],
              )
            ],
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: ColorData.renkGri,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 75,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: ColorData.renkKoyuGri,
                                      borderRadius: BorderRadius.circular(33)),
                                  child: Text("Acente",
                                      style: TextStyleData.boldLacivert),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.acenteUnvani == null
                                          ? "Portal Üyesi Değil"
                                          : _findAcente(item.acenteUnvani)
                                              .unvani,
                                      style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded,
                                        color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.acenteUnvani == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,
                                            "Acentenin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL(
                                            "tel:${_findAcente(item.acenteUnvani).telefon}");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 75,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: ColorData.renkKoyuGri,
                                      borderRadius: BorderRadius.circular(33)),
                                  child: Text("Sigorta Şirketi",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.sirketKodu == null
                                          ? "Bulunamadı"
                                          : UtilsPolicy.findSirket(
                                                  item.sirketKodu)
                                              .sirketAdi,
                                      style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded,
                                        color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.sirketKodu == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,
                                            "şirketin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL(
                                            "tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: ColorData.renkKoyuGri,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Text(
                                      "Açıklama",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.aciklama == null
                                          ? "Girilmemiş"
                                          : item.aciklama.toString(),
                                      style: TextStyleData.standartLacivert),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxDecorationData.shadow]),
                          child: OutlineButton(
                            child: Text("Yenile",
                                style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                                color: ColorData.renkLacivert,
                                style: BorderStyle.solid,
                                width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      RenewPolicy(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxDecorationData.shadow]),
                          child: OutlineButton(
                            child: Text("Hasar bildir",
                                style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                                color: ColorData.renkLacivert,
                                style: BorderStyle.solid,
                                width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ReportDamage(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxDecorationData.shadow]),
                          child: OutlineButton(
                            child:
                                Text("PDF", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                                color: ColorData.renkLacivert,
                                style: BorderStyle.solid,
                                width: 2),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget _createSaglikListItem(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: ColorData.renkBeyaz,
            borderRadius: BorderRadius.circular(33),
            boxShadow: [BoxDecorationData.shadow]),
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                      child: Image.asset("assets/images/ic_healt.png"),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              item.meslek == null
                                  ? "Bulunamadı"
                                  : "${UtilsPolicy.findMeslek(item.meslek)}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyleData.boldMavi18),
                        ],
                      ),
                    ),
                    item.teklifPolice == 1
                        ? Column(
                            children: [
                              /* InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "assets/images/ic_hand.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => MyDialog(
                                      dialogKind: "ManuelPoliceInfo",
                                    ),
                                  );
                                },
                              ), */
                              InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.picture_as_pdf,
                                      color: ColorData.renkLacivert,
                                    )),
                                onTap: () {
                                  pdfButtonClick(item);
                                },
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
                SizedBox(height: 8),
                item.teklifPolice == 1
                    ? Row(
                        children: <Widget>[
                          SizedBox(width: 62),
                          SizedBox(
                              width: 75,
                              child: Text("Teklif Talep No",
                                  style: TextStyleData.boldSolukGri)),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 48),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: ColorData.renkGri,
                                  borderRadius: BorderRadius.circular(33)),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                    item.teklifIslemNo == null
                                        ? "Bulunamadı"
                                        : item.teklifIslemNo.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyleData.boldAcikSiyah),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Başlangıç",
                            style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.baslangicTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(item.baslangicTarihi)),
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Bitiş", style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.bitisTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy")
                                      .format(DateTime.parse(item.bitisTarihi)),
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 48.0,
                      child: InkWell(
                        child: Image.asset("assets/images/ic_info-2.png",
                            height: 20.0,
                            width: 20.0,
                            color: UtilsPolicy.chooseDateColor(
                                bitisTarihi: item.bitisTarihi)),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => MyDialog(
                              dialogKind: "PoliceDayInfo",
                              color: UtilsPolicy.chooseDateColor(
                                  bitisTarihi: item.bitisTarihi),
                              body: UtilsPolicy.chooseTextInfo(
                                  bitisTarihi: item.bitisTarihi),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
            Image.asset(
              "assets/images/ic_right_arrow.png",
              fit: BoxFit.contain,
              width: 12,
              height: 12,
              color: ColorData.renkMavi,
            ),
          ],
        ));
  }

  Widget _createSeyahatListItemOldVersion(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: ColorData.renkBeyaz,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxDecorationData.shadow]),
        child: MyExpansionTile(
          key: Key("${item.policeNumarasi}/${item.yenilemeNo}"),
          backgroundColor: Colors.transparent,
          initiallyExpanded: false,
          leading: Image.asset("assets/images/ic_travel.png",
              width: 50, height: 50, fit: BoxFit.contain),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        item.seyahatUlkeKodu == null
                            ? "Bulunamadı"
                            : UtilsPolicy.findUlke(item.seyahatUlkeKodu, true),
                        style: TextStyleData.standartLacivert14),
                    Text(
                        item.seyahatUlkeKodu == null
                            ? "Bulunamadı"
                            : UtilsPolicy.findUlke(item.seyahatUlkeKodu, false),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyleData.boldLacivert),
                    Container(
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      decoration: BoxDecoration(
                          color: ColorData.renkGri,
                          borderRadius: BorderRadius.circular(33)),
                      child: Text(
                          item.seyahatEdenKisiSayisi == null
                              ? "Bulunmadı"
                              : "${item.seyahatEdenKisiSayisi} Kişi",
                          style: TextStyleData.boldLacivert),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      decoration: BoxDecoration(
                          color: ColorData.renkKoyuYesil,
                          borderRadius: BorderRadius.circular(33)),
                      child: Text("  Başlangıç  ",
                          style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(
                        item.seyahatGidisTarihi == null
                            ? "Bulunamadı"
                            : DateFormat("dd/MM/yyyy").format(
                                DateTime.parse(item.seyahatGidisTarihi)),
                        style: TextStyleData.boldSiyah12),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      decoration: BoxDecoration(
                          color: ColorData.renkKirmizi,
                          borderRadius: BorderRadius.circular(33)),
                      child: Text("       Bitiş       ",
                          style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(
                        item.seyahatDonusTarihi == null
                            ? "Bulunamadı"
                            : DateFormat("dd/MM/yyyy").format(
                                DateTime.parse(item.seyahatDonusTarihi)),
                        style: TextStyleData.boldSiyah12),
                  )
                ],
              )
            ],
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: ColorData.renkGri,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: ColorData.renkKoyuGri,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Text("Acente",
                                        style: TextStyleData.boldLacivert)),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.acenteUnvani == null
                                          ? "Portal Üyesi Değil"
                                          : _findAcente(item.acenteUnvani)
                                              .unvani,
                                      style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded,
                                        color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.acenteUnvani == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,
                                            "Acentenin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL(
                                            "tel:${_findAcente(item.acenteUnvani).telefon}");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: ColorData.renkKoyuGri,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Text("Sigorta Şirketi",
                                        style: TextStyleData.boldLacivert,
                                        textAlign: TextAlign.center)),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.sirketKodu == null
                                          ? "Bulunamadı"
                                          : UtilsPolicy.findSirket(
                                                  item.sirketKodu)
                                              .sirketAdi,
                                      style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded,
                                        color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.sirketKodu == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,
                                            "şirketin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL(
                                            "tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: ColorData.renkKoyuGri,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Text(
                                      "Açıklama",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.aciklama == null
                                          ? "Girilmemiş"
                                          : item.aciklama.toString(),
                                      style: TextStyleData.standartLacivert),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxDecorationData.shadow]),
                          child: OutlineButton(
                            child: Text("Hasar bildir",
                                style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                                color: ColorData.renkLacivert,
                                style: BorderStyle.solid,
                                width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ReportDamage(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxDecorationData.shadow]),
                          child: OutlineButton(
                            child:
                                Text("PDF", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                                color: ColorData.renkLacivert,
                                style: BorderStyle.solid,
                                width: 2),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget _createSeyahatListItem(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: ColorData.renkBeyaz,
            borderRadius: BorderRadius.circular(33),
            boxShadow: [BoxDecorationData.shadow]),
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                      child: Image.asset("assets/images/ic_travel.png"),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              item.seyahatUlkeKodu == null
                                  ? "Bulunamadı"
                                  : UtilsPolicy.findUlke(
                                      item.seyahatUlkeKodu, false),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyleData.boldMavi18),
                        ],
                      ),
                    ),
                    item.teklifPolice == 1
                        ? Column(
                            children: [
                              /*  InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "assets/images/ic_hand.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => MyDialog(
                                      dialogKind: "ManuelPoliceInfo",
                                    ),
                                  );
                                },
                              ), */
                              InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.picture_as_pdf,
                                      color: ColorData.renkLacivert,
                                    )),
                                onTap: () {
                                  pdfButtonClick(item);
                                },
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
                SizedBox(height: 8),
                item.teklifPolice == 1
                    ? Row(
                        children: <Widget>[
                          SizedBox(width: 62),
                          SizedBox(
                              width: 75,
                              child: Text("Teklif Talep No",
                                  style: TextStyleData.boldSolukGri)),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 48),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: ColorData.renkGri,
                                  borderRadius: BorderRadius.circular(33)),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                    item.teklifIslemNo == null
                                        ? "Bulunamadı"
                                        : item.teklifIslemNo.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyleData.boldAcikSiyah),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Ülke Türü",
                            style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.seyahatUlkeKodu == null
                                  ? "Bulunamadı"
                                  : UtilsPolicy.findUlke(
                                      item.seyahatUlkeKodu, true),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Kişi Sayısı",
                            style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.seyahatEdenKisiSayisi == null
                                  ? "Bulunamadı"
                                  : item.seyahatEdenKisiSayisi.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Gidiş", style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.seyahatGidisTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(item.seyahatGidisTarihi)),
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Dönüş", style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.seyahatDonusTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(item.seyahatDonusTarihi)),
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
            Image.asset(
              "assets/images/ic_right_arrow.png",
              fit: BoxFit.contain,
              width: 12,
              height: 12,
              color: ColorData.renkMavi,
            ),
          ],
        ));
  }

  Widget _createDigerListItemOldVersion(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: ColorData.renkBeyaz,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxDecorationData.shadow]),
        child: MyExpansionTile(
          key: Key("${item.policeNumarasi}/${item.yenilemeNo}"),
          backgroundColor: Colors.transparent,
          initiallyExpanded: false,
          leading: Image.asset("assets/images/ic_other.png",
              width: 50, height: 50, fit: BoxFit.contain),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        item.ilKodu == null
                            ? "Bulunamadı"
                            : "${UtilsPolicy.findIL(item.ilKodu)}/${UtilsPolicy.findILCE(item.ilceKodu)}",
                        style: TextStyleData.standartLacivert14),
                    Text(
                        item.bransKodu == null
                            ? "Bulunamadı"
                            : UtilsPolicy.findSigortaTuru(
                                item.bransKodu, false),
                        style: TextStyleData.boldLacivert),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      decoration: BoxDecoration(
                          color: ColorData.renkKoyuYesil,
                          borderRadius: BorderRadius.circular(33)),
                      child: Text("  Başlangıç  ",
                          style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(
                        item.baslangicTarihi == null
                            ? "Bulunamadı"
                            : DateFormat("dd/MM/yyyy")
                                .format(DateTime.parse(item.baslangicTarihi)),
                        style: TextStyleData.boldSiyah12),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      decoration: BoxDecoration(
                          color: ColorData.renkKirmizi,
                          borderRadius: BorderRadius.circular(33)),
                      child: Text("       Bitiş       ",
                          style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(
                        item.bitisTarihi == null
                            ? "Bulunamadı"
                            : DateFormat("dd/MM/yyyy")
                                .format(DateTime.parse(item.bitisTarihi)),
                        style: TextStyleData.boldSiyah12),
                  )
                ],
              )
            ],
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: ColorData.renkGri,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 75,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: ColorData.renkKoyuGri,
                                      borderRadius: BorderRadius.circular(33)),
                                  child: Text("Acente",
                                      style: TextStyleData.boldLacivert),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.acenteUnvani == null
                                          ? "Portal Üyesi Değil"
                                          : _findAcente(item.acenteUnvani)
                                              .unvani,
                                      style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded,
                                        color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.acenteUnvani == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,
                                            "Acentenin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL(
                                            "tel:${_findAcente(item.acenteUnvani).telefon}");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 75,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: ColorData.renkKoyuGri,
                                      borderRadius: BorderRadius.circular(33)),
                                  child: Text("Sigorta Şirketi",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.sirketKodu == null
                                          ? "Bulunamadı"
                                          : UtilsPolicy.findSirket(
                                                  item.sirketKodu)
                                              .sirketAdi,
                                      style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded,
                                        color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.sirketKodu == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,
                                            "şirketin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL(
                                            "tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: ColorData.renkKoyuGri,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Text(
                                      "Açıklama",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                      item.aciklama == null
                                          ? "Girilmemiş"
                                          : item.aciklama.toString(),
                                      style: TextStyleData.standartLacivert),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxDecorationData.shadow]),
                          child: OutlineButton(
                            child: Text("Yenile",
                                style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                                color: ColorData.renkLacivert,
                                style: BorderStyle.solid,
                                width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      RenewPolicy(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxDecorationData.shadow]),
                          child: OutlineButton(
                            child: Text("Hasar bildir",
                                style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                                color: ColorData.renkLacivert,
                                style: BorderStyle.solid,
                                width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ReportDamage(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxDecorationData.shadow]),
                          child: OutlineButton(
                            child:
                                Text("PDF", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                                color: ColorData.renkLacivert,
                                style: BorderStyle.solid,
                                width: 2),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget _createDigerListItem(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: ColorData.renkBeyaz,
            borderRadius: BorderRadius.circular(33),
            boxShadow: [BoxDecorationData.shadow]),
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                      child: Image.asset("assets/images/ic_other.png"),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              item.bransKodu == null
                                  ? "Bulunamadı"
                                  : UtilsPolicy.findSigortaTuru(
                                      item.bransKodu, false),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyleData.boldMavi18),
                        ],
                      ),
                    ),
                    item.teklifPolice == 1
                        ? Column(
                            children: [
                              /*  InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "assets/images/ic_hand.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => MyDialog(
                                      dialogKind: "ManuelPoliceInfo",
                                    ),
                                  );
                                },
                              ), */
                              InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.picture_as_pdf,
                                      color: ColorData.renkLacivert,
                                    )),
                                onTap: () {
                                  pdfButtonClick(item);
                                },
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
                SizedBox(height: 8),
                item.teklifPolice == 1
                    ? Row(
                        children: <Widget>[
                          SizedBox(width: 62),
                          SizedBox(
                              width: 75,
                              child: Text("Teklif Talep No",
                                  style: TextStyleData.boldSolukGri)),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 48),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: ColorData.renkGri,
                                  borderRadius: BorderRadius.circular(33)),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                    item.teklifIslemNo == null
                                        ? "Bulunamadı"
                                        : item.teklifIslemNo.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyleData.boldAcikSiyah),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("İl", style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.ilKodu == null
                                  ? "Bulunamadı"
                                  : "${UtilsPolicy.findIL(item.ilKodu)}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("İlçe", style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.ilKodu == null
                                  ? "Bulunamadı"
                                  : "${UtilsPolicy.findILCE(item.ilceKodu)}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Başlangıç",
                            style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.baslangicTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(item.baslangicTarihi)),
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Bitiş", style: TextStyleData.boldSolukGri)),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.bitisTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy")
                                      .format(DateTime.parse(item.bitisTarihi)),
                              style: TextStyleData.boldAcikSiyah),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 48.0,
                      child: InkWell(
                        child: Image.asset("assets/images/ic_info-2.png",
                            height: 20.0,
                            width: 20.0,
                            color: UtilsPolicy.chooseDateColor(
                                bitisTarihi: item.bitisTarihi)),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => MyDialog(
                              dialogKind: "PoliceDayInfo",
                              color: UtilsPolicy.chooseDateColor(
                                  bitisTarihi: item.bitisTarihi),
                              body: UtilsPolicy.chooseTextInfo(
                                  bitisTarihi: item.bitisTarihi),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
            Image.asset(
              "assets/images/ic_right_arrow.png",
              fit: BoxFit.contain,
              width: 12,
              height: 12,
              color: ColorData.renkMavi,
            ),
          ],
        ));
  }

  Widget _getTopSlider() {
    final urunSlider = CarouselSlider(
      items: [
        _createSliderItem(
            "https://cdn.pixabay.com/photo/2019/12/17/09/59/horse-4701283_960_720.jpg",
            _kullaniciInfo[0] + " " + _kullaniciInfo[1],
            "99",
            "TÜMÜ",
            !widget.isOffer?_tumuTabController.index == 0
                ? _tumuGuncelPolicyList.length.toString()
                : _tumuGecmisPolicyList.length.toString():_tumuPolicyList.length.toString()),
        _createSliderItem(
            "https://cdn.pixabay.com/photo/2019/12/17/09/59/horse-4701283_960_720.jpg",
            _kullaniciInfo[0] + " " + _kullaniciInfo[1],
            "85",
            "ARAÇ",
            _aracTabController.index == 0
                ? _aracPolicyList.length.toString()
                : _aracTabController.index == 1
                    ? _kaskoPolicyList.length.toString()
                    : _trafikPolicyList.length.toString()),
        _createSliderItem(
            "https://cdn.pixabay.com/photo/2019/12/17/09/59/horse-4701283_960_720.jpg",
            _kullaniciInfo[0] + " " + _kullaniciInfo[1],
            "81",
            "KONUT",
            _konutPolicyList.length.toString()),
        _createSliderItem(
            "https://cdn.pixabay.com/photo/2019/12/17/09/59/horse-4701283_960_720.jpg",
            _kullaniciInfo[0] + " " + _kullaniciInfo[1],
            "48",
            "DASK",
            _daskPolicyList.length.toString()),
        _createSliderItem(
            "https://cdn.pixabay.com/photo/2019/12/17/09/59/horse-4701283_960_720.jpg",
            _kullaniciInfo[0] + " " + _kullaniciInfo[1],
            "65",
            "SAĞLIK",
            _saglikTabController.index == 0
                ? _saglikPolicyList.length.toString()
                : _saglikTabController.index == 1
                    ? _genelSaglikPolicyList.length.toString()
                    : _tamamlayiciSaglikPolicyList.length.toString()),
        _createSliderItem(
            "https://cdn.pixabay.com/photo/2019/12/17/09/59/horse-4701283_960_720.jpg",
            _kullaniciInfo[0] + " " + _kullaniciInfo[1],
            "65",
            "SEYAHAT",
            _seyahatPolicyList.length.toString()),
        _createSliderItem(
            "https://cdn.pixabay.com/photo/2019/12/17/09/59/horse-4701283_960_720.jpg",
            _kullaniciInfo[0] + " " + _kullaniciInfo[1],
            "65",
            "DİĞER",
            _digerPolicyList.length.toString()),
      ],
      autoPlay: false,
      enlargeCenterPage: true,
      viewportFraction: 1.0,
      aspectRatio: 2.0,
      initialPage: currentIndex,
      onPageChanged: ((index) {
        setState(() {
          currentIndex = index;
          WidgetsBinding.instance.addPostFrameCallback(_onBuildCompleted);
        });
      }),
    );
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            height: 77,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: urunSlider,
            )),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: InkWell(
                onTap: () => urunSlider.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear),
                child: Image.asset(
                  "assets/images/arrow_left.png",
                  height: 16,
                  fit: BoxFit.cover,
                ),
              )),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: InkWell(
                onTap: () => urunSlider.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear),
                child: Image.asset(
                  "assets/images/arrow_right.png",
                  height: 16,
                  fit: BoxFit.cover,
                ),
              )),
        ),
      ],
    );
  }

  Widget _createSliderItem(String imageUrl, String adSoyad, String riskOrani,
      String urunAdi, String urunAdeti) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/ikonlar-2.png"),
            alignment: Alignment.topCenter,
            fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(45),
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.topRight,
            stops: [0.1, 0.8],
            colors: [Color(0xff0047FD), Color(0xff0B1A3D)]),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                      color: ColorData.renkKirmizi, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child:
                        //Image.asset("assets/images/clip-3.png"),
                        CircleAvatar(
                            backgroundColor: ColorData.renkKirmizi,
                            backgroundImage: NetworkImage(_kullaniciInfo[4])),
                  )),
              Padding(
                padding: const EdgeInsets.all(4.0),
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
                    //        child: Text("%$riskOrani Risk", style: TextStyleData.boldBeyaz12),
                    //      ),
                    //      SizedBox(width: 2)
                    //    ],
                    //  ),
                    //)
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(urunAdi, style: TextStyleData.standartYesil20),
              ),
              Container(
                height: 24,
                width: 24,
                margin: EdgeInsets.only(left: 8, right: 24),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: ColorData.renkYesil),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(urunAdeti, style: TextStyleData.boldLacivert),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _getTopPartSize() {
    final RenderBox topPartRB = _topPartKey.currentContext.findRenderObject();
    final topPartSize = topPartRB.size;
    setState(() {
      _topPartSize = topPartSize;
    });
  }

  void _onBuildCompleted(_) {
    _getTopPartSize();

    switch (currentIndex) {
      case 0:
        _tumuGuncelRefreshIndicatorKey.currentState.show();
        break;
      case 1:
        _aracRefreshIndicatorKey.currentState.show();
        break;
      case 2:
        _konutRefreshIndicatorKey.currentState.show();
        break;
      case 3:
        _daskRefreshIndicatorKey.currentState.show();
        break;
      case 4:
        _saglikRefreshIndicatorKey.currentState.show();
        break;
      case 5:
        _seyahatRefreshIndicatorKey.currentState.show();
        break;
      case 6:
        _digerRefreshIndicatorKey.currentState.show();
        break;
    }
  }

  Future<Null> _getTumuPoliciesList() async {
    AllPolicyResponse(widget.isOffer)
        .setPolicyIsOffer(
            _trafikPolicyList,
            _kaskoPolicyList,
            _aracPolicyList,
            _konutPolicyList,
            _daskPolicyList,
            _seyahatPolicyList,
            _genelSaglikPolicyList,
            _tamamlayiciSaglikPolicyList,
            _saglikPolicyList,
            _digerPolicyList,
            _tumuPolicyList)
        .whenComplete(() {
      if (!widget.isOffer) {
        _tumuGecmisPolicyList.clear();
        _tumuGuncelPolicyList.clear();
        var currentDate = DateTime.now();
        var diffinDays = 0;
        for (var item in _tumuPolicyList) {
          diffinDays =
              currentDate.difference(DateTime.parse(item.bitisTarihi)).inDays;
          if (diffinDays > 0 && diffinDays <= 30) {
            _tumuGuncelPolicyList.add(item);
            _tumuGecmisPolicyList.add(item);
          } else if (diffinDays <= 0) {
            _tumuGuncelPolicyList.add(item);
          } else if (diffinDays > 0) _tumuGecmisPolicyList.add(item);
        }
      }
      else {
         
        _trafikPolicyList = UtilsPolicy.sortArrayList(_trafikPolicyList);
        _kaskoPolicyList = UtilsPolicy.sortArrayList(_kaskoPolicyList); 
        _konutPolicyList = UtilsPolicy.sortArrayList(_konutPolicyList);
        _daskPolicyList = UtilsPolicy.sortArrayList(_daskPolicyList); 
        _tamamlayiciSaglikPolicyList =
            UtilsPolicy.sortArrayList(_tamamlayiciSaglikPolicyList);
        _genelSaglikPolicyList =
            UtilsPolicy.sortArrayList(_genelSaglikPolicyList);
        _seyahatPolicyList = UtilsPolicy.sortArrayList(_seyahatPolicyList);
        _digerPolicyList = UtilsPolicy.sortArrayList(_digerPolicyList);
        _tumuPolicyList.clear();
        _tumuPolicyList.addAll(
            _trafikPolicyList +
            _kaskoPolicyList +
            _konutPolicyList +
            _daskPolicyList + 
            _tamamlayiciSaglikPolicyList +
            _genelSaglikPolicyList +
            _seyahatPolicyList +
            _digerPolicyList);
        //_tumuPolicyList = UtilsPolicy.sortArrayList(_tumuPolicyList);
 
      }
    });
  }

  Future<Null> _getAracPoliciesList() async {
    await WebAPI.policiesRequest(
            token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "1")
        .then((responseList) {
      setState(() {
        if (widget.isOffer == true) {
          _geciciManuelList.clear();
          for (var item in responseList) {
            if (item.teklifPolice == 1) {
              _geciciManuelList.add(item);
            }
          }

          _trafikPolicyList.clear();
          _trafikPolicyList.addAll(_geciciManuelList);
        } else {
          _geciciManuelList.clear();
          for (var item in responseList) {
            var control = int.tryParse(item.plaka[2].toString()) ?? null;
            //    print(n);
            if (control != null) {
              item.plaka = item.plaka[1].toString() +
                  item.plaka[2].toString() +
                  item.plaka.substring(3);

              _geciciManuelList.add(item);
            } else
              _geciciManuelList.add(item);
          }
          _trafikPolicyList.clear();
          _trafikPolicyList.addAll(_geciciManuelList);
        }
      });
    }).then((value) {
      WebAPI.policiesRequest(
              token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "2")
          .then((responseList) {
        setState(() {
          if (widget.isOffer == true) {
            _geciciManuelList.clear();
            for (var item in responseList) {
              if (item.teklifPolice == 1) {
                _geciciManuelList.add(item);
              }
            }
            _kaskoPolicyList.clear();
            _kaskoPolicyList.addAll(_geciciManuelList);
          } else {
            _kaskoPolicyList.clear();
            _kaskoPolicyList = responseList;
          }
        });
      }).then((value) {
        _aracPolicyList.clear();
        setState(() {
          _aracPolicyList.addAll(_kaskoPolicyList + _trafikPolicyList);
          _aracPolicyList.sort((item1, item2) => item1.baslangicTarihi
              .toString()
              .compareTo(item2.baslangicTarihi.toString()));

          _aracPolicyList = _aracPolicyList.reversed.toList();

          if (widget.isOffer == true) {
            _geciciManuelList.clear();
            for (var i in _aracPolicyList) {
              if (i.teklifPolice == 1) {
                _geciciManuelList.add(i);
              }
            }

            _geciciManuelList.sort((item1, item2) => item1.baslangicTarihi
                .toString()
                .compareTo(item2.baslangicTarihi.toString()));

            _aracPolicyList.clear();
            _aracPolicyList.addAll(_geciciManuelList.reversed.toList());
          }

          return null;
        });
      });
    });
  }

  Future<Null> _getKonutPoliciesList() async {
    await WebAPI.policiesRequest(
            token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "22")
        .then((responseList) {
      setState(() {
        if (widget.isOffer == true) {
          _geciciManuelList.clear();
          for (var item in responseList) {
            if (item.teklifPolice == 1) {
              _geciciManuelList.add(item);
            }
          }
          _konutPolicyList.clear();
          _konutPolicyList.addAll(_geciciManuelList);
        } else {
          _konutPolicyList.clear();
          _konutPolicyList = responseList;
        }
      });
    });
  }

  Future<Null> _getDaskPoliciesList() async {
    await WebAPI.policiesRequest(
            token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "11")
        .then((responseList) {
      setState(() {
        if (widget.isOffer == true) {
          _geciciManuelList.clear();
          for (var item in responseList) {
            if (item.teklifPolice == 1) {
              _geciciManuelList.add(item);
            }
          }
          _daskPolicyList.clear();
          _daskPolicyList.addAll(_geciciManuelList);
        } else {
          _daskPolicyList.clear();
          _daskPolicyList = responseList;
        }
      });
    });
  }

  Future<Null> _getSaglikPoliciesList() async {
    await WebAPI.policiesRequest(
            token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "4")
        .then((responseList) {
      setState(() {
        if (widget.isOffer == true) {
          _geciciManuelList.clear();
          for (var item in responseList) {
            if (item.teklifPolice == 1) {
              _geciciManuelList.add(item);
            }
          }
          _genelSaglikPolicyList.clear();
          _genelSaglikPolicyList.addAll(_geciciManuelList);
        } else {
          _genelSaglikPolicyList.clear();
          _genelSaglikPolicyList = responseList;
        }
      });
    }).then((value) {
      WebAPI.policiesRequest(
              token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "8")
          .then((responseList) {
        setState(() {
          if (widget.isOffer == true) {
            _geciciManuelList.clear();
            for (var item in responseList) {
              if (item.teklifPolice == 1) {
                _geciciManuelList.add(item);
              }
            }
            _tamamlayiciSaglikPolicyList.clear();
            _tamamlayiciSaglikPolicyList.addAll(_geciciManuelList);
          } else {
            _tamamlayiciSaglikPolicyList.clear();
            _tamamlayiciSaglikPolicyList = responseList;
          }
        });
      }).then((value) {
        _saglikPolicyList.clear();
        setState(() {
          _saglikPolicyList
              .addAll(_genelSaglikPolicyList + _tamamlayiciSaglikPolicyList);
          _saglikPolicyList.sort((item1, item2) => item1.baslangicTarihi
              .toString()
              .compareTo(item2.baslangicTarihi.toString()));

          _saglikPolicyList = _saglikPolicyList.reversed.toList();

          if (widget.isOffer == true) {
            _geciciManuelList.clear();
            for (var item in _saglikPolicyList) {
              if (item.teklifPolice == 1) {
                _geciciManuelList.add(item);
              }
            }
            _saglikPolicyList.clear();
            _saglikPolicyList.addAll(_geciciManuelList);
          }
          return null;
        });
      });
    });
  }

  Future<Null> _getSeyahatPoliciesList() async {
    await WebAPI.policiesRequest(
            token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "21")
        .then((responseList) {
      setState(() {
        if (widget.isOffer == true) {
          _geciciManuelList.clear();
          for (var item in responseList) {
            if (item.teklifPolice == 1) {
              _geciciManuelList.add(item);
            }
          }
          _seyahatPolicyList.clear();
          _seyahatPolicyList.addAll(_geciciManuelList);
        } else {
          _seyahatPolicyList.clear();
          _seyahatPolicyList = responseList;
        }
      });
    });
  }

  Future<Null> _getDigerPoliciesList() async {
    await WebAPI.policiesRequest(
            token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "3")
        .then((responseList) {
      setState(() {
        if (widget.isOffer == true) {
          _geciciManuelList.clear();
          for (var item in responseList) {
            if (item.teklifPolice == 1) {
              _geciciManuelList.add(item);
            }
          }
          _digerPolicyList.clear();
          _digerPolicyList.addAll(_geciciManuelList);
        }
        _digerPolicyList.clear();
        _digerPolicyList = responseList;
      });
    });
  }

  Future getPolicyInformation() async {
    Utils.getAracMarka().then((value) => _aracMarka = value);
    Utils.getIL().then((value) => _ilList = value);
    Utils.getSigortaSirketi().then((value) => _sigortaSirketi = value);
    Utils.getAcente().then((value) => _acente = value);
    Utils.getKullaniciInfo().then((value) => _kullaniciInfo = value);
    /*  Utils.getAracTip(AracMarka(markaAdi: "Marka", markaKodu: "-1"))
        .then((value) => _aracTip = value); */
    Utils.getILCE(IL(ilAdi: "İl", ilKodu: "-1"))
        .then((value) => _ilceList = value);
    Utils.getMeslek().then((value) => _meslekList = value);
    Utils.getUlke("-1").then((value) => _ulkeList = value);
    Utils.getSigortaTuru().then((value) => _sigortaTurList = value);
  }

  Future getPolicyInformationWithCode(PolicyResponse police) async {
    await UtilsPolicy.getPolicyInformationWithCode(police).whenComplete(() {
      _marka = UtilsPolicy.marka;
      _aracTipi = UtilsPolicy.aracTipi;
      _kullanimTarzi = UtilsPolicy.kullanimTarzi;
      _sigortaSirketiforPDF = UtilsPolicy.sigortaSirketiforPDF;
      _kullaniciInfo = UtilsPolicy.kullaniciInfo;
      _sigortaTuru = UtilsPolicy.sigortaTuru;
      _ulkeTuru = UtilsPolicy.ulkeTuru;
      _gidilenUlke = UtilsPolicy.gidilenUlke;
      _yapiTarzi = UtilsPolicy.yapiTarzi;
      _yapimYili = UtilsPolicy.yapimYili;
      _binaKullanimSekli = UtilsPolicy.binaKullanimSekli;
      _il = UtilsPolicy.il;
      _ilce = UtilsPolicy.ilce;
      _meslek = UtilsPolicy.meslek;
    });
    /* var resultTemp = null;
    _sigortaSirketiforPDF = WebAPI.sigortaSirketiList
        .firstWhere((x) => x.sirketKodu == police.sirketKodu);
    

    _sigortaTuru = WebAPI.sigortaTuruList
        .firstWhere((x) => x.bransKodu == police.bransKodu);
   

    if (police.markaKodu != null){
        resultTemp =WebAPI.aracMarkaList
          .firstWhere((x) => x.markaKodu == police.markaKodu,
          orElse: () => null);
      if (resultTemp != null) _marka = resultTemp;
    }
       
    if (police.tipKodu != null){
      resultTemp = WebAPI.aracTipList.firstWhere((x) =>
          x.markaKodu == police.markaKodu && x.tipKodu == police.tipKodu,
          orElse: () => null);
       if (resultTemp != null)_aracTipi =resultTemp;
    }
    /* Utils.getAracTipByCode(police.tipKodu, police.markaKodu)
          .then((value) => _aracTipi = value); */

    if (police.aracKullanimTarzi != null){
      resultTemp =WebAPI.aracKullanimTarziList.firstWhere((x) =>
          x.kullanimTarziKodu + "+" + x.kod2 == police.aracKullanimTarzi,
          orElse: () => null);
       if (resultTemp != null)_kullanimTarzi = resultTemp;
    }
    /* Utils.getAracKullanimTarziByCode(police.aracKullanimTarzi)
          .then((value) => _kullanimTarzi = value); */

    Utils.getKullaniciInfo().then((value) => _kullaniciInfo = value);

    if (police.seyahatUlkeKodu != null) {
      resultTemp = WebAPI.ulkeList.firstWhere(
          (x) => x.ulkeKodu == police.seyahatUlkeKodu,
          orElse: () => null);

      if (resultTemp != null) {
        _gidilenUlke = resultTemp;
        resultTemp = WebAPI.ulkeTipiList.firstWhere(
            (x) => x.ulkeTipiKodu == _gidilenUlke.ulkeTipiKodu,
            orElse: () => null);
        _ulkeTuru = resultTemp != null
            ? resultTemp
            : UlkeTipi(ulkeTipiAdi: "Seyahat Edilicek Ülke Türü");
      }
    }
    if (police.binaYapiTarzi != null)
      _yapiTarzi = Utils.getYapiTarzi(index: police.binaYapiTarzi);

    if (police.binaKullanimSekli != null)
      _binaKullanimSekli =
          Utils.getBinaKullanimSekli(index: police.binaKullanimSekli);

    if (police.ilKodu != null) {
      resultTemp = WebAPI.ilList
          .firstWhere((x) => x.ilKodu == police.ilKodu, orElse: () => null);
      if (resultTemp != null) _il = resultTemp;
      //Utils.getILByCode(police.ilKodu).then((value) => _il = value);
    }
    if (police.ilceKodu != null) {
      resultTemp = WebAPI.ilceList
          .firstWhere((x) => x.ilceKodu == police.ilceKodu, orElse: () => null);
      if (resultTemp != null) _ilce = resultTemp;
      //Utils.getILCEByCode(police.ilceKodu).then((value) => _ilce = value);
    }
    if (police.meslek != null) {
      resultTemp = WebAPI.meslekList.firstWhere(
          (x) => x.meslekKodu == int.parse(police.meslek),
          orElse: () => null);
      if (resultTemp != null) _meslek = resultTemp;
    }
    //Utils.getMeslekByCode(police.meslek).then((value) => _meslek = value); */
  }

  Acente _findAcente(int kod) {
    Acente result = Acente(unvani: "Portal Üyesi Değil");
    _acente.forEach((item) {
      if (item.kodu == kod) result = item;
    });
    return result;
  }

  Future<void> pdfCreate(PolicyResponse policy) async {
    final pdf = PDF.Document();
    //final File pdfFile= File("${_sigortaSirketi.sirketKodu}-${widget.policyResponse.policeNumarasi}-${widget.policyResponse.yenilemeNo} Hasar Bildirimi.pdf");

    final ByteData fontData = await rootBundle.load("assets/fonts/micross.ttf");
    final PDF.Font ttf = PDF.Font.ttf(fontData);

    final ByteData logoData = await rootBundle.load("assets/images/logo-3.png");
    ResizedImage.Image logo =
        ResizedImage.decodeImage(logoData.buffer.asUint8List());

    String imageUrl;
    if (_sigortaSirketiforPDF.sirketLogo != null &&
        _sigortaSirketiforPDF.sirketLogo != "")
      imageUrl = _sigortaSirketiforPDF.sirketLogo;
    else {
      imageUrl = "https://neoonlinestrg.blob.core.windows.net";
    }

    var logoNetData = await get("$imageUrl");
    ResizedImage.Image logoNet;

    if (logoNetData.statusCode == 200)
      logoNet = ResizedImage.copyResize(
          ResizedImage.decodeImage(logoNetData.bodyBytes),
          height: -1,
          width: 100);
    pdf.addPage(PDF.MultiPage(
        theme: PDF.ThemeData(
            defaultTextStyle: PDF.TextStyle(font: ttf),
            paragraphStyle: PDF.TextStyle(font: ttf),
            tableCell: PDF.TextStyle(font: ttf),
            tableHeader: PDF.TextStyle(font: ttf)),
        footer: (PDF.Context context) {
          return PDF.Footer(
              leading: PDF.Text("2020 - © Neosinerji"),
              trailing: PDF.UrlLink(
                  child: PDF.Row(
                      mainAxisAlignment: PDF.MainAxisAlignment.end,
                      children: [
                        PDF.Text("sigorta",
                            style:
                                PDF.TextStyle(fontWeight: PDF.FontWeight.bold)),
                        PDF.Text("defterim.com")
                      ]),
                  destination: "www.sigortadefterim.com"));
        },
        build: (PDF.Context context) {
          return [
            PDF.Container(
                child: PDF.Column(
                    crossAxisAlignment: PDF.CrossAxisAlignment.center,
                    children: <PDF.Widget>[
                  PDF.Row(
                      mainAxisAlignment: PDF.MainAxisAlignment.spaceBetween,
                      children: [
                        PDF.Image(PdfImage(pdf.document,
                            image: logo.data.buffer.asUint8List(),
                            width: logo.width,
                            height: logo.height)),
                        PDF.Text(
                            "${DateFormat("dd/MM/yyyy").format(DateTime.now())}")
                      ]),
                  PDF.Padding(padding: const PDF.EdgeInsets.all(10)),
                  PDF.Paragraph(
                      text: "${_sigortaTuru.bransAdi} SİGORTASI TEKLİF TALEBİ",
                      style: PDF.TextStyle(fontSize: 18)),
                  PDF.Paragraph(
                      text:
                          "   Sayın ${_kullaniciInfo[0]} ${_kullaniciInfo[1]}, sigortadefterim.com kullanıcısı tarafından aşağıda detayları bulunan Teklif Talebini acilen değerlendirerek, gerekli işlemlerin başlatılması hususunu önemle bilgilerinize sunarız.\n\nSaygılarımızla\n\n",
                      textAlign: PDF.TextAlign.left),
                  PDF.Row(
                      mainAxisAlignment: PDF.MainAxisAlignment.start,
                      children: [
                        PDF.Text("sigorta",
                            style:
                                PDF.TextStyle(fontWeight: PDF.FontWeight.bold)),
                        PDF.Text("defterim.com")
                      ]),
                  PDF.Container(
                      margin: PDF.EdgeInsets.symmetric(horizontal: 24),
                      child: PDF.Table(
                          tableWidth: PDF.TableWidth.max,
                          border: PDF.TableBorder(),
                          defaultVerticalAlignment:
                              PDF.TableCellVerticalAlignment.middle,
                          children: [
                            PDF.TableRow(children: [
                              PDF.Container(
                                  padding: PDF.EdgeInsets.all(2),
                                  alignment: PDF.Alignment.center,
                                  child: PDF.Text(
                                      "${_sigortaSirketiforPDF.sirketAdi}",
                                      textAlign: PDF.TextAlign.center)),
                            ]),
                            logoNetData.statusCode == 200
                                ? PDF.TableRow(children: [
                                    PDF.Container(
                                        padding: PDF.EdgeInsets.all(2),
                                        alignment: PDF.Alignment.center,
                                        child: PDF.Image(PdfImage(pdf.document,
                                            image: logoNet.data.buffer
                                                .asUint8List(),
                                            width: logoNet.width,
                                            height: logoNet.height)))
                                  ])
                                : PDF.TableRow(children: [PDF.Text("")])
                          ])),
                  PDF.Padding(padding: const PDF.EdgeInsets.all(10)),
                  PDF.Paragraph(
                      text: "POLİÇE BİLGİLERİ",
                      style: PDF.TextStyle(fontSize: 16)),
                  PDF.Container(
                      margin: PDF.EdgeInsets.symmetric(horizontal: 24),
                      child: PDF.Table(
                          tableWidth: PDF.TableWidth.max,
                          border: PDF.TableBorder(),
                          defaultVerticalAlignment:
                              PDF.TableCellVerticalAlignment.middle,
                          children: _getUrunPDF(policy))),
                ]))
          ];
        }));

    //var dir = await getExternalStorageDirectory();
    //File file = new File('${dir.path}/Document.pdf');

    // print(file.path);

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  List<PDF.TableRow> _getUrunPDF(PolicyResponse police) {
    switch (_sigortaTuru.bransKodu) {
      case 1:
        return [
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Sigorta Şirketi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaSirketiforPDF.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.policeNumarasi}/${police.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.bitisTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Branş Adı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaTuru.bransAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("TCKN/VKN")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.kimlikNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adı Soyadı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[0]} ${_kullaniciInfo[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Araç Plakası")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.plaka}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Tescil Belge No(Ruhsat No)")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.ruhsatSeriKodu}-${police.ruhsatSeriNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("ASBIS NO")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.asbisNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Araç Markası")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_marka.markaAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Araç Tipi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_aracTipi.tipAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Araç Model Yılı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.modelYili}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Kullanım Tarzı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullanimTarzi.kullanimTarzi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Konum Bilgisi")),
            PDF.Container(
                width: PdfPageFormat.a4.width / 3,
                padding: PDF.EdgeInsets.all(2),
                child: PDF.UrlLink(
                    child: PDF.Text(
                        _location.isEmpty
                            ? ""
                            : "https://www.google.com/maps/search/?api=1&\nquery=${_location[0]},${_location[1]}",
                        maxLines: 2),
                    destination: _location.isEmpty
                        ? ""
                        : "https://www.google.com/maps/search/?api=1&query=${_location[0]},${_location[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    police.aciklama == null ? "" : "${police.aciklama}"))
          ]),
        ];
      case 2:
        return [
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Sigorta Şirketi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaSirketiforPDF.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.policeNumarasi}/${police.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.bitisTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Branş Adı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaTuru.bransAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("TCKN/VKN")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.kimlikNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adı Soyadı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[0]} ${_kullaniciInfo[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Araç Plakası")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.plaka}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Tescil Belge No(Ruhsat No)")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.ruhsatSeriKodu}-${police.ruhsatSeriNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("ASBIS NO")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.asbisNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Araç Markası")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_marka.markaAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Araç Tipi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_aracTipi.tipAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Araç Model Yılı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.modelYili}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Kullanım Tarzı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullanimTarzi.kullanimTarzi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Konum Bilgisi")),
            PDF.Container(
                width: PdfPageFormat.a4.width / 3,
                padding: PDF.EdgeInsets.all(2),
                child: PDF.UrlLink(
                    child: PDF.Text(
                        _location.isEmpty
                            ? ""
                            : "https://www.google.com/maps/search/?api=1&\nquery=${_location[0]},${_location[1]}",
                        maxLines: 2),
                    destination: _location.isEmpty
                        ? ""
                        : "https://www.google.com/maps/search/?api=1&query=${_location[0]},${_location[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    police.aciklama == null ? "" : "${police.aciklama}"))
          ]),
        ];
      case 4:
        return [
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Sigorta Şirketi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaSirketiforPDF.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.policeNumarasi}/${police.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.bitisTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Branş Adı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaTuru.bransAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("TCKN/VKN")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[2]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adı Soyadı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[0]} ${_kullaniciInfo[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Meslek")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_meslek.meslekAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Konum Bilgisi")),
            PDF.Container(
                width: PdfPageFormat.a4.width / 3,
                padding: PDF.EdgeInsets.all(2),
                child: PDF.UrlLink(
                    child: PDF.Text(
                        _location.isEmpty
                            ? ""
                            : "https://www.google.com/maps/search/?api=1&\nquery=${_location[0]},${_location[1]}",
                        maxLines: 2),
                    destination: _location.isEmpty
                        ? ""
                        : "https://www.google.com/maps/search/?api=1&query=${_location[0]},${_location[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    police.aciklama == null ? "" : "${police.aciklama}"))
          ]),
        ];
      case 11:
        return [
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Sigorta Şirketi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaSirketiforPDF.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.policeNumarasi}/${police.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.bitisTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Branş Adı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaTuru.bransAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("TCKN/VKN")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[2]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adı Soyadı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[0]} ${_kullaniciInfo[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("İl")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("${_il.ilAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("İlçe")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_ilce.ilceAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bina Kat Sayısı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.binaKatSayisi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bina Yapım Yılı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("$_yapimYili"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bina Kullanım Şekli")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("$_binaKullanimSekli"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Daire Brüt(m²)")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.daireBrut}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bina Yapı Tarzı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_yapiTarzi.yapiTarziAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adres")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.adres}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Konum Bilgisi")),
            PDF.Container(
                width: PdfPageFormat.a4.width / 3,
                padding: PDF.EdgeInsets.all(2),
                child: PDF.UrlLink(
                    child: PDF.Text(
                        _location.isEmpty
                            ? ""
                            : "https://www.google.com/maps/search/?api=1&\nquery=${_location[0]},${_location[1]}",
                        maxLines: 2),
                    destination: _location.isEmpty
                        ? ""
                        : "https://www.google.com/maps/search/?api=1&query=${_location[0]},${_location[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    police.aciklama == null ? "" : "${police.aciklama}"))
          ]),
        ];
      case 21:
        return [
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Sigorta Şirketi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaSirketiforPDF.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.policeNumarasi}/${police.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("seyahat Gidiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(DateFormat("dd/MM/yyyy")
                    .format(DateTime.parse(police.seyahatGidisTarihi))))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Seyahat Dönüş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(DateFormat("dd/MM/yyyy")
                    .format(DateTime.parse(police.seyahatDonusTarihi))))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Branş Adı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaTuru.bransAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("TCKN/VKN")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[2]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adı Soyadı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[0]} ${_kullaniciInfo[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Seyahat Edilen Ülke Tipi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_ulkeTuru.ulkeTipiAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Seyahat Edilen Ülke")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_gidilenUlke.ulkeAdi}}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Seyahat Eden Kişi Sayısı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("$_kisiSayisi"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Konum Bilgisi")),
            PDF.Container(
                width: PdfPageFormat.a4.width / 3,
                padding: PDF.EdgeInsets.all(2),
                child: PDF.UrlLink(
                    child: PDF.Text(
                        _location.isEmpty
                            ? ""
                            : "https://www.google.com/maps/search/?api=1&\nquery=${_location[0]},${_location[1]}",
                        maxLines: 2),
                    destination: _location.isEmpty
                        ? ""
                        : "https://www.google.com/maps/search/?api=1&query=${_location[0]},${_location[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    police.aciklama == null ? "" : "${police.aciklama}"))
          ]),
        ];
      case 22:
        return [
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Sigorta Şirketi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaSirketiforPDF.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.policeNumarasi}/${police.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.bitisTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Branş Adı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaTuru.bransAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("TCKN/VKN")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[2]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adı Soyadı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[0]} ${_kullaniciInfo[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("İl")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("${_il.ilAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("İlçe")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_ilce.ilceAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Eşya Bedeli")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.esyaBedeli}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Bina Bedeli")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.binaBedeli}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adres")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.adres}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Konum Bilgisi")),
            // PDF.Container(
            //     width: PdfPageFormat.a4.width/3,
            //     padding: PDF.EdgeInsets.all(2),
            //     child:PDF.UrlLink(child: PDF.Text(_location.isEmpty?"":"https://www.google.com/maps/search/?api=1&\nquery=${_location[0]},${_location[1]}",maxLines: 2),destination: _location.isEmpty?"":"https://www.google.com/maps/search/?api=1&query=${_location[0]},${_location[1]}")
            //     )
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    police.aciklama == null ? "" : "${police.aciklama}"))
          ]),
        ];
      default:
        return [
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Sigorta Şirketi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaSirketiforPDF.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.policeNumarasi}/${police.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.bitisTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Branş Adı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaTuru.bransAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("TCKN/VKN")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[2]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adı Soyadı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[0]} ${_kullaniciInfo[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("İl")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("${_il.ilAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("İlçe")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_ilce.ilceAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adres")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.adres}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Konum Bilgisi")),
            PDF.Container(
                width: PdfPageFormat.a4.width / 3,
                padding: PDF.EdgeInsets.all(2),
                child: PDF.UrlLink(
                    child: PDF.Text(
                        _location.isEmpty
                            ? ""
                            : "https://www.google.com/maps/search/?api=1&\nquery=${_location[0]},${_location[1]}",
                        maxLines: 2),
                    destination: _location.isEmpty
                        ? ""
                        : "https://www.google.com/maps/search/?api=1&query=${_location[0]},${_location[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    police.aciklama == null ? "" : "${police.aciklama}"))
          ]),
        ];
    }
  }
}
