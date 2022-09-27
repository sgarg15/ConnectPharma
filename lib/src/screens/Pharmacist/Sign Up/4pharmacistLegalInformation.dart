import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectpharma/model/userSignUpModel.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign Up/1pharmacistSignUp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign Up/5pharmacistSkills.dart';

class PharmacistLegalInformation extends ConsumerStatefulWidget {
  PharmacistLegalInformation({Key? key}) : super(key: key);

  @override
  _PharmacistLegalInformationState createState() => _PharmacistLegalInformationState();
}

class _PharmacistLegalInformationState extends ConsumerState<PharmacistLegalInformation> {

  String certificateIcon = 'assets/icons/certificate.svg';
  String licenseIcon = 'assets/icons/license.svg';

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final pharmacistSignUp = ref.watch(userSignUpProvider);
      return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_sharp), onPressed: () => Navigator.pop(context)),
            title: new Text(
              "Legal Information",
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
            children: [
              Center(
                child: Column(children: <Widget>[
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
                            child: Column(
                              children: <Widget>[

                                SizedBox(height: 30),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text:
                                          "Please provide us with some legal information to assure safe transactions.",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),

                                //Legally Entitled
                                TextandToggle(
                                  context,
                                  ref,
                                  certificateIcon,
                                  "Are you legally entitled to work in Canada?",
                                  ref.read(userSignUpProvider).entitledToWork,
                                  (value) {
                                    ref
                                        .read(userSignUpProvider.notifier)
                                        .changeEntitledToWork(value);
                                  },
                                ),
                                SizedBox(height: 20),

                                //Active Member
                                if (ref.read(userSignUpProvider).userType !=
                                    "Pharmacist Assistant") ...[
                                  TextandToggle(
                                    context,
                                    ref,
                                    certificateIcon,
                                    "Are you currently registered as an active member and in good standing with your provincial pharmacy licensing authority?",
                                    ref.read(userSignUpProvider).activeMember,
                                    (value) {
                                      ref
                                          .read(userSignUpProvider.notifier)
                                          .changeActiveMember(value);
                                    },
                                  ),
                                SizedBox(height: 20),
                                ],
                                
                                //Liability Insurance
                                if (ref.read(userSignUpProvider).userType !=
                                    "Pharmacist Assistant") ...[
                                TextandToggle(
                                  context,
                                  ref,
                                  certificateIcon,
                                  "Do you have valid Personal Professional Liability insurance as required by your provincial pharmacy licensing authority?",
                                  ref.read(userSignUpProvider).liabilityInsurance,
                                  (value) {
                                    ref
                                        .read(userSignUpProvider.notifier)
                                        .changeLiabilityInsurance(value);
                                  },
                                ),
                                SizedBox(height: 20),
                                ],

                                //License Restricted
                                if (ref.read(userSignUpProvider).userType !=
                                    "Pharmacist Assistant") ...[
                                TextandToggle(
                                  context,
                                  ref,
                                  certificateIcon,
                                  "Have you ever had your Professional license restricted, suspended, or revoked by your provincial pharmacy licensing authority?",
                                  ref.read(userSignUpProvider).licenseRestricted,
                                  (value) {
                                    ref
                                        .read(userSignUpProvider.notifier)
                                        .changeLicenseRestricted(value);
                                  },
                                ),
                                SizedBox(height: 20),
                                ],
                              
                                //Professional Malpractice
                                TextandToggle(
                                  context,
                                  ref,
                                  certificateIcon,
                                  "Have you ever been found guilty of professional malpractice, misconduct or incapacitated by your provincial pharmacy licensing authority?",
                                  ref.read(userSignUpProvider).malpractice,
                                  (value) {
                                    ref
                                        .read(userSignUpProvider.notifier)
                                        .changeMalpractice(value);
                                  },
                                ),
                                SizedBox(height: 20),

                                ///Convicted Felon
                                TextandToggle(
                                  context,
                                  ref,
                                  certificateIcon,
                                  "Have you ever been convicted of felony or been charged with a criminal offense for which a pardon was not granted?",
                                  ref.read(userSignUpProvider).felon,
                                  (value) {
                                    ref
                                        .read(userSignUpProvider.notifier)
                                        .changeFelonStatus(value);
                                  },
                                ),
                                SizedBox(height: 20),

                                nextButton(context),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ]),
              ),
            ],
          ));
    });
  }

  /*
          SingleChildScrollView(
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
                            ref.read(userSignUpProvider.notifier).changeEntitledToWork(value);
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
                                .read(userSignUpProvider.notifier)
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
                                .read(userSignUpProvider.notifier)
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
                                .read(userSignUpProvider.notifier)
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
                            ref.read(userSignUpProvider.notifier).changeMalpractice(value);
                          },
                        ),
                        SizedBox(height: 20),

                        // //Convicted Felon
                        customTextAndToggle(
                          ref,
                          "Have you ever been convicted of felony or been charged with a criminal offense for which a pardon was not granted?",
                          pharmacistSignUp.felon,
                          (bool value) {
                            ref.read(userSignUpProvider.notifier).changeFelonStatus(value);
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
      
  */

  Center nextButton(BuildContext context) {
    return Center(
      child: SizedBox(
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

  /*
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
            activeTrackColor: Color(0xFFF0069C1),
            activeColor: Color(0xFFF0069C1),
          ),
        ),
      ],
    );
  }

  */

  Container TextandToggle(
    BuildContext context,
    WidgetRef ref,
    String iconString,
    String title,
    bool currentValue,
    Function(bool) onChanged,
  ) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.84,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: RichText(
                        text: TextSpan(
                            text: title,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF4A4848),
                                fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.w500)
                                    .fontFamily))),
                  ),
                ),
                Consumer(
              builder: (context, ref, child) {
                ref.watch(userSignUpProvider);
                return Padding(
                      padding: const EdgeInsets.only(left: 5),
                  child: Transform.scale(
                    scale: 1.3,
                    child: Switch(
                      value: currentValue,
                      onChanged: onChanged,
                          activeTrackColor: Color(0xFFE2F2FF),
                          activeColor: Color(0xFF0069C1),
                          inactiveTrackColor: Color(0xFFDDDFE0),
                          inactiveThumbColor: Colors.white,
                    ),
                  ),
                );
              },
            ),
         
              ],
            ),
            Divider(
              color: Color.fromARGB(255, 185, 185, 185),
              thickness: 1,
            ),
          ],
        ));
  }


}
