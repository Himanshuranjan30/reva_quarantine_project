import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
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

  FirebaseUser currentuser;

  FirebaseAuth auth = FirebaseAuth.instance;
  List temp = [];
  List bmp=[];
  String phno;
  int d;
  Future returnuid() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentuser = user;
    });
  }

  int a;
  fetchdata() async {
    final dbref = FirebaseDatabase.instance.reference().child('${1}');

    dbref.child('temp').once().then((DataSnapshot snap) => {
          print(snap.value),
          temp.add(snap.value),
          print(temp[0])
        });
    dbref.child('bmp').once().then((DataSnapshot snap)=>{

      print(snap.value),
      bmp.add(snap.value),

    });
  }

  @override
  List<charts.Series<Temprature, int>> _seriesLineData1;
  List<charts.Series<BMP, int>> _seriesLineData2;

  _generateData() {
    var tempReq = [
      Temprature(tempVal: 32.6, time: 5),
      Temprature(tempVal: 37, time: 10),
      Temprature(tempVal: 37.4, time: 15),
      Temprature(tempVal: 32.8, time: 20),
      Temprature(tempVal: 32, time: 25)
    ];

    var BmpReq = [
      BMP(BmpVal: 72, time: 10),
      BMP(BmpVal: 74, time: 15),
      BMP(BmpVal: 70, time: 20),
      BMP(BmpVal: 76, time: 25),
      BMP(BmpVal: 73, time: 30)
    ];

    _seriesLineData1.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.deepPurple),
        id: 'Temprature',
        data: tempReq,
        domainFn: (Temprature temprature, _) => temprature.time,
        measureFn: (Temprature temprature, _) => temprature.tempVal,
      ),
    );
    _seriesLineData2.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.deepPurple),
        id: 'BMP',
        data: BmpReq,
        domainFn: (BMP bmp, _) => bmp.time,
        measureFn: (BMP bmp, _) => bmp.BmpVal,
      ),
    );
  }

  void initState() {
    returnuid();

    // TODO: implement initState
    _seriesLineData1 = List<charts.Series<Temprature, int>>();
    _seriesLineData2 = List<charts.Series<BMP, int>>();

    _generateData();
  }

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : StreamBuilder(
            stream: Firestore.instance
                .collection('UserData')
                .document(currentuser.uid.toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              phno = snapshot.data['phNo'].toString();

              fetchdata();

              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xFF8B81C6),
                  title: Text(
                    'quarantine tracker',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.popAndPushNamed(context, 'welcome_screen');
                      }),
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
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 36,
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          height: 350,
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(width: 4, color: Color(0xFF8B81C6)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  'Temperature',
                                  style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: charts.LineChart(
                                  _seriesLineData1,
                                  defaultRenderer: charts.LineRendererConfig(
                                    includePoints: true,
                                    stacked: true,
                                  ),
                                  animate: true,
                                  animationDuration: Duration(seconds: 3),
                                  behaviors: [
                                    charts.ChartTitle('Time',
                                        behaviorPosition:
                                            charts.BehaviorPosition.bottom,
                                        titleOutsideJustification: charts
                                            .OutsideJustification
                                            .middleDrawArea),
                                    charts.ChartTitle('Temperature',
                                        behaviorPosition:
                                            charts.BehaviorPosition.start,
                                        titleOutsideJustification: charts
                                            .OutsideJustification
                                            .middleDrawArea)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 36,
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          height: 350,
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(width: 4, color: Color(0xFF8B81C6)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  'Basic Metabolic Panel',
                                  style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: charts.LineChart(
                                  _seriesLineData2,
                                  defaultRenderer: charts.LineRendererConfig(
                                    includePoints: true,
                                    stacked: true,
                                  ),
                                  animate: true,
                                  animationDuration: Duration(seconds: 3),
                                  behaviors: [
                                    charts.ChartTitle('Time',
                                        behaviorPosition:
                                            charts.BehaviorPosition.bottom,
                                        titleOutsideJustification: charts
                                            .OutsideJustification
                                            .middleDrawArea),
                                    charts.ChartTitle('BMP',
                                        behaviorPosition:
                                            charts.BehaviorPosition.start,
                                        titleOutsideJustification: charts
                                            .OutsideJustification
                                            .middleDrawArea)
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 48,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

class Temprature {
  double tempVal;
  int time;
  Temprature({this.tempVal, this.time});
}

class BMP {
  double BmpVal;
  int time;
  BMP({this.BmpVal, this.time});
}
