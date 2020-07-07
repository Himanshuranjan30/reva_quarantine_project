import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDe extends StatefulWidget {
  @override
  _UserDeState createState() => _UserDeState();
}

class _UserDeState extends State<UserDe> {
  FirebaseUser currentuser;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future returnuid() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentuser = user;
    });
  }

  void initState() {
    super.initState();
    returnuid();
  }
  bool isloading=false;
  @override
  Widget build(BuildContext context) {
    return isloading? Center(child:CircularProgressIndicator()): StreamBuilder(
        stream: Firestore.instance
            .collection('UserData')
            .document(currentuser.uid.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if(!snapshot.hasData)
             setState(() {
               isloading=true;
             });
             
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xFF8B81C6),
                  title: Text('User details'),
                ),
                body: Center(
                  child: Column(children: <Widget>[
                      SizedBox(height: 60),
                      Card(
                                              child: Column(children: <Widget>[
                        Text(
                          'Name:' + snapshot.data['name'],
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          'Age:' + snapshot.data['age'].toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          'Gender:' + snapshot.data['gender'],
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          'Address:' + snapshot.data['address'],
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          'Phone No:' + snapshot.data['phNo'].toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          'Weight:' + snapshot.data['weight'].toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          'Height:' + snapshot.data['height'].toString(),
                          style: TextStyle(fontSize: 30),
                        )]),
                        margin: EdgeInsets.all(5),
                        
                      )
                    ]),
                ));
          }
        });
  }
}
