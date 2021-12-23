import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:pharma_connect/Custom%20Widgets/custom_multiSelect_field.dart';
import 'package:pharma_connect/Custom%20Widgets/custom_multi_select_display.dart';
import 'package:pharma_connect/src/Address%20Search/locationSearch.dart';
import 'package:pharma_connect/src/Address%20Search/placeService.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Main/jobHistoryPharmacist.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Sign%20Up/1pharmacistSignUp.dart';
import 'package:uuid/uuid.dart';

import '../../../../all_used.dart';
import '../../login.dart';

class EditPharmacistProfile extends ConsumerStatefulWidget {
  EditPharmacistProfile({Key? key}) : super(key: key);

  @override
  _EditPharmacistProfileState createState() => _EditPharmacistProfileState();
}

class _EditPharmacistProfileState extends ConsumerState<EditPharmacistProfile> {
  Map<String, dynamic> uploadDataMap = Map();
  List<Skill?>? skillList;
  List<Software?>? softwareList;
  List<Language?>? languageList;

  List<Skill?>? skillListToUpload = [];
  List<Software?>? softwareListToUpload = [];
  List<Language?>? languageListToUpload = [];

  bool filePicked = false;
  FilePickerResult? _result;
  File? file;

  final _softwareItems = software
      .map((software) => MultiSelectItem<Software>(software, software.name))
      .toList();
  final _skillItems =
      skill.map((skill) => MultiSelectItem<Skill>(skill, skill.name)).toList();

  final _languageItems = language
      .map((language) => MultiSelectItem<Language>(language, language.name))
      .toList();

  void checkIfChanged(WidgetRef ref, String? currentVal, String firestoreVal) {
    if (currentVal ==
        ref.read(pharmacistMainProvider.notifier)
            .userDataMap?[firestoreVal]) {
      uploadDataMap.remove(firestoreVal);
    } else {
      uploadDataMap[firestoreVal] = currentVal;
    }
  }

  void changeSkillToList(String? stringList) {
    int indexOfOpenBracket = stringList!.indexOf("[");
    int indexOfLastBracket = stringList.lastIndexOf("]");
    var noBracketString =
        stringList.substring(indexOfOpenBracket + 1, indexOfLastBracket);
    List<Skill?>? templist = [];
    var list = noBracketString.split(", ");
    for (var i = 0; i < list.length; i++) {
      templist.add(Skill(id: 1, name: list[i].toString()));
    }
    setState(() {
      skillList = templist;
    });
  }

  void changeSoftwareToList(String? stringList) {
    int indexOfOpenBracket = stringList!.indexOf("[");
    int indexOfLastBracket = stringList.lastIndexOf("]");
    var noBracketString =
        stringList.substring(indexOfOpenBracket + 1, indexOfLastBracket);
    List<Software?>? templist = [];
    var list = noBracketString.split(", ");
    for (var i = 0; i < list.length; i++) {
      templist.add(Software(id: 1, name: list[i].toString()));
    }
    setState(() {
      softwareList = templist;
    });
  }

  void changeLanguageToList(String? stringList) {
    int indexOfOpenBracket = stringList!.indexOf("[");
    int indexOfLastBracket = stringList.lastIndexOf("]");
    var noBracketString =
        stringList.substring(indexOfOpenBracket + 1, indexOfLastBracket);
    List<Language?>? templist = [];
    var list = noBracketString.split(", ");
    for (var i = 0; i < list.length; i++) {
      templist.add(Language(id: 1, name: list[i].toString()));
    }
    setState(() {
      languageList = templist;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      changeSkillToList(ref.read(pharmacistMainProvider.notifier)
          .userDataMap?["knownSkills"]);
      changeLanguageToList(ref.read(pharmacistMainProvider.notifier)
          .userDataMap?["knownLanguages"]);
      changeSoftwareToList(ref.read(pharmacistMainProvider.notifier)
          .userDataMap?["knownSoftware"]);

      ref.read(pharmacistSignUpProvider.notifier).changePharmacistAddress(
          ref.read(pharmacistMainProvider.notifier)
              .userDataMap?["address"]);

      print(
          "Known Software: ${ref.read(pharmacistMainProvider.notifier).userDataMap?["knownSoftware"]}");
      ref.read(pharmacistMainProvider.notifier).clearResumePDF();

      ref.read(pharmacistSignUpProvider.notifier)
          .changeSkillList(skillList as List<Skill?>);

      ref.read(pharmacistSignUpProvider.notifier)
          .changeSoftwareList(softwareList as List<Software?>);

      ref.read(pharmacistSignUpProvider.notifier)
          .changeLanguageList(languageList as List<Language?>);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController streetAddress = TextEditingController(
        text: ref.read(pharmacistSignUpProvider.notifier).address);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 12,
            title: Text(
              "Edit Profile",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 22),
            ),
            backgroundColor: Color(0xFFF6F6F6),
          ),
          body: Consumer(
            builder: (context, ref, child) {
              ref.watch(pharmacistSignUpProvider);
              return SingleChildScrollView(
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
                                  padding:
                                      const EdgeInsets.fromLTRB(11, 10, 0, 0),
                                  child: CustomFormField(
                                    fieldTitle: "First Name",
                                    hintText: "Enter your First Name...",
                                    keyboardStyle: TextInputType.name,
                                    containerWidth:
                                        MediaQuery.of(context).size.width *
                                            0.85,
                                    titleFont: 22,
                                    onChanged: (String firstName) {
                                      ref.read(
                                              pharmacistSignUpProvider.notifier)
                                          .changeFirstName(firstName);
                                      checkIfChanged(ref, firstName, "firstName");
                                    },
                                    validation: (value) {
                                      if (!RegExp(
                                              r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                          .hasMatch(value)) {
                                        return "Invalid field";
                                      }
                                      return null;
                                    },
                                    initialValue: ref.read(pharmacistMainProvider.notifier)
                                        .userDataMap?["firstName"],
                                  ),
                                ),
                                SizedBox(height: 20),
                                //Last Name
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 0, 0, 0),
                                  child: CustomFormField(
                                    fieldTitle: "Last Name",
                                    hintText: "Enter your Last Name...",
                                    keyboardStyle: TextInputType.name,
                                    containerWidth:
                                        MediaQuery.of(context).size.width *
                                            0.85,
                                    titleFont: 22,
                                    onChanged: (String lastName) {
                                      ref.read(
                                              pharmacistSignUpProvider.notifier)
                                          .changeLastName(lastName);
                                      checkIfChanged(ref, lastName, "lastName");
                                    },
                                    validation: (value) {
                                      if (!RegExp(
                                              r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                          .hasMatch(value)) {
                                        return "Invalid field";
                                      }
                                      return null;
                                    },
                                    initialValue: ref.read(pharmacistMainProvider.notifier)
                                        .userDataMap?["lastName"],
                                  ),
                                ),
                                SizedBox(height: 20),
                                //Phone Number
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 0, 0, 0),
                                  child: CustomFormField(
                                    fieldTitle: "Phone Number",
                                    hintText: "Enter your Phone Number...",
                                    keyboardStyle: TextInputType.number,
                                    containerWidth:
                                        MediaQuery.of(context).size.width *
                                            0.85,
                                    titleFont: 22,
                                    onChanged: (String phoneNumber) {
                                      ref.read(
                                              pharmacistSignUpProvider.notifier)
                                          .changePhoneNumber(phoneNumber);
                                      checkIfChanged(
                                          ref, phoneNumber, "phoneNumber");
                                    },
                                    validation: (value) {
                                      if (value.length < 4) {
                                        return "Phone is invalid";
                                      }
                                      return null;
                                    },
                                    initialValue: ref.read(pharmacistMainProvider.notifier)
                                        .userDataMap?["phoneNumber"],
                                    formatter: [
                                      MaskedInputFormatter('(###) ###-####')
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                //Address
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 0, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        //height: 50,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0.3, 3),
                                                blurRadius: 3.0,
                                                spreadRadius: 0.5,
                                                color: Colors.grey.shade400)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                              delegate:
                                                  AddressSearch(sessionToken),
                                            );

                                            if (result != null) {
                                              final placeDetails =
                                                  await PlaceApiProvider(
                                                          sessionToken)
                                                      .getPlaceDetailFromId(
                                                          result.placeId);
                                              ref.read(pharmacistSignUpProvider
                                                      .notifier)
                                                  .changePharmacistAddress(
                                                      placeDetails
                                                              .streetNumber! +
                                                          " " +
                                                          placeDetails.street
                                                              .toString() +
                                                          ", " +
                                                          placeDetails.city
                                                              .toString() +
                                                          ", " +
                                                          placeDetails.country
                                                              .toString());
                                              checkIfChanged(
                                                  ref, placeDetails.streetNumber! +
                                                      " " +
                                                      placeDetails.street
                                                          .toString() +
                                                      ", " +
                                                      placeDetails.city
                                                          .toString() +
                                                      ", " +
                                                      placeDetails.country
                                                          .toString(),
                                                  "address");
                                              setState(() {
                                                streetAddress.text =
                                                    placeDetails.streetNumber! +
                                                        " " +
                                                        placeDetails.street
                                                            .toString() +
                                                        ", " +
                                                        placeDetails.city
                                                            .toString() +
                                                        ", " +
                                                        placeDetails.country
                                                            .toString();
                                              });
                                            }
                                          },
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                                fontWeight: FontWeight.w500),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 30),
                                            filled: true,
                                            fillColor: Color(0xFFF0F0F0),
                                            // focusedErrorBorder: OutlineInputBorder(
                                            //     borderRadius: BorderRadius.circular(8),
                                            //     borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                                            // errorBorder: OutlineInputBorder(
                                            //     borderRadius: BorderRadius.circular(8),
                                            //     borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Color(0xFFE8E8E8))),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFE8E8E8)),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            hintText: "Enter the address...",
                                            hintStyle: GoogleFonts.inter(
                                                color: Color(0xFFBDBDBD),
                                                fontSize: 16),
                                          ),
                                          style: GoogleFonts.inter(
                                              color: Colors.black,
                                              fontSize: 16),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),

                              //First Year Licensed In Canada
                              Padding(
                                padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                                child: CustomFormField(
                                  fieldTitle: "First Year Licensed in Canada",
                                  hintText: "First Year Licensed in Canada...",
                                  containerWidth:
                                      MediaQuery.of(context).size.width * 0.85,
                                  titleFont: 22,
                                  keyboardStyle: TextInputType.number,
                                  onChanged: (String licenseYear) {
                                    checkIfChanged(
                                        ref, licenseYear, "firstYearLicensed");

                                    ref.read(pharmacistSignUpProvider.notifier)
                                        .changeFirstYearLicensed(licenseYear);
                                  },
                                  validation: (value) {
                                    if (!RegExp(r"^(19|20)\d{2}$")
                                        .hasMatch(value)) {
                                      return "Incorrect year format";
                                    }
                                    return null;
                                  },
                                  initialValue: ref.read(pharmacistMainProvider.notifier)
                                      .userDataMap?["firstYearLicensed"],
                                ),
                              ),
                              SizedBox(height: 20),

                              //Registration Number
                              Padding(
                                padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                                child: CustomFormField(
                                  fieldTitle: "Registration Number",
                                  hintText: "Registration Number...",
                                  keyboardStyle: TextInputType.number,
                                  containerWidth:
                                      MediaQuery.of(context).size.width * 0.85,
                                  titleFont: 22,
                                  onChanged: (String registrationNumber) {
                                    checkIfChanged(ref, registrationNumber,
                                        "registrationNumber");
                                    ref.read(pharmacistSignUpProvider.notifier)
                                        .changeRegistrationNumber(
                                            registrationNumber);
                                  },
                                  validation: (value) {
                                    if (value.length < 5) {
                                      return "Registration Number must be greater then 5 characters";
                                    }
                                    return null;
                                  },
                                  initialValue: ref.read(pharmacistMainProvider.notifier)
                                      .userDataMap?["registrationNumber"],
                                ),
                              ),
                              SizedBox(height: 20),

                              //Province of Registration
                              Padding(
                                padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                                child: CustomFormField(
                                  fieldTitle: "Registration Province",
                                  hintText: "Registration Province...",
                                  keyboardStyle: TextInputType.streetAddress,
                                  containerWidth:
                                      MediaQuery.of(context).size.width * 0.85,
                                  titleFont: 22,
                                  onChanged: (String registrationProvince) {
                                    checkIfChanged(ref, registrationProvince,
                                        "registrationProvince");
                                    ref.read(pharmacistSignUpProvider.notifier)
                                        .changeRegistrationProvince(
                                            registrationProvince);
                                  },
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  initialValue: ref.read(pharmacistMainProvider.notifier)
                                      .userDataMap?["registrationProvince"],
                                ),
                              ),
                              SizedBox(height: 20),

                              //Year of Graduation
                              Padding(
                                padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                                child: CustomFormField(
                                  fieldTitle: "Graduation Year",
                                  hintText: "Graduation Year...",
                                  keyboardStyle: TextInputType.number,
                                  containerWidth:
                                      MediaQuery.of(context).size.width * 0.85,
                                  titleFont: 22,
                                  onChanged: (String graduationYear) {
                                    checkIfChanged(
                                        ref, graduationYear, "gradutationYear");
                                    ref.read(pharmacistSignUpProvider.notifier)
                                        .changeGraduationYear(graduationYear);
                                  },
                                  validation: (value) {
                                    if (!RegExp(r"^(19|20)\d{2}$")
                                        .hasMatch(value)) {
                                      return "Incorrect year format";
                                    }
                                    return null;
                                  },
                                  initialValue: ref.read(pharmacistMainProvider.notifier)
                                      .userDataMap?["gradutationYear"],
                                ),
                              ),
                              SizedBox(height: 20),

                              //Instituation Name
                              Padding(
                                padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                                child: CustomFormField(
                                  fieldTitle: "Instituation Name",
                                  hintText: "Instituation Name...",
                                  keyboardStyle: TextInputType.streetAddress,
                                  containerWidth:
                                      MediaQuery.of(context).size.width * 0.85,
                                  titleFont: 22,
                                  onChanged: (String institutionName) {
                                    checkIfChanged(
                                        ref, institutionName, "institutionName");

                                    ref.read(pharmacistSignUpProvider.notifier)
                                        .changeInstitutionName(institutionName);
                                  },
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  initialValue: ref.read(pharmacistMainProvider.notifier)
                                      .userDataMap?["institutionName"],
                                ),
                              ),
                              SizedBox(height: 20),

                              //Years of Working experience
                              Padding(
                                padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                                child: CustomFormField(
                                  fieldTitle: "Years of Working experience",
                                  hintText: "Number of years...",
                                  keyboardStyle: TextInputType.number,
                                  containerWidth:
                                      MediaQuery.of(context).size.width * 0.85,
                                  titleFont: 22,
                                  onChanged: (String workingExperience) {
                                    checkIfChanged(
                                        ref, workingExperience, "workingExperience");
                                    ref.read(pharmacistSignUpProvider.notifier)
                                        .changeWorkingExperience(
                                            workingExperience);
                                  },
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  initialValue: ref.read(pharmacistMainProvider.notifier)
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
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
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
                                          CustomMultiSelectBottomSheetField<
                                              Software?>(
                                            selectedColor: Color(0xFF5DB075),
                                            selectedItemsTextStyle:
                                                TextStyle(color: Colors.white),
                                            initialChildSize: 0.4,
                                            decoration: BoxDecoration(),
                                            listType: MultiSelectListType.CHIP,
                                            initialValue: ref.read(pharmacistSignUpProvider
                                                    .notifier)
                                                .softwareList,
                                            searchable: true,
                                            items: _softwareItems,
                                            buttonText: Text(
                                                "Select known software...",
                                                style: GoogleFonts.inter(
                                                    color: Color(0xFFBDBDBD),
                                                    fontSize: 16)),
                                            onConfirm: (values) {
                                              softwareListToUpload
                                                  ?.addAll(values);
                                              ref.read(pharmacistSignUpProvider
                                                      .notifier)
                                                  .changeSoftwareList(values);
                                            },
                                            chipDisplay:
                                                CustomMultiSelectChipDisplay(
                                              items: ref.read(pharmacistSignUpProvider
                                                      .notifier)
                                                  .softwareList
                                                  ?.map((e) => MultiSelectItem(
                                                      e, e.toString()))
                                                  .toList(),
                                              chipColor: Color(0xFF5DB075),
                                              onTap: (value) {
                                                softwareListToUpload
                                                    ?.remove(value);
                                                softwareListToUpload
                                                    ?.removeWhere((element) =>
                                                        element?.name
                                                            .toString() ==
                                                        value.toString());
                                                ref.read(
                                                        pharmacistSignUpProvider
                                                            .notifier)
                                                    .softwareList
                                                    ?.cast()
                                                    .remove(value);
                                                ref.read(
                                                        pharmacistSignUpProvider
                                                            .notifier)
                                                    .softwareList
                                                    ?.removeWhere((element) =>
                                                        element?.name
                                                            .toString() ==
                                                        value.toString());

                                                return ref.read(
                                                        pharmacistSignUpProvider
                                                            .notifier)
                                                    .softwareList;
                                              },
                                              textStyle: TextStyle(
                                                  color: Colors.white),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
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
                                          CustomMultiSelectBottomSheetField<
                                              Skill?>(
                                            selectedColor: Color(0xFF5DB075),
                                            selectedItemsTextStyle:
                                                TextStyle(color: Colors.white),
                                            initialChildSize: 0.4,
                                            decoration: BoxDecoration(),
                                            listType: MultiSelectListType.CHIP,
                                            initialValue: ref.read(pharmacistSignUpProvider
                                                    .notifier)
                                                .skillList,
                                            searchable: true,
                                            items: _skillItems,
                                            buttonText: Text(
                                                "Select your skills...",
                                                style: GoogleFonts.inter(
                                                    color: Color(0xFFBDBDBD),
                                                    fontSize: 16)),
                                            onConfirm: (values) {
                                              skillListToUpload?.addAll(values);
                                              ref.read(pharmacistSignUpProvider
                                                      .notifier)
                                                  .changeSkillList(values);
                                            },
                                            chipDisplay:
                                                CustomMultiSelectChipDisplay(
                                              items: ref.read(pharmacistSignUpProvider
                                                      .notifier)
                                                  .skillList
                                                  ?.map((e) => MultiSelectItem(
                                                      e, e.toString()))
                                                  .toList(),
                                              chipColor: Color(0xFF5DB075),
                                              onTap: (value) {
                                                skillListToUpload
                                                    ?.remove(value);
                                                skillListToUpload?.removeWhere(
                                                    (element) =>
                                                        element?.name
                                                            .toString() ==
                                                        value.toString());
                                                ref.read(
                                                        pharmacistSignUpProvider
                                                            .notifier)
                                                    .skillList
                                                    ?.cast()
                                                    .remove(value);
                                                ref.read(
                                                        pharmacistSignUpProvider
                                                            .notifier)
                                                    .skillList
                                                    ?.removeWhere((element) =>
                                                        element?.name
                                                            .toString() ==
                                                        value.toString());
                                                return ref.read(
                                                        pharmacistSignUpProvider
                                                            .notifier)
                                                    .skillList;
                                              },
                                              textStyle: TextStyle(
                                                  color: Colors.white),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
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
                                          CustomMultiSelectBottomSheetField<
                                              Language?>(
                                            selectedColor: Color(0xFF5DB075),
                                            selectedItemsTextStyle:
                                                TextStyle(color: Colors.white),
                                            initialChildSize: 0.4,
                                            decoration: BoxDecoration(),
                                            listType: MultiSelectListType.CHIP,
                                            initialValue: ref.read(pharmacistSignUpProvider
                                                    .notifier)
                                                .languageList,
                                            searchable: true,
                                            items: _languageItems,
                                            buttonText: Text(
                                                "Select known languages...",
                                                style: GoogleFonts.inter(
                                                    color: Color(0xFFBDBDBD),
                                                    fontSize: 16)),
                                            onConfirm: (values) {
                                              languageListToUpload
                                                  ?.addAll(values);
                                              ref.read(pharmacistSignUpProvider
                                                      .notifier)
                                                  .changeLanguageList(values);
                                            },
                                            chipDisplay:
                                                CustomMultiSelectChipDisplay(
                                              items: ref.read(pharmacistSignUpProvider
                                                      .notifier)
                                                  .languageList
                                                  ?.map((e) => MultiSelectItem(
                                                      e, e.toString()))
                                                  .toList(),
                                              chipColor: Color(0xFF5DB075),
                                              onTap: (value) {
                                                languageListToUpload
                                                    ?.remove(value);
                                                languageListToUpload
                                                    ?.removeWhere((element) =>
                                                        element?.name
                                                            .toString() ==
                                                        value.toString());
                                                ref.read(
                                                        pharmacistSignUpProvider
                                                            .notifier)
                                                    .languageList
                                                    ?.remove(value);
                                                ref.read(
                                                        pharmacistSignUpProvider
                                                            .notifier)
                                                    .languageList
                                                    ?.removeWhere((element) =>
                                                        element?.name
                                                            .toString() ==
                                                        value.toString());
                                                return ref.read(
                                                        pharmacistSignUpProvider
                                                            .notifier)
                                                    .languageList;
                                              },
                                              textStyle: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),

                                //Resume
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                          text: "Resume (PDF Only)",
                                          style: GoogleFonts.questrial(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                    SizedBox(height: 10),
                                    if (ref.read(
                                                pharmacistMainProvider.notifier)
                                            .resumePDFData !=
                                        null)
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 170,
                                            height: 45,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .resolveWith<Color>(
                                                              (states) {
                                                    return Color(
                                                        0xFF5DB075); // Regular color
                                                  }),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ))),
                                              onPressed: () async {
                                                file = ref.read(pharmacistMainProvider
                                                        .notifier)
                                                    .resumePDFData;
                                                print("FILE PATH: " +
                                                    file!.path.toString());
                                                OpenFile.open(file!.path);
                                              },
                                              child: RichText(
                                                text: TextSpan(
                                                  text: "View Resume",
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
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .resolveWith<Color>(
                                                              (states) {
                                                    return Color(
                                                        0xFF5DB075); // Regular color
                                                  }),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ))),
                                              onPressed: () async {
                                                setState(() {
                                                  _result = null;
                                                  file = null;
                                                });

                                                ref.read(pharmacistMainProvider
                                                        .notifier)
                                                    .clearResumePDF();
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
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                          (states) {
                                                return Color(
                                                    0xFF5DB075); // Regular color
                                              }),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ))),
                                          onPressed: () async {
                                            try {
                                              _result = await FilePicker
                                                  .platform
                                                  .pickFiles(
                                                type: FileType.custom,
                                                allowedExtensions: ['pdf'],
                                                //withData: true,
                                              );
                                              if (_result?.files.first.path !=
                                                  null) {
                                                setState(() {
                                                  filePicked = true;
                                                });
                                                file = File(_result!
                                                    .files.first.path
                                                    .toString());

                                                ref.read(pharmacistMainProvider
                                                        .notifier)
                                                    .changeResumePDF(file);
                                                print(ref.read(pharmacistMainProvider
                                                        .notifier)
                                                    .resumePDFData);
                                              } else {
                                                // User canceled the picker
                                              }
                                            } catch (error) {
                                              print(
                                                  "ERROR: " + error.toString());
                                              final snackBar = SnackBar(
                                                content: Text(
                                                    'There was an error, please try again.'),
                                                duration: Duration(seconds: 3),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              text: "Select Resume",
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
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //Save Button
                    Center(
                      child: SizedBox(
                        width: 324,
                        height: 51,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Color(0xFF5DB075);
                                  else if (states
                                      .contains(MaterialState.disabled))
                                    return Colors.grey;
                                  return Color(
                                      0xFF5DB075); // Use the component's default.
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ))),
                          onPressed: (uploadDataMap.isNotEmpty ||
                                  softwareListToUpload!.isNotEmpty ||
                                  skillListToUpload!.isNotEmpty ||
                                  languageListToUpload!.isNotEmpty ||
                                  ref.read(pharmacistMainProvider.notifier)
                                          .resumePDFData !=
                                      null)
                              ? () async {
                                  print(ref.read(pharmacistSignUpProvider.notifier)
                                      .skillList);
                                  if (ref.read(
                                              pharmacistSignUpProvider.notifier)
                                          .softwareList !=
                                      null) {
                                    uploadDataMap["knownSoftware"] = ref.read(pharmacistSignUpProvider.notifier)
                                        .softwareList
                                        .toString();
                                  }
                                  if (ref.read(
                                              pharmacistSignUpProvider.notifier)
                                          .skillList !=
                                      null) {
                                    uploadDataMap["knownSkills"] = ref.read(pharmacistSignUpProvider.notifier)
                                        .skillList
                                        .toString();
                                  }
                                  if (ref.read(
                                              pharmacistSignUpProvider.notifier)
                                          .languageList !=
                                      null) {
                                    uploadDataMap["knownLanguages"] = ref.read(pharmacistSignUpProvider.notifier)
                                        .languageList
                                        .toString();
                                  }
                                  if (ref.read(pharmacistMainProvider.notifier)
                                          .resumePDFData !=
                                      null) {
                                    String resumePDFURL = await ref.read(authProviderMain.notifier)
                                        .saveAsset(
                                            ref.read(pharmacistMainProvider
                                                    .notifier)
                                                .resumePDFData,
                                            ref.read(
                                                    userProviderLogin.notifier)
                                                .userUID,
                                            "Resume",
                                            ref.read(pharmacistMainProvider
                                                    .notifier)
                                                .userDataMap?["firstName"]);
                                    uploadDataMap["resumeDownloadURL"] =
                                        resumePDFURL;
                                  }
                                  print("Upload Data Map: $uploadDataMap");

                                  String? result = await ref.read(authProviderMain.notifier)
                                      .updatePharmacistUserInformation(
                                          ref.read(userProviderLogin.notifier)
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
              );
            },
          )),
    );
  }
}
