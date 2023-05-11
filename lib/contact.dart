import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:nss_emea/CommonUrl/CommonUrl.dart';
import 'package:url_launcher/url_launcher.dart';
class contact extends StatefulWidget {
  const contact({Key? key}) : super(key: key);

  @override
  State<contact> createState() => _contactState();
}

class _contactState extends State<contact> {
  late Future<ContactModel> futureContact;
  void initState() {
    super.initState();
    futureContact = fetchAlbum();
  }

  Future<ContactModel> fetchAlbum() async {
    final response = await http.get(Uri.parse(CommonUrl.common_url+'viewcontact.jsp'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ContactModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
  _launchInsta() async {
    // var whatsapp = "+91" + number;
    var account = "nss_emea_college";
    var nativeUrl = Uri.parse("instagram://user?username=$account");
    var webUrl = Uri.parse("https://www.instagram.com/severinas_app/");

    // var whatsappAndroid = Uri.parse("https://www.instagram.com/_u/$account");
    if (await canLaunchUrl(webUrl)) {
      await launchUrl(nativeUrl);
    } else {
      await launchUrl(nativeUrl);
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
      appBar: AppBar(
        title: Text("Contact Us"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<ContactModel>(
            future: futureContact,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                 // height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person),
                            //  Text(

                            //                     'name:  ',

                            //                     style: TextStyle(

                            //                       fontSize: 20,

                            //                       color: Colors.blue[900],

                            //                       fontWeight: FontWeight.w500,

                            //                     ), //Textstyle

                            //                   ),

                            Text(
                              //  'Munavir Jasim',
                              snapshot.data!.name.toString(),

                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue[900],
                                fontWeight: FontWeight.w500,
                              ), //Textstyle
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.call),

                            // Text(

                            //                   'Phone: ',

                            //                   style: TextStyle(

                            //                     fontSize: 20,

                            //                     color: Colors.blue[900],

                            //                     fontWeight: FontWeight.w500,

                            //                   ), //Textstyle

                            //                 ),

                            Text(
                              // '987654323',
                              snapshot.data!.phone.toString(),

                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue[900],
                                fontWeight: FontWeight.w500,
                              ), //Textstyle
                            ),
                          ],
                        ),
                        Row(
                          children: [
                             Icon(Icons.location_on),
                            Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              child: Text(
                              //  'EMEA College of Arts & Sciene Kondotti',
                               snapshot.data!.place.toString(),
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        Row(children: <Widget>[
                          Image.asset(
                            "assets/images/instagram.png",
                            width: 25,
                            height: 20,
                          ),
                          Text(
                            snapshot.data!.instagramid,

                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blue[900],
                              fontWeight: FontWeight.w500,
                            ), //Textstyle
                          ),
                        ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                   Uri phoneno = Uri.parse('tel:+91'+snapshot.data!.phone.toString());
                      if (await launchUrl(phoneno)) {
                        //dialer opened
                      } else {
                        //dailer is not opened
                      }
                                }, child: Text("call us")),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  log("visit");
                                
                                 _launchInsta();
                                    log("message");
                                },
                                child: Text("visit instagram")),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                   );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center(child: const CircularProgressIndicator());
              }),
      ),
    );
  }
}

ContactModel contactModelFromJson(String str) =>
    ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel {
  ContactModel({
    required this.name,
    required this.phone,
    required this.place,
    required this.instagramid
  });

  String name;
  String phone;
  String place;
  String instagramid;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        name: json["name"].toString(),
        phone: json["phone"].toString(),
        place: json["place"].toString(),
        instagramid:json["nss_instagram"].toString()
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "place": place,
        "nss_instagram":instagramid
      };
}
