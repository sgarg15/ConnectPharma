import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Sign Up Information Pages/PharmacySignUpInfo.dart';
import 'Sign Up Information Pages/PharmacistSignUpInfo.dart';

DatabaseReference dbRef = FirebaseDatabase.instance.reference();
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignIn _googleSignIn = GoogleSignIn();
User _user;
CollectionReference users = FirebaseFirestore.instance.collection("Users");

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
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        return users.doc(value.user.uid.toString()).get();
      }).then((DocumentSnapshot user) {
        String userType = user.get("user_type").toString();
        print(email);
        return userType;
      }).then((userType) {
        if (userType.toLowerCase() == "pharmacy") {
          print("Logged in as pharmacy");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PharmacySignUpInfoPage()),
          );
        } else if (userType.toLowerCase() == "pharmacist") {
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
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        return users
            .doc(value.user.uid.toString())
            .set({"email": email, "user_type": userType.toLowerCase()});
      }).then((value) {
        return showDialog(
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

Future<void> googleAuthentication(
  String userType,
  BuildContext context,
  StatefulWidget pageToDirect,
  String action,
) async {
  try {
    print("Google Signing In");
    // Trigger the authentication flow
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    // Obtain the auth details from the request
    GoogleSignInAuthentication authentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
    if (action.toLowerCase() == "signup") {
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );

      await _auth.signInWithCredential(credential).then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => pageToDirect));
      });
      return _user = await _auth.currentUser;
    } else if (action.toLowerCase() == "login") {
      await _auth.signInWithCredential(credential).then((result) {
        return dbRef.child("Users/" + result.user.uid).once();
      }).then((DataSnapshot user) {
        String userType = user.value["user_type"].toString();
        return userType;
      }).then((userType) {
        if (userType.toLowerCase() == "pharmacy") {
          print("Logged in as pharmacy");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PharmacySignUpInfoPage()),
          );
        } else if (userType.toLowerCase() == "pharmacist") {
          print("Logged in as pharmacist");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PharmacistSignUpInfoPage()),
          );
        }
      });
      return _user = await _auth.currentUser;
    }
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

Future<void> signOut() async {
  await _auth.signOut().then((_) {
    _googleSignIn.signOut();
  });
}

class formField extends StatelessWidget {
  String fieldTitle;
  String hintText;
  TextEditingController textController;
  TextInputType keyboardStyle;

  formField(
      {this.fieldTitle,
      this.hintText,
      this.textController,
      this.keyboardStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
              text: fieldTitle,
              style: GoogleFonts.questrial(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              )),
        ),
        SizedBox(height: 10),
        Container(
          width: 335,
          height: 50,
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            child: TextFormField(
              keyboardType: keyboardStyle,
              controller: textController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF0F0F0),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE8E8E8)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: hintText,
                hintStyle:
                    GoogleFonts.inter(color: Color(0xFFBDBDBD), fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
