import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma_connect/all_used.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'accountInformation.dart';

class PharmacyManagerInformation extends StatelessWidget {
  PharmacyManagerInformation({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: new Text(
          "Account Owner Information",
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
                        if (value == null || value.isEmpty) {
                          return "This field is required";
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
                        if (value == null || value.isEmpty) {
                          return "This field is required";
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
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                      initialValue: context
                          .read(pharmacySignUpProvider.notifier)
                          .managerPhoneNumber,
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
                        if (value == null || value.isEmpty) {
                          return "This field is required";
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
                  final pharmacySignUp = watch(pharmacySignUpProvider);
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
                      onPressed: (context
                              .read(pharmacySignUpProvider.notifier)
                              .isValidManagerInformation())
                          ? null
                          : () {
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
