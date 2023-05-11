import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:nss_emea/CommonUrl/CommonUrl.dart';
import 'package:nss_emea/model/profilemodel.dart';
import 'package:nss_emea/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UpdateProfile extends StatefulWidget {
  // String username;
  // UpdateProfile({@required this.username});
  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  var  email, password, phonenumber, name;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  String uploadStatus = "";
  //SharedPreferences logindata;
  // late String username = "akshay";
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
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  Future<Map<String, dynamic>?> updateProfile(String username, String name,
      PickedFile imagefile, String phonenumber,String email) async {
        
    var res;
    var request = http.MultipartRequest(
        "POST", Uri.parse(CommonUrl.common_url+"updateProfile"));
    var pic = await http.MultipartFile.fromPath("profilePic", imagefile.path);
    request.files.add(pic);
    request.fields['username'] = username;
    request.fields['name'] = name;
    request.fields['email'] = email;
  //  request.fields['password'] = password;
    request.fields['phone'] = phonenumber;
    // request.fields['examtitle'] = examtitle;

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("aks" + responseString.toString());
    Map<String, dynamic> result;
    print(response.statusCode);
    if (response.statusCode == 200) {
      if (responseString.contains("success")) {
        setState(() {
          uploadStatus = "File Uploaded Succesfully";
        });
      } else {
        setState(() {
          uploadStatus = "Failed...........";
        });
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
//    MyViewModel Vm = Provider.of<MyViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Edit Profile",
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
                email=snapshot.data!.email;
                phonenumber=snapshot.data!.phone;
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
                      backgroundImage: _imageFile == null
                          ? NetworkImage(CommonUrl.profile_url+profileimage)
                          : FileImage(File(_imageFile!.path)) as ImageProvider,
                    ),
                    Positioned(
                        bottom: 7,
                        left: 115,
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white),
                        )),
                    Positioned(
                      bottom: 10,
                      left: 120,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey[200]),
                      ),
                    ),
                    Positioned(
                      bottom: 17.0,
                      left: 126,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: ((builder) => bottomSheet()),
                          );
                          print('CLICKEDDDDDD>>>>>>>>>>>>>>>>>>>>>>>');
                        },
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.teal,
                          size: 28.0,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 50, bottom: 10),
                child: TextFormField(
                  initialValue: name,
                 // controller: nameController,
                  onChanged: (value) {
                    name = value;
                  },
                  // initialValue: 'Input text',
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
                  initialValue: email,
                 // controller: emailcontroller,
                  onChanged: (value) {
                    email = value;
                  },
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
                  initialValue: phonenumber,
                  // controller: phonenumberController,
                  onChanged: (value) {
                    phonenumber = value;
                  },
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
                child: Container(
                  height: 50,
                  width: 500,
                  child: ElevatedButton(
                    onPressed: () {
                      // email = emailcontroller.text;
                      // password = passwordController.text;
                      // phonenumber = phonenumberController.text;
                      print("name >>>>>>>>>>>>>>>>>>>>" + name.toString());
                      print("place >>>>>>>>>>>>>>>" + email.toString());
                
                      print("phonenmber >>>>>>>>>>>>>>>" +
                          phonenumber.toString());
      
                   //   print("image>>>>>>>>>>>>>>>>>>>>>>>" + _imageFile!.path.toString());
                      print("username >>>>>>>>>>>>>>>>>>>>>>>>>>" + username.toString());
                      final image=_imageFile==null?profileimage:_imageFile;
                      log("image ---"+image.toString());
                      updateProfile(
                          username!, name, _imageFile!, phonenumber,email);
                      // updateProfile(
                      //     username, name, place, password, _imageFile, phonenumber);
                      //  if (response['status']) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => Profile(),
                        ),
                      );
                      //                 print(response);
                      //                 Search user = response['user'];
                      //               }
                    },
                    child: Text('SUBMIT'),
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

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile!;
      print("<<<<<<<<<<<<<<<<<<< IMAGE >>>>>>>>>>>>>>>>>>>>>>>" +
          _imageFile!.path);
    });
  }
}





// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class EditProfile extends StatefulWidget {
//   @override
//   _MyImagePickerState createState() => _MyImagePickerState();
// }

// class _MyImagePickerState extends State<EditProfile> {
//   PickedFile? _image;
//  String uploadStatus = "";
//   //this is a code get image from Camera
//   _imageFromCamera() async {
//     PickedFile? image = await ImagePicker()
//         .getImage(source: ImageSource.camera, imageQuality: 50);
//     setState(() {
//       _image = image!;
//     });
//   }

//   //this is a code get image from Gallery
//   _imageFromGallery() async {
//     PickedFile? image = await ImagePicker()
//         .getImage(source: ImageSource.gallery, imageQuality: 50);
//     setState(() {
//       _image = image;
//     });
//   }
//   Future<Map<String, dynamic>> updateProfile(String username, String name,
//       String password, PickedFile imagefile, String phonenumber) async {
//     var res;
//     var request = http.MultipartRequest(
//         "POST", Uri.parse("${common_url().url}/updateProfile"));
//     var pic = await http.MultipartFile.fromPath("profilePic", imagefile.path);
//     request.files.add(pic);
//     request.fields['username'] = username;
//     request.fields['name'] = name;
//     request.fields['email'] = email;
//     request.fields['password'] = password;
//     request.fields['phonenumber'] = phonenumber;
//     // request.fields['examtitle'] = examtitle;

//     var response = await request.send();
//     var responseData = await response.stream.toBytes();
//     var responseString = String.fromCharCodes(responseData);
//     print("aks" + responseString.toString());
//     Map<String, dynamic> result;
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       if (responseString.contains("success")) {
//         setState(() {
//           uploadStatus = "File Uploaded Succesfully";
//         });
//       } else {
//         setState(() {
//           uploadStatus = "Failed...........";
//         });
//       }
//     }
//     return res;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Profile"),
//       ),
//       body: ListView(
//           children: [
//             //this is a container that contain image
//             //when user select image from Gallery or Camera
//                CircleAvatar(
//                 radius: 100,
//                 backgroundImage: _image != null ? FileImage(File(_image!.path)) : NetworkImage('https://images.pexels.com/photos/268533/pexels-photo-268533.jpeg?cs=srgb&dl=pexels-pixabay-268533.jpg&fm=jpg') as ImageProvider,
//               ),
//           //  CircleAvatar(
//           //   radius: 30,
//           //     child: Container(
//           //       margin: EdgeInsets.only(top: 20),
//           //       width: 300,
//           //       height: 500,
//           //       child: (_image != null)
//           //           ? Image.file(File(_image!.path),fit: BoxFit.cover,)
//           //           : Icon(
//           //               Icons.image,
//           //               size: 300,
//           //             ),
//           //     ),
//           //   ),
//             SizedBox(
//               height: 50,
//             ),
//             Row(
//               //this is used to provide space between icons
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 //this widget is used to get image from
//                 //Camera
//                 IconButton(
//                   icon: Icon(Icons.camera_alt,size: 50,),
//                   onPressed: () {
//                     _imageFromCamera();
//                   },
//                 ),
//                 //this widget is used to get image from
//                 //Gallery
//                 IconButton(
//                   icon: Icon(Icons.image,size: 50,),
//                   onPressed: () {
//                     _imageFromGallery();
//                   },
//                 ),
//               ],
//             ),
//             Padding(padding: const EdgeInsets.only(
//               left: 15.0,right: 15,top: 15,bottom: 0 )),
//             TextField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Name',
//                 hintText: 'Enter Your Name',
//               ),
//             ),
//             Padding(padding: const EdgeInsets.only(
//               left: 15.0,right: 15,top: 15,bottom: 0 )),
//              TextField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Department',
//                 hintText: 'Enter Your Department',
//               ),
//             ),
//             Padding(padding: const EdgeInsets.only(
//               left: 15.0,right: 15,top: 15,bottom: 0 )),
//             TextField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Mobile No',
//                 hintText: 'Enter Your Mobile Number',
//               ),
//             ),
//             Padding(padding: const EdgeInsets.only(
//               left: 15.0,right: 15,top: 15,bottom: 0 )),
//             TextField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Email',
//                 hintText: 'Enter Your Email id',
//               ),
//             ),
//             Padding(padding: const EdgeInsets.only(
//               left: 15.0,right: 15,top: 15,bottom: 0 )),
//             TextField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Unit No',
//                 hintText: 'Enter Your Unit Number',
//               ),
//             ),
//             Padding(padding: const EdgeInsets.only(
//               left: 15.0,right: 15,top: 15,bottom: 0 )),
//             TextField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Blood Group',
//                 hintText: 'Enter Your Blood Group',
//               ),
//             ),

//             //this widget provide space in vertical
//             SizedBox(
//               height: 50,
//             ),
//             //this is used to perform uploading task
//             Container(
//               width: MediaQuery.of(context).size.width,
//               margin: EdgeInsets.only(left: 30, right: 30),
//               //this is a button that has event to perform action
//               child: ElevatedButton(
//                 child: Text("Upload Me"),
//                 onPressed: () {
//                   //upload method calling from here
//                   _upload(_image!);
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
  
//   }

//   // this method is used to convert image into String
//   // and you can write uploading code here
//   void _upload(PickedFile file) {
//     final bytes = File(file.path).readAsBytesSync();
//     String img64 = base64Encode(bytes);
//     print(img64.length);
//   }
// }

