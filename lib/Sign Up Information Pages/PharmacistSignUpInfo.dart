import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../all_used.dart';
import '../main.dart';

class PharmacistSignUpInfoPage extends StatefulWidget {
  @override
  _PharmacistSignUpInfoPage createState() => new _PharmacistSignUpInfoPage();
}

class _PharmacistSignUpInfoPage extends State<PharmacistSignUpInfoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          title: new Text("Pharmacist Info Page"),
        ),
      ),
    );
  }
}
