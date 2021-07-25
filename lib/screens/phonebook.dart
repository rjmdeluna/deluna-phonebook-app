import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:del_phonebook/screens/phonebook.dart';
import 'package:del_phonebook/auth.dart'
    show AuthPage, LoginSection, SignupSection;

import 'add_contacts.dart';
import 'package:del_phonebook/screens/up_phonebook.dart';

class Contacts extends StatefulWidget {
  static const String id = "Contacts";
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List users = [];
  late String authKey = '';
  var authHeaders;
  @override
  void initState() {
    super.initState();
    getAuth();
  }

  Future getAuth() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var getAuthKey = sharedPreferences.getString('token');
    print(getAuthKey);
    setState(
      () {
        if (getAuthKey != null) {
          authKey = getAuthKey;
          authHeaders = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'AUTHENTICATE': authKey.toString(),
          };
          fetchUser(authHeaders);
        }
      },
    );
  }

  final String apiUrlget = "https://deluna-upheroku-api.herokuapp.com/posts/";
  List<dynamic> _users = [];
  fetchUser(var authHeaders) async {
    print(authHeaders);
    var result = await http.get(Uri.parse(apiUrlget), headers: authHeaders);
    setState(() {
      _users = jsonDecode(result.body);
    });
    print(
        "Status Code [" + result.statusCode.toString() + "]: All Data Fetched");
  }

  String _name(dynamic user) {
    return user['first_name'] + " " + user['last_name'];
  }

  String _phonenum(dynamic user) {
    return user['phone_numbers'][0];
  }

  Future<http.Response> deleteContact(String id) {
    print("Status [Deleted]: [" + id + "]");
    return http.delete(
      Uri.parse('https://deluna-upheroku-api.herokuapp.com/posts/delete/' + id),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'AUTHENTICATE': authKey.toString()
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Phonebook"),
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.remove("token");
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                  (_) => false);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          builder: (context, snapshot) {
            return _users.length != 0
                ? RefreshIndicator(
                    child: ListView.builder(
                        padding: EdgeInsets.all(12.0),
                        itemCount: _users.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: Key(_users[index].toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(Icons.delete, color: Colors.white),
                                  ]),
                              decoration: BoxDecoration(
                                color: Colors.green[300],
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onDismissed: (direction) {
                              String id = _users[index]['_id'].toString();
                              String userDeleted =
                                  _users[index]['first_name'].toString();
                              deleteContact(id);
                              setState(() {
                                _users.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$userDeleted contact deleted'),
                                ),
                              );
                            },
                            confirmDismiss: (DismissDirection direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: const Text("Delete this contact?"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text("DELETE",
                                              style: TextStyle(
                                                  color: Colors.redAccent))),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("CANCEL",
                                            style: TextStyle(
                                                color: Color(0xFFFCC14A))),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(Icons.person),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    tileColor: index % 2 == 0
                                        ? Colors.grey[300]
                                        : Colors.grey[300],
                                    title: Text(
                                      _name(_users[index]),
                                      style: TextStyle(
                                          color: Colors.green[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    trailing: TextButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateContacts(
                                                        specificID:
                                                            _users[index]['_id']
                                                                .toString())),
                                            (_) => false);
                                      },
                                      //Edit Push Button
                                      child: const Icon(Icons.app_registration,
                                          color: Colors.lightGreen),
                                    ),
                                    onTap: () {
                                      List<int> listNumbers = [];
                                      for (int i = 0;
                                          i <
                                              _users[index]['phone_numbers']
                                                  .length;
                                          i++) {
                                        listNumbers.add(i + 1);
                                      }
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.app_registration,
                                                  color: Colors.lightGreen),
                                              Container(
                                                child: AlertDialog(
                                                  title: Text(
                                                    _name(_users[index]),
                                                    style: TextStyle(
                                                        color:
                                                            Colors.green[800],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                  content: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                              "Phone Number/s:",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      13)),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children:
                                                              List.generate(
                                                            listNumbers.length,
                                                            (iter) {
                                                              return Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    '#' +
                                                                        listNumbers[iter]
                                                                            .toString() +
                                                                        ':\t\t' +
                                                                        _users[index]['phone_numbers'][iter]
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          24, 12, 0, 0),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, 'OK'),
                                                      child: const Text(
                                                        'OK',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  actionsPadding:
                                                      EdgeInsets.fromLTRB(
                                                          24, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    onRefresh: _getData,
                  )
                : Center(
                    child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    backgroundColor: Colors.white,
                  ));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return AddContacts();
          }));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
    FlatButton.icon(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return LoginSection();
          }));
        },
        icon: Icon(Icons.save),
        label: Text("Logout"));
  }

  Future<void> _getData() async {
    setState(() {
      getAuth();
    });
  }
}
