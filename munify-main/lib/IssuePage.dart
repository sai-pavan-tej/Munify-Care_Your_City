import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IssuePage extends StatefulWidget {
  @override
  _IssuePageState createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {
  String address = "Select";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Position position;
  String _currentLocation;
  GeoFirePoint addresslatlangarg;
  final geo = Geoflutterfire();

  String uid;

  _getCurrentLocation() async {
    LocationPermission permission = await requestPermission();
    position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _currentLocation = placemarks[0].locality;
    });
  }

  setaddresslatlang() async {
    List addresslatlang = await locationFromAddress(address);
    addresslatlangarg = geo.point(
        latitude: addresslatlang[0].latitude,
        longitude: addresslatlang[0].longitude);
  }

  void getData() async {
    _auth.authStateChanges().listen((user) async {
      setState(() {
        uid = user.uid;
      });
      var temp = await firestore.collection('users').doc(user.uid).get();
      setState(() {
        if (temp.data()['address'] != null) {
          address = temp.data()['address'];
          setaddresslatlang();
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    _getCurrentLocation();
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
          "${temp[0]} ISSUES",
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff0c1f36),
              fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (address != "Select") {
            Navigator.pushNamed(context, "/AddIssue",
                arguments: [temp[0], addresslatlangarg.data, address]);
          } else {
            Fluttertoast.showToast(
                msg: "Please choose your location",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 12.0);
          }
        },
        backgroundColor: Color(0xff0075F2),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Color(0xff626e82),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CURRENT ADDRESS",
                          style: TextStyle(
                              color: Color(0xff626e82),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        address != "Select"
                            ? Text(
                                "${address.substring(0, 15)}...",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xff626e82),
                                  fontSize: 14,
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  LocationResult result =
                                      await showLocationPicker(
                                    context,
                                    "<API_KEY>",
                                    initialCenter: LatLng(
                                        position.latitude, position.longitude),
                                    automaticallyAnimateToCurrentLocation:
                                        false,
                                    resultCardConfirmIcon: Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                    ),
                                    myLocationButtonEnabled: false,
                                    layersButtonEnabled: false,
                                  );
                                  setState(() {
                                    address = result.address;
                                  });
                                  firestore
                                      .collection('users')
                                      .doc(uid)
                                      .update({
                                    "address": address,
                                  });
                                  setaddresslatlang();
                                },
                                child: Text(
                                  "SELECT",
                                  style: TextStyle(
                                    color: Color(0xff626e82),
                                    fontSize: 14,
                                  ),
                                ),
                              )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                    stream: firestore.collection(temp[0]).snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.blueAccent,
                              ),
                            )
                          : snapshot.data.documents.length != 0
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: ListView.builder(
                                      itemCount: snapshot.data.documents.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot issues =
                                            snapshot.data.documents[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, "/InfoPage",
                                                arguments: [
                                                  issues["image"],
                                                  issues["title"],
                                                  issues["bio"],
                                                  issues["address"],
                                                  issues["done"],
                                                  temp[1],
                                                  temp[0],
                                                  issues.id
                                                ]);
                                          },
                                          child: Card(
                                            color: Colors.grey[50],
                                            clipBehavior: Clip.antiAlias,
                                            child: ListTile(
                                              leading: Container(
                                                  width: 50,
                                                  height: 70,
                                                  decoration: new BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      image: new DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              "${issues["image"]}")))),
                                              title: Text(
                                                '${issues["title"]}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xff0075F2),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              // trailing: Text(
                                              //   '#${boxes["boxid"]}',
                                              //   style: TextStyle(
                                              //       fontSize: 15,
                                              //       color: Colors.grey,
                                              //       fontWeight:
                                              //           FontWeight.bold),
                                              // ),
                                              subtitle: Text(
                                                '${issues["bio"].substring(0, 5)}...',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 100,
                                    ),
                                    Container(
                                      // width: MediaQuery.of(context).size.width - 40,
                                      height: 210,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage("assets/noissues.png"),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Center(
                                      child: Text(
                                        "No issues found near your area.",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff0c1f36)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                );
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
