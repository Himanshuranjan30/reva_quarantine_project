import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  String name;
  String gender;
  String height;
  String weight;
  int age;
  Float temp;
  Float bpm;
  UserDetails({this.name, this.gender, this.height, this.weight, this.age});
}
