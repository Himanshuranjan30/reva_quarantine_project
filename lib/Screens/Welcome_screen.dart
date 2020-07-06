import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../DataBase/userDatabase.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reva_quarantine_project/DataBase/Covid_data_class.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Stream<QuerySnapshot> getUserSnapshot(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.document(uid).collection('UserData').snapshots();
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
                onPressed: () {
                  Navigator.of(context)
                      .popUntil((ModalRoute.withName('home_screen')));
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

  Widget displayData(Covid19Data data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          "Covid-19 Information.\n",
          style: TextStyle(
              color: Colors.purple[900],
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        Text(
          "Total cases in World:${data.worldWideTotal}",
          style: TextStyle(
              color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          "Total cases in India:${data.totalCasesInCounrty}",
          style: TextStyle(
              color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          "Active cases in India:${data.activeCaseInCounrty}",
          style: TextStyle(
              color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          "Total Death in India:${data.deathInCounrty}",
          style: TextStyle(
              color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          "Recovered cases in India:${data.recoveredCaseInCounrty}",
          style: TextStyle(
              color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          "Total cases in ${data.stateName}:${data.totalCasesInState}",
          style: TextStyle(
              color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          "Active cases in ${data.stateName}:${data.activeCaseInState}",
          style: TextStyle(
              color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          "Total Death in ${data.stateName}:${data.deathInState}",
          style: TextStyle(
              color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          "Recovered cases in ${data.stateName}:${data.recoveredCaseInState}",
          style: TextStyle(
              color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Future<Covid19Data> getCovidData() async {
    final responese = await http.get(
        Uri.encodeFull("https://disease.sh/v3/covid-19/gov/India"),
        headers: {"Accept": "application/jason"});

    if (responese.statusCode == 200) {
      final jsonCovidData = jsonDecode(responese.body);
      return Covid19Data.fromJson(jsonCovidData);
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      drawer: Drawer(child: ListView(
    children: <Widget>[
      ListTile(
        title: Text("User Details"),
        trailing: Icon(Icons.arrow_forward),
        onTap:()=> Navigator.of(context).pushNamed('userdetail_screen') ,
      ),]),),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 1,
                      color: Colors.black87,
                    )),
                child: FutureBuilder<Covid19Data>(
                    future: getCovidData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        return displayData(data);
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return CircularProgressIndicator();
                    }),
              ),
            ),
            Container(
              child: StreamBuilder(
                stream: getUserSnapshot(context),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Column(
                    children: <Widget>[Text("name:" + snapshot.data['name'])],
                  );
                },
              ),
            ),
            RaisedButton(child: Text('getdata'), onPressed: getCovidData),
            RaisedButton(
              child: Text(
                'Show In Graph ',
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
                Navigator.popAndPushNamed(context, 'display_screen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
