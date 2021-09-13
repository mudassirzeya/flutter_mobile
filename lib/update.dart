import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:todo_mobile/routes.dart';

class UpdateTodo extends StatefulWidget {
  final Client client;
  final int id;
  final String note;
  const UpdateTodo(
      {Key? key, required this.client, required this.id, required this.note})
      : super(key: key);

  @override
  _UpdateTodoState createState() => _UpdateTodoState();
}

class _UpdateTodoState extends State<UpdateTodo> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.note;
    super.initState();
  }

  updateUrl(int id) {
    return Uri.parse(
        "https://mudassirzeya.pythonanywhere.com/notes/$id/update/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Todo"),
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
              widget.client
                  .put(updateUrl(widget.id), body: {"note": controller.text});
              Navigator.pushNamed(context, MyRoutes.homeRoute);
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }
}
