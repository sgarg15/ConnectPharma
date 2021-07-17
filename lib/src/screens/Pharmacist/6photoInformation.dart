import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma_connect/src/screens/Pharmacist/1pharmacistSignUp.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import '../../../main.dart';

class PhotoInformation extends StatefulWidget {
  PhotoInformation({Key? key}) : super(key: key);

  @override
  _PhotoInformationState createState() => _PhotoInformationState();
}

class _PhotoInformationState extends State<PhotoInformation> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: new Text(
          "Photo Information",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFF6F6F6),
        foregroundColor: Colors.black,
        elevation: 12,
        bottomOpacity: 1,
        shadowColor: Colors.black,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //All Fields
            Align(
              alignment: Alignment(-0.35, -0.70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Front and Back of ID
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              text:
                                  "Please provide a photo of the front and back of your government issued ID along with a profile photo to allow us to verify your identity.",
                              style: GoogleFonts.questrial(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      //Front of ID
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 10),
                          if (context
                                  .read(pharmacistSignUpProvider.notifier)
                                  .frontIDData !=
                              null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  width: 170,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>((states) {
                                          return Color(
                                              0xFF5DB075); // Regular color
                                        }),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ))),
                                    onPressed: () async {
                                      frontFile = context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .frontIDData;
                                      print("FILE PATH: " +
                                          frontFile!.path.toString());
                                      OpenFile.open(frontFile!.path);
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "View Front",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 35),
                                SizedBox(
                                  width: 100,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>((states) {
                                          return Color(
                                              0xFF5DB075); // Regular color
                                        }),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ))),
                                    onPressed: () async {
                                      setState(() {
                                        _frontOfIDResult = null;
                                        frontFile = null;
                                      });

                                      context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .clearFrontIDImage();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Clear",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            SizedBox(
                              width: 270,
                              height: 45,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>((states) {
                                      return Color(0xFF5DB075); // Regular color
                                    }),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                                onPressed: () async {
                                  try {
                                    _frontOfIDResult =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.image,
                                    );
                                    if (_frontOfIDResult!.files.first.path !=
                                        null) {
                                      setState(() {
                                        frontOfIDPicked = true;
                                      });
                                      frontFile = File(_frontOfIDResult!
                                          .files.first.path
                                          .toString());

                                      context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .changeFrontIDImage(frontFile);
                                    } else {
                                      // User canceled the picker
                                    }
                                  } catch (error) {
                                    print("ERROR: " + error.toString());
                                    final snackBar = SnackBar(
                                      content: Text(
                                          'There was an error, please try again.'),
                                      duration: Duration(seconds: 3),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: "Front of ID",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                      SizedBox(height: 10),
                      //Back of ID
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 10),
                          if (context
                                  .read(pharmacistSignUpProvider.notifier)
                                  .backIDData !=
                              null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  width: 170,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>((states) {
                                          return Color(
                                              0xFF5DB075); // Regular color
                                        }),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ))),
                                    onPressed: () async {
                                      backFile = context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .backIDData;
                                      print("FILE PATH: " +
                                          backFile!.path.toString());
                                      OpenFile.open(backFile!.path);
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "View Back of ID",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 35),
                                SizedBox(
                                  width: 100,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>((states) {
                                          return Color(
                                              0xFF5DB075); // Regular color
                                        }),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ))),
                                    onPressed: () async {
                                      setState(() {
                                        _backOfIDResult = null;
                                        backFile = null;
                                      });

                                      context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .clearBackIDImage();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Clear",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            SizedBox(
                              width: 270,
                              height: 45,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>((states) {
                                      return Color(0xFF5DB075); // Regular color
                                    }),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                                onPressed: () async {
                                  try {
                                    _backOfIDResult =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.image,
                                      //withData: true,
                                    );
                                    if (_backOfIDResult!.files.first.path !=
                                        null) {
                                      setState(() {
                                        backOfIDPicked = true;
                                      });
                                      backFile = File(_backOfIDResult!
                                          .files.first.path
                                          .toString());

                                      context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .changeBackIDImage(backFile);
                                    } else {
                                      // User canceled the picker
                                    }
                                  } catch (error) {
                                    print("ERROR: " + error.toString());
                                    final snackBar = SnackBar(
                                      content: Text(
                                          'There was an error, please try again.'),
                                      duration: Duration(seconds: 3),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: "Back of ID",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),

                  //Registration Certificate
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              text:
                                  "Please provide a pdf of your Registration Certificate which can be found on the pharmaceutical website.",
                              style: GoogleFonts.questrial(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 10),
                          if (context
                                  .read(pharmacistSignUpProvider.notifier)
                                  .registrationCertificateData !=
                              null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  width: 170,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>((states) {
                                          return Color(
                                              0xFF5DB075); // Regular color
                                        }),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ))),
                                    onPressed: () async {
                                      registrationFile = context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .registrationCertificateData;
                                      print("FILE PATH: " +
                                          registrationFile!.path.toString());
                                      OpenFile.open(registrationFile!.path);
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "View Registration Certificate",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 35),
                                SizedBox(
                                  width: 100,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>((states) {
                                          return Color(
                                              0xFF5DB075); // Regular color
                                        }),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ))),
                                    onPressed: () async {
                                      setState(() {
                                        _registrationCertificateResult = null;
                                        registrationFile = null;
                                      });

                                      context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .clearRegistrationCertificatePDF();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Clear",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            SizedBox(
                              width: 270,
                              height: 45,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>((states) {
                                      return Color(0xFF5DB075); // Regular color
                                    }),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                                onPressed: () async {
                                  try {
                                    _registrationCertificateResult =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['pdf'],
                                      //withData: true,
                                    );
                                    if (_registrationCertificateResult!
                                            .files.first.path !=
                                        null) {
                                      setState(() {
                                        registrationCertificatePicked = true;
                                      });
                                      registrationFile = File(
                                          _registrationCertificateResult!
                                              .files.first.path
                                              .toString());

                                      context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .changeRegistrationCertificate(
                                              registrationFile);
                                    } else {
                                      // User canceled the picker
                                    }
                                  } catch (error) {
                                    print("ERROR: " + error.toString());
                                    final snackBar = SnackBar(
                                      content: Text(
                                          'There was an error, please try again.'),
                                      duration: Duration(seconds: 3),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: "Select Registration Certificate",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),

                  //Profile Photo
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              text:
                                  "Please provide an image of your self to be used as a profile photo for this app.",
                              style: GoogleFonts.questrial(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 10),
                          if (context
                                  .read(pharmacistSignUpProvider.notifier)
                                  .profilePhotoData !=
                              null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  width: 170,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>((states) {
                                          return Color(
                                              0xFF5DB075); // Regular color
                                        }),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ))),
                                    onPressed: () async {
                                      profilePhotoFile = context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .profilePhotoData;
                                      print("FILE PATH: " +
                                          profilePhotoFile!.path.toString());
                                      OpenFile.open(profilePhotoFile!.path);
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "View Profile Photo",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 35),
                                SizedBox(
                                  width: 100,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>((states) {
                                          return Color(
                                              0xFF5DB075); // Regular color
                                        }),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ))),
                                    onPressed: () async {
                                      setState(() {
                                        _profilePhotoResult = null;
                                        profilePhotoFile = null;
                                      });

                                      context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .clearProfilePhotoImage();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Clear",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            SizedBox(
                              width: 270,
                              height: 45,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>((states) {
                                      return Color(0xFF5DB075); // Regular color
                                    }),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                                onPressed: () async {
                                  try {
                                    _profilePhotoResult = await FilePicker
                                        .platform
                                        .pickFiles(type: FileType.image
                                            //withData: true,
                                            );
                                    if (_profilePhotoResult!.files.first.path !=
                                        null) {
                                      setState(() {
                                        profilePhotoPicked = true;
                                      });
                                      profilePhotoFile = File(
                                          _profilePhotoResult!.files.first.path
                                              .toString());

                                      context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .changeProfilePhotoImage(
                                              profilePhotoFile);
                                    } else {
                                      // User canceled the picker
                                    }
                                  } catch (error) {
                                    print("ERROR: " + error.toString());
                                    final snackBar = SnackBar(
                                      content: Text(
                                          'There was an error, please try again.'),
                                      duration: Duration(seconds: 3),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: "Select Profile Photo (HeadShot)",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),

            //Newsletter Check Box
            CheckboxListTile(
              title: RichText(
                text: TextSpan(
                  text:
                      "I have read and understood the Terms of Service and Privacy Policy.",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14.0,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
              activeColor: Color(0xFF5DB075),
              value: agreeToTermsAndConditions,
              onChanged: (newValue) {
                //todo: Save the check value information to save to account
                setState(() {
                  agreeToTermsAndConditions = newValue!;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            SizedBox(height: 20),

            //Submit
            Center(
              child: Consumer(
                builder: (context, watch, child) {
                  watch(pharmacistSignUpProvider);
                  return SizedBox(
                    width: 324,
                    height: 51,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Colors.grey; // Disabled color
                            }
                            return Color(0xFF5DB075); // Regular color
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ))),
                      onPressed: () async {
                        print("Pressed");
                        context
                            .read(authProvider.notifier)
                            .registerWithEmailAndPassword(
                                context
                                    .read(pharmacistSignUpProvider.notifier)
                                    .email
                                    .toString(),
                                context
                                    .read(pharmacistSignUpProvider.notifier)
                                    .password
                                    .toString())
                            .then((value) async {
                          print("UPLOADING DATA");
                          if (value == null) {
                            print("ERROR");
                            final snackBar = SnackBar(
                              content: Text(
                                  "There was an error trying to register you. Please check your email and password and try again."),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return null;
                          } else {
                            context
                                .read(authProvider.notifier)
                                .uploadPharmacistUserInformation(value, context)
                                .then((value) async {
                              final snackBar = SnackBar(
                                content: Text("User Registered"),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              print("DATA UPLOADED");
                              await value?.user
                                  ?.sendEmailVerification()
                                  .whenComplete(() {
                                final snackBar = SnackBar(
                                  content: Text(
                                    "A verification was sent to the email your registered with, please check your email and verify it.",
                                  ),
                                  action: SnackBarAction(
                                    label: "Ok",
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PharmaConnect()));
                                    },
                                  ),
                                  duration: Duration(seconds: 10),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            });
                          }
                        });
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Submit",
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
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
