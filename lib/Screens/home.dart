import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 36,
                ),
                Center(
                  child: Container(
                    height: 200,
                    child: Text(
                      'Quarantine Tracker',
                      style: TextStyle(
                        color: Color(0xFF8B81C6),
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
                height: 200,
                width: 200,
                child: Image.network(
                    'https://www.statnews.com/wp-content/uploads/2020/02/Coronavirus-CDC-645x645.jpg')),
            SizedBox(
              height: 54,
            ),
            Container(
              height: 40,
              width: 300,
              child: RaisedButton(
                  child: Text(
                    'Create Account',
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
                    Navigator.pushNamed(context, 'registration_screen');
                  }),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 40,
              width: 300,
              child: RaisedButton(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Color(0xFF8B81C6),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: Color(0xFF8B81C6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, 'login_screen');
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
