import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _email, _password;
  bool hidePassword = true;
  bool button = false;

  void signIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        button = true;
      });
      _formKey.currentState.save();
      try {
        UserCredential user = (await _auth
            .signInWithEmailAndPassword(email: _email, password: _password)
            .then((doc) async {
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString("isUserLoggedin", "true");
          Navigator.pushReplacementNamed(context, "/HomePage");
        }));
      } catch (e) {
        setState(() {
          button = false;
        });
        showError(e.message);
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
    var temp = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 165,
                ),
                Text(
                  "Login",
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
                  "Please enter your login details to continue",
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
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.user,
                              size: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Color.fromRGBO(38, 50, 56, .50)),
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return "Please enter your email";
                                  }
                                },
                                onSaved: (input) => _email = input,
                                decoration: InputDecoration(
                                  hintText: "Email",
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
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.lock,
                              size: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Color.fromRGBO(38, 50, 56, .50)),
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
                                  hintText: "Password",
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
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 8,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 80,
                          height: 65,
                          child: RaisedButton(
                            elevation: 5,
                            shape: StadiumBorder(),
                            color: Colors.black,
                            onPressed: () {
                              this.signIn();
                            },
                            child: button
                                ? SpinKitWave(
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Karla",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.25),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/SignupPage");
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account ? ",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Karla",
                                // letterSpacing: -1.5,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Register.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black)),
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
