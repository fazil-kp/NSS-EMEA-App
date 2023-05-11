import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nss_emea/CommonUrl/CommonUrl.dart';

import 'package:nss_emea/model/batchmodel.dart';
import 'package:nss_emea/model/programmodel.dart';
import 'package:nss_emea/pdf.dart';
import 'package:nss_emea/viewAttandance.dart';
import 'package:nss_emea/viewGallery.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String dropdownvalue = '2020-2022';
  var items = [
    '2020-2022',
    '2021-2023',
    '2022-2024',
  ];

  var isVisible = true;
  List<BatchModel> courselist = [];
  String cos = "";
  late dynamic dropdownValue_course = null;
  var batchid;
  @override
  void initState() {
    dropdownValue_course = null;

    getCourse();
  }

  getCourse() async {
    courselist = await getcourse();
    setState(() {});
  }

  Future<List<BatchModel>> getcourse() async {
    // log("Username in getmybookings ==" + username);
    log("inside");
    //final Map<String, dynamic> queryParameters = {};

    final response = await http.get(
      Uri.parse(CommonUrl.common_url + 'getbatch.jsp'),
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      log("statusCode====${response.statusCode}");

      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      log("parsed course====${json.decode(response.body).cast<Map<String, dynamic>>()}");
      //  print(parsed);
      log("response====${response.body}");

      return parsed
          .map<BatchModel>((json) => BatchModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load course');
    }
  }

  Future<List<ProgramModel>> fetchProgram(String batchid) async {
    final response = await http.post(
        Uri.parse(CommonUrl.common_url + 'viewprograms.jsp'),
        body: {'batchid': batchid});
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<ProgramModel>((json) => ProgramModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Programs"),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const Text("Select Course :  "),
                  courselist.isEmpty
                      ? const CircularProgressIndicator()
                      : DropdownButton<BatchModel>(
                          hint: const Text("Select Batch"),
                          value: dropdownValue_course,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          onChanged: (BatchModel? data) {
                            setState(() {
                              log("dataaa===$data");

                              dropdownValue_course = data!;
                              batchid = data.id;
                              // cos = data.course;

                              // log("dataaa22===$cos");

                              // log("clcikediddd===${data.id}");
                              // cos_id = data.id.toString();
                              // log("clcikedidddsemester================${selectedSem}");
                              // stdentAttandance =
                              //     getStudentAttandance(selectedSem, cos_id);
                            });
                            //  stdentAttandance = getStudentAttandance("Semester 1",cos_id );
                          },
                          items: courselist.map<DropdownMenuItem<BatchModel>>(
                              (BatchModel value) {
                            return DropdownMenuItem<BatchModel>(
                              value: value,
                              child: Text(value.batchname),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
          ),
        ),
      batchid==null?SizedBox():  Container(
        height: 500,
        child: FutureBuilder(
              future: fetchProgram(batchid.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            
                            decoration: BoxDecoration(
                                color: Color.fromARGB(61, 90, 91, 91),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Padding(
                                   padding: const EdgeInsets.only(top: 20,right: 20),
                                   child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                       
                                       
                                        Text(
                                         snapshot.data![index].date.toString(),
                                          // "15-01-2023",
                                          style: TextStyle(
                                            color: Colors.red.shade900,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                 ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    snapshot.data![index].name,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    // "Palliative Day",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                               
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      pdfview(prgrmid:snapshot
                                                          .data![index].id.toString() ,)));
                                        },
                                        child: Text("Report")),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          log("prgrm id =="+ snapshot
                                                          .data![index].id.toString());
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>ViewGallery(
                                                      prgrmid: snapshot
                                                          .data![index].id.toString(),
                                                    )),
                                          );
                                        },
                                        child: Text("Gallery")),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(

                                        onPressed: () {
                                          log("attandance ==");
                                        Navigator.push(
                                            context,    MaterialPageRoute(
                                                builder: (context) =>ViewAttandance(
                                                      programid: snapshot
                                                          .data![index].id.toString(),
                                                    )));
                                        },
                                        child: Text("Attendance")),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,)
                              ],
                            ),
                          ),
                        );
                     
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
      )
      ]),
    );
  }
}


class ViewGallery extends StatelessWidget {
String prgrmid;
   ViewGallery({required this.prgrmid});
  Future<List<Post>> fetchGallery(String prgrmid) async {
    final response = await http.post(
        Uri.parse(CommonUrl.common_url +'viewgallery.jsp'),
        body: {'prgrmid': prgrmid});
    if (response.statusCode == 200) {
      log("response ==="+response.body.toString());
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<Post>((json) => Post.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load album');
    }
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          title: Text('Gallery'),
        ),
        body: FutureBuilder(
            future: fetchGallery(prgrmid.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                log("length --"+snapshot.data!.length.toString());
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                          itemCount: snapshot.data!.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  image: DecorationImage(
                                      image: NetworkImage(CommonUrl.gallery_url+snapshot.data![index].photo),
                                      fit: BoxFit.cover)),
                              // child: Image.asset(images[index])
                            );
                          },
                        ),
                );
                   
               
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);



class Post {
    Post({
        required this.id,
        required this.photo,
    });

    int id;
    String photo;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        photo: json["photo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "photo": photo,
    };
}
