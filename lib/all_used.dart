import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Sign Up Information Pages/PharmacySignUpInfo.dart';
import 'Sign Up Information Pages/PharmacistSignUpInfo.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

DatabaseReference dbRef = FirebaseDatabase.instance.reference();
FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignIn _googleSignIn = GoogleSignIn();
FacebookAuth _facebookAuth = FacebookAuth.instance;
User _user;

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
      // ignore: unused_local_variable
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        dbRef.child("Users").child(result.user.uid).set({
          "email": email,
          "user_type": userType.toLowerCase(),
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

Future<void> googleAuthentication(
  String userType,
  BuildContext context,
  StatefulWidget pageToDirect,
  String action,
) async {
  try {
    print("Google Signing In");
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication authentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
    if (action.toLowerCase() == "signup") {
      await _auth.signInWithCredential(credential).then((value) {
        dbRef.child("Users").child(value.user.uid).set({
          "email": googleSignInAccount.email,
          "user_type": userType.toLowerCase(),
        }).then((value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => pageToDirect));
        });
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

// ignore: missing_return
Future<UserCredential> facebookAuthentication(
  String userType,
  BuildContext context,
  StatefulWidget pageToDirect,
  String action,
) async {
  final LoginResult result =
      await FacebookAuth.instance.login(permissions: ['email']);

  final facebookAuthCredential =
      FacebookAuthProvider.credential(result.accessToken.token);
  if (action.toLowerCase() == "signup") {
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential)
        .then((value) {
      dbRef.child("Users").child(value.user.uid).set({
        "email": _facebookAuth.getUserData(fields: "email"),
        "user_type": userType.toLowerCase(),
      }).then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => pageToDirect));
      });
    });
  } else if (action.toLowerCase() == "login") {
    await _auth.signInWithCredential(facebookAuthCredential).then((result) {
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
  }
}

Future<void> signOut() async {
  await _auth.signOut().then((_) {
    _googleSignIn.signOut();
    _facebookAuth.logOut();
  });
}
