import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_mobile/model.dart';

class TodoProvider with ChangeNotifier {
  var retrieveUrl = Uri.parse("https://mudassirzeya.pythonanywhere.com/notes/");

  http.Client client = http.Client();
  List<Note> notes = [];

  retrieveNotes() async {
    notes = [];
    List response = json.decode((await client.get(retrieveUrl)).body);
    response.forEach((element) {
      notes.add(Note.fromMap(element));
    });
    notifyListeners();
  }
}
