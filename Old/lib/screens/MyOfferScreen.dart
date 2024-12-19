import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sigortadefterim/models/Acente.dart';
import 'package:sigortadefterim/models/AracMarka.dart';
import 'package:sigortadefterim/models/IL.dart';
import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';
import 'package:sigortadefterim/models/SigortaSirketi.dart';
import 'package:sigortadefterim/screens/RenewPolicy.dart';
import 'package:sigortadefterim/screens/ReportDamage.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/widgets/Drawers.dart';
import 'package:sigortadefterim/widgets/MyExpansionTile.dart';

import 'PolicyDetailScreen.dart';

class MyOfferScreen extends StatefulWidget {
  int currentIndex=0;

  MyOfferScreen({initialIndex}){
    currentIndex = initialIndex;
  }

  @override
  _PolicyScreenState createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<MyOfferScreen> with TickerProviderStateMixin {
  List<PolicyResponse> _tumuPolicyList = List<PolicyResponse>();
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
  final GlobalKey<RefreshIndicatorState> _tumuRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _aracRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _konutRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _daskRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _saglikRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _seyahatRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _digerRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  TabController _aracTabController;
  TabController _saglikTabController;
  TabController _digerTabController;
  List _digerTabItems;

  List<String> _kullaniciInfo = List<String>();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onBuildCompleted);
    _aracTabController = TabController(length: 3, initialIndex: 0, vsync: this);
    _saglikTabController = TabController(length: 3, initialIndex: 0, vsync: this);
   _kullaniciInfo.addAll(["", "", "111111111111", "", ""]);
    
    getPolicyInformation().whenComplete(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (_aracTabController != null) _aracTabController.removeListener(() => this);
    if (_digerTabController != null) _digerTabController.removeListener(() => this);
    if (_saglikTabController != null) _saglikTabController.removeListener(() => this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorData.renkSolukBeyaz,
        drawer: MenuDrawer(adSoyad: _kullaniciInfo[0] + " " + _kullaniciInfo[1]),
        body: Column(
          children: <Widget>[
            Container(
              key: _topPartKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                          child: IconButton(
                              icon: Image.asset("assets/images/ic_menu.png"),
                              onPressed: () {
                                _scaffoldKey.currentState.openDrawer();
                              }),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Teklif Listem",style: TextStyleData.standartLacivert24,),
                              )),
                      ),
                    ],
                  ),
                  _getTopSlider(),
                  SizedBox(height: 8),
                  widget.currentIndex == 1 ? _getAracTabBar() : Container(),
                  //widget.currentIndex == 6 ? _getDigerTabBar() : Container(),
                  widget.currentIndex == 4 ? _getSaglikTabBar() : Container(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - (_topPartSize.height + 80)), height: 200, child: _getUrunList()),
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
            indicator: UnderlineTabIndicator(borderSide: BorderSide(color: ColorData.renkLacivert,width: 4),insets: EdgeInsets.only(bottom: 8)),
            labelColor: ColorData.renkLacivert,
            unselectedLabelColor: ColorData.renkLacivert,
            indicatorColor: ColorData.renkMavi,
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
          ),
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
              indicator: UnderlineTabIndicator(borderSide: BorderSide(color: ColorData.renkLacivert,width: 4),insets: EdgeInsets.only(bottom: 8)),
              labelColor: ColorData.renkLacivert,
              unselectedLabelColor: ColorData.renkLacivert,
              indicatorColor: ColorData.renkMavi,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              ),
            ),
        ],
        );
  }

  Widget _getDigerTabBar() {
    _digerTabItems = UtilsPolicy.findSigortaTuru(-1, true);
    _digerTabController = TabController(length: _digerTabItems.length + 1, initialIndex: 0, vsync: this);
    return TabBar(
      tabs: _getDigerTabItems(),
      controller: _digerTabController,
      labelStyle: TextStyleData.boldLacivert24,
      unselectedLabelStyle: TextStyleData.boldLacivert16,
      indicator: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(30)),
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
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyDetailScreen(policyResponse: item,isTitleOffer: true,)));
              },);
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
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyDetailScreen(policyResponse: item,)));
                },);
            }),
      );
    });
    return items;
  }

  Widget _getUrunList() {
    switch (widget.currentIndex) {
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

  Widget _tumuList(){
    return RefreshIndicator(
      key: _tumuRefreshIndicatorKey,
      onRefresh: () => _getTumuPoliciesList(),
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _tumuPolicyList.length,
          itemBuilder: (BuildContext bContext, index) {
            var item = _tumuPolicyList[index];
            return InkWell(
                child: _createTumuListItem(item),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyDetailScreen(policyResponse: item,)));
              },);
          }),
      );
  }

  Widget _aracList() {
    return TabBarView(
      controller: _aracTabController,
      children: <Widget>[
        RefreshIndicator(
          key: _aracRefreshIndicatorKey,
          onRefresh: () => _getAracPoliciesList(),
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _aracPolicyList.length,
              itemBuilder: (BuildContext bContext, index) {
                var item = _aracPolicyList[index];
                return InkWell(
                    child: _createAracListItem(item),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyDetailScreen(policyResponse: item,)));
                    },);
              }),
        ),
        RefreshIndicator(
          onRefresh: () => _getAracPoliciesList(),
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _kaskoPolicyList.length,
              itemBuilder: (BuildContext bContext, index) {
                var item = _kaskoPolicyList[index];
                return InkWell(
                  child: _createAracListItem(item),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyDetailScreen(policyResponse: item,)));
                  },);
              }),
        ),
        RefreshIndicator(
          onRefresh: () => _getAracPoliciesList(),
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _trafikPolicyList.length,
              itemBuilder: (BuildContext bContext, index) {
                var item = _trafikPolicyList[index];
                return InkWell(
                  child: _createAracListItem(item),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyDetailScreen(policyResponse: item,)));
                  },);
              }),
        ),
      ],
    );
  }

  Widget _konutList() {
    return RefreshIndicator(
      key: _konutRefreshIndicatorKey,
      onRefresh: () => _getKonutPoliciesList(),
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _konutPolicyList.length,
          itemBuilder: (BuildContext bContext, index) {
            var item = _konutPolicyList[index];
            return InkWell(
                child: _createKonutListItem(item),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyDetailScreen(policyResponse: item,)));
              },);
          }),
    );
  }

  Widget _daskList() {
    return RefreshIndicator(
      key: _daskRefreshIndicatorKey,
      onRefresh: () => _getDaskPoliciesList(),
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _daskPolicyList.length,
          itemBuilder: (BuildContext bContext, index) {
            var item = _daskPolicyList[index];
            return InkWell(
              child: _createDaskListItem(item),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyDetailScreen(policyResponse: item,)));
              },);
          }),
    );
  }

  Widget _saglikList() {
    return
    TabBarView(
      controller: _saglikTabController,
      children: <Widget>[
        RefreshIndicator(
          key: _saglikRefreshIndicatorKey,
          onRefresh: () => _getSaglikPoliciesList(),
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _saglikPolicyList.length,
              itemBuilder: (BuildContext bContext, index) {
                var item = _saglikPolicyList[index];
                return InkWell(
                    child: _createSaglikListItem(item),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyDetailScreen(policyResponse: item,)));
                  },);
              }),
          ),
        RefreshIndicator(
          onRefresh: () => _getSaglikPoliciesList(),
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _genelSaglikPolicyList.length,
              itemBuilder: (BuildContext bContext, index) {
                var item = _genelSaglikPolicyList[index];
                return InkWell(
                    child: _createSaglikListItem(item),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyDetailScreen(policyResponse: item,)));
                  },);
              }),
          ),
        RefreshIndicator(
          onRefresh: () => _getSaglikPoliciesList(),
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _tamamlayiciSaglikPolicyList.length,
              itemBuilder: (BuildContext bContext, index) {
                var item = _tamamlayiciSaglikPolicyList[index];
                return InkWell(
                    child: _createSaglikListItem(item),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyDetailScreen(policyResponse: item,)));
                  },);
              }),
          ),
      ],
      );
  }

  Widget _seyahatList() {
    return RefreshIndicator(
      key: _seyahatRefreshIndicatorKey,
      onRefresh: () => _getSeyahatPoliciesList(),
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _seyahatPolicyList.length,
          itemBuilder: (BuildContext bContext, index) {
            var item = _seyahatPolicyList[index];
            return InkWell(
                child: _createSeyahatListItem(item),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyDetailScreen(policyResponse: item,)));
              },);
          }),
      );
  }

  Widget _digerList() {
    //return TabBarView(controller: _digerTabController, children: _getDigerTabView());
    return RefreshIndicator(
      key: _digerRefreshIndicatorKey,
      onRefresh: () => _getDigerPoliciesList(),
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _digerPolicyList.length,
          itemBuilder: (BuildContext bContext, index) {
            var item = _digerPolicyList[index];
            return InkWell(
              child: _createDigerListItem(item),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyDetailScreen(policyResponse: item,)));
              },);
          }),
      );
  }

  Widget _createTumuListItem(PolicyResponse item){
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
          onTap: () => UtilsPolicy.showSnackBar(_scaffoldKey,"\"Poliçe Ekle\" ile kayıt edilen poliçeleri simgeler."),
          child: Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.all(8),
            height: 50,width: 50,
            decoration: BoxDecoration(color: ColorData.renkYesil, borderRadius: BorderRadius.circular(10)),
            child: Image.asset("assets/images/ic_hand.png"),
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(color: ColorData.renkBeyaz, borderRadius: BorderRadius.circular(50), boxShadow: [
              BoxDecorationData.shadow
            ]),
            child: MyExpansionTile(
              key: Key("${item.policeNumarasi}/${item.yenilemeNo}"),
              backgroundColor: Colors.transparent,
              initiallyExpanded: false,
              leading: Image.asset("assets/car_icons/${item.markaKodu == null ? "no_image" : (item.markaKodu)}.png", width: 50, height: 50, fit: BoxFit.contain),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(item.markaKodu == null ? "Bulunamadı" :  UtilsPolicy.findMarka(item.markaKodu), style: TextStyleData.standartLacivert14),
                        Text(item.tipKodu == null ? "Bulunamadı" : UtilsPolicy.findModel(item.tipKodu,item.markaKodu), overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyleData.boldLacivert),
                        Container(
                          padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                          decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                          child: Text(item.plaka == null ? "Bulunmadı" : item.plaka, style: TextStyleData.boldLacivert),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(padding: EdgeInsets.fromLTRB(4, 2, 4, 2), decoration: BoxDecoration(color: ColorData.renkKoyuYesil, borderRadius: BorderRadius.circular(33)), child: Text("  Başlangıç  ", style: TextStyleData.boldBeyaz12)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                        child: Text(item.baslangicTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.baslangicTarihi)), style: TextStyleData.boldSiyah12),
                      ),
                      Container(padding: EdgeInsets.fromLTRB(4, 2, 4, 2), decoration: BoxDecoration(color: ColorData.renkKirmizi, borderRadius: BorderRadius.circular(33)), child: Text("       Bitiş       ", style: TextStyleData.boldBeyaz12)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                        child: Text(item.bitisTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.bitisTarihi)), style: TextStyleData.boldSiyah12),
                      )
                    ],
                  )
                ],
              ),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
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
                                    Container(width: 75, alignment: Alignment.center, padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8), decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)), child: Text("Acente", style: TextStyleData.boldLacivert)),
                                    Container(
                                      width: MediaQuery.of(context).size.width - 150,
                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                      child: Text(item.acenteUnvani == null ? "Portal Üyesi Değil" : _findAcente(item.acenteUnvani).unvani, style: TextStyleData.standartLacivert),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                      child: InkWell(
                                        child: Icon(Icons.phone_forwarded, color: ColorData.renkLacivert),
                                        onTap: () {
                                          if (item.acenteUnvani == null)
                                            UtilsPolicy.showSnackBar(_scaffoldKey,"Acentenin telefon bilgisi bulunamadı");
                                          else
                                            Utils.launchURL("tel:${_findAcente(item.acenteUnvani).telefon}");
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
                                    Container(width: 75, alignment: Alignment.center, padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8), decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)), child: Text("Sigorta Şirketi", style: TextStyleData.boldLacivert, textAlign: TextAlign.center)),
                                    Container(
                                      width: MediaQuery.of(context).size.width - 150,
                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                      child: Text(item.sirketKodu == null ? "Bulunamadı" : UtilsPolicy.findSirket(item.sirketKodu).sirketAdi, style: TextStyleData.standartLacivert),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                      child: InkWell(
                                        child: Icon(Icons.phone_forwarded, color: ColorData.renkLacivert),
                                        onTap: () {
                                          if (item.sirketKodu == null)
                                            UtilsPolicy.showSnackBar(_scaffoldKey,"şirketin telefon bilgisi bulunamadı");
                                          else
                                            Utils.launchURL("tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
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
                                        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                        child: Text(
                                          "Tip",
                                          style: TextStyleData.boldLacivert,
                                        )),
                                    Container(
                                      width: MediaQuery.of(context).size.width - 150,
                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                      child: Text(item.tipKodu == null ? "Bulunamadı" : UtilsPolicy.findModel(item.tipKodu,item.markaKodu), style: TextStyleData.standartLacivert),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: <Widget>[
                                    Container(width: 75, alignment: Alignment.center, padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8), decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)), child: Text("Model", style: TextStyleData.boldLacivert),),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                      child: Text(item.modelYili == null ? "Bulunamadı" : item.modelYili.toString(), style: TextStyleData.standartLacivert),
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
                                        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                        child: Text(
                                          "Açıklama",
                                          style: TextStyleData.boldLacivert,
                                          textAlign: TextAlign.center,
                                        )),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                      child: Text(item.aciklama == null ? "Girilmemiş" : item.aciklama.toString(), style: TextStyleData.standartLacivert),
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
                              decoration: BoxDecoration(boxShadow: [
                                BoxDecorationData.shadow
                              ]),
                              child: OutlineButton(
                                child: Text("Yenile", style: TextStyleData.boldLacivert),
                                shape: StadiumBorder(),
                                borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RenewPolicy(policyResponse: item)));
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxDecorationData.shadow
                              ]),
                              child: OutlineButton(
                                child: Text("Hasar bildir", style: TextStyleData.boldLacivert),
                                shape: StadiumBorder(),
                                borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportDamage(policyResponse: item)));
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxDecorationData.shadow
                              ]),
                              child: OutlineButton(
                                child: Text("PDF", style: TextStyleData.boldLacivert),
                                shape: StadiumBorder(),
                                borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
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
        margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        padding: EdgeInsets.all(8),
    decoration: BoxDecoration(color: ColorData.renkBeyaz, borderRadius: BorderRadius.circular(33), boxShadow: [
      BoxDecorationData.shadow
    ]),
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
                      gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [
                      ColorData.renkLacivert,ColorData.renkMavi
                      ])),
                  child: Image.asset("assets/images/ic_car.png"),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Text(item.markaKodu == null ? "Bulunamadı" : UtilsPolicy.findMarka(item.markaKodu), style: TextStyleData.standartLacivert14),
                      Text(item.tipKodu == null ? "Bulunamadı" : UtilsPolicy.findMarka(item.markaKodu), overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyleData.boldMavi18),
                    ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/images/ic_hand.png",width: 24,height: 24,),
                  )
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                SizedBox(width: 62),
                SizedBox(
                    width: 75,
                    child: Text("Tip",style: TextStyleData.boldSolukGri)),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 48),
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(item.tipKodu == null ? "Bulunamadı" : UtilsPolicy.findModel(item.tipKodu,item.markaKodu), overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyleData.boldAcikSiyah),
                    ),),
                ),
              ],),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                SizedBox(width: 62),
                SizedBox(
                    width: 75,
                    child: Text("Plaka",style: TextStyleData.boldSolukGri)),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 48),
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(item.plaka == null ? "Bulunmadı" : item.plaka, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyleData.boldAcikSiyah),
                    ),),
                ),
              ],),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                SizedBox(width: 62),
                SizedBox(
                    width: 75,
                    child: Text("Başlangıç",style: TextStyleData.boldSolukGri)),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 48),
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(item.baslangicTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.baslangicTarihi)), style: TextStyleData.boldAcikSiyah),
                    ),),
                ),
              ],),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                SizedBox(width: 62),
                SizedBox(
                    width: 75,
                    child: Text("Bitiş",style: TextStyleData.boldSolukGri)),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 48),
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(item.bitisTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.bitisTarihi)), style: TextStyleData.boldAcikSiyah),
                    ),),
                ),
              ],),
            SizedBox(height: 8),

          ],
        ),
        Image.asset("assets/images/ic_right_arrow.png",fit: BoxFit.contain,width: 12,height: 12,color: ColorData.renkMavi,),
      ],
    )
    );
  }

  Widget _createKonutListItemOldVersion(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(color: ColorData.renkBeyaz, borderRadius: BorderRadius.circular(50), boxShadow: [
          BoxDecorationData.shadow
        ]),
        child: MyExpansionTile(
          key: Key("${item.policeNumarasi}/${item.yenilemeNo}"),
          backgroundColor: Colors.transparent,
          initiallyExpanded: false,
          leading: Image.asset("assets/images/ic_apartment.png", width: 50, height: 50, fit: BoxFit.contain),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.ilKodu == null ? "Bulunamadı" : "${UtilsPolicy.findIL(item.ilKodu)}/${UtilsPolicy.findILCE(item.ilceKodu)}", style: TextStyleData.standartLacivert14),
                    Text(item.adres == null ? "Bulunamadı" : item.adres, overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyleData.boldLacivert),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(padding: EdgeInsets.fromLTRB(4, 2, 4, 2), decoration: BoxDecoration(color: ColorData.renkKoyuYesil, borderRadius: BorderRadius.circular(33)), child: Text("  Başlangıç  ", style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(item.baslangicTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.baslangicTarihi)), style: TextStyleData.boldSiyah12),
                  ),
                  Container(padding: EdgeInsets.fromLTRB(4, 2, 4, 2), decoration: BoxDecoration(color: ColorData.renkKirmizi, borderRadius: BorderRadius.circular(33)), child: Text("       Bitiş       ", style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(item.bitisTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.bitisTarihi)), style: TextStyleData.boldSiyah12),
                  )
                ],
              )
            ],
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
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
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                  child: Text("Acente", style: TextStyleData.boldLacivert),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.acenteUnvani == null ? "Portal Üyesi Değil" : _findAcente(item.acenteUnvani).unvani, style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded, color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.acenteUnvani == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,"Acentenin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL("tel:${_findAcente(item.acenteUnvani).telefon}");
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
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                  child: Text("Sigorta Şirketi", style: TextStyleData.boldLacivert, textAlign: TextAlign.center),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.sirketKodu == null ? "Bulunamadı" : UtilsPolicy.findSirket(item.sirketKodu).sirketAdi, style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded, color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.sirketKodu == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,"şirketin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL("tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
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
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                    child: Text(
                                      "Adres",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width: MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.adres == null ? "Girilmemiş" : item.adres, style: TextStyleData.standartLacivert),
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
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                    child: Text(
                                      "Bina Bedeli",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width: MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.binaBedeli == null ? "Bulunamadı" : NumberFormat("###,###,###,###").format(item.binaBedeli), style: TextStyleData.standartLacivert),
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
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                    child: Text(
                                      "Eşya Bedeli",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.esyaBedeli == null ? "Bulunamadı" : NumberFormat("###,###,###,###").format(item.esyaBedeli), style: TextStyleData.standartLacivert),
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
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                    child: Text(
                                      "Açıklama",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.aciklama == null ? "Girilmemiş" : item.aciklama.toString(), style: TextStyleData.standartLacivert),
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
                          decoration: BoxDecoration(boxShadow: [
                            BoxDecorationData.shadow
                          ]),
                          child: OutlineButton(
                            child: Text("Yenile", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RenewPolicy(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxDecorationData.shadow
                          ]),
                          child: OutlineButton(
                            child: Text("Hasar bildir", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportDamage(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxDecorationData.shadow
                          ]),
                          child: OutlineButton(
                            child: Text("PDF", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
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
        margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(color: ColorData.renkBeyaz, borderRadius: BorderRadius.circular(33), boxShadow: [
          BoxDecorationData.shadow
        ]),
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
                          gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [
                            ColorData.renkLacivert,ColorData.renkMavi
                          ])),
                      child: Image.asset("assets/images/ic_apartment.png"),
                      ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(item.ilKodu == null ? "Bulunamadı" : "${UtilsPolicy.findIL(item.ilKodu)}/${UtilsPolicy.findILCE(item.ilceKodu)}",overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyleData.boldMavi18),
                        ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/ic_hand.png",width: 24,height: 24,),
                      )
                  ],
                  ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Adres",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.adres == null ? "Bulunamadı" : item.adres, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyleData.boldAcikSiyah),

                        ),),
                  ],),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Başlangıç",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.baslangicTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.baslangicTarihi)), style: TextStyleData.boldAcikSiyah),
                        ),),
                  ],),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Bitiş",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.bitisTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.bitisTarihi)), style: TextStyleData.boldAcikSiyah),
                        ),),
                  ],),
                SizedBox(height: 8),
              ],
              ),
            Image.asset("assets/images/ic_right_arrow.png",fit: BoxFit.contain,width: 12,height: 12,color: ColorData.renkMavi,),
          ],
          )
        );
  }

  Widget _createDaskListItemOldVersion(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(color: ColorData.renkBeyaz, borderRadius: BorderRadius.circular(50), boxShadow: [
          BoxDecorationData.shadow
        ]),
        child: MyExpansionTile(
          key: Key("${item.policeNumarasi}/${item.yenilemeNo}"),
          backgroundColor: Colors.transparent,
          initiallyExpanded: false,
          leading: Image.asset("assets/images/ic_dask.png", width: 50, height: 50, fit: BoxFit.contain),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.ilKodu == null ? "Bulunamadı" : "${UtilsPolicy.findIL(item.ilKodu)}/${UtilsPolicy.findILCE(item.ilceKodu)}", style: TextStyleData.standartLacivert14),
                    Text(item.adres == null ? "Bulunamadı" : item.adres, overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyleData.boldLacivert),
                    Container(
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Text(item.daireBrut == null ? "Bulunmadı" : "${item.daireBrut.toString()} m²", style: TextStyleData.boldLacivert),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(padding: EdgeInsets.fromLTRB(4, 2, 4, 2), decoration: BoxDecoration(color: ColorData.renkKoyuYesil, borderRadius: BorderRadius.circular(33)), child: Text("  Başlangıç  ", style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(item.baslangicTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.baslangicTarihi)), style: TextStyleData.boldSiyah12),
                  ),
                  Container(padding: EdgeInsets.fromLTRB(4, 2, 4, 2), decoration: BoxDecoration(color: ColorData.renkKirmizi, borderRadius: BorderRadius.circular(33)), child: Text("       Bitiş       ", style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(item.bitisTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.bitisTarihi)), style: TextStyleData.boldSiyah12),
                  )
                ],
              )
            ],
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
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
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                  child: Text("Acente", style: TextStyleData.boldLacivert),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.acenteUnvani == null ? "Portal Üyesi Değil" : _findAcente(item.acenteUnvani).unvani, style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded, color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.acenteUnvani == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,"Acentenin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL("tel:${_findAcente(item.acenteUnvani).telefon}");
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
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                  child: Text("Sigorta Şirketi", style: TextStyleData.boldLacivert, textAlign: TextAlign.center),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.sirketKodu == null ? "Bulunamadı" : UtilsPolicy.findSirket(item.sirketKodu).sirketAdi, style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded, color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.sirketKodu == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,"şirketin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL("tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
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
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                    child: Text(
                                      "Adres",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width: MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.adres == null ? "Girilmemiş" : item.adres, style: TextStyleData.standartLacivert),
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
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                    child: Text(
                                      "Yapı Tarzı",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width: MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.binaYapiTarzi == null ? "Bulunamadı" : Utils.getYapiTarzi(index: item.binaYapiTarzi), style: TextStyleData.standartLacivert),
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
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                    child: Text(
                                      "Yapım Yılı",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.binaYapimYili == null ? "Bulunamadı" : item.binaYapimYili.toString(), style: TextStyleData.standartLacivert),
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
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                    child: Text(
                                      "Kullanım Şekli",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.binaKullanimSekli == null ? "Bulunamadı" : Utils.getBinaKullanimSekli(index: item.binaKullanimSekli), style: TextStyleData.standartLacivert),
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
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                    child: Text(
                                      "Açıklama",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.aciklama == null ? "Girilmemiş" : item.aciklama.toString(), style: TextStyleData.standartLacivert),
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
                          decoration: BoxDecoration(boxShadow: [
                            BoxDecorationData.shadow
                          ]),
                          child: OutlineButton(
                            child: Text("Yenile", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RenewPolicy(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxDecorationData.shadow
                          ]),
                          child: OutlineButton(
                            child: Text("Hasar bildir", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportDamage(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxDecorationData.shadow
                          ]),
                          child: OutlineButton(
                            child: Text("PDF", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
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
        margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(color: ColorData.renkBeyaz, borderRadius: BorderRadius.circular(33), boxShadow: [
          BoxDecorationData.shadow
        ]),
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
                          gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [
                            ColorData.renkLacivert,ColorData.renkMavi
                          ])),
                      child: Image.asset("assets/images/ic_dask.png"),
                      ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(item.ilKodu == null ? "Bulunamadı" : "${UtilsPolicy.findIL(item.ilKodu)}/${UtilsPolicy.findILCE(item.ilceKodu)}",overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyleData.boldMavi18),
                        ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/ic_hand.png",width: 24,height: 24,),
                      )
                  ],
                  ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Daire m²",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.daireBrut == null ? "Bulunamadı" : item.daireBrut.toString(), overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyleData.boldAcikSiyah),

                        ),),
                  ],),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Adres",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.adres == null ? "Bulunamadı" : item.adres, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyleData.boldAcikSiyah),

                        ),),
                  ],),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Başlangıç",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.baslangicTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.baslangicTarihi)), style: TextStyleData.boldAcikSiyah),
                        ),),
                  ],),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Bitiş",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.bitisTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.bitisTarihi)), style: TextStyleData.boldAcikSiyah),
                        ),),
                  ],),
                SizedBox(height: 8),
              ],
              ),
            Image.asset("assets/images/ic_right_arrow.png",fit: BoxFit.contain,width: 12,height: 12,color: ColorData.renkMavi,),
          ],
          )
        );
  }

  Widget _createSaglikListItemOldVersion(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(color: ColorData.renkBeyaz, borderRadius: BorderRadius.circular(50), boxShadow: [
          BoxDecorationData.shadow
        ]),
        child: MyExpansionTile(
          key: Key("${item.policeNumarasi}/${item.yenilemeNo}"),
          backgroundColor: Colors.transparent,
          initiallyExpanded: false,
          leading: Image.asset("assets/images/ic_healt.png", width: 50, height: 50, fit: BoxFit.contain),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Meslek", style: TextStyleData.standartLacivert14),
                    Text(item.meslek == null ? "Bulunamadı" : "${UtilsPolicy.findMeslek(item.meslek)}", style: TextStyleData.boldLacivert),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(padding: EdgeInsets.fromLTRB(4, 2, 4, 2), decoration: BoxDecoration(color: ColorData.renkKoyuYesil, borderRadius: BorderRadius.circular(33)), child: Text("  Başlangıç  ", style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(item.baslangicTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.baslangicTarihi)), style: TextStyleData.boldSiyah12),
                  ),
                  Container(padding: EdgeInsets.fromLTRB(4, 2, 4, 2), decoration: BoxDecoration(color: ColorData.renkKirmizi, borderRadius: BorderRadius.circular(33)), child: Text("       Bitiş       ", style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(item.bitisTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.bitisTarihi)), style: TextStyleData.boldSiyah12),
                  )
                ],
              )
            ],
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
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
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                  child: Text("Acente", style: TextStyleData.boldLacivert),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.acenteUnvani == null ? "Portal Üyesi Değil" : _findAcente(item.acenteUnvani).unvani, style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded, color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.acenteUnvani == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,"Acentenin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL("tel:${_findAcente(item.acenteUnvani).telefon}");
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
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                  child: Text("Sigorta Şirketi", style: TextStyleData.boldLacivert, textAlign: TextAlign.center),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.sirketKodu == null ? "Bulunamadı" : UtilsPolicy.findSirket(item.sirketKodu).sirketAdi, style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded, color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.sirketKodu == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,"şirketin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL("tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
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
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                    child: Text(
                                      "Açıklama",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.aciklama == null ? "Girilmemiş" : item.aciklama.toString(), style: TextStyleData.standartLacivert),
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
                          decoration: BoxDecoration(boxShadow: [
                            BoxDecorationData.shadow
                          ]),
                          child: OutlineButton(
                            child: Text("Yenile", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RenewPolicy(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxDecorationData.shadow
                          ]),
                          child: OutlineButton(
                            child: Text("Hasar bildir", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportDamage(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxDecorationData.shadow
                          ]),
                          child: OutlineButton(
                            child: Text("PDF", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
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
        margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(color: ColorData.renkBeyaz, borderRadius: BorderRadius.circular(33), boxShadow: [
          BoxDecorationData.shadow
        ]),
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
                          gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [
                            ColorData.renkLacivert,ColorData.renkMavi
                          ])),
                      child: Image.asset("assets/images/ic_healt.png"),
                      ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(item.meslek == null ? "Bulunamadı" : "${UtilsPolicy.findMeslek(item.meslek)}",overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyleData.boldMavi18),
                        ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/ic_hand.png",width: 24,height: 24,),
                      )
                  ],
                  ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Başlangıç",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.baslangicTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.baslangicTarihi)), style: TextStyleData.boldAcikSiyah),
                        ),),
                  ],),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Bitiş",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.bitisTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.bitisTarihi)), style: TextStyleData.boldAcikSiyah),
                        ),),
                  ],),
                SizedBox(height: 8),
              ],
              ),
            Image.asset("assets/images/ic_right_arrow.png",fit: BoxFit.contain,width: 12,height: 12,color: ColorData.renkMavi,),
          ],
          )
        );
  }

  Widget _createSeyahatListItemOldVersion(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(color: ColorData.renkBeyaz, borderRadius: BorderRadius.circular(50), boxShadow: [
          BoxDecorationData.shadow
        ]),
        child: MyExpansionTile(
          key: Key("${item.policeNumarasi}/${item.yenilemeNo}"),
          backgroundColor: Colors.transparent,
          initiallyExpanded: false,
          leading: Image.asset("assets/images/ic_travel.png", width: 50, height: 50, fit: BoxFit.contain),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.seyahatUlkeKodu == null ? "Bulunamadı" : UtilsPolicy.findUlke(item.seyahatUlkeKodu, true), style: TextStyleData.standartLacivert14),
                    Text(item.seyahatUlkeKodu == null ? "Bulunamadı" : UtilsPolicy.findUlke(item.seyahatUlkeKodu, false), overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyleData.boldLacivert),
                    Container(
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Text(item.seyahatEdenKisiSayisi == null ? "Bulunmadı" : "${item.seyahatEdenKisiSayisi} Kişi", style: TextStyleData.boldLacivert),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(padding: EdgeInsets.fromLTRB(4, 2, 4, 2), decoration: BoxDecoration(color: ColorData.renkKoyuYesil, borderRadius: BorderRadius.circular(33)), child: Text("  Başlangıç  ", style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(item.seyahatGidisTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.seyahatGidisTarihi)), style: TextStyleData.boldSiyah12),
                  ),
                  Container(padding: EdgeInsets.fromLTRB(4, 2, 4, 2), decoration: BoxDecoration(color: ColorData.renkKirmizi, borderRadius: BorderRadius.circular(33)), child: Text("       Bitiş       ", style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(item.seyahatDonusTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.seyahatDonusTarihi)), style: TextStyleData.boldSiyah12),
                  )
                ],
              )
            ],
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
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
                                Container(width: 75, alignment: Alignment.center, padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8), decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)), child: Text("Acente", style: TextStyleData.boldLacivert)),
                                Container(
                                  width: MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.acenteUnvani == null ? "Portal Üyesi Değil" : _findAcente(item.acenteUnvani).unvani, style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded, color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.acenteUnvani == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,"Acentenin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL("tel:${_findAcente(item.acenteUnvani).telefon}");
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
                                Container(width: 75, alignment: Alignment.center, padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8), decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)), child: Text("Sigorta Şirketi", style: TextStyleData.boldLacivert, textAlign: TextAlign.center)),
                                Container(
                                  width: MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.sirketKodu == null ? "Bulunamadı" : UtilsPolicy.findSirket(item.sirketKodu).sirketAdi, style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded, color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.sirketKodu == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,"şirketin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL("tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
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
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                    child: Text(
                                      "Açıklama",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.aciklama == null ? "Girilmemiş" : item.aciklama.toString(), style: TextStyleData.standartLacivert),
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
                          decoration: BoxDecoration(boxShadow: [
                            BoxDecorationData.shadow
                          ]),
                          child: OutlineButton(
                            child: Text("Hasar bildir", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportDamage(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxDecorationData.shadow
                          ]),
                          child: OutlineButton(
                            child: Text("PDF", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
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
        margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(color: ColorData.renkBeyaz, borderRadius: BorderRadius.circular(33), boxShadow: [
          BoxDecorationData.shadow
        ]),
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
                          gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [
                            ColorData.renkLacivert,ColorData.renkMavi
                          ])),
                      child: Image.asset("assets/images/ic_travel.png"),
                      ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(item.seyahatUlkeKodu == null ? "Bulunamadı" : UtilsPolicy.findUlke(item.seyahatUlkeKodu, false), overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyleData.boldMavi18),
                        ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/ic_hand.png",width: 24,height: 24,),
                      )
                  ],
                  ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Ülke Türü",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.seyahatUlkeKodu == null ? "Bulunamadı" : UtilsPolicy.findUlke(item.seyahatUlkeKodu, true), overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyleData.boldAcikSiyah),

                        ),),
                  ],),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Kişi Sayısı",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.seyahatEdenKisiSayisi == null ? "Bulunamadı" : item.seyahatEdenKisiSayisi.toString(), overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyleData.boldAcikSiyah),

                        ),),
                  ],),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Gidiş",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.seyahatGidisTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.seyahatGidisTarihi)), style: TextStyleData.boldAcikSiyah),
                        ),),
                  ],),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Dönüş",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.seyahatDonusTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.seyahatDonusTarihi)), style: TextStyleData.boldAcikSiyah),
                        ),),
                  ],),
                SizedBox(height: 8),
              ],
              ),
            Image.asset("assets/images/ic_right_arrow.png",fit: BoxFit.contain,width: 12,height: 12,color: ColorData.renkMavi,),
          ],
          )
        );
  }

  Widget _createDigerListItemOldVersion(PolicyResponse item) {
    return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(color: ColorData.renkBeyaz, borderRadius: BorderRadius.circular(50), boxShadow: [
          BoxDecorationData.shadow
        ]),
        child: MyExpansionTile(
          key: Key("${item.policeNumarasi}/${item.yenilemeNo}"),
          backgroundColor: Colors.transparent,
          initiallyExpanded: false,
          leading: Image.asset("assets/images/ic_other.png", width: 50, height: 50, fit: BoxFit.contain),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.ilKodu == null ? "Bulunamadı" : "${UtilsPolicy.findIL(item.ilKodu)}/${UtilsPolicy.findILCE(item.ilceKodu)}", style: TextStyleData.standartLacivert14),
                    Text(item.bransKodu == null ? "Bulunamadı" : UtilsPolicy.findSigortaTuru(item.bransKodu, false), style: TextStyleData.boldLacivert),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(padding: EdgeInsets.fromLTRB(4, 2, 4, 2), decoration: BoxDecoration(color: ColorData.renkKoyuYesil, borderRadius: BorderRadius.circular(33)), child: Text("  Başlangıç  ", style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(item.baslangicTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.baslangicTarihi)), style: TextStyleData.boldSiyah12),
                  ),
                  Container(padding: EdgeInsets.fromLTRB(4, 2, 4, 2), decoration: BoxDecoration(color: ColorData.renkKirmizi, borderRadius: BorderRadius.circular(33)), child: Text("       Bitiş       ", style: TextStyleData.boldBeyaz12)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Text(item.bitisTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.bitisTarihi)), style: TextStyleData.boldSiyah12),
                  )
                ],
              )
            ],
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
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
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                  child: Text("Acente", style: TextStyleData.boldLacivert),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.acenteUnvani == null ? "Portal Üyesi Değil" : _findAcente(item.acenteUnvani).unvani, style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded, color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.acenteUnvani == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,"Acentenin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL("tel:${_findAcente(item.acenteUnvani).telefon}");
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
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                  child: Text("Sigorta Şirketi", style: TextStyleData.boldLacivert, textAlign: TextAlign.center),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.sirketKodu == null ? "Bulunamadı" : UtilsPolicy.findSirket(item.sirketKodu).sirketAdi, style: TextStyleData.standartLacivert),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: InkWell(
                                    child: Icon(Icons.phone_forwarded, color: ColorData.renkLacivert),
                                    onTap: () {
                                      if (item.sirketKodu == null)
                                        UtilsPolicy.showSnackBar(_scaffoldKey,"şirketin telefon bilgisi bulunamadı");
                                      else
                                        Utils.launchURL("tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
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
                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(color: ColorData.renkKoyuGri, borderRadius: BorderRadius.circular(33)),
                                    child: Text(
                                      "Açıklama",
                                      style: TextStyleData.boldLacivert,
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: Text(item.aciklama == null ? "Girilmemiş" : item.aciklama.toString(), style: TextStyleData.standartLacivert),
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
                          decoration: BoxDecoration(boxShadow: [
                            BoxDecorationData.shadow
                          ]),
                          child: OutlineButton(
                            child: Text("Yenile", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RenewPolicy(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxDecorationData.shadow
                          ]),
                          child: OutlineButton(
                            child: Text("Hasar bildir", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportDamage(policyResponse: item)));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxDecorationData.shadow
                          ]),
                          child: OutlineButton(
                            child: Text("PDF", style: TextStyleData.boldLacivert),
                            shape: StadiumBorder(),
                            borderSide: BorderSide(color: ColorData.renkLacivert, style: BorderStyle.solid, width: 2),
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
        margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(color: ColorData.renkBeyaz, borderRadius: BorderRadius.circular(33), boxShadow: [
          BoxDecorationData.shadow
        ]),
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
                          gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [
                            ColorData.renkLacivert,ColorData.renkMavi
                          ])),
                      child: Image.asset("assets/images/ic_other.png"),
                      ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(item.bransKodu == null ? "Bulunamadı" : UtilsPolicy.findSigortaTuru(item.bransKodu, false), overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyleData.boldMavi18),
                        ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/ic_hand.png",width: 24,height: 24,),
                      )
                  ],
                  ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("İl",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.ilKodu == null ? "Bulunamadı" : "${UtilsPolicy.findIL(item.ilKodu)}", overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyleData.boldAcikSiyah),
                        ),),
                  ],),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("İlçe",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.ilKodu == null ? "Bulunamadı" : "${UtilsPolicy.findILCE(item.ilceKodu)}", overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyleData.boldAcikSiyah),

                        ),),
                  ],),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Başlangıç",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.baslangicTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.baslangicTarihi)), style: TextStyleData.boldAcikSiyah),
                        ),),
                  ],),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Bitiş",style: TextStyleData.boldSolukGri)),
                    Container(
                      width: MediaQuery.of(context).size.width-250,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(color: ColorData.renkGri, borderRadius: BorderRadius.circular(33)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(item.bitisTarihi == null ? "Bulunamadı" : DateFormat("dd/MM/yyyy").format(DateTime.parse(item.bitisTarihi)), style: TextStyleData.boldAcikSiyah),
                        ),),
                  ],),
                SizedBox(height: 8),
              ],
              ),
            Image.asset("assets/images/ic_right_arrow.png",fit: BoxFit.contain,width: 12,height: 12,color: ColorData.renkMavi,),
          ],
          )
        );

  }

  Widget _getTopSlider() {
    final urunSlider = CarouselSlider(
      items: [
        _createSliderItem("https://cdn.pixabay.com/photo/2019/12/17/09/59/horse-4701283_960_720.jpg", _kullaniciInfo[0] + " " + _kullaniciInfo[1], "99", "TÜMÜ", _tumuPolicyList.length.toString()),
        _createSliderItem("https://cdn.pixabay.com/photo/2019/12/17/09/59/horse-4701283_960_720.jpg", _kullaniciInfo[0] + " " + _kullaniciInfo[1], "85", "ARAÇ", _aracPolicyList.length.toString()),
        _createSliderItem("https://cdn.pixabay.com/photo/2019/12/17/09/59/horse-4701283_960_720.jpg", _kullaniciInfo[0] + " " + _kullaniciInfo[1], "81", "KONUT", _konutPolicyList.length.toString()),
        _createSliderItem("https://cdn.pixabay.com/photo/2019/12/17/09/59/horse-4701283_960_720.jpg", _kullaniciInfo[0] + " " + _kullaniciInfo[1], "48", "DASK", _daskPolicyList.length.toString()),
        _createSliderItem("https://cdn.pixabay.com/photo/2019/12/17/09/59/horse-4701283_960_720.jpg", _kullaniciInfo[0] + " " + _kullaniciInfo[1], "65", "SAĞLIK", _saglikPolicyList.length.toString()),
        _createSliderItem("https://cdn.pixabay.com/photo/2019/12/17/09/59/horse-4701283_960_720.jpg", _kullaniciInfo[0] + " " + _kullaniciInfo[1], "65", "SEYAHAT", _seyahatPolicyList.length.toString()),
        _createSliderItem("https://cdn.pixabay.com/photo/2019/12/17/09/59/horse-4701283_960_720.jpg", _kullaniciInfo[0] + " " + _kullaniciInfo[1], "65", "DİĞER", _digerPolicyList.length.toString()),
      ],

      autoPlay: false,
      enlargeCenterPage: true,
      viewportFraction: 1.0,
      aspectRatio: 2.0,
      initialPage: widget.currentIndex,
      onPageChanged: ((index) {
        setState(() {
          widget.currentIndex = index;
          WidgetsBinding.instance.addPostFrameCallback(_onBuildCompleted);
        });
      }),
    );
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width , height: 77,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: urunSlider,
            )),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: InkWell(
                onTap: () => urunSlider.previousPage(duration: Duration(milliseconds: 300), curve: Curves.linear),
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
                onTap: () => urunSlider.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear),
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

  Widget _createSliderItem(String imageUrl, String adSoyad, String riskOrani, String urunAdi, String urunAdeti) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/ikonlar-2.png"), alignment: Alignment.topCenter, fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(45),
          gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.topRight,stops: [0.1,0.8], colors: [
            Color(0xff0047FD),
            Color(0xff0B1A3D)
          ]),
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
                  decoration: BoxDecoration(color: ColorData.renkKirmizi, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Image.asset("assets/images/clip-3.png"),
                  ) //CircleAvatar(backgroundColor: ColorData.renkKirmizi,backgroundImage: NetworkImage(imageUrl)),
                  ),
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
                margin: EdgeInsets.only(left: 8,right: 24),
                decoration: BoxDecoration(shape: BoxShape.circle, color: ColorData.renkYesil),
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
    switch (widget.currentIndex) {
      case 0:
        _tumuRefreshIndicatorKey.currentState.show();
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
    _getAracPoliciesList().whenComplete(() =>
        _getKonutPoliciesList().whenComplete(() =>
            _getDaskPoliciesList().whenComplete(() =>
                _getSaglikPoliciesList().whenComplete(() =>
                    _getSeyahatPoliciesList().whenComplete(() =>
                        _getDigerPoliciesList().whenComplete((){
                          setState(() {
                            _tumuPolicyList.clear();
                            _tumuPolicyList.addAll(_aracPolicyList);
                            _tumuPolicyList.addAll(_konutPolicyList);
                            _tumuPolicyList.addAll(_daskPolicyList);
                            _tumuPolicyList.addAll(_saglikPolicyList);
                            _tumuPolicyList.addAll(_seyahatPolicyList);
                            _tumuPolicyList.addAll(_digerPolicyList);
                          });
                        }))))));
  }

  Future<Null> _getAracPoliciesList() async {
    await WebAPI.policiesRequest(token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "1").then((responseList) {
      setState(() {
        _trafikPolicyList.clear();
        _trafikPolicyList = responseList;
      });
    }).then((value) {
      WebAPI.policiesRequest(token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "2").then((responseList) {
        setState(() {
          _kaskoPolicyList.clear();
          _kaskoPolicyList = responseList;
        });
      }).then((value) {
        _aracPolicyList.clear();
        setState(() {
          _aracPolicyList.addAll(_kaskoPolicyList + _trafikPolicyList);
          return null;
        });
      });
    });
  }

  Future<Null> _getKonutPoliciesList() async {
    await WebAPI.policiesRequest(token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "22").then((responseList) {
      setState(() {
        _konutPolicyList.clear();
        _konutPolicyList = responseList;
      });
    });
  }

  Future<Null> _getDaskPoliciesList() async {
    await WebAPI.policiesRequest(token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "11").then((responseList) {
      setState(() {
        _daskPolicyList.clear();
        _daskPolicyList = responseList;
      });
    });
  }

  Future<Null> _getSaglikPoliciesList() async {
    await WebAPI.policiesRequest(token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "4").then((responseList) {
      setState(() {
        _genelSaglikPolicyList.clear();
        _genelSaglikPolicyList = responseList;
      });
    }).then((value) {
      WebAPI.policiesRequest(token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "8").then((responseList) {
        setState(() {
          _tamamlayiciSaglikPolicyList.clear();
          _tamamlayiciSaglikPolicyList = responseList;
        });
      }).then((value) {
        _saglikPolicyList.clear();
        setState(() {
          _saglikPolicyList.addAll(_genelSaglikPolicyList + _tamamlayiciSaglikPolicyList);
          return null;
        });
      });
    });
  }

  Future<Null> _getSeyahatPoliciesList() async {
    await WebAPI.policiesRequest(token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "21").then((responseList) {
      setState(() {
        _seyahatPolicyList.clear();
        _seyahatPolicyList = responseList;
      });
    });
  }

  Future<Null> _getDigerPoliciesList() async {
    await WebAPI.policiesRequest(token: _kullaniciInfo[3], tckn: _kullaniciInfo[2], brans: "3").then((responseList) {
      setState(() {
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
 /*    Utils.getAracTip(AracMarka(markaAdi: "Marka", markaKodu: "-1")).then((value) => _aracTip = value); */
    Utils.getILCE(IL(ilAdi: "İl", ilKodu: "-1")).then((value) => _ilceList = value);
    Utils.getMeslek().then((value) => _meslekList = value);
    Utils.getUlke("-1").then((value) => _ulkeList = value);
    Utils.getSigortaTuru().then((value) => _sigortaTurList = value);
  }

 /*  String UtilsPolicy.findMarka(String kod) {
    String result = "Bulunamadı";
    _aracMarka.forEach((item) {
      if (item.markaKodu == kod) result = item.markaAdi;
    });
    return result;
  }

  String UtilsPolicy.findModel(String model,String marka) {
     String result = "";
    result = WebAPI.aracTipList.firstWhere((x) => x.markaKodu == marka && x.tipKodu==model) != null
        ? WebAPI.aracTipList.firstWhere((x) => x.markaKodu == marka && x.tipKodu==model).tipAdi
        : "Bulunamadı"; 
   /*  _aracTip.forEach((item) {
      if (item.tipKodu == model && item.markaKodu == marka) result = item.tipAdi;
    }); */
    return result;
  } */

  Acente _findAcente(int kod) {
    Acente result = Acente(unvani: "Portal Üyesi Değil");
    _acente.forEach((item) {
      if (item.kodu == kod) result = item;
    });
    return result;
  }

 /*  SigortaSirketi UtilsPolicy.findSirket(String kod) {
    SigortaSirketi result = SigortaSirketi(sirketAdi: "Bulunamadı");
    _sigortaSirketi.forEach((item) {
      if (item.sirketKodu == kod) result = item;
    });
    return result;
  } */
/* 
  String UtilsPolicy.findIL(String ilKodu) {
    String result = "Bulunamadı";
    _ilList.forEach((item) {
      if (item.ilKodu == ilKodu) result = item.ilAdi;
    });
    return result;
  } */

 /*  String UtilsPolicy.findILCE(int ilceKodu) {
    String result = "Bulunamadı";
    _ilceList.forEach((item) {
      if (item.ilceKodu == ilceKodu) result = item.ilceAdi;
    });
    return result;
  } */

  /* String UtilsPolicy.findMeslek(String meslekKodu) {
    String result = "Bulunamadı";
    _meslekList.forEach((item) {
      if (item.meslekKodu == int.parse(meslekKodu)) result = item.meslekAdi;
    });
    return result;
  } */

  /* String UtilsPolicy.findUlke(String kod, bool isTur) {
    String result = "Bulunamadı";
    _ulkeList.forEach((item) {
      if (item.ulkeKodu == kod) result = isTur ? item.ulkeTipiAdi : item.ulkeAdi;
    });
    return result;
  } */

  /* Object UtilsPolicy.findSigortaTuru(int bransKodu, bool isForTab) {
    String result = "Bulunamadı";
    List filteredList;
    if (isForTab) {
      filteredList = List();
      _sigortaTurList.forEach((item) {
        if (item.bransKodu != 1 && item.bransKodu != 2 && item.bransKodu != 22 && item.bransKodu != 11 && item.bransKodu != 4 && item.bransKodu != 21) filteredList.add(item);
      });
      return filteredList;
    } else {
      _sigortaTurList.forEach((item) {
        if (item.bransKodu == bransKodu) result = item.bransAdi;
      });
      return result;
    }
  } */
 
}
