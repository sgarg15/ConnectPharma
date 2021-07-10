import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma_connect/src/screens/Pharmacist/pharmacistSignUp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/src/screens/Pharmacist/pharmacistSkills.dart';

class PharmacistLegalInformation extends StatefulWidget {
  PharmacistLegalInformation({Key? key}) : super(key: key);

  @override
  _PharmacistLegalInformationState createState() =>
      _PharmacistLegalInformationState();
}

class _PharmacistLegalInformationState
    extends State<PharmacistLegalInformation> {

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final pharmacistSignUp = watch(pharmacistSignUpProvider);
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: new Text(
            "Pharmacist Legal Information",
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
                            "Please provide us with some legal information to assure safe transactions.",
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 20),
                        //Legally Entitled
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text:
                                  "Are you legally entitled to work in Canada?",
                              style: GoogleFonts.questrial(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: pharmacistSignUp.entitledToWork,
                            onChanged: (value) {
                              context
                                  .read(pharmacistSignUpProvider.notifier)
                                  .changeEntitledToWork(value);
                            },
                            activeTrackColor: Color(0xFF5DB075),
                            activeColor: Color(0xFF5DB075),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Active Member
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text:
                                  "Are you currently registered as an active member and in good standing with your provincial pharmacy licensing authority?",
                              style: GoogleFonts.questrial(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: pharmacistSignUp.activeMember,
                            onChanged: (value) {
                              context
                                  .read(pharmacistSignUpProvider.notifier)
                                  .changeActiveMember(value);
                            },
                            activeTrackColor: Color(0xFF5DB075),
                            activeColor: Color(0xFF5DB075),
                          ),
                        ),
                        SizedBox(height: 20),

                        // //Liability Insurance
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text:
                                  "Do you have valid Personal Professional Liability insurance as required by your provincial pharmacy licensing authority?",
                              style: GoogleFonts.questrial(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: pharmacistSignUp.liabilityInsurance,
                            onChanged: (value) {
                              print(value);
                              context
                                  .read(pharmacistSignUpProvider.notifier)
                                  .changeLiabilityInsurance(value);
                            },
                            activeTrackColor: Color(0xFF5DB075),
                            activeColor: Color(0xFF5DB075),
                          ),
                        ),
                        SizedBox(height: 20),

                        // //License Restricted
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text:
                                  "Have you ever had your Professional license restricted, suspended, or revoked by your provincial pharmacy licensing authority?",
                              style: GoogleFonts.questrial(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: pharmacistSignUp.licenseRestricted,
                            onChanged: (value) {
                              print(value);
                              context
                                  .read(pharmacistSignUpProvider.notifier)
                                  .changeLicenseRestricted(value);
                            },
                            activeTrackColor: Color(0xFF5DB075),
                            activeColor: Color(0xFF5DB075),
                          ),
                        ),
                        SizedBox(height: 20),

                        // //Professional Malpractice
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text:
                                  "Have you ever been found guilty of professional malpractice, misconduct or incapacitated by your provincial pharmacy licensing authority?",
                              style: GoogleFonts.questrial(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: pharmacistSignUp.malpractice,
                            onChanged: (value) {
                              print(value);
                              context
                                  .read(pharmacistSignUpProvider.notifier)
                                  .changeMalpractice(value);
                            },
                            activeTrackColor: Color(0xFF5DB075),
                            activeColor: Color(0xFF5DB075),
                          ),
                        ),
                        SizedBox(height: 20),

                        // //Convicted Felon
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text:
                                  "Have you ever been convicted of felony or been charged with a criminal offense for which a pardon was not granted?",
                              style: GoogleFonts.questrial(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: pharmacistSignUp.felon,
                            onChanged: (value) {
                              print(value);
                              context
                                  .read(pharmacistSignUpProvider.notifier)
                                  .changeFelonStatus(value);
                            },
                            activeTrackColor: Color(0xFF5DB075),
                            activeColor: Color(0xFF5DB075),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                //Next Button
                Center(
                  child: SizedBox(
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PharmacistSkills()));
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
                  ),
                ),
                SizedBox(height: 15),
              ],
            )),
      );
    });
  }
}
