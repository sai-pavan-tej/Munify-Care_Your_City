import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool button = false;
  String coll, doc;

  getData() async {
    _auth.authStateChanges().listen((user) async {
      var temp = await firestore.collection(coll).doc(doc).get();
      setState(() {
        button = temp.data()["done"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> temp = ModalRoute.of(context).settings.arguments;
    coll = temp[6];
    doc = temp[7];
    return Scaffold(
      backgroundColor: Colors.white,
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
          "${temp[1]}",
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff0c1f36),
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: 190,
              decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: new DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(temp[0])))),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "ISSUE NAME",
                  style: TextStyle(
                      color: Color(0xff626e82),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "${temp[1]}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "LOCATION",
                  style: TextStyle(
                      color: Color(0xff626e82),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "${temp[3]}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "DESCRIPTION",
                  style: TextStyle(
                      color: Color(0xff626e82),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "${temp[2]}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                temp[5] != "USER"
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 200,
                          height: 50,
                          child: RaisedButton(
                            elevation: 5,
                            shape: StadiumBorder(),
                            color:
                                button ? Colors.greenAccent : Colors.redAccent,
                            onPressed: () {
                              setState(() {
                                button = !button;
                              });
                              firestore
                                  .collection(coll)
                                  .doc(doc)
                                  .update({"done": button});
                            },
                            child: button
                                ? Text(
                                    "COMPLETED",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Karla",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.25),
                                  )
                                : Text(
                                    "PENDING",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Karla",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.25),
                                  ),
                          ),
                        ))
                    : Container()
              ],
            ),
          )
        ],
      ),
    );
  }
}
