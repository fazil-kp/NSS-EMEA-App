import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClickWidget extends StatefulWidget {
  @override
  ClickWidgetState createState() => ClickWidgetState();
}

class ClickWidgetState extends State<ClickWidget> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new InkWell(
            child: new Text('Open Browser'),
            onTap: () =>
                launch('https://instagram.com/__nyz_?igshid=YmMyMTA2M2Y=')),
      ),
      // body: Center(
      //     child: RichText(
      //         textAlign: TextAlign.center,
      //         text: TextSpan(children: [
      //           TextSpan(
      //             text: "To Learn More About Flutter ",
      //             style: TextStyle(fontSize: 20, color: Colors.black),
      //           ),
      //           TextSpan(
      //               text: "Click Here",
      //               style: TextStyle(
      //                 fontSize: 20,
      //                 color: Colors.blue,
      //                 decoration: TextDecoration.underline,
      //              ),
      //               recognizer: TapGestureRecognizer()
      //                 ..onTap = () async {
      //                   var url = "https://flutter-examples.com";
      //                   if (await canLaunch(url)) {
      //                     await launch(url);
      //                   } else {
      //                     throw 'Could not launch $url';
      //                   }
      //                 }),
      //         ]))),
    );
  }
}
