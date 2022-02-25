import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectpharma/all_used.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/src/screens/Pharmacy/Sign Up/1pharmacy_signup.dart';

import '../../../../main.dart';

class PharmacyManagerInformation extends ConsumerStatefulWidget {
  PharmacyManagerInformation({Key? key}) : super(key: key);

  @override
  _PharmacyManagerInformationState createState() => _PharmacyManagerInformationState();
}

class _PharmacyManagerInformationState extends ConsumerState<PharmacyManagerInformation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
          title: new Text(
            "Pharmacy Manager Contact",
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
              //Information Text
              Align(
                alignment: Alignment(0, -0.96),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 10, 0, 0),
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: "Please provide us with the Pharmacies Owner’s contact information.",
                      style: GoogleFonts.questrial(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              //All Fields
              Align(
                alignment: Alignment(-0.35, -0.70),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 20),

                      //First Name
                      CustomFormField(
                        fieldTitle: "First Name",
                        hintText: "Enter manager's First Name...",
                        keyboardStyle: TextInputType.name,
                        onChanged: (String managerFirstName) {
                          ref
                              .read(pharmacySignUpProvider.notifier)
                              .changeManagerFirstName(managerFirstName);
                        },
                        validation: (value) {
                          if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                              .hasMatch(value)) {
                            return "Invalid field";
                          }
                          return null;
                        },
                        initialValue: ref.read(pharmacySignUpProvider.notifier).managerFirstName,
                      ),
                      SizedBox(height: 20),

                      //Last Name
                      CustomFormField(
                        fieldTitle: "Last Name",
                        hintText: "Enter manager's Last Name...",
                        keyboardStyle: TextInputType.name,
                        onChanged: (String managerLastName) {
                          ref
                              .read(pharmacySignUpProvider.notifier)
                              .changeMangagerLastName(managerLastName);
                        },
                        validation: (value) {
                          if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                              .hasMatch(value)) {
                            return "Invalid field";
                          }
                          return null;
                        },
                        initialValue: ref.read(pharmacySignUpProvider.notifier).managerLastName,
                      ),
                      SizedBox(height: 20),

                      //Phone Number
                      CustomFormField(
                        fieldTitle: "Phone Number",
                        hintText: "+1 234 567 8910",
                        keyboardStyle: TextInputType.number,
                        onChanged: (String managerPhoneNumber) {
                          ref
                              .read(pharmacySignUpProvider.notifier)
                              .changeManagerPhoneNumber(managerPhoneNumber);
                        },
                        validation: (value) {
                          if (value.length < 4) {
                            return "Phone is invalid";
                          }
                          return null;
                        },
                        initialValue: ref.read(pharmacySignUpProvider.notifier).managerPhoneNumber,
                        formatter: [PhoneInputFormatter()],
                      ),
                      SizedBox(height: 20),

                      //License Number
                      CustomFormField(
                        fieldTitle: "License Number",
                        hintText: "Enter license Number...",
                        keyboardStyle: TextInputType.number,
                        onChanged: (String licenseNumber) {
                          ref
                              .read(pharmacySignUpProvider.notifier)
                              .changeLicenseNumber(licenseNumber);
                        },
                        validation: (value) {
                          if (value.length < 5) {
                            return "License Number must be greater then 5 numbers";
                          }
                          return null;
                        },
                        initialValue: ref.read(pharmacySignUpProvider.notifier).licenseNumber,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              //Submit
              submitButton(),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Center submitButton() {
    return Center(
      child: Consumer(
        builder: (context, ref, child) {
          ref.watch(pharmacySignUpProvider);
          return SizedBox(
            width: 324,
            height: 51,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey; // Disabled color
                    }
                    return Color(0xFF5DB075); // Regular color
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ))),
              onPressed: (!ref.read(pharmacySignUpProvider.notifier).isValidManagerInformation() &&
                      !disableButton)
                  ? () {
                      print("Pressed");
                      setState(() {
                        disableButton = true;
                      });
                      ref
                          .read(authProvider.notifier)
                          .registerWithEmailAndPassword(
                              ref.read(pharmacySignUpProvider.notifier).email.toString(),
                              ref.read(pharmacySignUpProvider.notifier).password.toString())
                          .then((value) async {
                        print("UPLOADING DATA");

                        if (value == null) {
                          print("ERROR");
                          final snackBar = SnackBar(
                            content: Text(
                                "There was an error trying to register you. Please check your email and password and try again."),
                            behavior: SnackBarBehavior.floating,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          setState(() {
                            disableButton = false;
                          });
                          return null;
                        } else {
                          ref
                              .read(authProvider.notifier)
                              .uploadPharmacyUserInformation(ref, value, context)
                              .then((value) async {
                            final snackBar = SnackBar(
                              content: Text("User Registered"),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            print("DATA UPLOADED");
                            await value?.user?.sendEmailVerification().then((_) {
                              ref.read(pharmacySignUpProvider.notifier).resetValues();
                              Navigator.push(context,
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
                          });
                        }
                      });
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
}
