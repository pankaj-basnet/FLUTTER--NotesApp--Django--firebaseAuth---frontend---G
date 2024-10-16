import 'package:flutter/material.dart';

class NoteNotifier with ChangeNotifier {
  String note = '';
  String _id = '';

  String get id => _id;

  void setNote(String c, String id) {
    note = c;
    _id = id;

    notifyListeners();
  }
}
