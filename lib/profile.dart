import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nss_emea/CommonUrl/CommonUrl.dart';
import 'package:nss_emea/editprofile.dart';
import 'package:nss_emea/model/profilemodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
    Future<ProfileModel> fetchProfile(String username) async {
    final response = await http.post(Uri.parse(CommonUrl.common_url+'viewprofile.jsp'),body: {'username':username});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ProfileModel.fromJson(jsonDecode(response.body));
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
    });
  }
  var name,phonenumber,email,departmentname,batchname,bloodgrp,unitno;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body:FutureBuilder<ProfileModel>(
            future: fetchProfile(username.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                name=snapshot.data!.name;
                email=snapshot.data!.email.toString();
                phonenumber=snapshot.data!.phone.toString();
                departmentname=snapshot.data!.departmentname.toString();
                batchname=snapshot.data!.batchname.toString();
                bloodgrp=snapshot.data!.bloodgrp.toString();
                unitno=snapshot.data!.unitno.toString();
                final profileimage=snapshot.data!.profile;
                return ListView(children: [
          Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Center(
                child: Container(
                  child: Stack(children: <Widget>[
                    CircleAvatar(
                      radius: 80.0,
                      backgroundImage: NetworkImage(CommonUrl.profile_url+profileimage)
                        
                    ),
                   
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 50, bottom: 10),
                child: TextFormField(
                  enabled: false,
                  initialValue: name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintText: "Full Name",
                      //  ' Name',
      
                      labelText:
                          //  "abc",
                          "Full Name"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: TextFormField(
                  enabled: false,
                  initialValue: email,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintText: ' Email ',
                      labelText: "Email"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: TextFormField(
              enabled: false,
              initialValue: phonenumber,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    hintText: "Phone number",
                    labelText: 'Phone number',
                  ),
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: TextFormField(
                  enabled: false,
                  initialValue: departmentname,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintText: ' Department ',
                      labelText: "Department"),
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: TextFormField(
                  enabled: false,
                  initialValue: batchname,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintText: ' Batch ',
                      labelText: "Batch"),
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: TextFormField(
                  enabled: false,
                  initialValue: bloodgrp,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintText: ' Blood Group ',
                      labelText: "Blood Group"
                      ),
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: TextFormField(
                  enabled: false,
                  initialValue: unitno,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintText: ' Unit no ',
                      labelText: "Unit no"
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Container(
                  height: 50,
                  width: 500,
                  child: ElevatedButton(
                    onPressed: () {
                      log("edit profile");
                       Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => UpdateProfile()));
                                   },
                    child: Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                        // elevation: 10,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.blue),
                        ),
                        primary: Colors.blue,
                    // child: Text(' Login'.toUpperCase())
                  ),
                ),
              )
          )],
          ),
        ] );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center(child: const CircularProgressIndicator());
              }),
    );
  }
}