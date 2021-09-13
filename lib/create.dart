import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:todo_mobile/api.dart';
import 'package:todo_mobile/main.dart';
import 'package:todo_mobile/routes.dart';

class CreateTodo extends StatefulWidget {
  final Client client;
  const CreateTodo({Key? key, required this.client}) : super(key: key);

  @override
  _CreateTodoState createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  TextEditingController controller = TextEditingController();
  var createUrl =
      Uri.parse("https://mudassirzeya.pythonanywhere.com/notes/create/");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Todo"),
      ),
      backgroundColor: Colors.deepOrange,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Enter Text",
                  ),
                  maxLines: 5,
                ),
              ),
              elevation: 10,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.client.post(createUrl, body: {"note": controller.text});
              Navigator.pushNamed(context, MyRoutes.homeRoute);
            },
            child: Text("Create"),
          ),
        ],
      ),
    );
  }
}
