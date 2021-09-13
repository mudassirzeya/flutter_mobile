import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_mobile/login_page.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController username = new TextEditingController();

  TextEditingController usernameError = new TextEditingController();

  TextEditingController email = new TextEditingController();

  TextEditingController emailError = new TextEditingController();

  TextEditingController password = new TextEditingController();

  TextEditingController passwordError = new TextEditingController();

  TextEditingController repassword = new TextEditingController();

  TextEditingController rePassError = new TextEditingController();

  TextEditingController loginInfo = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: Vx.m32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Sign Up".text.xl5.bold.color(Colors.deepPurple).make(),
                "Create your account".text.xl2.make(),
                SizedBox(
                  height: 10,
                ),
                CupertinoFormSection(header: "User".text.make(), children: [
                  CupertinoFormRow(
                    child: CupertinoTextFormFieldRow(
                      controller: username,
                      placeholder: "Enter Username",
                    ),
                    prefix: "Username".text.make(),
                    error: Text(usernameError.text),
                  ),
                  CupertinoFormRow(
                    child: CupertinoTextFormFieldRow(
                      controller: email,
                      placeholder: "Enter email",
                    ),
                    prefix: "Email".text.make(),
                    error: Text(emailError.text),
                  ),
                  CupertinoFormRow(
                    child: CupertinoTextFormFieldRow(
                      controller: password,
                      obscureText: true,
                      placeholder: "Enter password",
                    ),
                    prefix: "Password".text.make(),
                    error: Text(passwordError.text),
                  ),
                  CupertinoFormRow(
                    child: CupertinoTextFormFieldRow(
                      controller: repassword,
                      obscureText: true,
                      placeholder: "Confirm password",
                    ),
                    prefix: "Confirm Password".text.make(),
                    error: Text(rePassError.text),
                  ),
                ]),
                SizedBox(
                  height: 20,
                ),
                Material(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      validateInput();
                    },
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: 100,
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ).centered(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateInput() {
    setState(() {
      usernameError.text = "";
      emailError.text = "";
      passwordError.text = "";
      rePassError.text = "";
    });
    if (username.text.length > 0 &&
        email.text.length > 0 &&
        password.text.length > 0 &&
        repassword.text.length > 0) {
      if (password.text == repassword.text) {
        signUp(username.text, email.text, password.text, repassword.text);
      } else {
        rePassError.text = "Password doesn't Match";
      }
    } else {
      if (username.text.length == 0) {
        usernameError.text = "Please fill";
      }
      if (email.text.length == 0) {
        emailError.text = "Please fill";
      }
      if (password.text.length == 0) {
        passwordError.text = "Please fill";
      }
      if (rePassError.text.length == 0) {
        rePassError.text = "Please fill";
      }
    }
  }

  Future<void> signUp(
      String name, String email, String password, String repassword) async {
    var post = await http.post(
        Uri.parse(
            'https://mudassirzeya.pythonanywhere.com/rest-auth/registration/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "username": name,
          "password1": password,
          "password2": repassword,
        }));

    print("Login ${post.statusCode}");

    if (post.statusCode == 200) {
      Fluttertoast.showToast(msg: "Signup Successful");
      goToLogin();
    } else if (post.statusCode == 400) {
      var body = jsonDecode(post.body);
      Fluttertoast.showToast(msg: "Signup Failed $body");
    } else {
      Fluttertoast.showToast(msg: "Signup Failed");
    }
  }

  void goToLogin() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => LoginPage(),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
  }
}
