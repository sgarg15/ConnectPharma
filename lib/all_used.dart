import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'Sign Up Information Pages/PharmacySignUpInfo.dart';
import 'Sign Up Information Pages/PharmacistSignUpInfo.dart';

DatabaseReference dbRef = FirebaseDatabase.instance.reference();

Future<void> logInEmail(
  GlobalKey<FormState> formKey,
  String email,
  String password,
  BuildContext context,
) async {
  //Validate Fields
  final formState = formKey.currentState;
  if (formState.validate()) {
    //Login to firebase
    formState.save();
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((result) {
        return dbRef.child("Users/" + result.user.uid).once();
      }).then((DataSnapshot user) {
        String userType = user.value["user_type"].toString();
        return userType;
      }).then((userType) {
        if (userType == "Pharmacy") {
          print("Logged in as pharmacy");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PharmacySignUpInfoPage()),
          );
        } else if (userType == "Pharmacist") {
          print("Logged in as pharmacist");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PharmacistSignUpInfoPage()),
          );
        }
      });
    } catch (e) {
      print(e.message);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(e.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
}

Future<void> signUpEmail(
  GlobalKey<FormState> formKey,
  String email,
  String password,
  BuildContext context,
  String userType,
  StatefulWidget infoPage,
) async {
  //Validate Fields
  final formState = formKey.currentState;
  if (formState.validate()) {
    //Login to firebase
    formState.save();
    try {
      // ignore: unused_local_variable
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        dbRef.child("Users").child(result.user.uid).set({
          "email": email,
          "user_type": userType,
        }).then((res) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Important!"),
                  content: Text(
                      "You will later be required to verify this email. Without verifying your email you will not be allowed access the services. Please make sure you have access to this email. Thank you"),
                  actions: [
                    TextButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Color(0xFF5DB075)),
                      ),
                      onPressed: () {
                        // Direct to whichever they are in Information Form pages
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => infoPage),
                        );
                      },
                    )
                  ],
                );
              });
        });
      });
    } catch (e) {
      print(e.message);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(e.message),
              actions: [
                TextButton(
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Color(0xFF5DB075)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
}
