import 'package:flutter/material.dart';

class ChooseAuthentication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Material(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              elevation: 0.0,
              child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/SigninPage",
                        arguments: "user");
                  },
                  minWidth: MediaQuery.of(context).size.width - 80,
                  height: 54.0,
                  child: Text(
                    'LOGIN AS USER',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            Material(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              elevation: 0.0,
              child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/SigninPage",
                        arguments: "admin");
                  },
                  minWidth: MediaQuery.of(context).size.width - 80,
                  height: 54.0,
                  child: Text(
                    'LOGIN AS VOLUNTEER',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  )),
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
        ),
      ),
    );
  }
}
