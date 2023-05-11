import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nss_emea/CommonUrl/CommonUrl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
class pdfview extends StatefulWidget {
  String prgrmid;
  pdfview({required this.prgrmid});
 // pdfview({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

 // final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<pdfview> {
  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }
Future<PdfreportModel> fetchAlbum(String programid) async {
    final response = await http.post(Uri.parse(CommonUrl.common_url+'viewpdfreport.jsp'),body: {'programid':programid});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return PdfreportModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:FutureBuilder<PdfreportModel>(
            future: fetchAlbum(widget.prgrmid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
              body: SfPdfViewer.network(
              //  CommonUrl.common_url+snapshot.data!.reportname,
              CommonUrl.pdf_url+'sample.pdf',
                // 'http://192.168.1.79:8080/nssemea/PrReportFile/sample.pdf',
            // 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
            controller: _pdfViewerController,
            key: _pdfViewerStateKey),
              appBar: AppBar(
  
        title: Text("Report"),
      
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  _pdfViewerStateKey.currentState!.openBookmarkView();
                },
                icon: Icon(
                  Icons.bookmark,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  _pdfViewerController.jumpToPage(5);
                },
                icon: Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  _pdfViewerController.zoomLevel = 1.25;
                },
                icon: Icon(
                  Icons.zoom_in,
                  color: Colors.white,
                ))
          ],
              ),
            );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center(child: const CircularProgressIndicator());
              }),);
  }
}

// To parse this JSON data, do
//
//     final pdfreportModel = pdfreportModelFromJson(jsonString);




class PdfreportModel {
    PdfreportModel({
        required this.id,
        required this.reportname,
    });

    int id;
    String reportname;

    factory PdfreportModel.fromJson(Map<String, dynamic> json) => PdfreportModel(
        id: json["id"],
        reportname: json["reportname"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "reportname": reportname,
    };
}
