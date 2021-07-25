import 'dart:convert';
import 'package:del_phonebook/screens/phonebook.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  var myemail;
  var mypassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 400,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              primary: Colors.green[900],
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, SignupSection.id);
                            },
                            child: Text('SIGN UP'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              primary: Colors.green[900],
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, LoginSection.id);
                            },
                            child: Text('LOG IN'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // child: Column(
          //   children: [

          //   ],
          // ),
        ),
      ),
    );
  }
}

class LoginSection extends StatelessWidget {
  static const String id = "LoginSection";
  var myemail;
  var mypassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log In Account"),
      ),
      body: CupertinoPageScaffold(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    prefixIcon: Icon(
                      Icons.email,
                      size: 25,
                    ),
                    fillColor: Colors.white30,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                  onChanged: (value) {
                    myemail = value;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    prefixIcon: Icon(
                      Icons.password,
                      size: 25,
                    ),
                    fillColor: Colors.white30,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    mypassword = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () async {
                    await login(myemail, mypassword);
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    String token = preferences.getString("token");
                    if (token != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Contacts()),
                          (_) => false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green[900],
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.all(20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupSection extends StatelessWidget {
  static const String id = "SignupSection";
  var newEmail;
  var newPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Account"),
      ),
      body: CupertinoPageScaffold(
          child: SafeArea(
              child: ListView(padding: const EdgeInsets.all(18), children: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Create Email',
                  prefixIcon: Icon(
                    Icons.email,
                    size: 25,
                  ),
                  fillColor: Colors.white30,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                onChanged: (value) {
                  newEmail = value;
                })),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Create Password',
                  prefixIcon: Icon(
                    Icons.password,
                    size: 25,
                  ),
                  fillColor: Colors.white30,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                obscureText: true,
                onChanged: (value) {
                  newPassword = value;
                })),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () async {
              await signup(newEmail, newPassword);
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return LoginSection();
              }));
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.green[900],
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.all(20)),
          ),
        ),
      ]))),
    );
  }
}

login(email, password) async {
  var url =
      Uri.parse('https://deluna-upheroku-api.herokuapp.com/auth/login'); // iOS
  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  print(response.body);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var parse = jsonDecode(response.body);

  await preferences.setString('token', parse["token"]);
}

signup(email, password) async {
  var url =
      Uri.parse('https://deluna-upheroku-api.herokuapp.com/auth/signup'); // iOS
  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{'email': email, 'password': password}),
  );
  print(response.body);
}
