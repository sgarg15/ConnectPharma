import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'LoginPage.dart';
import 'PharmacySignUpPage.dart';
import 'PharmacistSignUpPage.dart';

Future main() async {
  await dotenv.load();

  runApp(MaterialApp(
    home: PharmaConnect(),
    debugShowCheckedModeBanner: false,
  ));
}

class PharmaConnect extends StatefulWidget {
  @override
  _PharmaConnectState createState() => new _PharmaConnectState();
}

class _PharmaConnectState extends State<PharmaConnect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //Pharma Text
            Container(
              alignment: Alignment(-0.45, -0.55),
              child: RichText(
                text: TextSpan(
                  text: "Pharma",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 50.0,
                      color: Colors.black),
                ),
              ),
            ),
            //Connect Text
            Container(
              //top: 240,
              // left: 130,
              alignment: Alignment(0.45, -0.35),
              child: RichText(
                text: TextSpan(
                  text: "Connect",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 50.0,
                      color: Colors.black),
                ),
              ),
            ),
            //Register Text
            Container(
              //top: 360,
              alignment: Alignment(0, 0.2),
              child: RichText(
                text: TextSpan(
                  text: "Register",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 35.0,
                      color: Colors.black),
                ),
              ),
            ),
            //Log In Text and Button
            Container(
              alignment: Alignment(0, 0.95),
              child: GestureDetector(
                child: RichText(
                  text: TextSpan(
                    text: "Log In",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 25.0,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                onTap: () {
                  //Push to Login Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogInPage()),
                  );
                },
              ),
            ),
            //Button For Pharmacist Registration
            Container(
              alignment: Alignment(0, 0.4),
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //Send to Pharmacist Sign Up Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PharmacistSignUpPage()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Pharmacist",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //Button For Pharmacy Registration
            Container(
              alignment: Alignment(0, 0.6),
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //Send to Pharmacy Sign Up Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PharmacySignUpPage()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Pharmacy",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
