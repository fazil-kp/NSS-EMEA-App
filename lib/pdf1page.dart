import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nss_emea/pdfapi.dart';
import 'package:nss_emea/pdfview.dart';


class TimetablePage extends StatelessWidget {
  const TimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    // late Future<List<TimetableModel>> timetablelist;
    // Future<List<TimetableModel>> getTimetable() async {
    //   log("inside");

    //   final response = await http.get(
    //       Uri.parse("http://192.168.1.6:8080/studentstracker/timetable.jsp"));

    //   if (response.statusCode == 200) {
    //     // log(response.statusCode.t);
    //     log("statusCode====" + response.statusCode.toString());
    //     // var abc = response.body;
    //     // log('response result=' + response.body);
    //     final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    //     log("parsed====" +
    //         json.decode(response.body).cast<Map<String, dynamic>>().toString());
    //     print(parsed);
    //     log("response====" + response.body);

    //     return parsed
    //         .map<TimetableModel>((json) => TimetableModel.fromJson(json))
    //         .toList();
    //   } else {
    //     throw Exception('Failed to load course');
    //   }
    // }

    // @override
    // void initState() {
    //   // super.initState();
    //   timetablelist = getTimetable();
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text("TimeTable"),
        centerTitle: true,
      ),
      body:
      //  FutureBuilder<List<TimetableModel>>(
      //     future: getTimetable(),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         return 
              ListView.builder(
                itemCount:1,
                //  snapshot.data!.length,
                itemBuilder: (context, index) {
                  // log("length ==" + snapshot.data!.length.toString());
                  // final timetable = snapshot.data![index];

                  return Column(
                    children: [
                      Text(
                        "view pdf " ,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            log("clicked");
                            final url =
                                'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf';
                            final file = await PDFApi.loadNetwork(url);
                            openPDF(context, file);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                               "data",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.grey),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ));
    //         }
    //         return Center(child: CircularProgressIndicator());
    //       }),
    // );
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );
}
