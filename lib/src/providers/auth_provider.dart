import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Sign Up/1pharmacistSignUp.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Sign Up/1pharmacy_signup.dart';

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
  CollectionReference testCollection =
      FirebaseFirestore.instance.collection('TestCollection');

  //Default status
  Status _status = Status.Uninitialized;

  Status get status => _status;

  //Stream<UserModel> get user => _auth.authStateChanges().map(_userFromFirebase);

  AuthProvider() {
    //initialise object
    _auth = FirebaseAuth.instance;
    User _user;
    //listener for authentication changes such as user sign in and sign out
    //_auth.authStateChanges().listen(onAuthStateChanged);
  }

  //Create user object based on the given FirebaseUser
  // UserModel _userFromFirebase(User? user) {
  //   return UserModel(
  //     uid: user!.uid,
  //     email: user.email,
  //     displayName: user.displayName,
  //   );
  // }

  //Method to detect live auth changes such as user sign in and sign out
  // Future<void> onAuthStateChanged(User? firebaseUser) async {
  //   if (firebaseUser == null) {
  //     _status = Status.Unauthenticated;
  //   } else {
  //     _userFromFirebase(firebaseUser);
  //     _status = Status.Authenticated;
  //   }
  //   notifyListeners();
  // }

  Future<String> saveAsset(
      File? asset, String uidName, String fileName, String userName) async {
    try {
      if (asset != null) {
        Reference reference = FirebaseStorage.instance
            .ref()
            .child(userName + uidName)
            .child(fileName);
        UploadTask uploadTask = reference.putFile(asset);

        String url = await (await uploadTask).ref.getDownloadURL();
        return url;
      } else {
        return "";
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
            .child(userName + uidName)
            .child(fileName);
        UploadTask uploadTask = reference.putData(asset);

        String url = await (await uploadTask).ref.getDownloadURL();
        return url;
      } else {
        return "";
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
      WidgetRef ref, UserCredential? user, BuildContext context) async {
    if (user == null) {
      return null;
    }
    String resumePDFURL = await saveAsset(
        ref.read(pharmacistSignUpProvider.notifier).resumePDFData,
        user.user!.uid,
        "Resume",
        ref.read(pharmacistSignUpProvider.notifier).firstName);
    String frontIDURL = await saveAsset(
        ref.read(pharmacistSignUpProvider.notifier).frontIDData,
        user.user!.uid,
        "Front ID",
        ref.read(pharmacistSignUpProvider.notifier).firstName);
    String backIDURL = await saveAsset(
        ref.read(pharmacistSignUpProvider.notifier).backIDData,
        user.user!.uid,
        "Back ID",
        ref.read(pharmacistSignUpProvider.notifier).firstName);
    String registrationCertificateURL = await saveAsset(
        ref
            .read(pharmacistSignUpProvider.notifier)
            .registrationCertificateData,
        user.user!.uid,
        "Registration Certificate",
        ref.read(pharmacistSignUpProvider.notifier).firstName);
    String profilePhotoURL = await saveAsset(
        ref.read(pharmacistSignUpProvider.notifier).profilePhotoData,
        user.user!.uid,
        "Profile Photo",
        ref.read(pharmacistSignUpProvider.notifier).firstName);

    String signaureImageURL = await saveImageAsset(
        ref.read(pharmacistSignUpProvider.notifier).signatureData,
        user.user!.uid,
        "Signature",
        ref.read(pharmacistSignUpProvider.notifier).firstName);

    users
        .doc(user.user?.uid.toString())
        .collection("SignUp")
        .doc("Information")
        .set({
      "availability": {},
      "userType": "Pharmacist",
      "email": ref.read(pharmacistSignUpProvider.notifier).email,
      "firstName": ref.read(pharmacistSignUpProvider.notifier).firstName,
      "lastName": ref.read(pharmacistSignUpProvider.notifier).lastName,
      "address": ref.read(pharmacistSignUpProvider.notifier).address,
      "phoneNumber":
          ref.read(pharmacistSignUpProvider.notifier).phoneNumber,
      "firstYearLicensed":
          ref.read(pharmacistSignUpProvider.notifier).firstYearLicensed,
      "registrationNumber":
          ref.read(pharmacistSignUpProvider.notifier).registrationNumber,
      "registrationProvince":
          ref.read(pharmacistSignUpProvider.notifier).registrationProvince,
      "gradutationYear":
          ref.read(pharmacistSignUpProvider.notifier).graduationYear,
      "institutionName":
          ref.read(pharmacistSignUpProvider.notifier).institutionName,
      "workingExperience":
          ref.read(pharmacistSignUpProvider.notifier).workingExperience,
      "willingToMove":
          ref.read(pharmacistSignUpProvider.notifier).willingToMove,
      "entitledToWork":
          ref.read(pharmacistSignUpProvider.notifier).entitledToWork,
      "activeMember":
          ref.read(pharmacistSignUpProvider.notifier).activeMember,
      "liabilityInsurance":
          ref.read(pharmacistSignUpProvider.notifier).liabilityInsurance,
      "licenseRestricted":
          ref.read(pharmacistSignUpProvider.notifier).licenseRestricted,
      "malPractice":
          ref.read(pharmacistSignUpProvider.notifier).malpractice,
      "felon": ref.read(pharmacistSignUpProvider.notifier).felon,
      "knownSoftware":
          ref.read(pharmacistSignUpProvider.notifier)
          .softwareList
          .toString(),
      "knownSkills":
          ref.read(pharmacistSignUpProvider.notifier).skillList.toString(),
      "knownLanguages":
          ref
          .read(pharmacistSignUpProvider.notifier)
          .languageList
          .toString(),
      "resumeDownloadURL": resumePDFURL,
      "frontIDDownloadURL": frontIDURL,
      "backIDDownloadURL": backIDURL,
      "registrationCertificateDownloadURL": registrationCertificateURL,
      "profilePhotoDownloadURL": profilePhotoURL,
      "signatureDownloadURL": signaureImageURL,
    });
    return user;
  }

  Future<UserCredential?> uploadPharmacyAssistantUserInformation(
      WidgetRef ref, UserCredential? user, BuildContext context) async {
    if (user == null) {
      return null;
    }
    print("Uploading Pharmacy Assistant User Info");
    String resumePDFURL = await saveAsset(
        ref.read(pharmacistSignUpProvider.notifier).resumePDFData,
        user.user!.uid,
        "Resume",
        ref.read(pharmacistSignUpProvider.notifier).firstName);
    String frontIDURL = await saveAsset(
        ref.read(pharmacistSignUpProvider.notifier).frontIDData,
        user.user!.uid,
        "Front ID",
        ref.read(pharmacistSignUpProvider.notifier).firstName);
    String backIDURL = await saveAsset(
        ref.read(pharmacistSignUpProvider.notifier).backIDData,
        user.user!.uid,
        "Back ID",
        ref.read(pharmacistSignUpProvider.notifier).firstName);
    String registrationCertificateURL = await saveAsset(
        ref
            .read(pharmacistSignUpProvider.notifier)
            .registrationCertificateData,
        user.user!.uid,
        "Registration Certificate",
        ref.read(pharmacistSignUpProvider.notifier).firstName);
    String profilePhotoURL = await saveAsset(
        ref.read(pharmacistSignUpProvider.notifier).profilePhotoData,
        user.user!.uid,
        "Profile Photo",
        ref.read(pharmacistSignUpProvider.notifier).firstName);

    String signaureImageURL = await saveImageAsset(
        ref.read(pharmacistSignUpProvider.notifier).signatureData,
        user.user!.uid,
        "Signature",
        ref.read(pharmacistSignUpProvider.notifier).firstName);

    users
        .doc(user.user?.uid.toString())
        .collection("SignUp")
        .doc("Information")
        .set({
      "availability": {},
      "userType": "Pharmacy Assistant",
      "email": ref.read(pharmacistSignUpProvider.notifier).email,
      "firstName": ref.read(pharmacistSignUpProvider.notifier).firstName,
      "lastName": ref.read(pharmacistSignUpProvider.notifier).lastName,
      "address": ref.read(pharmacistSignUpProvider.notifier).address,
      "phoneNumber":
          ref.read(pharmacistSignUpProvider.notifier).phoneNumber,
      "firstYearLicensed":
          ref.read(pharmacistSignUpProvider.notifier).firstYearLicensed,
      "registrationNumber":
          ref.read(pharmacistSignUpProvider.notifier).registrationNumber,
      "registrationProvince":
          ref.read(pharmacistSignUpProvider.notifier).registrationProvince,
      "gradutationYear":
          ref.read(pharmacistSignUpProvider.notifier).graduationYear,
      "institutionName":
          ref.read(pharmacistSignUpProvider.notifier).institutionName,
      "workingExperience":
          ref.read(pharmacistSignUpProvider.notifier).workingExperience,
      "willingToMove":
          ref.read(pharmacistSignUpProvider.notifier).willingToMove,
      "entitledToWork":
          ref.read(pharmacistSignUpProvider.notifier).entitledToWork,
      "activeMember":
          ref.read(pharmacistSignUpProvider.notifier).activeMember,
      "liabilityInsurance":
          ref.read(pharmacistSignUpProvider.notifier).liabilityInsurance,
      "licenseRestricted":
          ref.read(pharmacistSignUpProvider.notifier).licenseRestricted,
      "malPractice":
          ref.read(pharmacistSignUpProvider.notifier).malpractice,
      "felon": ref.read(pharmacistSignUpProvider.notifier).felon,
      "knownSoftware":
          ref
          .read(pharmacistSignUpProvider.notifier)
          .softwareList
          .toString(),
      "knownSkills":
          ref.read(pharmacistSignUpProvider.notifier).skillList.toString(),
      "knownLanguages":
          ref
          .read(pharmacistSignUpProvider.notifier)
          .languageList
          .toString(),
      "resumeDownloadURL": resumePDFURL,
      "frontIDDownloadURL": frontIDURL,
      "backIDDownloadURL": backIDURL,
      "registrationCertificateDownloadURL": registrationCertificateURL,
      "profilePhotoDownloadURL": profilePhotoURL,
      "signatureDownloadURL": signaureImageURL,
    });
    return user;
  }

  Future<UserCredential?> uploadPharmacyTechnicianUserInformation(
      WidgetRef ref, UserCredential? user, BuildContext context) async {
    if (user == null) {
      return null;
    }
    print("Uploading Pharmacy Assistant User Info");
    String resumePDFURL = await saveAsset(
        ref.read(pharmacistSignUpProvider.notifier).resumePDFData,
        user.user!.uid,
        "Resume",
        ref.read(pharmacistSignUpProvider.notifier).firstName);
    String frontIDURL = await saveAsset(
        ref.read(pharmacistSignUpProvider.notifier).frontIDData,
        user.user!.uid,
        "Front ID",
        ref.read(pharmacistSignUpProvider.notifier).firstName);
    String backIDURL = await saveAsset(
        ref.read(pharmacistSignUpProvider.notifier).backIDData,
        user.user!.uid,
        "Back ID",
        ref.read(pharmacistSignUpProvider.notifier).firstName);
    String registrationCertificateURL = await saveAsset(
        ref
            .read(pharmacistSignUpProvider.notifier)
            .registrationCertificateData,
        user.user!.uid,
        "Registration Certificate",
        ref.read(pharmacistSignUpProvider.notifier).firstName);
    String profilePhotoURL = await saveAsset(
        ref.read(pharmacistSignUpProvider.notifier).profilePhotoData,
        user.user!.uid,
        "Profile Photo",
        ref.read(pharmacistSignUpProvider.notifier).firstName);

    String signaureImageURL = await saveImageAsset(
        ref.read(pharmacistSignUpProvider.notifier).signatureData,
        user.user!.uid,
        "Signature",
        ref.read(pharmacistSignUpProvider.notifier).firstName);

    users
        .doc(user.user?.uid.toString())
        .collection("SignUp")
        .doc("Information")
        .set({
      "availability": {},
      "userType": "Pharmacy Technician",
      "email": ref.read(pharmacistSignUpProvider.notifier).email,
      "firstName": ref.read(pharmacistSignUpProvider.notifier).firstName,
      "lastName": ref.read(pharmacistSignUpProvider.notifier).lastName,
      "address": ref.read(pharmacistSignUpProvider.notifier).address,
      "phoneNumber":
          ref.read(pharmacistSignUpProvider.notifier).phoneNumber,
      "firstYearLicensed":
          ref.read(pharmacistSignUpProvider.notifier).firstYearLicensed,
      "registrationNumber":
          ref.read(pharmacistSignUpProvider.notifier).registrationNumber,
      "registrationProvince":
          ref.read(pharmacistSignUpProvider.notifier).registrationProvince,
      "gradutationYear":
          ref.read(pharmacistSignUpProvider.notifier).graduationYear,
      "institutionName":
          ref.read(pharmacistSignUpProvider.notifier).institutionName,
      "workingExperience":
          ref.read(pharmacistSignUpProvider.notifier).workingExperience,
      "willingToMove":
          ref.read(pharmacistSignUpProvider.notifier).willingToMove,
      "entitledToWork":
          ref.read(pharmacistSignUpProvider.notifier).entitledToWork,
      "activeMember":
          ref.read(pharmacistSignUpProvider.notifier).activeMember,
      "liabilityInsurance":
          ref.read(pharmacistSignUpProvider.notifier).liabilityInsurance,
      "licenseRestricted":
          ref.read(pharmacistSignUpProvider.notifier).licenseRestricted,
      "malPractice":
          ref.read(pharmacistSignUpProvider.notifier).malpractice,
      "felon": ref.read(pharmacistSignUpProvider.notifier).felon,
      "knownSoftware":
          ref
          .read(pharmacistSignUpProvider.notifier)
          .softwareList
          .toString(),
      "knownSkills":
          ref.read(pharmacistSignUpProvider.notifier).skillList.toString(),
      "knownLanguages":
          ref
          .read(pharmacistSignUpProvider.notifier)
          .languageList
          .toString(),
      "resumeDownloadURL": resumePDFURL,
      "frontIDDownloadURL": frontIDURL,
      "backIDDownloadURL": backIDURL,
      "registrationCertificateDownloadURL": registrationCertificateURL,
      "profilePhotoDownloadURL": profilePhotoURL,
      "signatureDownloadURL": signaureImageURL,
    });
    return user;
  }

  Future<UserCredential?> uploadPharmacyUserInformation(
      WidgetRef ref, UserCredential? user, BuildContext context) async {
    if (user == null) {
      return null;
    }
    String signaureImageURL = await saveImageAsset(
        ref.read(pharmacySignUpProvider.notifier).signatureData,
        user.user!.uid,
        "Signature",
        ref.read(pharmacySignUpProvider.notifier).firstName);

    users
        .doc(user.user?.uid.toString())
        .collection("SignUp")
        .doc("Information")
        .set({
      "userType": "Pharmacy",
      "email": ref.read(pharmacySignUpProvider.notifier).email,
      "firstName": ref.read(pharmacySignUpProvider.notifier).firstName,
      "lastName": ref.read(pharmacySignUpProvider.notifier).lastName,
      "phoneNumber": ref.read(pharmacySignUpProvider.notifier).phoneNumber,
      "position": ref.read(pharmacySignUpProvider.notifier).position,
      "pharmacyName":
          ref.read(pharmacySignUpProvider.notifier).pharmacyName,
      "address": {
        "streetAddress":
            ref.read(pharmacySignUpProvider.notifier).streetAddress,
        "storeNumber":
            ref.read(pharmacySignUpProvider.notifier).storeNumber,
        "city": ref.read(pharmacySignUpProvider.notifier).city,
        "postalCode": ref.read(pharmacySignUpProvider.notifier).postalCode,
        "country": ref.read(pharmacySignUpProvider.notifier).country,
      },
      "pharmacyPhoneNumber":
          ref.read(pharmacySignUpProvider.notifier).phoneNumberPharmacy,
      "pharmacyFaxNumber":
          ref.read(pharmacySignUpProvider.notifier).faxNumber,
      "accreditationProvice":
          ref.read(pharmacySignUpProvider.notifier).accreditationProvince,
      "managerFirstName":
          ref.read(pharmacySignUpProvider.notifier).managerFirstName,
      "managerLastName":
          ref.read(pharmacySignUpProvider.notifier).managerLastName,
      "managerPhoneNumber":
          ref.read(pharmacySignUpProvider.notifier).managerPhoneNumber,
      "managerLicenseNumber":
          ref.read(pharmacySignUpProvider.notifier).licenseNumber,
      "signatureDownloadURL": signaureImageURL,
      "softwareList":
          ref.read(pharmacySignUpProvider.notifier).softwareList.toString(),
    });
    return user;
  }

  Future<String?>? updatePharmacyUserInformation(
      String userUID, Map<String, dynamic> uploadData) async {
    try {
      users
          .doc(userUID)
          .collection("SignUp")
          .doc("Information")
          .update(uploadData);
    } catch (error) {
      return "Profile Upload Failed";
    }
  }

  Future<String?>? updatePharmacistUserInformation(
      String userUID, Map<String, dynamic> uploadData) async {
    try {
      users
          .doc(userUID)
          .collection("SignUp")
          .doc("Information")
          .update(uploadData);
    } catch (error) {
      return "Profile Upload Failed";
    }
  }

  Future<UserCredential?> uploadTestInformaiton(
      UserCredential? user, BuildContext context) async {
    if (user == null) {
      return null;
    }
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    String resumePDFURL = "http://www.africau.edu/images/default/sample.pdf";
    String frontIDURL = "http://www.africau.edu/images/default/sample.pdf";
    String backIDURL = "http://www.africau.edu/images/default/sample.pdf";
    String registrationCertificateURL =
        "http://www.africau.edu/images/default/sample.pdf";
    String profilePhotoURL = "http://www.africau.edu/images/default/sample.pdf";

    String signaureImageURL =
        "http://www.africau.edu/images/default/sample.pdf";

    users
        .doc(user.user?.uid.toString())
        .collection("SignUp")
        .doc("Information")
        .set({
      "userType": "Pharmacist",
      "email": getRandomString(5),
      "firstName": getRandomString(4),
      "lastName": getRandomString(4),
      "address": getRandomString(9),
      "phoneNumber": getRandomString(8),
      "firstYearLicensed": getRandomString(4),
      "registrationNumber": getRandomString(6),
      "registrationProvince": getRandomString(9),
      "gradutationYear": getRandomString(4),
      "institutionName": getRandomString(8),
      "workingExperience": getRandomString(2),
      "willingToMove": getRandomString(2),
      "entitledToWork": getRandomString(2),
      "activeMember": getRandomString(2),
      "liabilityInsurance": getRandomString(2),
      "licenseRestricted": getRandomString(2),
      "malPractice": getRandomString(2),
      "felon": getRandomString(2),
      "knownSoftware": getRandomString(8),
      "knownSkills": getRandomString(8),
      "knownLanguages": getRandomString(8),
      "resumeDownloadURL": resumePDFURL,
      "frontIDDownloadURL": frontIDURL,
      "backIDDownloadURL": backIDURL,
      "registrationCertificateDownloadURL": registrationCertificateURL,
      "profilePhotoDownloadURL": profilePhotoURL,
      "signatureDownloadURL": signaureImageURL,
    });
    return user;
  }

  Future<UserCredential?>? uploadTestJobToPharmacy(
      String? userUID, BuildContext context) async {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    users.doc(userUID).collection("Main").add({
      "userType": "Pharmacy",
      "startDate": DateTime(2019, 01, 01),
      "endDate": DateTime(2021, 01, 01),
      "pharmacyUID": userUID,
      "pharmacyNumber": getRandomString(6),
      "pharmacyName": getRandomString(6),
      "pharmacyAddress": getRandomString(6),
      "jobStatus": "active",
      "skillsNeeded": getRandomString(6),
      "softwareNeeded": getRandomString(6),
      "techOnSite": true,
      "assistantOnSite": false,
      "hourlyRate": "\$45.03",
      "limaStatus": true,
      "comments": getRandomString(10),
      "email": getRandomString(6),
    });
    return null;
  }

  Future<UserCredential?>? uploadAvailalibitlityData(
      String userUID, Map dataUpload, bool? permanentJobBool) async {
    if (dataUpload.isEmpty) {
      users.doc(userUID).collection("SignUp").doc("Information").set({
        "permanentJob": permanentJobBool,
      }, SetOptions(merge: true));
    } else {
      users.doc(userUID).collection("SignUp").doc("Information").set({
        "availability": dataUpload,
        "permanentJob": permanentJobBool,
      }, SetOptions(merge: true));
    }

    return null;
  }

  Future<UserCredential?>? uploadJobToPharmacy(
      WidgetRef ref, String? userUID, BuildContext context) async {
    users.doc(userUID).collection("Main").add({
      "userType": "Pharmacy",
      "position": ref.read(pharmacyMainProvider).position,
      "startDate": ref.read(pharmacyMainProvider).startDate,
      "endDate": ref.read(pharmacyMainProvider).endDate,
      "fullTime": ref.read(pharmacyMainProvider).fullTime,
      "pharmacyUID": userUID,
      "pharmacyNumber":
          ref.read(pharmacyMainProvider).userData?["pharmacyPhoneNumber"],
      "pharmacyName":
          ref.read(pharmacyMainProvider).userData?["pharmacyName"],
      "pharmacyAddress":
          ref.read(pharmacyMainProvider).userData?["address"],
      "jobStatus": "active",
      "skillsNeeded": ref.read(pharmacyMainProvider).skillList.toString(),
      "softwareNeeded":
          ref.read(pharmacyMainProvider).softwareList.toString(),
      "techOnSite": ref.read(pharmacyMainProvider).techOnSite,
      "assistantOnSite": ref.read(pharmacyMainProvider).assistantOnSite,
      "hourlyRate": ref.read(pharmacyMainProvider).hourlyRate,
      "limaStatus": ref.read(pharmacyMainProvider).limaStatus,
      "comments": ref.read(pharmacyMainProvider).jobComments,
      "email": ref.read(pharmacyMainProvider).userData?["email"],
    });
    return null;
  }

  Future<String?>? deleteJob(String userUID, String? jobUID) async {
    try {
      await users.doc(userUID).collection("Main").doc(jobUID).delete();
    } catch (e) {
      return "Job Delete Failed";
    }
  }

  Future<String?>? updateJobInformation(
      String userUID, Map<String, dynamic> uploadData, String? jobUID) async {
    try {
      await users
          .doc(userUID)
          .collection("Main")
          .doc(jobUID)
          .update(uploadData);
    } catch (error) {
      return "Profile Upload Failed";
    }
  }

  //Method to handle user sign in using email and password
  Future<List?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final UserCredential? result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (result!.user!.emailVerified) {
        _status = Status.Authenticated;
        notifyListeners();
        print("User verified: " + result.user!.emailVerified.toString());
        DocumentSnapshot user = await users
            .doc(result.user?.uid.toString())
            .collection("SignUp")
            .doc("Information")
            .get();

        String userType = user.get("userType").toString();
        print(userType);
        if (userType.trim() == "Pharmacy") {
          print("Logged in as a Pharmacy");
          //Send to pharmacy main page
          return [result, "Pharmacy"];
        } else if (userType.trim() == "Pharmacist" ||
            userType.trim() == "Pharmacy Assistant" ||
            userType.trim() == "Pharmacy Technician") {
          print("Logged in as a $userType");
          //Send to pharmacist main page
          return [
            result,
            "Pharmacist",
          ];
        }
      } else {
        print("INSIDE ELSE STATEMENT");
        print("User verified: " + result.user!.emailVerified.toString());
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseAuth.instance.currentUser?.sendEmailVerification();
        }
        signOut();
        _status = Status.Unauthenticated;
        notifyListeners();
        return [null, null, "user-not-verified"];
      }
    } on FirebaseAuthException catch (error) {
      // if (error.code == "user-disabled") {
      //   return [null, null, error.code];
      // }
      // if (error.code == "user-not-found") {
      //   return [null, null, error.code];
      // }
      print("Error on the sign in = " + error.toString());
      _status = Status.Unauthenticated;
      notifyListeners();
      return [null, null, error.code];
    }
  }

  Future<String?> getCurrentUserData(String? userUID) async {
    _status = Status.Authenticated;
    notifyListeners();
    print("UserUID: $userUID");
    DocumentSnapshot user =
        await users.doc(userUID).collection("SignUp").doc("Information").get();
    print("UserData: $user");
    String userType = user.get("userType").toString();
    print(userType);
    if (userType.trim() == "Pharmacy") {
      print("Logged in as a Pharmacy");
      //Send to pharmacy main page
      return "Pharmacy";
    } else if (userType.trim() == "Pharmacist") {
      print("Logged in as a Pharmacist");
      //Send to pharmacist main page
      return "Pharmacist";
    } else if (userType.trim() == "Pharmacy Assistant") {
      print("Logged in as a Pharmacy Assistant");
      //Send to pharmacy main page
      return "Pharmacy Assistant";
    } else if (userType.trim() == "Pharmacy Technician") {
      print("Logged in as a Pharmacy Technician");
      //Send to pharmacy main page
      return "Pharmacy Technician";
    }
  }

  // Future<UserModel?> signInWithGoogle() async {
  //   try {
  //     _status = Status.Authenticating;
  //     notifyListeners();
  //     // Trigger the authentication flow
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser!.authentication;
  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     // Once signed in, return the UserCredential
  //     final UserCredential result = await FirebaseAuth.instance
  //         .signInWithCredential(credential)
  //         .whenComplete(() {
  //       _status = Status.Authenticated;
  //     });
  //     return _userFromFirebase(result.user);
  //   } catch (err) {
  //     print("Error on the sign in = " + err.toString());
  //     _status = Status.Unauthenticated;
  //     notifyListeners();
  //     return null;
  //   }
  // }

  //Method to handle password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  //Method to handle user signing out
  Future<void> signOut() async {
    await _auth.signOut().then((_) {
      _googleSignIn.signOut();
    });
    //_status = Status.Unauthenticated;
    //notifyListeners();
  }
}
