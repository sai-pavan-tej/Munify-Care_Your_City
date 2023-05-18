import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String userType;

  void getData() async {
    _auth.authStateChanges().listen((user) async {
      var temp = await firestore.collection('users').doc(user.uid).get();
      setState(() {
        userType = temp.data()["userType"];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/SettingsPage");
              },
              child: Icon(
                Icons.settings,
                color: Colors.black,
              )),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 10,
            right: 10,
            child: Container(
              // width: MediaQuery.of(context).size.width - 40,
              height: 210,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/garbagetruck.jpg"),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose a Issue type,",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0c1f36)),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 4.0),
                  Material(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    elevation: 0.0,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/IssuePage",
                            arguments: ["DECLUTTER", userType]);
                      },
                      minWidth: 335.0,
                      height: 90.0,
                      child: Row(
                        children: [
                          Container(
                            child: Expanded(
                              child: Text(
                                'DECLUTTER',
                                style: TextStyle(
                                  color: Color(0xff0c1f36),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 52,
                            width: 40,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/Trash.png',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Material(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    elevation: 0.0,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/IssuePage",
                            arguments: ["POTHOLES", userType]);
                      },
                      minWidth: 335.0,
                      height: 90.0,
                      child: Row(
                        children: [
                          Container(
                            child: Expanded(
                              child: Text(
                                'POTHOLES',
                                style: TextStyle(
                                  color: Color(0xff0c1f36),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 52,
                            width: 40,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/Water Filtration.png',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Material(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    elevation: 0.0,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/IssuePage",
                            arguments: ["SEEPAGE", userType]);
                      },
                      minWidth: 335.0,
                      height: 90.0,
                      child: Row(
                        children: [
                          Container(
                            child: Expanded(
                              child: Text(
                                'SEEPAGE',
                                style: TextStyle(
                                  color: Color(0xff0c1f36),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 52,
                            width: 40,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/Faucet.png',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Material(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    elevation: 0.0,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/IssuePage",
                            arguments: ["ELECTRICITY", userType]);
                      },
                      minWidth: 335.0,
                      height: 90.0,
                      child: Row(
                        children: [
                          Container(
                            child: Expanded(
                              child: Text(
                                'ELECTRICITY',
                                style: TextStyle(
                                  color: Color(0xff0c1f36),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 52,
                            width: 40,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/Eco Plug.png',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
