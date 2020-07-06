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
      currentuser=user;
    });
    
      
    
    
  }

  void initState() {
    super.initState();
    returnuid();
    
  }

  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder(
            stream: Firestore.instance
                .collection('UserData')
                .document(currentuser.uid.toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Scaffold(

                  appBar: AppBar(
                backgroundColor: Color(0xFF8B81C6),
                title: Text('User details'),),

                body:
                
                Column(children: <Widget>[
                  Text(snapshot.data['name']),
                  Text(snapshot.data['age'].toString()),
                  Text(snapshot.data['gender']),
                  
                  Text(snapshot.data['address']),
                  Text(snapshot.data['phNo'].toString()),
                  Text(snapshot.data['weight'].toString()),
                  Text(snapshot.data['height'].toString())
                ]));
              }
            });
  }
}
