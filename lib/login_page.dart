import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:todo_mobile/api/api_service.dart';
import 'package:todo_mobile/main.dart';
// import 'package:todo_mobile/model/login_model.dart';
import 'package:todo_mobile/routes.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  bool changeButton = false;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  TextEditingController emailError = new TextEditingController();
  TextEditingController passwordError = new TextEditingController();
  // final formKey = GlobalKey<FormState>();
  // late LoginRequestModel requestModel;
  // final scaffoldKey = GlobalKey<ScaffoldState>();

  // moveToHome(BuildContext context) async {
  //   if (formKey.currentState!.validate()) {
  //     setState(() {
  //       changeButton = true;
  //     });
  //     await Future.delayed(Duration(seconds: 1));
  //     await Navigator.pushNamed(context, MyRoutes.homeRoute);
  //     setState(() {
  //       changeButton = false;
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   requestModel = new LoginRequestModel(email: '', password: '');
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data?.containsKey("login") == true) {
          return HomePage(title: 'My Todo');
        } else {
          return Scaffold(
            body: SingleChildScrollView(
              // key: formKey,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/hey.png",
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome $name",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        TextField(
                          controller: email,
                          decoration: InputDecoration(
                            hintText: "Enter Username",
                            labelText: "Username",
                            errorText: emailError.text,
                          ),
                          onChanged: (value) {
                            name = value;
                            setState(() {});
                          },
                        ),
                        TextField(
                          obscureText: true,
                          controller: password,
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            labelText: "Password",
                            errorText: passwordError.text,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Material(
                          color: Colors.deepPurple,
                          borderRadius:
                              BorderRadius.circular(changeButton ? 50 : 10),
                          child: InkWell(
                            onTap: () {
                              validateInput();
                            },
                            child: AnimatedContainer(
                              duration: Duration(seconds: 1),
                              width: changeButton ? 50 : 150,
                              height: 50,
                              alignment: Alignment.center,
                              child: changeButton
                                  ? Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, MyRoutes.signUpRoute);
                          },
                          child: Text(
                            "Signup ?",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              // ),
            ),
          );
        }
      },
    );
  }

  void get background => Colors;

  void validateInput() {
    setState(() {
      emailError.text = "";
      passwordError.text = "";
    });
    if (email.text.length > 0 && password.text.length > 0) {
      // changeButton = true;
      login(email.text, password.text);
      changeButton = false;
    } else {
      if (email.text.length == 0) {
        emailError.text = "Please fill";
      }
      if (password.text.length == 0) {
        passwordError.text = "Please fill";
      }
    }
  }

  Future<void> login(String email, String password) async {
    changeButton = true;
    var post = await http.post(
        Uri.parse('https://mudassirzeya.pythonanywhere.com/rest-auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"username": email, "password": password}));

    print("Login ${post.statusCode}");

    if (post.statusCode == 200) {
      Fluttertoast.showToast(msg: "Signup Successful");

      var jsonDecode2 = jsonDecode(post.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("login", jsonEncode(jsonDecode2["data"]));
      // await prefs.commit();

      gotoProfile();
    } else if (post.statusCode == 400) {
      var body = jsonDecode(post.body);
      Fluttertoast.showToast(msg: "Signup Failed $body");
    } else {
      Fluttertoast.showToast(msg: "Signup Failed");
    }
  }

  void gotoProfile() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => HomePage(title: 'My Todo'),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
  }
}
