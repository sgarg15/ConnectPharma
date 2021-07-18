import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma_connect/all_used.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/src/screens/Pharmacy/1pharmacy_signup.dart';

import '../../../main.dart';

class PharmacyManagerInformation extends StatefulWidget {
  PharmacyManagerInformation({Key? key}) : super(key: key);

  @override
  _PharmacyManagerInformationState createState() =>
      _PharmacyManagerInformationState();
}

class _PharmacyManagerInformationState
    extends State<PharmacyManagerInformation> {
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
                      text:
                          "Please provide us with the Pharmacies Owner’s contact information.",
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
                      formField(
                        fieldTitle: "First Name",
                        hintText: "Enter manager's First Name...",
                        keyboardStyle: TextInputType.name,
                        onChanged: (String managerFirstName) {
                          context
                              .read(pharmacySignUpProvider.notifier)
                              .changeManagerFirstName(managerFirstName);
                        },
                        validation: (value) {
                          if (!RegExp(
                                  r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                              .hasMatch(value)) {
                            return "Invalid field";
                          }
                          return null;
                        },
                        initialValue: context
                            .read(pharmacySignUpProvider.notifier)
                            .managerFirstName,
                      ),
                      SizedBox(height: 20),

                      //Last Name
                      formField(
                        fieldTitle: "Last Name",
                        hintText: "Enter manager's Last Name...",
                        keyboardStyle: TextInputType.name,
                        onChanged: (String managerLastName) {
                          context
                              .read(pharmacySignUpProvider.notifier)
                              .changeMangagerLastName(managerLastName);
                        },
                        validation: (value) {
                          if (!RegExp(
                                  r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                              .hasMatch(value)) {
                            return "Invalid field";
                          }
                          return null;
                        },
                        initialValue: context
                            .read(pharmacySignUpProvider.notifier)
                            .managerLastName,
                      ),
                      SizedBox(height: 20),

                      //Phone Number
                      formField(
                        fieldTitle: "Phone Number",
                        hintText: "Enter manager's Phone Number...",
                        keyboardStyle: TextInputType.number,
                        onChanged: (String managerPhoneNumber) {
                          context
                              .read(pharmacySignUpProvider.notifier)
                              .changeManagerPhoneNumber(managerPhoneNumber);
                        },
                        validation: (value) {
                          if (value.length < 4) {
                            return "Phone is invalid";
                          }
                          return null;
                        },
                        initialValue: context
                            .read(pharmacySignUpProvider.notifier)
                            .managerPhoneNumber,
                        formatter: [MaskedInputFormatter('(###) ###-####')],
                      ),
                      SizedBox(height: 20),

                      //License Number
                      formField(
                        fieldTitle: "License Number",
                        hintText: "Enter license Number...",
                        keyboardStyle: TextInputType.number,
                        onChanged: (String licenseNumber) {
                          context
                              .read(pharmacySignUpProvider.notifier)
                              .changeLicenseNumber(licenseNumber);
                        },
                        validation: (value) {
                          if (value.length < 5) {
                            return "License Number must be greater then 5 numbers";
                          }
                          return null;
                        },
                        initialValue: context
                            .read(pharmacySignUpProvider.notifier)
                            .licenseNumber,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              //Submit
              Center(
                child: Consumer(
                  builder: (context, watch, child) {
                    watch(pharmacySignUpProvider);
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ))),
                        onPressed: (!context
                                    .read(pharmacySignUpProvider.notifier)
                                    .isValidManagerInformation() &&
                                !disableButton)
                            ? () {
                                print("Pressed");
                                setState(() {
                                  disableButton = true;
                                });
                                context
                                    .read(authProvider.notifier)
                                    .registerWithEmailAndPassword(
                                        context
                                            .read(
                                                pharmacySignUpProvider.notifier)
                                            .email
                                            .toString(),
                                        context
                                            .read(
                                                pharmacySignUpProvider.notifier)
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
                                    setState(() {
                                      disableButton = false;
                                    });
                                    return null;
                                  } else {
                                    context
                                        .read(authProvider.notifier)
                                        .uploadPharmacyUserInformation(
                                            value, context)
                                        .then((value) async {
                                      final snackBar = SnackBar(
                                        content: Text("User Registered"),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      print("DATA UPLOADED");
                                      await value?.user
                                          ?.sendEmailVerification()
                                          .then((_) {
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
                                              context
                                                  .read(pharmacySignUpProvider
                                                      .notifier)
                                                  .clearAllValues();
                                            },
                                          ),
                                          duration: Duration(seconds: 30),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
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
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
