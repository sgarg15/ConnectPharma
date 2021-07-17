import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pharma_connect/model/user_model.dart';
import 'package:pharma_connect/src/screens/Pharmacist/1pharmacistSignUp.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Registering
}

/*
The UI will depends on the Status to decide which screen/action to be done.
- Uninitialized - Checking user is logged or not, the Splash Screen will be shown
- Authenticated - User is authenticated successfully, Home Page will be shown
- Authenticating - Sign In button just been pressed, progress bar will be shown
- Unauthenticated - User is not authenticated, login page will be shown
- Registering - User just pressed registering, progress bar will be shown
Take note, this is just an idea. You can remove or further add more different
status for your UI or widgets to listen.
 */

class AuthProvider extends ChangeNotifier {
  //Firebase Auth object
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  CollectionReference users = FirebaseFirestore.instance.collection("Users");

  //Default status
  Status _status = Status.Uninitialized;

  Status get status => _status;

  //Stream<UserModel> get user => _auth.authStateChanges().map(_userFromFirebase);

  AuthProvider() {
    //initialise object
    _auth = FirebaseAuth.instance;
    User _user;
    //listener for authentication changes such as user sign in and sign out
    _auth.authStateChanges().listen(onAuthStateChanged);
  }

  //Create user object based on the given FirebaseUser
  UserModel _userFromFirebase(User? user) {
    return UserModel(
      uid: user!.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }

  //Method to detect live auth changes such as user sign in and sign out
  Future<void> onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _userFromFirebase(firebaseUser);
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<String> saveAsset(
      File? asset, String uidName, String fileName, String userName) async {
    try {
      if (asset != null) {
        Reference reference = FirebaseStorage.instance
            .ref()
            .child(userName + " " + uidName)
            .child(fileName);
        UploadTask uploadTask = reference.putFile(asset);

        String url = await (await uploadTask).ref.getDownloadURL();
        print(url);
        return url;
      } else {
        throw ("File was not able to be uploaded.");
      }
    } on FirebaseException catch (e) {
      print(e);
      return "";
    }
  }

  Future<String> saveImageAsset(Uint8List? asset, String uidName,
      String fileName, String userName) async {
    try {
      if (asset != null) {
        Reference reference = FirebaseStorage.instance
            .ref()
            .child(userName + " " + uidName)
            .child(fileName);
        UploadTask uploadTask = reference.putData(asset);

        String url = await (await uploadTask).ref.getDownloadURL();
        print(url);
        return url;
      } else {
        throw ("File was not able to be uploaded.");
      }
    } on FirebaseException catch (e) {
      print(e);
      return "";
    }
  }

  //Method for new user registration using email and password
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final UserCredential result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() {
        _status = Status.Authenticated;
        notifyListeners();
      });
      return result;
    } catch (e) {
      print("Error on the new user registration = " + e.toString());
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<UserCredential?> uploadPharmacistUserInformation(
      UserCredential? user, BuildContext context) async {
    if (user == null) {
      return null;
    }
    String resumePDFURL = await saveAsset(
        context.read(pharmacistSignUpProvider.notifier).resumePDFData,
        user.user!.uid,
        "Resume",
        context.read(pharmacistSignUpProvider.notifier).firstName);
    String frontIDURL = await saveAsset(
        context.read(pharmacistSignUpProvider.notifier).frontIDData,
        user.user!.uid,
        "Front ID",
        context.read(pharmacistSignUpProvider.notifier).firstName);
    String backIDURL = await saveAsset(
        context.read(pharmacistSignUpProvider.notifier).backIDData,
        user.user!.uid,
        "Back ID",
        context.read(pharmacistSignUpProvider.notifier).firstName);
    String registrationCertificateURL = await saveAsset(
        context
            .read(pharmacistSignUpProvider.notifier)
            .registrationCertificateData,
        user.user!.uid,
        "Registration Certificate",
        context.read(pharmacistSignUpProvider.notifier).firstName);
    String profilePhotoURL = await saveAsset(
        context.read(pharmacistSignUpProvider.notifier).profilePhotoData,
        user.user!.uid,
        "Profile Photo",
        context.read(pharmacistSignUpProvider.notifier).firstName);

    String signaureImageURL = await saveImageAsset(
        context.read(pharmacistSignUpProvider.notifier).signatureData,
        user.user!.uid,
        "Signature",
        context.read(pharmacistSignUpProvider.notifier).firstName);

    users
        .doc(user.user?.uid.toString())
        .collection(context.read(pharmacistSignUpProvider.notifier).firstName)
        .doc("Sign Up Information")
        .set({
      "User Type": "Pharmacist",
      "Email": context.read(pharmacistSignUpProvider.notifier).email,
      "First Name": context.read(pharmacistSignUpProvider.notifier).firstName,
      "Last Name": context.read(pharmacistSignUpProvider.notifier).lastName,
      "Address": context.read(pharmacistSignUpProvider.notifier).address,
      "Phone Number":
          context.read(pharmacistSignUpProvider.notifier).phoneNumber,
      "First Year Licensed":
          context.read(pharmacistSignUpProvider.notifier).firstYearLicensed,
      "Registration Number":
          context.read(pharmacistSignUpProvider.notifier).registrationNumber,
      "Registration Province":
          context.read(pharmacistSignUpProvider.notifier).registrationProvince,
      "Gradutation Year":
          context.read(pharmacistSignUpProvider.notifier).graduationYear,
      "Institution Name":
          context.read(pharmacistSignUpProvider.notifier).institutionName,
      "Working Experience":
          context.read(pharmacistSignUpProvider.notifier).workingExperience,
      "Willing to Move": context
          .read(pharmacistSignUpProvider.notifier)
          .willingToMove
          .toString(),
      "Entitled to Work": context
          .read(pharmacistSignUpProvider.notifier)
          .entitledToWork
          .toString(),
      "Active Member": context
          .read(pharmacistSignUpProvider.notifier)
          .activeMember
          .toString(),
      "Liability Insurance": context
          .read(pharmacistSignUpProvider.notifier)
          .liabilityInsurance
          .toString(),
      "License Restricted": context
          .read(pharmacistSignUpProvider.notifier)
          .licenseRestricted
          .toString(),
      "MalPractice": context
          .read(pharmacistSignUpProvider.notifier)
          .malpractice
          .toString(),
      "Felon": context.read(pharmacistSignUpProvider.notifier).felon.toString(),
      "Resume Download URL": resumePDFURL,
      "FrontID Download URL": frontIDURL,
      "BackID Download URL": backIDURL,
      "Registration Certificate Download URL": registrationCertificateURL,
      "Profile Photo Download URL": profilePhotoURL,
      "Signature Download URL": signaureImageURL,
    });
    return user;
  }

  //Method to handle user sign in using email and password
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (result.user!.emailVerified) {
        _status = Status.Authenticated;
        notifyListeners();
        return _userFromFirebase(result.user);
      } else {
        return null;
      }
    } catch (e) {
      print("Error on the sign in = " + e.toString());
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential result = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .whenComplete(() {
        _status = Status.Authenticated;
      });

      return _userFromFirebase(result.user);
    } catch (err) {
      print("Error on the sign in = " + err.toString());
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  //Method to handle password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  //Method to handle user signing out
  Future signOut() async {
    await _auth.signOut().then((_) {
      _googleSignIn.signOut();
    });
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}
