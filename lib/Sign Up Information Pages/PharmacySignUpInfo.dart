import 'package:flutter/material.dart';

class PharmacySignUpInfoPage extends StatefulWidget {
  @override
  _PharmacySignUpInfoPage createState() => new _PharmacySignUpInfoPage();
}

class _PharmacySignUpInfoPage extends State<PharmacySignUpInfoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ignore: unused_field
  String _password, _email;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("PHARMACY SIGN UP"),
          ],
        ),
      ),
    );
  }
}
