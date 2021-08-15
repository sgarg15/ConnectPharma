import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pharma_connect/src/Address%20Search/locationSearch.dart';
import 'package:pharma_connect/src/Address%20Search/placeService.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Main/jobHistoryPharmacist.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Sign%20Up/1pharmacistSignUp.dart';
import 'package:uuid/uuid.dart';

import '../../../../all_used.dart';
import '../../login.dart';

class EditPharmacistProfile extends StatefulWidget {
  EditPharmacistProfile({Key? key}) : super(key: key);

  @override
  _EditPharmacistProfileState createState() => _EditPharmacistProfileState();
}

class _EditPharmacistProfileState extends State<EditPharmacistProfile> {
  Map<String, dynamic> uploadDataMap = Map();
  List<Skill?> skillList = [];
  List<Software?> softwareList = [];
  List<Language?> languageList = [];

  final _softwareItems = software
      .map((software) => MultiSelectItem<Software>(software, software.name))
      .toList();
  final _skillItems =
      skill.map((skill) => MultiSelectItem<Skill>(skill, skill.name)).toList();

  final _languageItems = language
      .map((language) => MultiSelectItem<Language>(language, language.name))
      .toList();

  void checkIfChanged(String? currentVal, String firestoreVal) {
    if (currentVal ==
        context
            .read(pharmacistMainProvider.notifier)
            .userDataMap?[firestoreVal]) {
      uploadDataMap.remove(firestoreVal);
    } else {
      uploadDataMap[firestoreVal] = currentVal;
    }
  }

  List<Skill> changeSkillToList(String? stringList) {
    int indexOfOpenBracket = stringList!.indexOf("[");
    int indexOfLastBracket = stringList.lastIndexOf("]");
    var noBracketString =
        stringList.substring(indexOfOpenBracket + 1, indexOfLastBracket);
    var list = noBracketString.split(", ");
    List<Skill> accSkillList = [];
    for (var i = 0; i < list.length; i++) {
      accSkillList.add(Skill(id: 1, name: list[i].toString()));
    }
    return accSkillList;
  }

  void changeSoftwareToList(String? stringList) {
    int indexOfOpenBracket = stringList!.indexOf("[");
    int indexOfLastBracket = stringList.lastIndexOf("]");
    var noBracketString =
        stringList.substring(indexOfOpenBracket + 1, indexOfLastBracket);
    var list = noBracketString.split(", ");
    for (var i = 0; i < list.length; i++) {
      softwareList.add(Software(id: 1, name: list[i]));
    }
  }

  void changeLanguageToList(String? stringList) {
    int indexOfOpenBracket = stringList!.indexOf("[");
    int indexOfLastBracket = stringList.lastIndexOf("]");
    var noBracketString =
        stringList.substring(indexOfOpenBracket + 1, indexOfLastBracket);
    var list = noBracketString.split(", ");
    for (var i = 0; i < list.length; i++) {
      languageList.add(Language(id: 1, name: list[i]));
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      skillList = changeSkillToList(context
          .read(pharmacistMainProvider.notifier)
          .userDataMap?["knownSkills"]);

      changeSoftwareToList(context
          .read(pharmacistMainProvider.notifier)
          .userDataMap?["knownSoftware"]);
      changeLanguageToList(context
          .read(pharmacistMainProvider.notifier)
          .userDataMap?["knownLanguages"]);
      context
          .read(pharmacistSignUpProvider.notifier)
          .changeSkillList(skillList);
      print(softwareList);
      print(skillList);
      print(languageList);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController streetAddress = TextEditingController(
        text: context.read(pharmacistSignUpProvider.notifier).address);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 12,
        title: Text(
          "Edit Profile",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
        ),
        backgroundColor: Color(0xFFF6F6F6),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Account Owner Information
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Center(
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    constraints: BoxConstraints(minHeight: 320),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Title
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: "User Information",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24.0,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0,
                          thickness: 2,
                          color: Color(0xFF5DB075),
                        ),
                        //First Name
                        Padding(
                          padding: const EdgeInsets.fromLTRB(11, 10, 0, 0),
                          child: formField(
                            fieldTitle: "First Name",
                            hintText: "Enter your First Name...",
                            keyboardStyle: TextInputType.name,
                            containerWidth: 345,
                            titleFont: 22,
                            onChanged: (String firstName) {
                              context
                                  .read(pharmacistSignUpProvider.notifier)
                                  .changeFirstName(firstName);
                              checkIfChanged(firstName, "firstName");
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
                                .read(pharmacistMainProvider.notifier)
                                .userDataMap?["firstName"],
                          ),
                        ),
                        SizedBox(height: 20),
                        //Last Name
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: formField(
                            fieldTitle: "Last Name",
                            hintText: "Enter your Last Name...",
                            keyboardStyle: TextInputType.name,
                            containerWidth: 345,
                            titleFont: 22,
                            onChanged: (String lastName) {
                              context
                                  .read(pharmacistSignUpProvider.notifier)
                                  .changeLastName(lastName);
                              checkIfChanged(lastName, "lastName");
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
                                .read(pharmacistMainProvider.notifier)
                                .userDataMap?["lastName"],
                          ),
                        ),
                        SizedBox(height: 20),
                        //Phone Number
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: formField(
                            fieldTitle: "Phone Number",
                            hintText: "Enter your Phone Number...",
                            keyboardStyle: TextInputType.number,
                            containerWidth: 345,
                            titleFont: 22,
                            onChanged: (String phoneNumber) {
                              context
                                  .read(pharmacistSignUpProvider.notifier)
                                  .changePhoneNumber(phoneNumber);
                              checkIfChanged(phoneNumber, "phoneNumber");
                            },
                            validation: (value) {
                              if (value.length < 4) {
                                return "Phone is invalid";
                              }
                              return null;
                            },
                            initialValue: context
                                .read(pharmacistMainProvider.notifier)
                                .userDataMap?["phoneNumber"],
                            formatter: [MaskedInputFormatter('(###) ###-####')],
                          ),
                        ),
                        SizedBox(height: 20),
                        //Address
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                    text: "Address",
                                    style: GoogleFonts.questrial(
                                      fontSize: 22,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: 345,
                                //height: 50,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0.3, 3),
                                        blurRadius: 3.0,
                                        spreadRadius: 0.5,
                                        color: Colors.grey.shade400)
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.shade200,
                                ),
                                child: TextFormField(
                                  readOnly: true,
                                  controller: streetAddress,
                                  onTap: () async {
                                    final sessionToken = Uuid().v4();
                                    final Suggestion? result =
                                        await showSearch<Suggestion?>(
                                      context: context,
                                      delegate: AddressSearch(sessionToken),
                                    );

                                    if (result != null) {
                                      final placeDetails =
                                          await PlaceApiProvider(sessionToken)
                                              .getPlaceDetailFromId(
                                                  result.placeId);
                                      context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .changePharmacistAddress(placeDetails
                                                  .streetNumber! +
                                              " " +
                                              placeDetails.street.toString() +
                                              ", " +
                                              placeDetails.city.toString() +
                                              ", " +
                                              placeDetails.country.toString());
                                      checkIfChanged(
                                          placeDetails.streetNumber! +
                                              " " +
                                              placeDetails.street.toString() +
                                              ", " +
                                              placeDetails.city.toString() +
                                              ", " +
                                              placeDetails.country.toString(),
                                          "address");
                                      setState(() {
                                        streetAddress.text =
                                            placeDetails.streetNumber! +
                                                " " +
                                                placeDetails.street.toString() +
                                                ", " +
                                                placeDetails.city.toString() +
                                                ", " +
                                                placeDetails.country.toString();
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    errorStyle:
                                        TextStyle(fontWeight: FontWeight.w500),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 0, 0, 30),
                                    filled: true,
                                    fillColor: Color(0xFFF0F0F0),
                                    // focusedErrorBorder: OutlineInputBorder(
                                    //     borderRadius: BorderRadius.circular(8),
                                    //     borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                                    // errorBorder: OutlineInputBorder(
                                    //     borderRadius: BorderRadius.circular(8),
                                    //     borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Color(0xFFE8E8E8))),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFE8E8E8)),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    hintText: "Enter the address...",
                                    hintStyle: GoogleFonts.inter(
                                        color: Color(0xFFBDBDBD), fontSize: 16),
                                  ),
                                  style: GoogleFonts.inter(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            //Grad Info
            Center(
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  constraints: BoxConstraints(minHeight: 320),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),

                      //First Year Licensed In Canada
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: formField(
                          fieldTitle: "First Year Licensed in Canada",
                          hintText: "First Year Licensed in Canada...",
                          containerWidth: 345,
                          titleFont: 22,
                          keyboardStyle: TextInputType.number,
                          onChanged: (String licenseYear) {
                            checkIfChanged(licenseYear, "firstYearLicensed");

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
                              .read(pharmacistMainProvider.notifier)
                              .userDataMap?["firstYearLicensed"],
                        ),
                      ),
                      SizedBox(height: 20),

                      //Registration Number
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: formField(
                          fieldTitle: "Registration Number",
                          hintText: "Registration Number...",
                          keyboardStyle: TextInputType.number,
                          containerWidth: 345,
                          titleFont: 22,
                          onChanged: (String registrationNumber) {
                            checkIfChanged(
                                registrationNumber, "registrationNumber");
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
                              .read(pharmacistMainProvider.notifier)
                              .userDataMap?["registrationNumber"],
                        ),
                      ),
                      SizedBox(height: 20),

                      //Province of Registration
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: formField(
                          fieldTitle: "Registration Province",
                          hintText: "Registration Province...",
                          keyboardStyle: TextInputType.streetAddress,
                          containerWidth: 345,
                          titleFont: 22,
                          onChanged: (String registrationProvince) {
                            checkIfChanged(
                                registrationProvince, "registrationProvince");
                            context
                                .read(pharmacistSignUpProvider.notifier)
                                .changeRegistrationProvince(
                                    registrationProvince);
                          },
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                          initialValue: context
                              .read(pharmacistMainProvider.notifier)
                              .userDataMap?["registrationProvince"],
                        ),
                      ),
                      SizedBox(height: 20),

                      //Year of Graduation
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: formField(
                          fieldTitle: "Graduation Year",
                          hintText: "Graduation Year...",
                          keyboardStyle: TextInputType.number,
                          containerWidth: 345,
                          titleFont: 22,
                          onChanged: (String graduationYear) {
                            checkIfChanged(graduationYear, "gradutationYear");
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
                              .read(pharmacistMainProvider.notifier)
                              .userDataMap?["gradutationYear"],
                        ),
                      ),
                      SizedBox(height: 20),

                      //Instituation Name
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: formField(
                          fieldTitle: "Instituation Name",
                          hintText: "Instituation Name...",
                          keyboardStyle: TextInputType.streetAddress,
                          containerWidth: 345,
                          titleFont: 22,
                          onChanged: (String institutionName) {
                            checkIfChanged(institutionName, "institutionName");

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
                              .read(pharmacistMainProvider.notifier)
                              .userDataMap?["institutionName"],
                        ),
                      ),
                      SizedBox(height: 20),

                      //Years of Working experience
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: formField(
                          fieldTitle: "Years of Working experience",
                          hintText: "Number of years...",
                          keyboardStyle: TextInputType.number,
                          containerWidth: 345,
                          titleFont: 22,
                          onChanged: (String workingExperience) {
                            checkIfChanged(
                                workingExperience, "workingExperience");
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
                              .read(pharmacistMainProvider.notifier)
                              .userDataMap?["workingExperience"],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            //Software/Skills/Language
            Center(
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  constraints: BoxConstraints(minHeight: 320),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      //Software
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                                text: "Software",
                                style: GoogleFonts.questrial(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 345,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0.3, 3),
                                    blurRadius: 3.0,
                                    spreadRadius: 0.5,
                                    color: Colors.grey.shade400)
                              ],
                              color: Color(0xFFF0F0F0),
                              border: Border.all(
                                color: Color(0xFFE8E8E8),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: <Widget>[
                                MultiSelectBottomSheetField<Software?>(
                                  selectedColor: Color(0xFF5DB075),
                                  selectedItemsTextStyle:
                                      TextStyle(color: Colors.white),
                                  initialChildSize: 0.4,
                                  decoration: BoxDecoration(),
                                  listType: MultiSelectListType.CHIP,
                                  initialValue: softwareList,
                                  searchable: true,
                                  items: _softwareItems,
                                  buttonText: Text("Select known software...",
                                      style: GoogleFonts.inter(
                                          color: Color(0xFFBDBDBD),
                                          fontSize: 16)),
                                  onConfirm: (values) {
                                    softwareList.clear();
                                    softwareList.addAll(values);

                                    context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .changeSoftwareList(values);
                                  },
                                  chipDisplay: MultiSelectChipDisplay(
                                    items: context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .softwareList
                                        ?.map((e) =>
                                            MultiSelectItem(e, e.toString()))
                                        .toList(),
                                    chipColor: Color(0xFF5DB075),
                                    onTap: (value) {
                                      softwareList.remove(value);
                                      context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .softwareList
                                          ?.remove(value);
                                      return context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .softwareList;
                                    },
                                    textStyle: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      //Skill
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                                text: "Skill",
                                style: GoogleFonts.questrial(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 345,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0.3, 3),
                                    blurRadius: 3.0,
                                    spreadRadius: 0.5,
                                    color: Colors.grey.shade400)
                              ],
                              color: Color(0xFFF0F0F0),
                              border: Border.all(
                                color: Color(0xFFE8E8E8),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: <Widget>[
                                MultiSelectBottomSheetField<Skill?>(
                                  selectedColor: Color(0xFF5DB075),
                                  selectedItemsTextStyle:
                                      TextStyle(color: Colors.white),
                                  initialChildSize: 0.4,
                                  decoration: BoxDecoration(),
                                  listType: MultiSelectListType.CHIP,
                                  initialValue: context
                                      .read(pharmacistSignUpProvider.notifier)
                                      .skillList,
                                  searchable: true,
                                  items: _skillItems,
                                  buttonText: Text("Select your skills...",
                                      style: GoogleFonts.inter(
                                          color: Color(0xFFBDBDBD),
                                          fontSize: 16)),
                                  onConfirm: (values) {
                                    context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .changeSkillList(values);
                                  },
                                  chipDisplay: MultiSelectChipDisplay(
                                    items: context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .skillList
                                        ?.map((e) =>
                                            MultiSelectItem(e, e.toString()))
                                        .toList(),
                                    chipColor: Color(0xFF5DB075),
                                    onTap: (value) {
                                      context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .skillList
                                          ?.remove(value);
                                      return context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .skillList;
                                    },
                                    textStyle: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      //Language
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                                text: "Languages",
                                style: GoogleFonts.questrial(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 345,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0.3, 3),
                                    blurRadius: 3.0,
                                    spreadRadius: 0.5,
                                    color: Colors.grey.shade400)
                              ],
                              color: Color(0xFFF0F0F0),
                              border: Border.all(
                                color: Color(0xFFE8E8E8),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: <Widget>[
                                MultiSelectBottomSheetField<Language?>(
                                  selectedColor: Color(0xFF5DB075),
                                  selectedItemsTextStyle:
                                      TextStyle(color: Colors.white),
                                  initialChildSize: 0.4,
                                  decoration: BoxDecoration(),
                                  listType: MultiSelectListType.CHIP,
                                  initialValue: languageList,
                                  searchable: true,
                                  items: _languageItems,
                                  buttonText: Text("Select known languages...",
                                      style: GoogleFonts.inter(
                                          color: Color(0xFFBDBDBD),
                                          fontSize: 16)),
                                  onConfirm: (values) {
                                    context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .changeLanguageList(values);
                                  },
                                  chipDisplay: MultiSelectChipDisplay(
                                    items: context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .languageList
                                        ?.map((e) =>
                                            MultiSelectItem(e, e.toString()))
                                        .toList(),
                                    chipColor: Color(0xFF5DB075),
                                    onTap: (value) {
                                      context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .languageList
                                          ?.remove(value);
                                      return context
                                          .read(
                                              pharmacistSignUpProvider.notifier)
                                          .languageList;
                                    },
                                    textStyle: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Center(
              child: SizedBox(
                width: 324,
                height: 51,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Color(0xFF5DB075);
                          else if (states.contains(MaterialState.disabled))
                            return Colors.grey;
                          return Color(
                              0xFF5DB075); // Use the component's default.
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ))),
                  onPressed: uploadDataMap.isNotEmpty
                      ? () async {
                          print(uploadDataMap);
                          String? result = await context
                              .read(authProviderMain.notifier)
                              .updatePharmacistUserInformation(
                                  context
                                      .read(userProviderLogin.notifier)
                                      .userUID,
                                  uploadDataMap);

                          if (result == "Profile Upload Failed") {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Important!"),
                                    content: Text(
                                        "There was an error trying to update your profile. Please try again."),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(
                                              color: Color(0xFF5DB075)),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                });
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        JobHistoryPharmacist()));
                          }
                        }
                      : null,
                  child: RichText(
                    text: TextSpan(
                      text: "Save",
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

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
