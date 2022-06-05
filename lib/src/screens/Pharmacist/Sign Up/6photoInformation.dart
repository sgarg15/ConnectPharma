import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign Up/1pharmacistSignUp.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../../../main.dart';

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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !disableButton,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
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
                        selectFrontID(context),
                        SizedBox(height: 10),
                        //Back of ID
                        selectBackID(context),
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
                        selectRegistrationCertificate(context),
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
                        selectProfilePhoto(context),
                        SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
              ),

              //Newsletter Check Box
              newsLetterCheckBox(),
              SizedBox(height: 20),

              //Submit
              submitButton(),

              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
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
          ref.watch(pharmacistSignUpProvider);
          return SizedBox(
            width: 324,
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
                    borderRadius: BorderRadius.circular(100),
                  ))),
              onPressed: agreeToTermsAndConditions && !disableButton
                  ? () async {
                      print("Pressed");
                      setState(() {
                        disableButton = true;
                      });
                      if (ref.read(pharmacistSignUpProvider.notifier).userType!.isNotEmpty) {
                        ref
                            .read(authProvider.notifier)
                            .registerWithEmailAndPassword(
                                ref.read(pharmacistSignUpProvider.notifier).email.toString(),
                                ref.read(pharmacistSignUpProvider.notifier).password.toString())
                            .then((user) async {
                          print("UPLOADING DATA");
                          print(
                              "USER TYPE: ${ref.read(pharmacistSignUpProvider.notifier).userType}");

                          if (user == null) {
                            return errorMethod(context);
                          } else {
                            if (ref.read(pharmacistSignUpProvider.notifier).userType ==
                                "Pharmacist") {
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
                                  ref.read(pharmacistSignUpProvider.notifier).clearAllValues();
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => ConnectPharma()));
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
                            } else if (ref.read(pharmacistSignUpProvider.notifier).userType ==
                                "Pharmacy Assistant") {
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
                                  ref.read(pharmacistSignUpProvider.notifier).clearAllValues();
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => ConnectPharma()));
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
                            } else if (ref.read(pharmacistSignUpProvider.notifier).userType ==
                                "Pharmacy Technician") {
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
                                  ref.read(pharmacistSignUpProvider.notifier).clearAllValues();
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => ConnectPharma()));
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
                                          'Pharmacy',
                                          'Pharmacist',
                                          'Technician',
                                        ].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                              child: Text(value), value: value);
                                        }).toList(),
                                        onChanged: (String? value) {
                                          ref
                                              .read(pharmacistSignUpProvider.notifier)
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

  Column selectProfilePhoto(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 10),
        if (ref.read(pharmacistSignUpProvider.notifier).profilePhotoData != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 170,
                height: 45,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        return Color(0xFFF0069C1); // Regular color
                      }),
                      shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                  onPressed: () async {
                    profilePhotoFile = ref.read(pharmacistSignUpProvider.notifier).profilePhotoData;
                    print("FILE PATH: " + profilePhotoFile!.path.toString());
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        return Color(0xFFF0069C1); // Regular color
                      }),
                      shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                  onPressed: () async {
                    setState(() {
                      _profilePhotoResult = null;
                      profilePhotoFile = null;
                    });

                    ref.read(pharmacistSignUpProvider.notifier).clearProfilePhotoImage();
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
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    return Color(0xFFF0069C1); // Regular color
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))),
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

                    ref
                        .read(pharmacistSignUpProvider.notifier)
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
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Column selectRegistrationCertificate(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 10),
        if (ref.read(pharmacistSignUpProvider.notifier).registrationCertificateData != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 170,
                height: 45,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        return Color(0xFFF0069C1); // Regular color
                      }),
                      shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                  onPressed: () async {
                    registrationFile =
                        ref.read(pharmacistSignUpProvider.notifier).registrationCertificateData;
                    print("FILE PATH: " + registrationFile!.path.toString());
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        return Color(0xFFF0069C1); // Regular color
                      }),
                      shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                  onPressed: () async {
                    setState(() {
                      _registrationCertificateResult = null;
                      registrationFile = null;
                    });

                    ref.read(pharmacistSignUpProvider.notifier).clearRegistrationCertificatePDF();
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
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    return Color(0xFFF0069C1); // Regular color
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))),
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
                        .read(pharmacistSignUpProvider.notifier)
                        .changeRegistrationCertificate(registrationFile);

                    //Check if registrationCertificate is correct
                    bool registrationCertificateCheck =
                        await checkRegistrationCertificate(registrationFile!.readAsBytesSync());
                    if (registrationCertificateCheck == false) {
                      setState(() {
                        _registrationCertificateResult = null;
                        registrationFile = null;
                      });

                      ref.read(pharmacistSignUpProvider.notifier).clearRegistrationCertificatePDF();
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
    );
  }

  Column selectBackID(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 10),
        if (ref.read(pharmacistSignUpProvider.notifier).backIDData != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 170,
                height: 45,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        return Color(0xFFF0069C1); // Regular color
                      }),
                      shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                  onPressed: () async {
                    backFile = ref.read(pharmacistSignUpProvider.notifier).backIDData;
                    print("FILE PATH: " + backFile!.path.toString());
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        return Color(0xFFF0069C1); // Regular color
                      }),
                      shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                  onPressed: () async {
                    setState(() {
                      _backOfIDResult = null;
                      backFile = null;
                    });

                    ref.read(pharmacistSignUpProvider.notifier).clearBackIDImage();
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
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    return Color(0xFFF0069C1); // Regular color
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))),
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

                    ref.read(pharmacistSignUpProvider.notifier).changeBackIDImage(backFile);
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
    );
  }

  Column selectFrontID(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 10),
        if (ref.read(pharmacistSignUpProvider.notifier).frontIDData != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 170,
                height: 45,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        return Color(0xFFF0069C1); // Regular color
                      }),
                      shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                  onPressed: () async {
                    frontFile = ref.read(pharmacistSignUpProvider.notifier).frontIDData;
                    print("FILE PATH: " + frontFile!.path.toString());
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        return Color(0xFFF0069C1); // Regular color
                      }),
                      shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                  onPressed: () async {
                    setState(() {
                      _frontOfIDResult = null;
                      frontFile = null;
                    });

                    ref.read(pharmacistSignUpProvider.notifier).clearFrontIDImage();
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
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    return Color(0xFFF0069C1); // Regular color
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))),
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

                    ref.read(pharmacistSignUpProvider.notifier).changeFrontIDImage(frontFile);
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
    );
  }
}
