import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign Up/4pharmacistLegalInformation.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign Up/1pharmacistSignUp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../all_used.dart';

class PharmacistInformation extends ConsumerStatefulWidget {
  PharmacistInformation({Key? key}) : super(key: key);

  @override
  _PharmacistInformationState createState() => _PharmacistInformationState();
}

class _PharmacistInformationState extends ConsumerState<PharmacistInformation> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final String calendarIcon = 'assets/icons/calendar.svg';
  final String stampIcon = 'assets/icons/stamp.svg';
  final String locationIcon = 'assets/icons/location.svg';
  final String institutionIcon = 'assets/icons/institution.svg';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_sharp), onPressed: () => Navigator.pop(context)),
            title: new Text(
              "Education Information",
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
            children: <Widget>[
              Center(
                child: Column(children: <Widget>[
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (OverscrollIndicatorNotification overscroll) {
                            overscroll.disallowIndicator();
                            return true;
                          },
                          child: SingleChildScrollView(
                            physics: ClampingScrollPhysics(),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 30),
                                //Information Text
                                Padding(
                                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text:
                                          "Please provide us with your Pharmacist Information, to help us verify.",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),

                                //First Year Licensed in Canada
                                CustomInputField(
                                  fieldTitle: "First Year Licensed in Canada",
                                  hintText: "Enter your licensed year",
                                  icon: calendarIcon,
                                  keyboardStyle: TextInputType.number,
                                  onChanged: (String licenseYear) {
                                    ref
                                        .read(userSignUpProvider.notifier)
                                        .changeFirstYearLicensed(licenseYear);
                                  },
                                  validation: (value) {
                                    if (!RegExp(r"^(19|20)\d{2}$").hasMatch(value)) {
                                      return "Incorrect year format";
                                    }
                                    return null;
                                  },
                                  initialValue:
                                      ref.read(userSignUpProvider.notifier).firstYearLicensed,
                                ),
                                SizedBox(height: 30),

                                //Registration Number
                                CustomInputField(
                                  fieldTitle: "Registration Number",
                                  hintText: "Enter your registration number",
                                  icon: stampIcon,
                                  keyboardStyle: TextInputType.number,
                                  onChanged: (String registrationNumber) {
                                    ref
                                        .read(userSignUpProvider.notifier)
                                        .changeRegistrationNumber(registrationNumber);
                                  },
                                  validation: (value) {
                                    if (value.length < 5) {
                                      return "Must be greater then 5 characters";
                                    }
                                    return null;
                                  },
                                  initialValue: ref
                                      .read(userSignUpProvider.notifier)
                                      .registrationNumber,
                                ),
                                SizedBox(height: 30),

                                //Province Registration
                                CustomInputField(
                                  fieldTitle: "Province of Registration",
                                  hintText: "Enter your province of registration",
                                  icon: stampIcon,
                                  keyboardStyle: TextInputType.name,
                                  onChanged: (String registrationProvince) {
                                    ref
                                        .read(userSignUpProvider.notifier)
                                        .changeRegistrationProvince(registrationProvince);
                                  },
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  initialValue: ref
                                      .read(userSignUpProvider.notifier)
                                      .registrationProvince,
                                ),
                                SizedBox(height: 30),

                                //Year of Graduation
                                CustomInputField(
                                  fieldTitle: "Year of Graduation",
                                  hintText: "Enter your year of graduation",
                                  icon: calendarIcon,
                                  keyboardStyle: TextInputType.number,
                                  onChanged: (String yearOfGraduation) {
                                    ref
                                        .read(userSignUpProvider.notifier)
                                        .changeGraduationYear(yearOfGraduation);
                                  },
                                  validation: (value) {
                                    if (!RegExp(r"^(19|20)\d{2}$").hasMatch(value)) {
                                      return "Incorrect year format";
                                    }
                                    return null;
                                  },
                                  initialValue:
                                      ref.read(userSignUpProvider.notifier).graduationYear,
                                ),
                                SizedBox(height: 30),

                                //Institution Name
                                CustomInputField(
                                  fieldTitle: "Institution Name",
                                  hintText: "Enter your institution name",
                                  icon: institutionIcon,
                                  keyboardStyle: TextInputType.name,
                                  onChanged: (String institutionName) {
                                    ref
                                        .read(userSignUpProvider.notifier)
                                        .changeInstitutionName(institutionName);
                                  },
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  initialValue:
                                      ref.read(userSignUpProvider.notifier).institutionName,
                                ),
                                SizedBox(height: 30),

                                //Year of Working Experience
                                CustomInputField(
                                  fieldTitle: "Years of Working Experience",
                                  hintText: "Enter your years of working experience",
                                  icon: calendarIcon,
                                  keyboardStyle: TextInputType.number,
                                  onChanged: (String yearsOfExperience) {
                                    ref
                                        .read(userSignUpProvider.notifier)
                                        .changeWorkingExperience(yearsOfExperience);
                                  },
                                  validation: (value) {
                                    if (value.length > 2) {
                                      return "Incorrect Field";
                                    }
                                    return null;
                                  },
                                  initialValue:
                                      ref.read(userSignUpProvider.notifier).workingExperience,
                                ),
                                SizedBox(height: 30),

                                //Willing to move Toggle
                                moveToggle(context, ref),
                                SizedBox(height: 30),

                                nextButton(),

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
          )),
    );
  }

  Container moveToggle(BuildContext context, WidgetRef ref) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                SvgPicture.asset(locationIcon, width: 21, height: 21),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: RichText(
                      text: TextSpan(
                          text: "Willing to move to nearby areas?",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF4A4848),
                              fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                  .fontFamily))),
                ),
              ],
            ),
            Consumer(
              builder: (context, ref, child) {
                ref.watch(userSignUpProvider);
                return Transform.scale(
                  scale: 1.3,
                  child: Switch(
                    value: ref.read(userSignUpProvider.notifier).willingToMove,
                    onChanged: (value) {
                      print(value);
                      ref.read(userSignUpProvider.notifier).changeWillingToMove(value);
                    },
                    activeTrackColor: Color(0xFFE2F2FF),
                    activeColor: Color(0xFF0069C1),
                    inactiveTrackColor: Color(0xFFDDDFE0),
                    inactiveThumbColor: Colors.white,
                  ),
                );
              },
            ),
          ],
        ));
  }

  Center nextButton() {
    return Center(
      child: Consumer(
        builder: (context, ref, child) {
          ref.watch(userSignUpProvider);
          return SizedBox(
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
              
              onPressed: (ref
                      .read(userSignUpProvider.notifier)
                      .isValidPharmacistInformation())
                  ? null
                  : () {
                      print("Pressed");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PharmacistLegalInformation()));
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
    );
  }
}
