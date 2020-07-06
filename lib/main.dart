import 'package:flutter/material.dart';
import 'package:reva_quarantine_project/DataBase/UserDetails.dart';


import 'Screens/Welcome_screen.dart';
import 'Screens/home.dart';
import 'Screens/registration.dart';
import 'Screens/login.dart';
import 'Screens/display_screen.dart';
import 'Screens/user_de.dart';

void main() => runApp(QApp());

class QApp extends StatefulWidget {
  @override
  _QAppState createState() => _QAppState();
}

class _QAppState extends State<QApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: Colors.white70,
        accentColor: Color(0xFF8B81C6),
      ),
      routes: {
        'home_screen': (context) => HomeScreen(),
        'registration_screen': (context) => RegistraionScreen(),
        'login_screen': (context) => LoginScreen(),
        'display_screen': (context) => DisplayScreen(),
        'welcome_screen': (context) => WelcomeScreen(),
        'userdetail_screen': (context)=> UserDe(),
      },
      initialRoute: 'home_screen',
    );
  }
}
