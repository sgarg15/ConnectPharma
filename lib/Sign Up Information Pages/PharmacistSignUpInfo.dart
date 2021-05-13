import 'package:flutter/material.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("PHARMACIST SIGN UP"),
          ],
        ),
      ),
    );
  }
}
