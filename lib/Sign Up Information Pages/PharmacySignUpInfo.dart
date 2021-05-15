import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pharma_connect/all_used.dart';

import '../main.dart';

class PharmacySignUpInfoPage extends StatefulWidget {
  @override
  _PharmacySignUpInfoPage createState() => new _PharmacySignUpInfoPage();
}

class _PharmacySignUpInfoPage extends State<PharmacySignUpInfoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ignore: unused_field
  String _password, _email;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        //TODO: REMOVE THIS ONCE EVERYTHING WORKS AND REPLACE IT INSIDE THE SIDE MENU
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Important!"),
                content: Text("You will be signed out."),
                actions: [
                  TextButton(
                    child: Text(
                      "Ok",
                      style: TextStyle(color: Color(0xFF5DB075)),
                    ),
                    onPressed: () {
                      // Direct to whichever they are in Information Form pages
                      signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PharmaConnect()),
                      );
                    },
                  )
                ],
              );
            });
      },
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Pharmacy Info Page"),
        ),
      ),
    );
  }
}
