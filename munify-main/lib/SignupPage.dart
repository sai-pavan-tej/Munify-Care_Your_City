import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _email, _password;
  bool hidePassword = true;
  String userType;
  bool button = true;

  void signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        button = false;
      });
      try {
        User user = (await _auth
            .createUserWithEmailAndPassword(email: _email, password: _password)
            .then((docs) async {
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString("isUserLoggedin", "true");
          sp.setString("isPhoneLoggedin", "false");
          firestore.collection('users').doc(docs.user.uid).set(
              {"email": _email, "password": _password, "userType": userType});
          Navigator.pushNamedAndRemoveUntil(
              context, "/HomePage", (Route<dynamic> route) => false);
        }));
      } catch (e) {
        showError(e.message);
        setState(() {
          button = true;
        });
      }
    }
  }

  showError(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  showPassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 165,
              ),
              Text(
                "Signup",
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Karla",
                    letterSpacing: -1.5,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Please enter your credentials to get registered",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                  color: Color(0xff7E7E7E),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style:
                            TextStyle(color: Color.fromRGBO(38, 50, 56, .50)),
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Please enter your email address";
                          }
                        },
                        onSaved: (input) => _email = input,
                        decoration: InputDecoration(
                          hintText: "EMAIL ADDRESS/PHONE",
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(38, 50, 56, 0.30),
                            fontSize: 14.0,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        style:
                            TextStyle(color: Color.fromRGBO(38, 50, 56, .50)),
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Please enter your password";
                          }
                        },
                        onSaved: (input) => _password = input,
                        obscureText: hidePassword,
                        decoration: InputDecoration(
                          suffix: GestureDetector(
                            onTap: () {
                              showPassword();
                            },
                            child: Icon(
                              Icons.remove_red_eye,
                              color: Colors.black,
                              size: 15,
                            ),
                          ),
                          hintText: "PASSWORD",
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(38, 50, 56, 0.30),
                            fontSize: 14.0,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: Colors.white,
                            border: Border.all()),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              style: TextStyle(
                                color: Color.fromRGBO(38, 50, 56, 0.30),
                                fontSize: 14,
                              ),
                              hint: Text(
                                "USER TYPE",
                                style: TextStyle(
                                  color: Color.fromRGBO(38, 50, 56, 0.30),
                                  fontSize: 14,
                                ),
                              ),
                              value: userType,
                              items: [
                                DropdownMenuItem(
                                  child: Text("USER"),
                                  value: "USER",
                                ),
                                DropdownMenuItem(
                                  child: Text("VOLUNTEER"),
                                  value: "VOLUNTEER",
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  userType = value;
                                });
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Material(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () {
                            signUp();
                          },
                          minWidth: 335.0,
                          height: 54.0,
                          child: button
                              ? Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                )
                              : SpinKitWave(
                                  color: Colors.white,
                                  size: 20,
                                ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
