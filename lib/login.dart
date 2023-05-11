import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nss_emea/CommonUrl/CommonUrl.dart';
import 'package:nss_emea/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nss_emea/registration.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  late SharedPreferences logindata;
  late bool newuser;
 bool _passwordVisible=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check_if_already_login();
     _passwordVisible = false;
  }

  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    print(newuser);
    if (newuser == false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("NSS EMEA"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
                hintText: 'Enter Your Name',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: passwordController,
               obscureText: !_passwordVisible,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter Your Password',
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
          TextButton(
            onPressed: () {},
            child: Text(
              "Forgot password?",
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
          ),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: ElevatedButton(
              onPressed: () {
                login(usernameController.text, passwordController.text, "1");
              },
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              const Text("Does not have an account"),
              TextButton(
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Registration()));
                  })
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ]),
      ),
    );
  }

  Future<Map<String, dynamic>?> login(String username, password, type) async {
    print('>>>>>>>>>>>>>>>>>>>>>>> inside RegController >>>>>>>>>>>>>>>>');

    var result;
    final Map<String, dynamic> Regdata = {
      'username': username,
      'password': password,
      'type': type
    };

    final response = await http.post(
      Uri.parse(CommonUrl.common_url + "login.jsp"),
      body: Regdata,
    );

    if (response.statusCode == 200) {
      log(response.statusCode.toString());
      final Map<String, dynamic> responseData = json.decode(response.body);
      log(response.body.toString());
      var webData = responseData;
      print(webData);
      log("success !!!");

      if (response.body.contains("Successful")) {
        logindata.setBool('login', false);
        logindata.setString('username', username);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Home()));
      }
      log("registrtion successfully");
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


