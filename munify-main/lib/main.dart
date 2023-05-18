import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:munify/AddIssue.dart';
import 'package:munify/ChooseAuthentication.dart';
import 'package:munify/HomePage.dart';
import 'package:munify/InfoPage.dart';
import 'package:munify/IssuePage.dart';
import 'package:munify/SettingsPage.dart';
import 'package:munify/SigninPage.dart';
import 'package:munify/SignupPage.dart';
import 'package:munify/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Muni\'fy',
        themeMode: ThemeMode.system,
        theme: ThemeData.light().copyWith(
          backgroundColor: Colors.white,
          textTheme: TextTheme(
            headline1: GoogleFonts.karla(
                fontSize: 106,
                fontWeight: FontWeight.w300,
                letterSpacing: -1.5),
            headline2: GoogleFonts.karla(
                fontSize: 62, fontWeight: FontWeight.w600, letterSpacing: -0.5),
            headline3: GoogleFonts.karla(
                fontSize: 53, fontWeight: FontWeight.w600, letterSpacing: -0.5),
            headline4: GoogleFonts.karla(
                fontSize: 38, fontWeight: FontWeight.w600, letterSpacing: 0.25),
            headline5:
                GoogleFonts.karla(fontSize: 27, fontWeight: FontWeight.w400),
            headline6: GoogleFonts.karla(
                fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 0.15),
            subtitle1: GoogleFonts.karla(
                fontSize: 18, fontWeight: FontWeight.w400, letterSpacing: 0.15),
            subtitle2: GoogleFonts.karla(
                fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 0.1),
            bodyText1: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
              height: 1.5,
            ),
            bodyText2: GoogleFonts.roboto(
                fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
            button: GoogleFonts.roboto(
                fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
            caption: GoogleFonts.karla(
                fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0),
            overline: GoogleFonts.roboto(
                fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
          ).apply(
            displayColor: Colors.black,
            bodyColor: Color.fromRGBO(126, 126, 126, 1),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          // "/SplashScreen": (BuildContext context) => SplashScreen(),
          "/SigninPage": (BuildContext context) => SigninPage(),
          "/SignupPage": (BuildContext context) => SignupPage(),
          "/HomePage": (BuildContext context) => HomePage(),
          "/IssuePage": (BuildContext context) => IssuePage(),
          "/AddIssue": (BuildContext context) => AddIssue(),
          "/InfoPage": (BuildContext context) => InfoPage(),
          "/SettingsPage": (BuildContext context) => SettingsPage(),
          "/ChooseAuthentication": (BuildContext context) =>
              ChooseAuthentication(),
        });
  }
}
