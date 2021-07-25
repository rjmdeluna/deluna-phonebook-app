// @dart=2.9

import 'package:flutter/material.dart';
import 'package:del_phonebook/screens/phonebook.dart';
import 'package:del_phonebook/auth.dart'
    show AuthPage, LoginSection, SignupSection;

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
        home: AuthPage(),
        routes: <String, WidgetBuilder>{
          Contacts.id: (context) => Contacts(),
          LoginSection.id: (context) => LoginSection(),
          SignupSection.id: (context) => SignupSection(),
          '/contacts': (BuildContext context) => new Contacts(),
          'Log in': (BuildContext context) => new LoginSection(),
          'Sign up': (BuildContext context) => new SignupSection(),
        });
  }
}
