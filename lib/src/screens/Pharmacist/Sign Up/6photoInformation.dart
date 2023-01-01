import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign Up/1pharmacistSignUp.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../main.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class PhotoInformation extends ConsumerStatefulWidget {
  PhotoInformation({Key? key}) : super(key: key);

  @override
  _PhotoInformationState createState() => _PhotoInformationState();
}

class _PhotoInformationState extends ConsumerState<PhotoInformation> {
  bool frontOfIDPicked = false;
  bool backOfIDPicked = false;
  bool registrationCertificatePicked = false;
  bool profilePhotoPicked = false;
  FilePickerResult? _frontOfIDResult;
  FilePickerResult? _backOfIDResult;
  FilePickerResult? _registrationCertificateResult;
  FilePickerResult? _profilePhotoResult;
  File? frontFile;
  File? backFile;
  File? registrationFile;
  File? profilePhotoFile;

  bool agreeToTermsAndConditions = false;
  bool disableButton = false;

  String saveIcon = 'assets/icons/save.svg';
  String documentIcon = 'assets/icons/document2.svg';
  String profilePhotoIcon = 'assets/icons/account.svg';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !disableButton,
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_sharp), onPressed: () => Navigator.pop(context)),
            title: new Text(
              "Photo Information",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily,
              ),
            ),
            backgroundColor: Color(0xFFF0069C1),
            foregroundColor: Colors.white,
            elevation: 12,
            bottomOpacity: 1,
            shadowColor: Colors.white,
          ),
          body: Stack(
            children: <Widget>[
              Center(
                  child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return NotificationListener(
                            onNotification: (OverscrollIndicatorNotification overscroll) {
                              overscroll.disallowIndicator();
                              return true;
                            },
                            child: SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              child: Column(children: [
                                SizedBox(height: 30),
                                //Information Text
                                Padding(
                                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text:
                                          "Please provide a photo of the front and back of your government issued ID, your pharmacist registration certificate along with a profile photo to allow us to verify your identity.",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),

                                //Front of ID
                                selectFrontID(context),
                                SizedBox(height: 30),

                                //Back Of ID
                                selectBackID(context),
                                SizedBox(height: 30),

                                //Registration Certificate
                                Tooltip(
                                    message: 'Hi there!ddddddddddddddddddddddddddd',
                                    triggerMode: TooltipTriggerMode.longPress,
                                    preferBelow: false,
                                    child: selectRegistrationCertificate(context)),
                                SizedBox(height: 30),

                                //Profile Photo
                                selectProfilePhoto(context),
                                SizedBox(height: 30),

                                //Terms and Conditions
                                newsLetterCheckBox(),
                                SizedBox(height: 30),

                                //Submit Button
                                submitButton(),
                                SizedBox(height: 20),
                              ]),
                            ));
                      },
                    ),
                  )
                ],
              ))
            ],
          )),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 12), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Center submitButton() {
    return Center(
      child: Consumer(
        builder: (context, ref, child) {
          ref.watch(userSignUpProvider);
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 51,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey; // Disabled color
                    }
                    return Color(0xFFF0069C1); // Regular color
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))),
              onPressed: agreeToTermsAndConditions && !disableButton
                  ? () async {
                      print("Pressed");
                      setState(() {
                        disableButton = true;
                      });
                      if (ref.read(userSignUpProvider.notifier).userType!.isNotEmpty) {
                        ref
                            .read(authProvider.notifier)
                            .registerWithEmailAndPassword(
                                ref.read(userSignUpProvider.notifier).email.toString(),
                                ref.read(userSignUpProvider.notifier).password.toString())
                            .then((user) async {
                          print("UPLOADING DATA");
                          print("USER TYPE: ${ref.read(userSignUpProvider.notifier).userType}");

                          if (user == null) {
                            return errorMethod(context);
                          } else {
                            if (ref.read(userSignUpProvider.notifier).userType == "Pharmacist") {
                              await registerPharmacist(context, ref, user);
                            } else if (ref.read(userSignUpProvider.notifier).userType ==
                                "Pharmacy Assistant") {
                              await registerPharmacyAssistant(ref, user, context);
                            } else if (ref.read(userSignUpProvider.notifier).userType ==
                                "Pharmacy Technician") {
                              await registerPharmacyTechnician(ref, user, context);
                            }
                          }
                        });
                      } else {
                        //Show Dialog to reselect user type
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Please Select a User Type Again"),
                                  content: Text("Please select a user type below."),
                                  actions: <Widget>[
                                    DropdownButtonFormField<String>(
                                        hint: Text(
                                          "Select your Position...",
                                          style: GoogleFonts.inter(
                                              color: Color(0xFFBDBDBD), fontSize: 16),
                                        ),
                                        value: "",
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xFFF0F0F0),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                                        ),
                                        items: <String>[
                                          'Pharmacist',
                                          'Pharmacy Assistant',
                                          'Pharmacy Technician',
                                        ].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                              child: Text(value), value: value);
                                        }).toList(),
                                        onChanged: (String? value) {
                                          ref
                                              .read(userSignUpProvider.notifier)
                                              .changeUserType(value);
                                        },
                                        style: GoogleFonts.questrial(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                    new TextButton(
                                      child: new Text("Ok"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ));

                        print("ERROR");
                        final snackBar = SnackBar(
                          content:
                              Text("There was an error trying to register you. Please try again."),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        ref.read(authProvider.notifier).deleteUserAccount();
                        print("USER DELETED");

                        setState(() {
                          disableButton = false;
                        });
                        //value!.user!.delete();
                      }
                    }
                  : null,
              child: RichText(
                text: TextSpan(
                  text: disableButton ? "Loading..." : "Submit",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> registerPharmacyTechnician(
      WidgetRef ref, UserCredential user, BuildContext context) async {
    print("Registering Pharmacy Technician");
    ref
        .read(authProvider.notifier)
        .uploadPharmacyTechnicianUserInformation(ref, user, context)
        .then((value) async {
      final snackBar = SnackBar(
        content: Text("Pharmacy Technician Registered"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print("DATA UPLOADED");
      await value?.user?.sendEmailVerification().then((_) {
        ref.read(userSignUpProvider.notifier).clearAllValues();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ConnectPharma()));
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Verification Email"),
                  content: Text(
                      "An verification email was sent to you. Please follow the link and verify your email. Once finished you may log in using your email and password."),
                  actions: <Widget>[
                    new TextButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
      });
    }).catchError((e) {
      errorMethod(context);
    });
  }

  Future<void> registerPharmacyAssistant(
      WidgetRef ref, UserCredential user, BuildContext context) async {
    print("Registering Pharmacy Assistant");
    ref
        .read(authProvider.notifier)
        .uploadPharmacyAssistantUserInformation(ref, user, context)
        .then((value) async {
      final snackBar = SnackBar(
        content: Text("Pharmacy Assistant Registered"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print("DATA UPLOADED");
      await value?.user?.sendEmailVerification().then((_) {
        ref.read(userSignUpProvider.notifier).clearAllValues();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ConnectPharma()));
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Verification Email"),
                  content: Text(
                      "An verification email was sent to you. Please follow the link and verify your email. Once finished you may log in using your email and password."),
                  actions: <Widget>[
                    new TextButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
      });
    }).catchError((e) {
      errorMethod(context);
    });
  }

  Future<void> registerPharmacist(BuildContext context, WidgetRef ref, UserCredential user) async {
    showLoaderDialog(context);
    ref
        .read(authProvider.notifier)
        .uploadPharmacistUserInformation(ref, user, context)
        .then((value) async {
      Navigator.pop(context);
      final snackBar = SnackBar(
        content: Text("Pharmacist Registered"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print("DATA UPLOADED");
      await value?.user?.sendEmailVerification().then((_) {
        ref.read(userSignUpProvider.notifier).clearAllValues();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ConnectPharma()));
        ref.read(authProvider.notifier).signOut();
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Verification Email"),
                  content: Text(
                      "An verification email was sent to you. Please follow the link and verify your email. Once finished you may log in using your email and password."),
                  actions: <Widget>[
                    new TextButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
      });
    }).catchError((e) {
      errorMethod(context);
    });
  }

  Null errorMethod(BuildContext context) {
    print("ERROR");
    final snackBar = SnackBar(
      content: Text(
          "There was an error trying to register you. Please check your email and password and try again."),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {
      disableButton = false;
    });
    //value!.user!.delete();
    return null;
  }

  CheckboxListTile newsLetterCheckBox() {
    return CheckboxListTile(
      title: RichText(
        text: TextSpan(
          text: "I have read and understood the Terms of Service and Privacy Policy.",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 14.0,
            color: Color(0xFF666666),
          ),
        ),
      ),
      activeColor: Color(0xFFF0069C1),
      value: agreeToTermsAndConditions,
      onChanged: (newValue) {
        //todo: Save the check value information to save to account
        setState(() {
          agreeToTermsAndConditions = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  Container selectProfilePhoto(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10),
          if (ref.read(userSignUpProvider.notifier).profilePhotoData != null)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                DottedBorder(
                  radius: Radius.circular(10),
                  borderType: BorderType.RRect,
                  color: Color(0xFFDBDBDB),
                  strokeWidth: 1,
                  child: SizedBox(
                    height: 55,
                    width: 110,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Color(0xFFF0069C1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        profilePhotoFile = ref.read(userSignUpProvider.notifier).profilePhotoData;
                        print("FILE PATH: " + profilePhotoFile!.path.toString());
                        OpenFile.open(profilePhotoFile!.path);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "View Profile Photo",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                DottedBorder(
                  radius: Radius.circular(10),
                  borderType: BorderType.RRect,
                  color: Color(0xFFDBDBDB),
                  strokeWidth: 1,
                  child: SizedBox(
                    height: 50,
                    width: 90,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Color(0xFFF0069C1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _profilePhotoResult = null;
                          profilePhotoFile = null;
                        });

                        ref.read(userSignUpProvider.notifier).clearProfilePhotoImage();
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Clear",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            DottedBorder(
              radius: Radius.circular(10),
              borderType: BorderType.RRect,
              color: Color(0xFFDBDBDB),
              strokeWidth: 1,
              child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Color(0xFFF0069C1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      _profilePhotoResult = await FilePicker.platform.pickFiles(type: FileType.image
                          //withData: true,
                          );
                      if (_profilePhotoResult!.files.first.path != null) {
                        setState(() {
                          profilePhotoPicked = true;
                        });
                        profilePhotoFile = File(_profilePhotoResult!.files.first.path.toString());
                        profilePhotoFile = await compressAndGetFile(profilePhotoFile!);

                        ref
                            .read(userSignUpProvider.notifier)
                            .changeProfilePhotoImage(profilePhotoFile);
                      } else {
                        // User canceled the picker
                      }
                    } catch (error) {
                      print("ERROR: " + error.toString());
                      final snackBar = SnackBar(
                        content: Text('There was an error, please try again.'),
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(profilePhotoIcon),
                      SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          text: "Select Profile Photo",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Future<List<int>> _readDocumentData(Uint8List data2) async {
    final ByteData data = ByteData.view(data2.buffer);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<bool> checkRegistrationCertificate(Uint8List fileData) async {
    //Load the existing PDF document.
    PdfDocument document = PdfDocument(inputBytes: await _readDocumentData(fileData));

    //Create the new instance of the PdfTextExtractor.
    PdfTextExtractor extractor = PdfTextExtractor(document);

    //Extract all the text from the document.
    String text = extractor.extractText();

    bool containsKeyword = text.contains("This is your annual registration card");

    return containsKeyword;
  }

  void _showRegistrationCertificateError() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Wrong Registration Certificate'),
            content: Scrollbar(
              child: SingleChildScrollView(
                child: Text(
                    "Please provide an actual registration certificate, which can be found on the eservices website."),
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              ),
            ),
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Container selectRegistrationCertificate(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10),
          if (ref.read(userSignUpProvider.notifier).registrationCertificateData != null)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                DottedBorder(
                  radius: Radius.circular(10),
                  borderType: BorderType.RRect,
                  color: Color(0xFFDBDBDB),
                  strokeWidth: 1,
                  child: SizedBox(
                    height: 55,
                    width: 110,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Color(0xFFF0069C1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        registrationFile =
                            ref.read(userSignUpProvider.notifier).registrationCertificateData;
                        print("FILE PATH: " + registrationFile!.path.toString());
                        OpenFile.open(registrationFile!.path);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "View Certificate",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                DottedBorder(
                  radius: Radius.circular(10),
                  borderType: BorderType.RRect,
                  color: Color(0xFFDBDBDB),
                  strokeWidth: 1,
                  child: SizedBox(
                    height: 50,
                    width: 90,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Color(0xFFF0069C1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _registrationCertificateResult = null;
                          registrationFile = null;
                        });

                        ref.read(userSignUpProvider.notifier).clearRegistrationCertificatePDF();
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Clear",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            DottedBorder(
              radius: Radius.circular(10),
              borderType: BorderType.RRect,
              color: Color(0xFFDBDBDB),
              strokeWidth: 1,
              child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Color(0xFFF0069C1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      _registrationCertificateResult = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                        //withData: true,
                      );
                      if (_registrationCertificateResult!.files.first.path != null) {
                        setState(() {
                          registrationCertificatePicked = true;
                        });
                        registrationFile =
                            File(_registrationCertificateResult!.files.first.path.toString());

                        ref
                            .read(userSignUpProvider.notifier)
                            .changeRegistrationCertificate(registrationFile);

                        //Check if registrationCertificate is correct
                        bool registrationCertificateCheck =
                            await checkRegistrationCertificate(registrationFile!.readAsBytesSync());
                        if (registrationCertificateCheck == false) {
                          setState(() {
                            _registrationCertificateResult = null;
                            registrationFile = null;
                          });

                          ref.read(userSignUpProvider.notifier).clearRegistrationCertificatePDF();
                          _showRegistrationCertificateError();
                        }
                      } else {
                        // User canceled the picker
                      }
                    } catch (error) {
                      print("ERROR: " + error.toString());
                      final snackBar = SnackBar(
                        content: Text('There was an error, please try again.'),
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(documentIcon),
                      SizedBox(width: 15),
                      RichText(
                        text: TextSpan(
                          text: "Upload Registration \nCertificate",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Container selectBackID(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10),
          if (ref.read(userSignUpProvider.notifier).backIDData != null)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                DottedBorder(
                  radius: Radius.circular(10),
                  borderType: BorderType.RRect,
                  color: Color(0xFFDBDBDB),
                  strokeWidth: 1,
                  child: SizedBox(
                    height: 50,
                    width: 110,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Color(0xFFF0069C1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        backFile = ref.read(userSignUpProvider.notifier).backIDData;
                        print("FILE PATH: " + backFile!.path.toString());
                        OpenFile.open(backFile!.path);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "View Back",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 35),
                DottedBorder(
                  radius: Radius.circular(10),
                  borderType: BorderType.RRect,
                  color: Color(0xFFDBDBDB),
                  strokeWidth: 1,
                  child: SizedBox(
                    width: 90,
                    height: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Color(0xFFF0069C1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _backOfIDResult = null;
                          backFile = null;
                        });

                        ref.read(userSignUpProvider.notifier).clearBackIDImage();
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Clear",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            DottedBorder(
              radius: Radius.circular(10),
              borderType: BorderType.RRect,
              color: Color(0xFFDBDBDB),
              strokeWidth: 1,
              child: SizedBox(
                height: 60,
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Color(0xFFF0069C1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      _backOfIDResult = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                        //withData: true,
                      );
                      if (_backOfIDResult!.files.first.path != null) {
                        setState(() {
                          backOfIDPicked = true;
                        });
                        backFile = File(_backOfIDResult!.files.first.path.toString());
                        backFile = await compressAndGetFile(backFile!);
                        
                        ref.read(userSignUpProvider.notifier).changeBackIDImage(backFile);
                      } else {
                        // User canceled the picker
                      }
                    } catch (error) {
                      print("ERROR: " + error.toString());
                      final snackBar = SnackBar(
                        content: Text('There was an error, please try again.'),
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(saveIcon),
                      SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          text: "Upload Back of ID",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Container selectFrontID(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10),
          if (ref.read(userSignUpProvider.notifier).frontIDData != null)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                DottedBorder(
                  radius: Radius.circular(10),
                  borderType: BorderType.RRect,
                  color: Color(0xFFDBDBDB),
                  strokeWidth: 1,
                  child: SizedBox(
                    height: 50,
                    width: 110,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        frontFile = ref.read(userSignUpProvider.notifier).frontIDData;
                        print("FILE PATH: " + frontFile!.path.toString());
                        OpenFile.open(frontFile!.path);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "View Front",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                DottedBorder(
                  radius: Radius.circular(10),
                  borderType: BorderType.RRect,
                  color: Color(0xFFDBDBDB),
                  strokeWidth: 1,
                  child: SizedBox(
                    height: 50,
                    width: 90,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Color(0xFFF0069C1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _frontOfIDResult = null;
                          frontFile = null;
                        });

                        ref.read(userSignUpProvider.notifier).clearFrontIDImage();
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Clear",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            DottedBorder(
              radius: Radius.circular(10),
              borderType: BorderType.RRect,
              color: Color(0xFFDBDBDB),
              strokeWidth: 1,
              child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Color(0xFFF0069C1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      _frontOfIDResult = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if (_frontOfIDResult!.files.first.path != null) {
                        setState(() {
                          frontOfIDPicked = true;
                        });
                        frontFile = File(_frontOfIDResult!.files.first.path.toString());
                        frontFile = await compressAndGetFile(frontFile!);

                        ref.read(userSignUpProvider.notifier).changeFrontIDImage(frontFile);
                      } else {
                        // User canceled the picker
                      }
                    } catch (error) {
                      print("ERROR: " + error.toString());
                      final snackBar = SnackBar(
                        content: Text('There was an error, please try again.'),
                        duration: Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(saveIcon),
                      SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          text: "Upload Front of ID",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Future<File?> compressAndGetFile(File file) async {
    print("File Path2: " + file.path);
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = dir.absolute.path + '/temp${file.lengthSync()}.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 50,
    );

    print(file.lengthSync() * 0.000001);
    print(result!.lengthSync() * 0.000001);

    return result;
  }
}
