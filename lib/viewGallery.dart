// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:nss_emea/CommonUrl/CommonUrl.dart';

// class Gallery extends StatefulWidget {
//   int programid;
//   Gallery({required this.programid});

//   @override
//   State<Gallery> createState() => _GalleryState();
// }

// class _GalleryState extends State<Gallery> {
  
//   List<String> images = [
//     "images/image1.jpg",
//     "images/image2.jpg",
//     "images/image3.jpg",
//     "images/image4.jpg",
//     "images/image5.jpg",
//     "images/image6.jpg",
//   ];

//   get http => null;
// //

// //  {
//   late Future<List<Post>> futurePost;
//   @override
//   void initState() {
//     super.initState();
   
//   }

//   Future<List<Post>> fetchPost(String programid) async {
 
//     final response = await http.post(
//         Uri.parse( 'http://192.168.1.79:8080/nssemea/viewprograms.jsp'),
      
//        // body: {'batchid': programid}
//         );
//     if (response.statusCode == 200) {
//       final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
//       return parsed.map<Post>((json) => Post.fromMap(json)).toList();
//     } else {
//       throw Exception('Failed to load album');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('GridView'),
//         ),
//         body: FutureBuilder(
//             future: fetchPost(widget.programid.toString()),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (_, index) => Center(
//                     child: Container(
//                       child: GridView.builder(
//                         itemCount: images.length,
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           crossAxisSpacing: 5.0,
//                           mainAxisSpacing: 5.0,
//                         ),
//                         itemBuilder: (BuildContext context, int index) {
//                           return Container(
//                             decoration: BoxDecoration(
//                                 color: Colors.red,
//                                 image: DecorationImage(
//                                     image: AssetImage(images[index]),
//                                     fit: BoxFit.cover)),
//                             // child: Image.asset(images[index])
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 );
//               } else {
//                 return Center(child: CircularProgressIndicator());
//               }
//             }));
//   }
// }

// //model

// List<Post> postFromJson(String str) =>
//     List<Post>.from(json.decode(str).map((x) => Post.fromMap(x)));

// class Post {
//   Post({
//     required this.id,
//     required this.programid,
//     required this.photo,
//   });
//   int? id;
//   int? programid;
//   String? photo;
//   factory Post.fromMap(Map<String, dynamic> json) => Post(
//         id: json["id"],
//         programid: json["title"],
//         photo: json["body"],
//       );

// }
