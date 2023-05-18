import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:munify/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String language = "English";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 15,
              color: Color(0xff0c1f36),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: Text(
          "SETTINGS",
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff0c1f36),
              fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                Expanded(
                    child: Text("Language",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold))),
                Container(
                  width: 100.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Center(
                    child: DropdownButton<Language>(
                      hint: Text("${language}"),
                      style: TextStyle(
                        color: Color.fromRGBO(38, 50, 56, 0.30),
                        fontSize: 15.0,
                        fontFamily: "Gilroy",
                      ),
                      underline: SizedBox(),
                      onChanged: (Language val) {
                        setState(() {
                          language = val.name;
                        });
                      },
                      items: Language.languageList()
                          .map<DropdownMenuItem<Language>>(
                            (e) => DropdownMenuItem<Language>(
                              value: e,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    e.name,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _auth.signOut().then((value) async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.setString("isUserLoggedin", "false");
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/SigninPage", (Route<dynamic> route) => false);
                });
              },
              child: Text(
                "SIGN OUT",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffde7979)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
