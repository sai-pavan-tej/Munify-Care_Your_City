import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';

class AddIssue extends StatefulWidget {
  @override
  _AddIssueState createState() => _AddIssueState();
}

class _AddIssueState extends State<AddIssue> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool button = true;
  String uid;

  String _title, _bio;
  var imageFile;
  final ImagePicker _picker = ImagePicker();

  // void getData() async {
  //   _auth.authStateChanges().listen((user) async {
  //     setState(() {
  //       uid = user.uid;
  //     });
  //   });
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getData();
  // }

  saveDetails(String coll, var latlang, String address) async {
    String url;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        button = false;
      });

      try {
        var storageReference =
            FirebaseStorage.instance.ref().child(Path.basename(imageFile.path));
        await storageReference.putFile(imageFile).whenComplete(() async {
          url = await storageReference.getDownloadURL();
        });
        firestore.collection('${coll}').doc().set({
          "image": url,
          "title": _title,
          "bio": _bio,
          "count": 0,
          "coords": latlang,
          "address": address,
          "done": false,
        }).then((value) {
          Navigator.pop(context);
        });
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

  void _startPickingImage(BuildContext ctx) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: ctx,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ListTile(
                  dense: true,
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.black45,
                      )),
                  title: Text(
                    'Choose An Option',
                    style: TextStyle(
                        fontFamily: "Gilroy",
                        color: Colors.black45,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            //SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.cameraRetro,
                        size: 30,
                        color: Color(0xff0075F2),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await _picker
                            .getImage(source: ImageSource.camera)
                            .then((image) async {
                          setState(() {
                            // button = false;
                            imageFile = File(image.path);
                          });
                        });
                      },
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(
                          fontFamily: "Gilroy",
                          color: Colors.black45,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.images,
                        size: 30,
                        color: Color(0xff0075F2),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await _picker
                            .getImage(source: ImageSource.gallery)
                            .then((image) async {
                          setState(() {
                            // button = false;
                            imageFile = File(image.path);
                          });
                        });
                      },
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(
                          fontFamily: "Gilroy",
                          color: Colors.black45,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> temp = ModalRoute.of(context).settings.arguments;
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
          "ADD ISSUE",
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff0c1f36),
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey[200],
              width: MediaQuery.of(context).size.width,
              height: 190,
              child: imageFile == null
                  ? GestureDetector(
                      onTap: () {
                        this._startPickingImage(context);
                      },
                      child: Center(
                        child: Icon(
                          Icons.add,
                          size: 50,
                          color: Color(0xff0c1f36),
                        ),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: 190,
                      decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: new DecorationImage(
                              fit: BoxFit.cover, image: FileImage(imageFile)))),
            ),
            SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    TextFormField(
                      style: TextStyle(color: Color.fromRGBO(38, 50, 56, .50)),
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Please enter Issue name";
                        }
                      },
                      onSaved: (input) => _title = input,
                      decoration: InputDecoration(
                        hintText: "ISSUE NAME",
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(38, 50, 56, 0.30),
                          fontSize: 14.0,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                      ),
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
                    TextFormField(
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(color: Color.fromRGBO(38, 50, 56, .50)),
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Please enter description";
                        }
                      },
                      onSaved: (input) => _bio = input,
                      decoration: InputDecoration(
                        hintText: "DESCRIPTION",
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(38, 50, 56, 0.30),
                          fontSize: 14.0,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Material(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () {
                            saveDetails(temp[0], temp[1], temp[2]);
                          },
                          minWidth: MediaQuery.of(context).size.width - 40,
                          height: 54.0,
                          child: button
                              ? Text(
                                  'SUBMIT ISSUE',
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
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
