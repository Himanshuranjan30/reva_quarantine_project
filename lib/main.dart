import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reva_quarantine_project/DataBase/UserDetails.dart';
import 'package:reva_quarantine_project/Screens/stats.dart';
import 'package:reva_quarantine_project/Screens/wrapper.dart';
import 'package:reva_quarantine_project/services/user.dart';


import 'Screens/Welcome_screen.dart';
import 'Screens/home.dart';
import 'Screens/registration.dart';
import 'Screens/login.dart';
import 'Screens/display_screen.dart';
import 'Screens/user_de.dart';
import 'services/auth.dart';

void main() => runApp(QApp());

class QApp extends StatefulWidget {
  @override
  _QAppState createState() => _QAppState();
}

class _QAppState extends State<QApp> {
  @override
  Widget build(BuildContext context) {
     
    return MultiProvider(
        providers: [StreamProvider.value(value: AuthService().user),],
      child:
    Consumer<User>(builder: (ctx,auth,_)=>
    MaterialApp(
      theme: ThemeData(
        backgroundColor: Colors.white70,
        accentColor: Color(0xFF8B81C6),
      ),
      home: Wrapper(),
      routes: {
        'home_screen': (context) => HomeScreen(),
        'registration_screen': (context) => RegistraionScreen(),
        'login_screen': (context) => LoginScreen(),
        'display_screen': (context) => DisplayScreen(),
        'welcome_screen': (context) => WelcomeScreen(),
        'userdetail_screen': (context)=> UserDe(),
        'stats_Screen': (context)=> Stats(),
      },
      
    )));
  }
}
