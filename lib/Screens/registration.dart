import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:reva_quarantine_project/DataBase/userDatabase.dart';

class RegistraionScreen extends StatefulWidget {
  @override
  _RegistraionScreenState createState() => _RegistraionScreenState();
}

class _RegistraionScreenState extends State<RegistraionScreen> {
  String _name;
  int _age;
  String _gender;
  String _address;
  String _height;
  String _weight;
  String _phNo;
  String _email;
  String _password;
  bool showSpinner = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  Future _authication(context) async {
    setState(() {
      showSpinner = true;
    });
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      FirebaseUser user = newUser.user;
      if (newUser != null) {
        await DatabaseService(uid: user.uid).createUserData(
            _name, _age, _gender, _address, _height, _weight, _phNo);
        Navigator.popAndPushNamed(context, 'welcome_screen');
      }

      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Unknown Error')));
      setState(() {
        showSpinner = false;
      });
    }
  }

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Name',
        labelStyle: TextStyle(
          color: Color(0xFF8B81C6),
          fontSize: 10,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildAge() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Age',
        labelStyle: TextStyle(
          color: Color(0xFF8B81C6),
          fontSize: 10,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Age is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _age = int.parse(value);
      },
    );
  }

  Widget _buildGender() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: TextStyle(
          color: Color(0xFF8B81C6),
          fontSize: 10,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Gender is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _gender = value;
      },
    );
  }

  Widget _buildAddress() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: 'Address',
        labelStyle: TextStyle(
          color: Color(0xFF8B81C6),
          fontSize: 10,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Address is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _address = value;
      },
    );
  }

  Widget _buildHeight() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Height in cms',
        labelStyle: TextStyle(
          color: Color(0xFF8B81C6),
          fontSize: 10,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Height is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _height = value;
      },
    );
  }

  Widget _buildWeight() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Weight in KGs',
        labelStyle: TextStyle(
          color: Color(0xFF8B81C6),
          fontSize: 10,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Weight is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _weight = value;
      },
    );
  }

  Widget _buildPhNo() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'PhoneNo.',
        labelStyle: TextStyle(
          color: Color(0xFF8B81C6),
          fontSize: 10,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'PhoneNo. is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _phNo = value;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
          color: Color(0xFF8B81C6),
          fontSize: 10,
        ),
        focusColor: Color(0xFF8B81C6),
        hoverColor: Color(0xFF8B81C6),
        fillColor: Color(0xFF8B81C6),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }
        if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
            .hasMatch(value)) {
          return 'Enter a valid Email Address';
        }
        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          color: Color(0xFF8B81C6),
          fontSize: 10,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8B81C6),
        title: Text(
          'Quarantine Tracker',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 2, color: Color(0xFF8B81C6)),
              ),
              margin: EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 4, 20),
                child: ModalProgressHUD(
                  color: Color(0xFF8B81C6),
                  inAsyncCall: showSpinner,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildName(),
                        _buildAge(),
                        _buildGender(),
                        _buildAddress(),
                        _buildHeight(),
                        _buildWeight(),
                        _buildPhNo(),
                        _buildEmail(),
                        _buildPassword(),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            RaisedButton(
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
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _authication(_formKey.currentContext);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
