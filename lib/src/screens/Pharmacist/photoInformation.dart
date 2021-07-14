import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma_connect/src/screens/Pharmacist/pharmacistSignUp.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

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
                          if (frontOfIDPicked == false)
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
                          else
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
                                      PlatformFile file =
                                          _frontOfIDResult!.files.first;
                                      print(
                                          "FILE PATH: " + file.path.toString());
                                      OpenFile.open(file.path);
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
                                        frontOfIDPicked = false;
                                      });
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
                        ],
                      ),
                      SizedBox(height: 10),
                      //Back of ID
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 10),
                          if (backOfIDPicked == false)
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
                                    );
                                    if (_backOfIDResult!.files.first.path !=
                                        null) {
                                      setState(() {
                                        backOfIDPicked = true;
                                      });
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
                          else
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
                                      PlatformFile file =
                                          _backOfIDResult!.files.first;
                                      print(
                                          "FILE PATH: " + file.path.toString());
                                      OpenFile.open(file.path);
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "View Back",
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
                                        backOfIDPicked = false;
                                      });
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
                          if (registrationCertificatePicked == false)
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
                                    );
                                    if (_registrationCertificateResult!
                                            .files.first.path !=
                                        null) {
                                      setState(() {
                                        registrationCertificatePicked = true;
                                      });
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
                                    text: "Registration Certificate",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else
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
                                      PlatformFile file =
                                          _registrationCertificateResult!
                                              .files.first;
                                      print(
                                          "FILE PATH: " + file.path.toString());
                                      OpenFile.open(file.path);
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "View",
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
                                        registrationCertificatePicked = false;
                                      });
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
                          if (profilePhotoPicked == false)
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
                                    _profilePhotoResult =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.image,
                                    );
                                    if (_profilePhotoResult!.files.first.path !=
                                        null) {
                                      setState(() {
                                        profilePhotoPicked = true;
                                      });
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
                                    text: "Profile Photo",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else
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
                                      PlatformFile file =
                                          _profilePhotoResult!.files.first;
                                      print(
                                          "FILE PATH: " + file.path.toString());
                                      OpenFile.open(file.path);
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "View",
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
                                        profilePhotoPicked = false;
                                      });
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
                      onPressed: () {
                        print("Pressed");
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
