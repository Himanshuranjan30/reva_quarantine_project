import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:reva_quarantine_project/services/auth.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Stream<QuerySnapshot> getUserSnapshot(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.document(uid).collection('UserData').snapshots();
  }

  final AuthService _auth = AuthService();
  List temp = [];
  List bpm = [];
  FirebaseUser currentuser;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future returnuid() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentuser = user;
    });
  }

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Do You want to Logout?'),
            actions: <Widget>[
              RaisedButton(
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                color: Color(0xFF8B81C6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Color(0xFF8B81C6),
                  ),
                ),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.of(context).pushNamed('home_screen');
                },
              ),
              RaisedButton(
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                color: Color(0xFF8B81C6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Color(0xFF8B81C6),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  fetchdata() async {
    final dbref = FirebaseDatabase.instance.reference().child('${1}');

    dbref.child('temp').once().then((DataSnapshot snap) => {
          print(snap.value),
          setState(() {
            temp.add(snap.value);
          }),
        });
    dbref.child('bpm').once().then((DataSnapshot snap) => {
          print(snap.value),
          setState(() {
            bpm.add(snap.value);
          }),
        });
  }

  void initState() {
    super.initState();
    returnuid();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return temp.isEmpty && bpm.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF8B81C6),
              title: Text(
                'Quarantine Tracker',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      createAlertDialog(context);
                    })
              ],
            ),
            drawer: Drawer(
              child: ListView(children: <Widget>[
                ListTile(
                  title: Text("User Details"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () =>
                      Navigator.of(context).pushNamed('userdetail_screen'),
                ),
                ListTile(
                  title: Text('Show in Graph'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () =>
                      Navigator.of(context).pushNamed('display_screen'),
                ),
                ListTile(
                  title: Text('Covid 19 Stats'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () => Navigator.of(context).pushNamed('stats_Screen'),
                )
              ]),
            ),
            body: StreamBuilder(
                stream: Firestore.instance
                    .collection('UserData')
                    .document(currentuser.uid.toString())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                            child: Text(
                          'Welcome  ' + snapshot.data['name'] + '!',
                          style: TextStyle(
                              color: Colors.purple[900],
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                        SizedBox(height: 250),
                        Container(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.black87,
                                )),
                            child: Column(children: <Widget>[
                              Text(
                                'Your Current Health Status',
                                style: TextStyle(
                                    color: Colors.purple[900],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Temperature:' + temp.last.toString(),
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Bpm:' + bpm.last.toString(),
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              temp.last < 37
                                  ? Text(
                                      'Youre Safe From Covid',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      'You need to consult a doctor!',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                            ]),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  );
                }),
          );
  }
}
