import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nss_emea/CommonUrl/CommonUrl.dart';
import 'package:nss_emea/model/attandancemodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewAttandance extends StatefulWidget {
  String programid;
  ViewAttandance({required this.programid});

  @override
  State<ViewAttandance> createState() => _ViewAttandanceState();
}

class _ViewAttandanceState extends State<ViewAttandance> {

  Future<AttandanceModel> fetchAlbum(String programid,username) async {
    final response = await http.post(Uri.parse(CommonUrl.common_url+'viewattandance.jsp'),body: {'prgrmid':programid.toString(),'username':username.toString()});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return AttandanceModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
    SharedPreferences? logindata;

   String? username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata!.getString('username')!;
      log("username =="+username.toString());
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Attendance")),
      body:FutureBuilder<AttandanceModel>(
            future: fetchAlbum(widget.programid.toString(),username.toString()),

            builder: (context, snapshot) {
              if (snapshot.hasData) {
          log("valuee ==="+snapshot.data!.attandance.toString());
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
          children: [
       
         Text("Present",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        SizedBox(height: 20,),
          
            Container(
              height: 100,
              width: 150,
              child: Image.asset(
                  "assets/images/tick.jpg",
                  fit: BoxFit.cover,
              ),
            ),
              // child: Image.asset(
              //     "assets/images/cross1.png",
              //     fit: BoxFit.cover,
              // ),
          
          ],
       ),
                );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Absent",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        Icon(Icons.cancel,color: Colors.red.shade900,size: 200,),
                      ],
                    ),
                  );
                }else if (!snapshot.hasData) {
                  return Text('Loding.....');
                }
                return Center(child: const CircularProgressIndicator());
              }),
    );
  }
}
