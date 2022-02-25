import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectpharma/model/pharmacistSignUpModel.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign Up/1pharmacistSignUp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign Up/5pharmacistSkills.dart';

class PharmacistLegalInformation extends ConsumerStatefulWidget {
  PharmacistLegalInformation({Key? key}) : super(key: key);

  @override
  _PharmacistLegalInformationState createState() => _PharmacistLegalInformationState();
}

class _PharmacistLegalInformationState extends ConsumerState<PharmacistLegalInformation> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final pharmacistSignUp = ref.watch(pharmacistSignUpProvider);
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
          title: new Text(
            "Legal Information",
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
                        customTextAndToggle(
                          ref,
                          "Are you legally entitled to work in Canada",
                          pharmacistSignUp.entitledToWork,
                          (bool value) {
                            ref.read(pharmacistSignUpProvider.notifier).changeEntitledToWork(value);
                          },
                        ),

                        SizedBox(height: 20),

                        // Active Member
                        customTextAndToggle(
                          ref,
                          "Are you currently registered as an active member and in good standing with your provincial pharmacy licensing authority?",
                          pharmacistSignUp.activeMember,
                          (bool activeMember) {
                            ref
                                .read(pharmacistSignUpProvider.notifier)
                                .changeActiveMember(activeMember);
                          },
                        ),
                        SizedBox(height: 20),

                        // //Liability Insurance
                        customTextAndToggle(
                          ref,
                          "Do you have valid Personal Professional Liability insurance as required by your provincial pharmacy licensing authority?",
                          pharmacistSignUp.liabilityInsurance,
                          (bool value) {
                            ref
                                .read(pharmacistSignUpProvider.notifier)
                                .changeLiabilityInsurance(value);
                          },
                        ),
                        SizedBox(height: 20),

                        // //License Restricted
                        customTextAndToggle(
                          ref,
                          "Have you ever had your Professional license restricted, suspended, or revoked by your provincial pharmacy licensing authority?",
                          pharmacistSignUp.licenseRestricted,
                          (bool value) {
                            ref
                                .read(pharmacistSignUpProvider.notifier)
                                .changeLicenseRestricted(value);
                          },
                        ),
                        SizedBox(height: 20),

                        // //Professional Malpractice
                        customTextAndToggle(
                          ref,
                          "Have you ever been found guilty of professional malpractice, misconduct or incapacitated by your provincial pharmacy licensing authority?",
                          pharmacistSignUp.malpractice,
                          (bool value) {
                            ref.read(pharmacistSignUpProvider.notifier).changeMalpractice(value);
                          },
                        ),
                        SizedBox(height: 20),

                        // //Convicted Felon
                        customTextAndToggle(
                          ref,
                          "Have you ever been convicted of felony or been charged with a criminal offense for which a pardon was not granted?",
                          pharmacistSignUp.felon,
                          (bool value) {
                            ref.read(pharmacistSignUpProvider.notifier).changeFelonStatus(value);
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                //Next Button
                nextButton(context),
                SizedBox(height: 15),
              ],
            )),
      );
    });
  }

  Center nextButton(BuildContext context) {
    return Center(
      child: SizedBox(
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
          onPressed: () {
            print("Pressed");

            Navigator.push(context, MaterialPageRoute(builder: (context) => PharmacistSkills()));
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
    );
  }

  Column customTextAndToggle(
      WidgetRef ref, String text, bool valueName, Function(bool)? onChanged) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
              text: text,
              style: GoogleFonts.questrial(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              )),
        ),
        Transform.scale(
          scale: 1.5,
          child: Switch(
            value: valueName,
            onChanged: onChanged,
            activeTrackColor: Color(0xFF5DB075),
            activeColor: Color(0xFF5DB075),
          ),
        ),
      ],
    );
  }
}
