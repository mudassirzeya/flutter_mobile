import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_mobile/create.dart';
import 'package:todo_mobile/signup_page.dart';
import 'package:todo_mobile/model.dart';
import 'package:todo_mobile/routes.dart';
import 'package:todo_mobile/login_page.dart';
import 'package:todo_mobile/update.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        MyRoutes.homeRoute: (context) => HomePage(title: 'MyTodo App'),
        MyRoutes.signUpRoute: (context) => SignUpPage(),
        MyRoutes.loginRoute: (context) => LoginPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ChangeNotifier {
  var retrieveUrl = Uri.parse("https://mudassirzeya.pythonanywhere.com/notes/");
  var fetchurl = http.get(
    Uri.parse('https://mudassirzeya.pythonanywhere.com/notes/'),
    headers: {'Content-Type': 'application/json'},
  );

  http.Client client = http.Client();
  List<Note> notes = [];
  @override
  void initState() {
    retrieveNotes();
    // dataRetrieve();
    super.initState();
  }

  Future<void> retrieveNotes() async {
    var userData = SharedPreferences.getInstance();
    notes = [];
    List response = json.decode((await client.get(retrieveUrl, headers: {
      "Content-Type": "application/json",
      "Authorization": "token ${userData}",
    }))
        .body);
    print('body: ${response.toString()}');
    response.forEach((element) {
      notes.add(Note.fromMap(element));
    });

    setState(() {});
    notifyListeners();
  }

  void _deleteNote(int id) {
    var deleteUrl =
        Uri.parse("https://mudassirzeya.pythonanywhere.com/notes/$id/delete/");

    client.delete(deleteUrl);
    retrieveNotes();
    notifyListeners();
  }

  void _addNote() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => CreateTodo(
              client: client,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) async {
              var sharedPreferences = await SharedPreferences.getInstance();
              await sharedPreferences.clear();
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => LoginPage(),
                ),
                (route) =>
                    false, //if you want to disable back feature set to false
              );
            },
            itemBuilder: (BuildContext context) {
              return (<String>['Logout']).map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
        title: Text(widget.title),
      ),
      backgroundColor: Colors.greenAccent,
      body: RefreshIndicator(
        onRefresh: () async {
          retrieveNotes();
        },
        child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.deepPurpleAccent,
                child: ListTile(
                  title: Text(
                    notes[index].note,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => UpdateTodo(
                              client: client,
                              id: notes[index].id,
                              note: notes[index].note,
                            )));
                  },
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => _deleteNote(notes[index].id),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNote();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Future<void> dataRetrieve() async {
  //   var post = await http.get(
  //     Uri.parse('https://mudassirzeya.pythonanywhere.com/notes/'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization':
  //     },
  //   );

  //   print("Login ${post.body}");

  //   if (post.statusCode == 200) {
  //     Fluttertoast.showToast(msg: "Signup Successful");

  //     var jsonDecode2 = jsonDecode(post.body);

  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString("login", jsonEncode(jsonDecode2["data"]));
  //     await prefs.commit();

  //     // gotoProfile();
  //   } else if (post.statusCode == 400) {
  //     var body = jsonDecode(post.body);
  //     Fluttertoast.showToast(msg: "Signup Failed ${body}");
  //   } else {
  //     Fluttertoast.showToast(msg: "Signup Failed");
  //   }
  // }
}
