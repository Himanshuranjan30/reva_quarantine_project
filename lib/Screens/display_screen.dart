import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:reva_quarantine_project/services/auth.dart';

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  
   final AuthService _auth = AuthService();
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
                onPressed: () async{
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

  FirebaseUser currentuser;

  FirebaseAuth auth = FirebaseAuth.instance;
  List temp = [];
  List bpm=[];
  String phno;
  int d;
  Future returnuid() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentuser = user;
    });
  }
List temp1=[35.0,36.0,36.0,36.0,37.0];
  List bpm1=[71.5,73.6,73.8,74.8,78.2];

  int a;
  fetchdata() async {
    final dbref = FirebaseDatabase.instance.reference().child('${1}');

    dbref.child('temp').once().then((DataSnapshot snap) => {
          print(snap.value),
          temp.add(snap.value),
          
        });
    dbref.child('bpm').once().then((DataSnapshot snap)=>{

      print(snap.value),
      bpm.add(snap.value),

    });
  }
   void startTimer() {
  Random rnd = new Random();
  double a1=rnd.nextDouble()+35;
  double a2=rnd.nextDouble()+35;
  double a3= rnd.nextDouble()+35;
  double a4=rnd.nextDouble()+35;
  double a5= rnd.nextDouble()+35;
  double b1=rnd.nextDouble()+71;
  double b2= rnd.nextDouble()+73;
  double b3= rnd.nextDouble()+75;
  double b4= rnd.nextDouble()+77;
  double b5= rnd.nextDouble()+79;

  setState(() {
    temp1=[a1,a2,a3,a4,a5];
    bpm1= [b1,b2,b3,b4,b5];
  });
  

}

  @override
  List<charts.Series<Temprature, int>> _seriesLineData1;
  List<charts.Series<BMP, int>> _seriesLineData2;

  _generateData() {
    var tempReq = [
      Temprature(tempVal: temp1[0], time: 5),
      Temprature(tempVal: temp1[1], time: 10),
      Temprature(tempVal: temp1[2], time: 15),
      Temprature(tempVal: temp1[3], time: 20),
      Temprature(tempVal: temp1[4], time: 25)
    ];

    var BmpReq = [
      BMP(BmpVal: bpm1[0] , time: 10),
      BMP(BmpVal: bpm1[1], time: 15),
      BMP(BmpVal: bpm1[2], time: 20),
      BMP(BmpVal: bpm1[3], time: 25),
      BMP(BmpVal: bpm1[4], time: 30)
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
   Timer.periodic(Duration(seconds: 10), (Timer t) => {
        _seriesLineData1 = List<charts.Series<Temprature, int>>(),
    _seriesLineData2 = List<charts.Series<BMP, int>>(),
     startTimer(),
   _generateData()
   });
    
    
    
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
