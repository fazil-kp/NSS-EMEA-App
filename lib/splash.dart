import 'dart:async';

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nss_emea/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<Splash> {


@override
  Widget build(BuildContext context) {
   return EasySplashScreen(
      logo://SizedBox(height: 200,child:    
      Image.asset(
          'assets/images/photo.jpg',height: 500,width:600),  
      
  
      title: Text(
        "NSS EMEA",
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor:Colors.white,
      showLoader: true,
      loadingText: Text("Loading..."),
      navigator: LoginPage(),
      durationInSeconds: 5,
    );
  }
}