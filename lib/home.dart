import 'dart:developer';
import 'package:nss_emea/about.dart';
import 'package:nss_emea/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nss_emea/about.dart';
import 'package:nss_emea/contact.dart';
import 'package:nss_emea/editprofile.dart';
import 'package:nss_emea/login.dart';
import 'package:nss_emea/profile.dart';
import 'package:nss_emea/programreport.dart';
import 'package:nss_emea/volunteer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences logindata;

  late String username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    log("username==" + username.toString());
    // var divider;
    return Scaffold(
      appBar: AppBar(
        title: Text("NSS EMEA"),
      ),
      drawer: Drawer(
        //ListView to listdown children of drawer
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            //Drawer header for Heading part of drawer
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              //Title of header
              child: Text(
                'Welcome to NSS EMEA!!',
                style: TextStyle(fontSize: 26, color: Colors.white),
              ),
            ),
            //Child tile of drawer with specified title
            ListTile(
              title: const Text('Home'),
              //To perform action on tapping at tile
              onTap: () {
                Navigator.pop(context);
              },
            ),
            //divider,
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                  Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Profile()));
              },
            ),

            ///  divider,
            ListTile(
              title: const Text('Programs'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Report()));
              },
            ),

            ///divider,
            ListTile(
              title: const Text('Volunteers'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Volunteer()));
                // Navigator.of(context).push(MaterialPageRoute(builder:(context)=> Registration()));
              },
            ),
            ////  divider,
            ListTile(
              title: const Text('Contact'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => contact()));
              },
            ),
            // divider,
            ListTile(
              title: const Text('About'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => about()));
              },
            ),

            ///divider,
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                logindata.setBool('login', true);
                Navigator.pushReplacement(context,
                    new MaterialPageRoute(builder: (context) => LoginPage()));
                // Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      //Empty body with a empty container
      body: Center(
          /* Card Widget */
          child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 108,
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://emeacollege.ac.in/uploads/images/Images_M38_D0_F414.jpeg"),
                  radius: 100,
                ), //CircleAvatar
              ), //CircleAvatar
              const SizedBox(
                height: 10,
              ), //SizedBox
              Align(
                alignment: Alignment.center,
                child: Text(
                  'EMEA NSS',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w500,
                    
                    
                  ), //Textstyle
                ),
              ), //Text
              const SizedBox(
                height: 10,
              ), //SizedBox
              const Text(
                'The National Service Scheme has been functioning with the motto “NOT ME BUT YOU” in view of making the youth inspired in service of the people and hence NSS Aims Education through Community Service and Community Service through Education.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blueAccent,
                ), //Textstyle
              ),
            ],
          ),
        ),

        // Take Drawer widget
      )),
    );
  }
}
