import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/widgets/MyExpansionTile.dart';

class SearchCompanyAgent extends StatefulWidget {
  @override
  _SearchCompanyAgentState createState() => _SearchCompanyAgentState();
}

class _SearchCompanyAgentState extends State<SearchCompanyAgent> with TickerProviderStateMixin {
  List _acenteList = List();
  List _sirketList = List();
  TextEditingController _searchController = TextEditingController();
  TabController _tabController;
  String _searchText = "";
  bool isCompany = true;

  @override
  void initState() {
    super.initState();
    _getLists();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorData.renkLacivert,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 230,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 32, left: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            icon: Image.asset("assets/images/circle_arrow.png"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FlatButton(
                                shape: StadiumBorder(),
                                child: Text("Şirketler", style: isCompany ? TextStyleData.standartYesil36 : TextStyleData.standartMavi36),
                                onPressed: () => handleTap(true),
                              ),
                              SizedBox(width: 24),
                              Container(color: isCompany ? ColorData.renkYesil : ColorData.renkLacivert, width: 10, height: 40, child: Text(""))
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FlatButton(
                                shape: StadiumBorder(),
                                child: Text("Acenteler", style: isCompany ? TextStyleData.standartMavi36 : TextStyleData.standartYesil36),
                                onPressed: () => handleTap(false),
                              ),
                              SizedBox(width: 24),
                              Container(color: isCompany ? ColorData.renkLacivert : ColorData.renkYesil, width: 10, height: 40, child: Text(""))
                            ],
                          ),
                        ]),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(right: 48),
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      style: TextStyleData.boldYesil,
                      cursorColor: ColorData.renkYesil,
                      decoration: InputDecoration(
                        isDense: true,
                        suffixIcon: Image.asset("assets/images/ic_search.png"),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorData.renkYesil),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorData.renkYesil),
                        ),
                      ),
                      controller: _searchController,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: MediaQuery.of(context).size.height - 250,
              child: isCompany
                  ? Center(
                      child: _sirketList.length == 0
                          ? CircularProgressIndicator()
                          : ListView.builder(
                              itemCount: _sirketList.length,
                              itemBuilder: (BuildContext bContext, index) {
                                return _searchText == null || _searchText == "" ? _createListItem(_sirketList[index].sirketAdi, _sirketList[index].telefon, _sirketList[index].email, index) : _sirketList[index].sirketAdi.toString().toLowerCase().contains(_searchText.toLowerCase()) ? _createListItem(_sirketList[index].sirketAdi, _sirketList[index].telefon, _sirketList[index].email, index) : Container();
                              }),
                    )
                  : Center(
                      child: _acenteList.length == 0
                          ? CircularProgressIndicator()
                          : ListView.builder(
                              itemCount: _acenteList.length,
                              itemBuilder: (BuildContext bContext, index) {
                                return _searchText == null || _searchText == "" ? _createListItem(_acenteList[index].unvani, _acenteList[index].telefon, _acenteList[index].email, index) : _acenteList[index].unvani.toString().toLowerCase().contains(_searchText.toLowerCase()) ? _createListItem(_acenteList[index].unvani, _acenteList[index].telefon, _acenteList[index].email, index) : Container();
                              }),
                    ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _createListItem(String ad, String telefon, String eposta, int index) {
    ad = ad==null? "":ad;
    telefon = telefon ==null?"":telefon;
    eposta = eposta==null?"":eposta;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(color: ColorData.renkLacivert),
        child: ListTile(
          key: Key("$index"),
          title: Text(ad, style: TextStyleData.boldBeyaz),
          trailing: Icon(Icons.keyboard_arrow_right, color: ColorData.renkYesil),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ItemDetail(ad, telefon, eposta, isCompany)));
          },
        ));
  }

  void _getLists() async {
    List tempAcente = await Utils.getAcente();
    List tempSirket = await Utils.getSigortaSirketi();
    setState(() {
      _sirketList = tempSirket;
      _acenteList = tempAcente;
    });
  }

  void handleTap(bool status) {
    setState(() {
      isCompany = status;
    });
  }
}

class ItemDetail extends StatefulWidget {
  final String ad, telefon, eposta;
  final bool isCompany;

  ItemDetail(this.ad, this.telefon, this.eposta, this.isCompany);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    bool telefonInfo = widget.telefon == null || widget.telefon == "";
    bool epostaInfo = widget.eposta == null || widget.eposta == "";
    return Scaffold(
      backgroundColor: ColorData.renkLacivert,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 32, left: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Image.asset("assets/images/circle_arrow.png"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("${widget.isCompany ? "Şirket" : "Acente"} Bilgileri", style: TextStyleData.standartYesil24),
                      SizedBox(width: 24),
                      Container(color: ColorData.renkYesil, width: 10, height: 40, child: Text(""))
                    ],
                  ),
                ]),
              ],
            ),
          ),
          SizedBox(height: 64),
          Text(widget.ad, style: TextStyleData.boldBeyaz24,textAlign: TextAlign.center),
          SizedBox(height: 16),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
            padding: EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border.all(color: ColorData.renkYesil),borderRadius: BorderRadius.circular(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            icon: Image.asset("assets/images/ic_phone.png"),
                            onPressed: () {
                              if(!telefonInfo) Utils.launchURL("tel:${widget.telefon}");
                            }),
                      ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(telefonInfo ? "Bulunamadı" : widget.telefon, style: TextStyleData.standartBeyaz,textAlign: TextAlign.center),
                  ),
                ],
              )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border.all(color: ColorData.renkYesil),borderRadius: BorderRadius.circular(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                   Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            icon: Image.asset("assets/images/ic_message.png"),
                            onPressed: () {
                              if(!epostaInfo) Utils.launchURL("mailto:${widget.eposta}");
                            }),
                      ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(epostaInfo ? "Bulunamadı" : widget.eposta, style: TextStyleData.standartBeyaz,textAlign: TextAlign.center),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
