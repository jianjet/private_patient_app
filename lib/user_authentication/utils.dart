import 'package:flutter/material.dart';



class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackbar (String? text){
    if (text == null) return;
    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red);
    messengerKey.currentState!..removeCurrentSnackBar()..showSnackBar(snackBar);
  }
}