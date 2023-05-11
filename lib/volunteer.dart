import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nss_emea/CommonUrl/CommonUrl.dart';
import 'package:nss_emea/model/batchmodel.dart';
import 'package:url_launcher/url_launcher.dart';


import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Volunteer extends StatefulWidget {
  Volunteer({super.key});

  @override
  State<Volunteer> createState() => _volunteerState();
}

class _volunteerState extends State<Volunteer> {
  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  List<BatchModel> courselist = [];
  var batchid;
  dynamic dropdownValue_course = null;

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

  Future<List<ValanteersModel>> fetchvolunteer(String batchid) async {
    final response = await http.post(
        Uri.parse(CommonUrl.common_url + 'viewvalanteer.jsp'),
        body: {'batchid': batchid});

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed
          .map<ValanteersModel>((json) => ValanteersModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  late Future<List<ValanteersModel>> Allvolunteer;
  @override
  void initState() {
    super.initState();
    dropdownValue_course = null;
    getCourse();
  }
 _launchWhatsapp(String number) async {
      var whatsapp = "+91" + number;
      var whatsappAndroid =
          Uri.parse("whatsapp://send?phone=$whatsapp&text=hello");
      if (await canLaunchUrl(whatsappAndroid)) {
        await launchUrl(whatsappAndroid);
      } else {
        await launchUrl(whatsappAndroid);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text("WhatsApp is not installed on the device"),
        //   ),
        // );
      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Volunteers")),
        body: ListView(
          children: [
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
                              items: courselist
                                  .map<DropdownMenuItem<BatchModel>>(
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
            batchid == null
                ? SizedBox()
                : Container(
                 
                   height:800,
                    child: FutureBuilder<List<ValanteersModel>>(
                      future: fetchvolunteer(batchid.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) => Container(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(61, 90, 91, 91),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snapshot.data![index].name}",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("${snapshot.data![index].email}"),
                                    SizedBox(height: 10),
                                    Text(
                                        "${snapshot.data![index].phone.toString()}"),
                                    Text(
                                        "Unit.no : ${snapshot.data![index].unitno}"),
                                         Text(
                                        "Department :${snapshot.data![index].department}"),
                                    Text(
                                        "Blood Grp :${snapshot.data![index].bloodgroup}"),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                      
                                            InkWell(onTap: () {
                                              log("watsapp number =="+snapshot.data![index].phone.toString());
                                              _launchWhatsapp(snapshot.data![index].phone.toString());
                                            },
                                              child: Image.asset("assets/images/w2.png",height: 30,width: 30,)),
                                              IconButton(
                                            onPressed: () async {
                                              log("call");
                                             Uri phoneno = Uri.parse('tel:+91'+snapshot.data![index].phone.toString());
                      if (await launchUrl(phoneno)) {
                        //dialer opened
                      } else {
                        //dailer is not opened
                      }
                                            },
                                            icon: Icon(Icons.call,color: Colors.red.shade900,)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  )
          ],
        ));
  }
}

class ValanteersModel {
  ValanteersModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.unitno,
      this.phone,
      required this.department,
      required this.bloodgroup});

  int id;
  String name;
  String email;
  String unitno;
  String? phone;
  String department;
  String bloodgroup;

  factory ValanteersModel.fromJson(Map<String, dynamic> json) =>
      ValanteersModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        unitno: json["unitno"],
        phone: json["phone"],
        department: json["department"],
        bloodgroup: json["bloodgroup"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "unitno": unitno,
        "phone": phone,
        "department": department,
        "bloodgroup": bloodgroup,
      };
}
