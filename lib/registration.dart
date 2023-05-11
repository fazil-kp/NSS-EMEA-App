import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nss_emea/CommonUrl/CommonUrl.dart';
import 'package:nss_emea/home.dart';
import 'package:nss_emea/home.dart';
import 'package:http/http.dart' as http;
import 'package:nss_emea/login.dart';
import 'package:nss_emea/model/batchmodel.dart';
import 'package:nss_emea/model/departmentmodel.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  String departmentvalue = 'BSC CS';
  String? gender = "male";
  String bloodgrp = 'B+ve';
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController unitnoController = TextEditingController();

  // List of items in our dropdown menu
  var Departmnt = [
    'BSC CS',
    'BSC MB',
    'BSC BC',
    'BSC BT',
    'BSC PHY&MATH',
    'BBA',
    'BCOM CA',
    'BCOM COP',
    'BA ENG',
    'BA ECO',
    'BA WAS'
  ];

  var Bloodgroup = [
    'A+ve',
    'A-ve',
    'B+ve',
    'B-ve',
    'O+ve',
    'O-ve',
    'AB+ve',
    'AB-ve',
  ];
  List<BatchModel> courselist = [];
  List<DepartmentModel> departmentlist = [];
  var batchid;
  var departmentid;
   dynamic dropdownValue_course = null;
   dynamic dropdownValue_department = null;
    bool _passwordVisible=false;
  @override
  void initState() {
    dropdownValue_course = null;
    dropdownValue_department = null;
    getCourse();
    getDepartment();
     _passwordVisible = false;
  }

  getCourse() async {
    courselist = await getcourse();

    setState(() {});
  }

  getDepartment() async {
    departmentlist = await getdepartment();
    setState(() {
      
    });
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

  Future<List<DepartmentModel>> getdepartment() async {
    // log("Username in getmybookings ==" + username);
    log("inside");
    //final Map<String, dynamic> queryParameters = {};

    final response = await http.get(
      Uri.parse(CommonUrl.common_url + 'getdepartment.jsp'),
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      log("statusCode====${response.statusCode}");

      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      log("parsed course====${json.decode(response.body).cast<Map<String, dynamic>>()}");
      //  print(parsed);
      log("response====${response.body}");

      return parsed
          .map<DepartmentModel>((json) => DepartmentModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load course');
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Registration'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: ' Name',
                              hintText: 'Enter your name',
                            ),
                          ),
                        ),
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
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
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
                                          items: courselist.map<
                                                  DropdownMenuItem<BatchModel>>(
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
                                  departmentlist.isEmpty
                                      ? const CircularProgressIndicator()
                                      : DropdownButton<DepartmentModel>(
                                          hint: const Text("Select Department"),
                                          value: dropdownValue_department,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                          onChanged: (DepartmentModel? data) {
                                            setState(() {
                                              log("dataaa===$data");

                                              dropdownValue_department = data!;
                                              departmentid = data.id;
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
                                          items: departmentlist.map<
                                                  DropdownMenuItem<
                                                      DepartmentModel>>(
                                              (DepartmentModel value) {
                                            return DropdownMenuItem<
                                                DepartmentModel>(
                                              value: value,
                                              child: Text(value.departmentname),
                                            );
                                          }).toList(),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.all(15),
                        //   child: Row(children: <Widget>[
                        //     Text('Department'),
                        //     Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: DropdownButton(
                        //         // Initial Value

                        //         value: departmentvalue,

                        //         // Down Arrow Icon

                        //         icon: const Icon(Icons.keyboard_arrow_down),

                        //         // Array list of items

                        //         items: Departmnt.map((String items) {
                        //           return DropdownMenuItem(
                        //             value: items,
                        //             child: Text(items),
                        //           );
                        //         }).toList(),

                        //         // After selecting the desired option,it will

                        //         // change button value to selected value

                        //         onChanged: (String? newValue) {
                        //           setState(() {
                        //             departmentvalue = newValue!;
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //   ]),
                        // ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: phoneController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Phone no',
                              hintText: 'Enter your ph no',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              hintText: 'Enter your mail id',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: unitnoController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Unit no',
                              hintText: 'Enter your unit no',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Gender :"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Container(
                                  height: 60,
                                  // color: Colors.amber,
                                  width: 125,
                                  child: RadioListTile(
                                    title: Text("Male"),
                                    value: "male",
                                    groupValue: gender,
                                    onChanged: (value) {
                                      setState(() {
                                        gender = value.toString();
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  //  color: Colors.blue,
                                  width: 145,
                                  child: RadioListTile(
                                    title: Text("Female"),
                                    value: "female",
                                    groupValue: gender,
                                    onChanged: (value) {
                                      setState(() {
                                        gender = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(children: <Widget>[
                            Text('Bloodgroup'),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton(
                                // Initial Value

                                value: bloodgrp,

                                // Down Arrow Icon

                                icon: const Icon(Icons.keyboard_arrow_down),

                                // Array list of items

                                items: Bloodgroup.map((String items2) {
                                  return DropdownMenuItem(
                                    value: items2,
                                    child: Text(items2),
                                  );
                                }).toList(),

                                // After selecting the desired option,it will

                                // change button value to selected value

                                onChanged: (String? newValue) {
                                  setState(() {
                                    bloodgrp = newValue!;
                                  });
                                },
                              ),
                            ),
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: usernameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'user name',
                              hintText: 'Enter your user name',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              hintText: 'Enter your password',
                                 suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
               _passwordVisible
               ? Icons.visibility
               : Icons.visibility_off,
               color: Theme.of(context).primaryColorDark,
               ),
            onPressed: () {
               // Update the state i.e. toogle the state of passwordVisible variable
               setState(() {
                   _passwordVisible = !_passwordVisible;
               });
             },
            ),
                            ),
                          ),
                        ),
                        Align
                        (alignment: Alignment.center,
                          child: ElevatedButton(
                            child: const Text(
                              'Register',
                              style: TextStyle(fontSize: 20),
                              
                              
                            ),
                            onPressed: () {
                              // Navigator.of(context)
                              //   .push(MaterialPageRoute(builder: (context) => Home()));
                              log("message");
                        
                              // reg(nameController.text, usernameController.text, dropdownvalue.toString(), dropdownvalue.toString(), nameController.text, nameController.text, nameController.text, gender, dropdownvalue.toString(), nameController.text);
                              log("nameController.text==" + nameController.text);
                              log("nameController.text==" + nameController.text);
                              log("batchid =="+batchid.toString());
                              log("department id =="+departmentid.toString());
                              // reg(
                              //     
                              //     usernameController.text,
                              //     departmentid,
                              //     batchid,
                              //     phoneController.text,
                              //     emailController.text,
                              //     unitnoController.text,
                              //     gender,
                              //     bloodgrp.toString(),
                              //     passwordController.text);
                              reg(nameController.text, usernameController.text,phoneController.text,emailController.text, unitnoController.text, gender, bloodgrp.toString(), passwordController.text, departmentid.toString(), batchid.toString());
                        
                              //   if (_formKey.currentState!.validate()) {
                              // // If the form is valid, display a Snackbar.
                              // Scaffold.of(context)
                              //     .showSnackBar(SnackBar(content: Text('Data is in processing.')));
                        
                              //
                              // };
                            },
                          ),
                        ),
                      ]))
            ],
          ),
        ));
  }

  Future<Map<String, dynamic>?> reg(String name, username,
      phone, email, unitno, gender, bloodgroup, password, depid, batchid) async {
    print('>>>>>>>>>>>>>>>>>>>>>>> inside  >>>>>>>>>>>>>>>>');

    var result;
    final Map<String, dynamic> Regdata = {
      'name': name,
      'username': username,
      'depid': depid,
      'batchid': batchid,
      'phone': phone,
      'email': email,
      'unitno': unitno,
      'gender': gender,
      'bloodgrp': bloodgroup,
      'password': password
    };

    final response = await http.post(
      Uri.parse(CommonUrl.common_url + "registration.jsp"),
      body: Regdata,
    );

    if (response.statusCode == 200) {
      log(response.statusCode.toString());
      final Map<String, dynamic> responseData = json.decode(response.body);
      log(response.body.toString());
      var webData = responseData;
      print(webData);
      log("success !!!");
      if (response.body.contains("Success")) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }

      log("registration successfully");
    } else {
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }
}

//create function

