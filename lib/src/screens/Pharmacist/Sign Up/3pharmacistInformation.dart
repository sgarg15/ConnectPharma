import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Sign Up/4pharmacistLegalInformation.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Sign Up/1pharmacistSignUp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../all_used.dart';

class PharmacistInformation extends StatefulWidget {
  PharmacistInformation({Key? key}) : super(key: key);

  @override
  _PharmacistInformationState createState() => _PharmacistInformationState();
}

class _PharmacistInformationState extends State<PharmacistInformation> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        title: new Text(
          "Education Information",
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
                        "Please provide us with your Pharmacist Information, to help us verify.",
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
                    //First Year Licensed In Canada
                    CustomFormField(
                      fieldTitle: "First Year Licensed in Canada",
                      hintText: "First Year Licensed in Canada...",
                      keyboardStyle: TextInputType.number,
                      onChanged: (String licenseYear) {
                        context
                            .read(pharmacistSignUpProvider.notifier)
                            .changeFirstYearLicensed(licenseYear);
                      },
                      validation: (value) {
                        if (!RegExp(r"^(19|20)\d{2}$").hasMatch(value)) {
                          return "Incorrect year format";
                        }
                        return null;
                      },
                      initialValue: context
                          .read(pharmacistSignUpProvider.notifier)
                          .firstYearLicensed,
                    ),
                    SizedBox(height: 20),

                    //Registration Number
                    CustomFormField(
                      fieldTitle: "Registration Number",
                      hintText: "Registration Number...",
                      keyboardStyle: TextInputType.number,
                      onChanged: (String registrationNumber) {
                        context
                            .read(pharmacistSignUpProvider.notifier)
                            .changeRegistrationNumber(registrationNumber);
                      },
                      validation: (value) {
                        if (value.length < 5) {
                          return "Registration Number must be greater then 5 characters";
                        }
                        return null;
                      },
                      initialValue: context
                          .read(pharmacistSignUpProvider.notifier)
                          .registrationNumber,
                    ),
                    SizedBox(height: 20),

                    //Province of Registration
                    CustomFormField(
                      fieldTitle: "Registration Province",
                      hintText: "Registration Province...",
                      keyboardStyle: TextInputType.streetAddress,
                      onChanged: (String registrationProvince) {
                        context
                            .read(pharmacistSignUpProvider.notifier)
                            .changeRegistrationProvince(registrationProvince);
                      },
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                      initialValue: context
                          .read(pharmacistSignUpProvider.notifier)
                          .registrationProvince,
                    ),
                    SizedBox(height: 20),

                    //Year of Graduation
                    CustomFormField(
                      fieldTitle: "Graduation Year",
                      hintText: "Graduation Year...",
                      keyboardStyle: TextInputType.number,
                      onChanged: (String graduationYear) {
                        context
                            .read(pharmacistSignUpProvider.notifier)
                            .changeGraduationYear(graduationYear);
                      },
                      validation: (value) {
                        if (!RegExp(r"^(19|20)\d{2}$").hasMatch(value)) {
                          return "Incorrect year format";
                        }
                        return null;
                      },
                      initialValue: context
                          .read(pharmacistSignUpProvider.notifier)
                          .graduationYear,
                    ),
                    SizedBox(height: 20),

                    //Instituation Name
                    CustomFormField(
                      fieldTitle: "Instituation Name",
                      hintText: "Instituation Name...",
                      keyboardStyle: TextInputType.streetAddress,
                      onChanged: (String institutionName) {
                        context
                            .read(pharmacistSignUpProvider.notifier)
                            .changeInstitutionName(institutionName);
                      },
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                      initialValue: context
                          .read(pharmacistSignUpProvider.notifier)
                          .institutionName,
                    ),
                    SizedBox(height: 20),

                    //Years of Working experience
                    CustomFormField(
                      fieldTitle: "Years of Working experience",
                      hintText: "Number of years...",
                      keyboardStyle: TextInputType.number,
                      onChanged: (String workingExperience) {
                        context
                            .read(pharmacistSignUpProvider.notifier)
                            .changeWorkingExperience(workingExperience);
                      },
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                      initialValue: context
                          .read(pharmacistSignUpProvider.notifier)
                          .workingExperience,
                    ),
                    SizedBox(height: 20),

                    //Willing to move Toggle
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                          text: "Willing to move to nearby areas?",
                          style: GoogleFonts.questrial(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    SizedBox(height: 0),
                    Consumer(
                      builder: (context, watch, child) {
                        watch(pharmacistSignUpProvider);
                        return Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: context
                                .read(pharmacistSignUpProvider.notifier)
                                .willingToMove,
                            onChanged: (value) {
                              print(value);
                              context
                                  .read(pharmacistSignUpProvider.notifier)
                                  .changeWillingToMove(value);
                            },
                            activeTrackColor: Color(0xFF5DB075),
                            activeColor: Color(0xFF5DB075),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            //Next Button
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
                      onPressed: (context
                              .read(pharmacistSignUpProvider.notifier)
                              .isValidPharmacistInformation())
                          ? null
                          : () {
                              print("Pressed");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PharmacistLegalInformation()));
                            },
                      child: RichText(
                        text: TextSpan(
                          text: "Next",
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
