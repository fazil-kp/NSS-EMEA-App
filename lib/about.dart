import 'dart:developer';
import 'package:flutter/material.dart' ; 
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
class about extends StatelessWidget {
  const about({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      //Empty body with a empty container
      body:  Center(
        /* Card Widget */
        child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 108,
                    child: const CircleAvatar(
                      backgroundImage: NetworkImage(
                        
"https://www.pngkey.com/png/full/247-2479287_nss-logo-national-service-scheme-logo-png.png"),

                      radius: 100,
                    ), //CircleAvatar
                  ), //CircleAvatar
                  const SizedBox(
                    height: 10,
                  ), //SizedBox
                  Text(
                    'Mission',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.w500,
                    ), //Textstyle
                  ), //Text
                  const SizedBox(
                    height: 10,
                  ), //SizedBox
                  const Text(
                    'The National Service Scheme has been functioning with the motto “NOT ME BUT YOU” in view of making the youth inspired in service of the people and hence NSS Aims Education through Community Service and Community Service through Education.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                    ), //Textstyle
                  ),

                  const SizedBox(
                    height: 10,
                  ), 
                  Text(
                    'Vision',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.w500,
                    ), //Textstyle
                  ), //Text
                  const SizedBox(
                    height: 10,
                  ), //SizedBox
                  const Text(

                    'The vision is to build the youth with the mind and spirit to serve the society and work for the social uplift of the down-trodden masses of our nation as a movement.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                    ), //Textstyle
                  ),
                  
                  
                   //Text
           ],
              ), //Column
            ), //Padding
          ), //SizedBox
        ), //Card
      ); //Center
}}