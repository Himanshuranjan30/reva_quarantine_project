import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reva_quarantine_project/DataBase/Covid_data_class.dart';
import 'package:http/http.dart' as http;

class Stats extends StatelessWidget {
  Widget displayData(Covid19Data data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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
            'Covid 19 Stats',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        body: Center(
          child: Container(
            alignment: Alignment.center,
            
            decoration: BoxDecoration(
                
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
        ));
  }
}
