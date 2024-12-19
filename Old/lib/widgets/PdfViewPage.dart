import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:sigortadefterim/AppStyle.dart'; 

class PdfViewPage extends StatefulWidget {
  final String path;

  const PdfViewPage({Key key, this.path}) : super(key: key);

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  int _totalPages = 0;
  int _currentPage = 1;
  bool pdfReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          
          PDFView(
            filePath: widget.path,
            onError: (e) {
              print(e);
            },
            onRender: (_pages) {
              setState(() {
                _totalPages = _pages;
                pdfReady = true;
              });
            },
            onPageChanged: (int page, int total) {
              setState(() {
                _currentPage = page + 1;
              });
            },
          ), 
            !pdfReady
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage()
        ],
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: ColorData.renkLacivert, borderRadius: BorderRadius.circular(33)),
        child: Text("$_currentPage/$_totalPages", style: TextStyleData.standartYesil),
      ),
    );
  }
}
