import 'package:flutter/material.dart';
import 'package:munify/ChooseAuthentication.dart';
import 'package:munify/HomePage.dart';
import 'package:munify/SigninPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.checkAuth();
  }

  checkAuth() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    status = sp.getString("isUserLoggedin");

    if (status == "true") {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    } else {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SigninPage()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                text: 'Muni\'fy',
                style: TextStyle(
                    fontSize: 60,
                    fontFamily: "Karla",
                    letterSpacing: -1.5,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: '.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 70,
                          color: Color(0xff0075F2))),
                ],
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              "~ help us know your city better ~",
              style: TextStyle(
                fontSize: 15,
                fontFamily: "Karla",
                letterSpacing: -1.5,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: LinearProgressIndicator(
                minHeight: 3,
                backgroundColor: Colors.grey[100],
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0075F2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
