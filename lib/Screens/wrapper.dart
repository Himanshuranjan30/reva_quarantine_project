

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:reva_quarantine_project/Screens/Welcome_screen.dart';
import 'package:reva_quarantine_project/Screens/home.dart';
import 'package:reva_quarantine_project/services/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);
    
    // return either the Home or Authenticate widget
    if (user == null){
      return HomeScreen();
    } else {
      return WelcomeScreen();
    }
    
  }
}