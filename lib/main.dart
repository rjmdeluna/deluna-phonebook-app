import 'package:del_phonebook/screens/auth.dart';
import 'package:flutter/material.dart';
import 'package:del_phonebook/screens/phonebook.dart';
import 'package:del_phonebook/screens/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Database',
        theme: ThemeData(
          primaryColor: Colors.green[800],
          accentColor: Colors.lightGreen[900],
        ),
        home: AuthPage());
  }
}
