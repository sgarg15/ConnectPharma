import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign Up/1pharmacistSignUp.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';
import 'package:connectpharma/src/screens/Pharmacy/Sign Up/1pharmacy_signup.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated, Registering }

/*
The UI will depends on the Status to decide which screen/action to be done.
- Uninitialized - Checking user is logged or not, the Splash Screen will be shown
- Authenticated - User is authenticated successfully, Home Page will be shown
- Authenticating - Sign In button just been pressed, progress bar will be shown
- Unauthenticated - User is not authenticated, login page will be shown
- Registering - User just pressed registering, progress bar will be shown
*/

class AuthProvider extends ChangeNotifier {
  //Firebase Auth object
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  CollectionReference testCollection = FirebaseFirestore.instance.collection('TestCollection');

  //Default status
  Status _status = Status.Uninitialized;

  Status get status => _status;

  AuthProvider() {
    //initialise object
    _auth = FirebaseAuth.instance;
    User _user;
  }

  ///Function used to send given file to the given uid in firebase.
  ///
  ///It returns a [Future<String>] which contains the download url of the file.
  Future<String> saveAsset(File? asset, String uid, String fileName, String userName) async {
    try {
      if (asset != null) {
        Reference reference = FirebaseStorage.instance.ref().child(uid).child(fileName);
        UploadTask uploadTask =
            reference.putFile(asset, SettableMetadata(contentType: 'application/pdf'));

        String url = await (await uploadTask).ref.getDownloadURL();
        print("Uploaded $fileName");
        return url;
      } else {
        return "";
      }
    } on FirebaseException catch (e) {
      print(e);
      return "";
    }
  }

  ///Function used to send an Image to the given uid in firebase.
  ///
  ///It returns a [Future<String>] which contains the download url of the image.
  ///
  ///Two functions are needed, one for uploading a file and another for uploading an image.
  /// - [saveAsset] is used to upload a file.
  /// - [saveImageAsset] is used to upload an image.
  Future<String> saveImageAsset(
      Uint8List? asset, String uidName, String fileName, String userName) async {
    try {
      if (asset != null) {
        Reference reference = FirebaseStorage.instance.ref().child(uidName).child(fileName);
        UploadTask uploadTask =
            reference.putData(asset, SettableMetadata(contentType: 'image/jpeg'));

        String url = await (await uploadTask).ref.getDownloadURL();
        return url;
      } else {
        return "";
      }
    } on FirebaseException catch (e) {
      print("Save Image Asset Failure: $e");
      return "";
    }
  }

  ///Method for new user registration using email and password
  ///
  ///Returns a [Future] which contains the [UserCredential] object.
  Future<UserCredential?> registerWithEmailAndPassword(String email, String password) async {
    try {
      _status = Status.Authenticating;
      final UserCredential result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() {
        _status = Status.Authenticated;
      });
      return result;
    } catch (e) {
      print("registerWithEmailAndPassword failure: $e");
      _status = Status.Unauthenticated;
      return null;
    }
  }

  ///Function to upload the pharmacist details to firebase.
  Future<UserCredential?> uploadPharmacistUserInformation(WidgetRef ref, UserCredential? user, BuildContext context) async {
    if (user == null) {
      return null;
    }
    print("Uploading Pharmacist User Info");

    //Upload the users files to firebase and get the download url
    String resumePDFURL = await saveAsset(ref.read(userSignUpProvider.notifier).resumePDFData,
        user.user!.uid, "Resume", ref.read(userSignUpProvider.notifier).firstName);
    String frontIDURL = await saveAsset(ref.read(userSignUpProvider.notifier).frontIDData,
        user.user!.uid, "Front ID", ref.read(userSignUpProvider.notifier).firstName);
    String backIDURL = await saveAsset(ref.read(userSignUpProvider.notifier).backIDData,
        user.user!.uid, "Back ID", ref.read(userSignUpProvider.notifier).firstName);
    String registrationCertificateURL = await saveAsset(
        ref.read(userSignUpProvider.notifier).registrationCertificateData,
        user.user!.uid,
        "Registration Certificate",
        ref.read(userSignUpProvider.notifier).firstName);
    String profilePhotoURL = await saveAsset(ref.read(userSignUpProvider.notifier).profilePhotoData,
        user.user!.uid, "Profile Photo", ref.read(userSignUpProvider.notifier).firstName);
    String signaureImageURL = await saveImageAsset(
        ref.read(userSignUpProvider.notifier).signatureData,
        user.user!.uid,
        "Signature",
        ref.read(userSignUpProvider.notifier).firstName);

    // Converts the custom [Software, Skills, Language] objects to a list Firebase can read
    List<String?>? softwareList =
        ref.read(userSignUpProvider.notifier).softwareList?.map((e) => e?.name).toList();
    List<String?>? skillsList =
        ref.read(userSignUpProvider.notifier).skillList?.map((e) => e?.name).toList();
    List<String?>? languageList =
        ref.read(userSignUpProvider.notifier).languageList?.map((e) => e?.name).toList();

    var pharmacistSignUp = ref.read(userSignUpProvider.notifier);

    print("Sending Info to Firestore");
    users.doc(user.user?.uid.toString()).collection("SignUp").doc("Information").set({
      "availability": {},
      "userType": "Pharmacist",
      "email": pharmacistSignUp.email,
      "firstName": pharmacistSignUp.firstName,
      "lastName": pharmacistSignUp.lastName,
      "address": pharmacistSignUp.address,
      "phoneNumber": pharmacistSignUp.phoneNumber,
      "firstYearLicensed": pharmacistSignUp.firstYearLicensed,
      "registrationNumber": pharmacistSignUp.registrationNumber,
      "registrationProvince": pharmacistSignUp.registrationProvince,
      "gradutationYear": pharmacistSignUp.graduationYear,
      "institutionName": pharmacistSignUp.institutionName,
      "workingExperience": pharmacistSignUp.workingExperience,
      "willingToMove": pharmacistSignUp.willingToMove,
      "entitledToWork": pharmacistSignUp.entitledToWork,
      "activeMember": pharmacistSignUp.activeMember,
      "liabilityInsurance": pharmacistSignUp.liabilityInsurance,
      "licenseRestricted": pharmacistSignUp.licenseRestricted,
      "malPractice": pharmacistSignUp.malpractice,
      "felon": pharmacistSignUp.felon,
      "knownSoftware": softwareList,
      "knownSkills": skillsList,
      "knownLanguages": languageList,
      "resumeDownloadURL": resumePDFURL,
      "frontIDDownloadURL": frontIDURL,
      "backIDDownloadURL": backIDURL,
      "registrationCertificateDownloadURL": registrationCertificateURL,
      "profilePhotoDownloadURL": profilePhotoURL,
      "signatureDownloadURL": signaureImageURL,
      "verified": false,
    });
    return user;
  }

  ///Function to upload the Pharmacy Assistant details to firebase.
  Future<UserCredential?> uploadPharmacyAssistantUserInformation(
      WidgetRef ref, UserCredential? user, BuildContext context) async {
    if (user == null) {
      return null;
    }
    print("Uploading Pharmacy Assistant User Info");

    //Upload the users files to firebase and get the download url
    String resumePDFURL = await saveAsset(ref.read(userSignUpProvider.notifier).resumePDFData,
        user.user!.uid, "Resume", ref.read(userSignUpProvider.notifier).firstName);
    String frontIDURL = await saveAsset(ref.read(userSignUpProvider.notifier).frontIDData,
        user.user!.uid, "Front ID", ref.read(userSignUpProvider.notifier).firstName);
    String backIDURL = await saveAsset(ref.read(userSignUpProvider.notifier).backIDData,
        user.user!.uid, "Back ID", ref.read(userSignUpProvider.notifier).firstName);
    String registrationCertificateURL = await saveAsset(
        ref.read(userSignUpProvider.notifier).registrationCertificateData,
        user.user!.uid,
        "Registration Certificate",
        ref.read(userSignUpProvider.notifier).firstName);
    String profilePhotoURL = await saveAsset(ref.read(userSignUpProvider.notifier).profilePhotoData,
        user.user!.uid, "Profile Photo", ref.read(userSignUpProvider.notifier).firstName);
    String signaureImageURL = await saveImageAsset(
        ref.read(userSignUpProvider.notifier).signatureData,
        user.user!.uid,
        "Signature",
        ref.read(userSignUpProvider.notifier).firstName);

    //Converts the custom [Software, Skills, Language] objects to a list Firebase can read
    List<String?>? softwareList =
        ref.read(userSignUpProvider.notifier).softwareList?.map((e) => e?.name).toList();
    List<String?>? skillsList =
        ref.read(userSignUpProvider.notifier).skillList?.map((e) => e?.name).toList();
    List<String?>? languageList =
        ref.read(userSignUpProvider.notifier).languageList?.map((e) => e?.name).toList();

    var pharmacyAssistantSignUp = ref.read(userSignUpProvider.notifier);

    print("Sending Info to Firestore");
    users.doc(user.user?.uid.toString()).collection("SignUp").doc("Information").set({
      "availability": {},
      "userType": "Pharmacy Assistant",
      "email": ref.read(userSignUpProvider.notifier).email,
      "firstName": ref.read(userSignUpProvider.notifier).firstName,
      "lastName": ref.read(userSignUpProvider.notifier).lastName,
      "address": ref.read(userSignUpProvider.notifier).address,
      "phoneNumber": ref.read(userSignUpProvider.notifier).phoneNumber,
      "firstYearLicensed": ref.read(userSignUpProvider.notifier).firstYearLicensed,
      "registrationNumber": ref.read(userSignUpProvider.notifier).registrationNumber,
      "registrationProvince": ref.read(userSignUpProvider.notifier).registrationProvince,
      "gradutationYear": ref.read(userSignUpProvider.notifier).graduationYear,
      "institutionName": ref.read(userSignUpProvider.notifier).institutionName,
      "workingExperience": ref.read(userSignUpProvider.notifier).workingExperience,
      "willingToMove": ref.read(userSignUpProvider.notifier).willingToMove,
      "entitledToWork": ref.read(userSignUpProvider.notifier).entitledToWork,
      "activeMember": ref.read(userSignUpProvider.notifier).activeMember,
      "liabilityInsurance": ref.read(userSignUpProvider.notifier).liabilityInsurance,
      "licenseRestricted": ref.read(userSignUpProvider.notifier).licenseRestricted,
      "malPractice": ref.read(userSignUpProvider.notifier).malpractice,
      "felon": ref.read(userSignUpProvider.notifier).felon,
      "knownSoftware": softwareList,
      "knownSkills": skillsList,
      "knownLanguages": languageList,
      "resumeDownloadURL": resumePDFURL,
      "frontIDDownloadURL": frontIDURL,
      "backIDDownloadURL": backIDURL,
      "registrationCertificateDownloadURL": registrationCertificateURL,
      "profilePhotoDownloadURL": profilePhotoURL,
      "signatureDownloadURL": signaureImageURL,
      "verified": false,
    });
    return user;
  }

  ///Function to upload the Pharmacy Technician details to firebase.
  Future<UserCredential?> uploadPharmacyTechnicianUserInformation(
      WidgetRef ref, UserCredential? user, BuildContext context) async {
    if (user == null) {
      return null;
    }
    print("Uploading Pharmacy Technician User Info");
    String resumePDFURL = await saveAsset(ref.read(userSignUpProvider.notifier).resumePDFData,
        user.user!.uid, "Resume", ref.read(userSignUpProvider.notifier).firstName);
    String frontIDURL = await saveAsset(ref.read(userSignUpProvider.notifier).frontIDData,
        user.user!.uid, "Front ID", ref.read(userSignUpProvider.notifier).firstName);
    String backIDURL = await saveAsset(ref.read(userSignUpProvider.notifier).backIDData,
        user.user!.uid, "Back ID", ref.read(userSignUpProvider.notifier).firstName);
    String registrationCertificateURL = await saveAsset(
        ref.read(userSignUpProvider.notifier).registrationCertificateData,
        user.user!.uid,
        "Registration Certificate",
        ref.read(userSignUpProvider.notifier).firstName);
    String profilePhotoURL = await saveAsset(ref.read(userSignUpProvider.notifier).profilePhotoData,
        user.user!.uid, "Profile Photo", ref.read(userSignUpProvider.notifier).firstName);

    String signaureImageURL = await saveImageAsset(
        ref.read(userSignUpProvider.notifier).signatureData,
        user.user!.uid,
        "Signature",
        ref.read(userSignUpProvider.notifier).firstName);

    List<String?>? softwareList =
        ref.read(userSignUpProvider.notifier).softwareList?.map((e) => e?.name).toList();
    List<String?>? skillsList =
        ref.read(userSignUpProvider.notifier).skillList?.map((e) => e?.name).toList();
    List<String?>? languageList =
        ref.read(userSignUpProvider.notifier).languageList?.map((e) => e?.name).toList();

    users.doc(user.user?.uid.toString()).collection("SignUp").doc("Information").set({
      "availability": {},
      "userType": "Pharmacy Technician",
      "email": ref.read(userSignUpProvider.notifier).email,
      "firstName": ref.read(userSignUpProvider.notifier).firstName,
      "lastName": ref.read(userSignUpProvider.notifier).lastName,
      "address": ref.read(userSignUpProvider.notifier).address,
      "phoneNumber": ref.read(userSignUpProvider.notifier).phoneNumber,
      "firstYearLicensed": ref.read(userSignUpProvider.notifier).firstYearLicensed,
      "registrationNumber": ref.read(userSignUpProvider.notifier).registrationNumber,
      "registrationProvince": ref.read(userSignUpProvider.notifier).registrationProvince,
      "gradutationYear": ref.read(userSignUpProvider.notifier).graduationYear,
      "institutionName": ref.read(userSignUpProvider.notifier).institutionName,
      "workingExperience": ref.read(userSignUpProvider.notifier).workingExperience,
      "willingToMove": ref.read(userSignUpProvider.notifier).willingToMove,
      "entitledToWork": ref.read(userSignUpProvider.notifier).entitledToWork,
      "activeMember": ref.read(userSignUpProvider.notifier).activeMember,
      "liabilityInsurance": ref.read(userSignUpProvider.notifier).liabilityInsurance,
      "licenseRestricted": ref.read(userSignUpProvider.notifier).licenseRestricted,
      "malPractice": ref.read(userSignUpProvider.notifier).malpractice,
      "felon": ref.read(userSignUpProvider.notifier).felon,
      "knownSoftware": softwareList,
      "knownSkills": skillsList,
      "knownLanguages": languageList,
      "resumeDownloadURL": resumePDFURL,
      "frontIDDownloadURL": frontIDURL,
      "backIDDownloadURL": backIDURL,
      "registrationCertificateDownloadURL": registrationCertificateURL,
      "profilePhotoDownloadURL": profilePhotoURL,
      "signatureDownloadURL": signaureImageURL,
      "verified": false,
    });
    return user;
  }

  ///Function to upload the Pharmacy details to firebase.
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

    List<String?>? softwareList =
        ref.read(pharmacySignUpProvider.notifier).softwareList?.map((e) => e?.name).toList();

    users.doc(user.user?.uid.toString()).collection("SignUp").doc("Information").set({
      "userType": "Pharmacy",
      "email": ref.read(pharmacySignUpProvider.notifier).email,
      "firstName": ref.read(pharmacySignUpProvider.notifier).firstName,
      "lastName": ref.read(pharmacySignUpProvider.notifier).lastName,
      "phoneNumber": ref.read(pharmacySignUpProvider.notifier).phoneNumber,
      "position": ref.read(pharmacySignUpProvider.notifier).position,
      "pharmacyName": ref.read(pharmacySignUpProvider.notifier).pharmacyName,
      "address": {
        "streetAddress": ref.read(pharmacySignUpProvider.notifier).streetAddress,
        "storeNumber": ref.read(pharmacySignUpProvider.notifier).storeNumber,
        "city": ref.read(pharmacySignUpProvider.notifier).city,
        "postalCode": ref.read(pharmacySignUpProvider.notifier).postalCode,
        "country": ref.read(pharmacySignUpProvider.notifier).country,
      },
      "pharmacyPhoneNumber": ref.read(pharmacySignUpProvider.notifier).phoneNumberPharmacy,
      "pharmacyFaxNumber": ref.read(pharmacySignUpProvider.notifier).faxNumber,
      "accreditationProvice": ref.read(pharmacySignUpProvider.notifier).accreditationProvince,
      "managerFirstName": ref.read(pharmacySignUpProvider.notifier).managerFirstName,
      "managerLastName": ref.read(pharmacySignUpProvider.notifier).managerLastName,
      "managerPhoneNumber": ref.read(pharmacySignUpProvider.notifier).managerPhoneNumber,
      "managerLicenseNumber": ref.read(pharmacySignUpProvider.notifier).licenseNumber,
      "signatureDownloadURL": signaureImageURL,
      "softwareList": softwareList,
      "verified": false,
    });
    return user;
  }

  ///Function to update the Pharmacy user details to firebase.
  Future<String?>? updatePharmacyUserInformation(
      String userUID, Map<String, dynamic> uploadData) async {
    try {
      users.doc(userUID).collection("SignUp").doc("Information").update(uploadData);
    } catch (error) {
      return "Profile Upload Failed";
    }
    return null;
  }

  ///Function to update the Pharmacist user details to firebase.
  Future<String?>? updatePharmacistUserInformation(
      String userUID, Map<String, dynamic> uploadData) async {
    try {
      users.doc(userUID).collection("SignUp").doc("Information").update(uploadData);
    } catch (error) {
      return "Profile Upload Failed";
    }
    return null;
  }

  ///Function to upload the availability of a pharmacist to firebase.
  Future<UserCredential?>? uploadAvailalibitlityData(String userUID, Map dataUpload, bool? permanentJobBool, bool? nightShiftBool) async {
    if (dataUpload.isEmpty) {
      users.doc(userUID).collection("SignUp").doc("Information").set({
        "permanentJob": permanentJobBool,
        "nightShift": nightShiftBool,
      }, SetOptions(merge: true));
    } else {
      users.doc(userUID).collection("SignUp").doc("Information").set({
        "availability": dataUpload,
        "permanentJob": permanentJobBool,
        "nightShift": nightShiftBool,
      }, SetOptions(merge: true));
    }

    return null;
  }

  ///Function to clear the availability data of a pharmacist to firebase.
  Future<UserCredential?>? clearAvailabilityData(String userUID) async {
    users.doc(userUID).collection("SignUp").doc("Information").update({
      "availability": [],
    });

    return null;
  }

  ///Function to upload a job from a pharmacy to firebase.
  Future<UserCredential?>? uploadJobToPharmacy(WidgetRef ref, String? userUID, BuildContext context) async {
    List<String?>? softwareList =
        ref.read(pharmacyMainProvider.notifier).softwareList?.map((e) => e?.name).toList();
    List<String?>? skillsList =
        ref.read(pharmacyMainProvider.notifier).skillList?.map((e) => e?.name).toList();
    List<String?>? languageList =
        ref.read(pharmacyMainProvider.notifier).languageList?.map((e) => e?.name).toList();

    DateTime startTimeConverted = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        ref.read(pharmacyMainProvider.notifier).startTime!.hour,
        ref.read(pharmacyMainProvider.notifier).startTime!.minute);

    DateTime endTimeConverted = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        ref.read(pharmacyMainProvider.notifier).endTime!.hour,
        ref.read(pharmacyMainProvider.notifier).endTime!.minute);

    users.doc(userUID).collection("Main").add({
      "userType": "Pharmacy",
      "position": ref.read(pharmacyMainProvider).position,
      "startDate": ref.read(pharmacyMainProvider).startDate,
      "endDate": ref.read(pharmacyMainProvider).endDate,
      "startTime": startTimeConverted,
      "endTime": endTimeConverted,
      "fullTime": ref.read(pharmacyMainProvider).fullTime,
      "pharmacyUID": userUID,
      "pharmacyNumber": ref.read(pharmacyMainProvider).userData?["pharmacyPhoneNumber"],
      "pharmacyName": ref.read(pharmacyMainProvider).userData?["pharmacyName"],
      "pharmacyAddress": ref.read(pharmacyMainProvider).userData?["address"],
      "jobStatus": "active",
      "skillsNeeded": skillsList,
      "softwareNeeded": softwareList,
      "languageNeeded": languageList,
      "techOnSite": ref.read(pharmacyMainProvider).techOnSite,
      "assistantOnSite": ref.read(pharmacyMainProvider).assistantOnSite,
      "hourlyRate": ref.read(pharmacyMainProvider).hourlyRate,
      "limaStatus": ref.read(pharmacyMainProvider).limaStatus,
      "comments": ref.read(pharmacyMainProvider).jobComments,
      "email": ref.read(pharmacyMainProvider).userData?["email"],
    });
    return null;
  }

  ///Function to delete a job from a pharmacy in firebase.
  Future<String?>? deleteJob(String userUID, String? jobUID) async {
    try {
      await users.doc(userUID).collection("Main").doc(jobUID).delete();
    } catch (e) {
      return "Job Delete Failed";
    }
    return null;
  }

  ///Function to update a job from a pharmacy in firebase.
  Future<String?>? updateJobInformation(String userUID, Map<String, dynamic> uploadData, String? jobUID) async {
    try {
      await users.doc(userUID).collection("Main").doc(jobUID).update(uploadData);
    } catch (error) {
      dev.log(error.toString(), name: "Error in updateJobInformation");
      return "Job Update Failed";
    }
    return null;
  }

  ///Method to handle user sign in using email and password.
  Future<List?> signInWithEmailAndPassword(String email, String password) async {
    try {
      _status = Status.Authenticating;
      final UserCredential? result =
          await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (result!.user!.emailVerified) {
        _status = Status.Authenticated;
        print("Getting user information");
        DocumentSnapshot user = await users
            .doc(result.user?.uid.toString())
            .collection("SignUp")
            .doc("Information")
            .get();

        String userType = user.get("userType").toString();
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
        print("User is not verified");
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseAuth.instance.currentUser?.sendEmailVerification();
        }
        signOut();
        _status = Status.Unauthenticated;
        return [null, null, "user-not-verified"];
      }
    } on FirebaseAuthException catch (error) {
      print("Error on the sign in: $error");
      _status = Status.Unauthenticated;
      return [null, null, error.code];
    }
    return null;
  }

  ///Method to get the current users data.
  Future<String?> getCurrentUserType(String? userUID) async {
    _status = Status.Authenticated;
    print("Getting User Type");
    DocumentSnapshot user = await users.doc(userUID).collection("SignUp").doc("Information").get();
    String userType = user.get("userType").toString();
    print("Logged in as a : $userType");
    if (userType != "") {
      return userType.trim();
    }
    return null;
  }

  ///Method to handle password reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  ///Method to delete user account from firebase auth.
  Future<void> deleteUserAccount() async {
    await _auth.currentUser?.delete();
  }

  ///Method to handle user signing out.
  Future<void> signOut() async {
    print("Signing User Out");
    await _auth.signOut().then((_) {
      _googleSignIn.signOut();
    });
  }

  ///Function to test the upload of the user details to firebase.
  Future<UserCredential?> uploadTestInformaiton(UserCredential? user, BuildContext context) async {
    if (user == null) {
      return null;
    }
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    String resumePDFURL = "http://www.africau.edu/images/default/sample.pdf";
    String frontIDURL = "http://www.africau.edu/images/default/sample.pdf";
    String backIDURL = "http://www.africau.edu/images/default/sample.pdf";
    String registrationCertificateURL = "http://www.africau.edu/images/default/sample.pdf";
    String profilePhotoURL = "http://www.africau.edu/images/default/sample.pdf";

    String signaureImageURL = "http://www.africau.edu/images/default/sample.pdf";

    users.doc(user.user?.uid.toString()).collection("SignUp").doc("Information").set({
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

  ///Function to test the upload of jobs to firebase.
  Future<UserCredential?>? uploadTestJobToPharmacy(String? userUID, BuildContext context) async {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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

  }
