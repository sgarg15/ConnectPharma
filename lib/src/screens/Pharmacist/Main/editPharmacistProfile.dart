import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:connectpharma/Custom%20Widgets/custom_multiSelect_field.dart';
import 'package:connectpharma/Custom%20Widgets/custom_multi_select_display.dart';
import 'package:connectpharma/src/Address%20Search/locationSearch.dart';
import 'package:connectpharma/src/Address%20Search/placeService.dart';
import 'package:connectpharma/src/screens/Pharmacist/Main/jobHistoryPharmacist.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign%20Up/1pharmacistSignUp.dart';
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

  List<Skill?>? skillListToUpload = [];
  List<Software?>? softwareListToUpload = [];
  List<Language?>? languageListToUpload = [];

  bool filePicked = false;
  FilePickerResult? _result;
  File? file;

  final _softwareItems =
      software.map((software) => MultiSelectItem<Software>(software, software.name)).toList();

  final _skillItems = skill.map((skill) => MultiSelectItem<Skill>(skill, skill.name)).toList();

  final _languageItems =
      language.map((language) => MultiSelectItem<Language>(language, language.name)).toList();

  void checkIfChanged(WidgetRef ref, String? currentVal, String firestoreVal) {
    if (currentVal == ref.read(pharmacistMainProvider.notifier).userDataMap?[firestoreVal]) {
      uploadDataMap.remove(firestoreVal);
    } else {
      uploadDataMap[firestoreVal] = currentVal;
    }
  }

  TextEditingController streetAddressController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // List<dynamic> dynamicSoftwareList =
      //     ref.read(pharmacistMainProvider.notifier).userDataMap?["knownSoftware"];

      // List<Software?> softwareList =
      //     dynamicSoftwareList.map((e) => Software(id: 1, name: e)).toList();

      // log(softwareList.runtimeType.toString(), name: "softwareList Runtime Type");
      // log("SoftwareListToUpload: $softwareListToUpload", name: "SoftwareListToUpload");

      streetAddressController.text =
          ref.read(pharmacistMainProvider.notifier).userDataMap?["address"];

      ref.read(userSignUpProvider.notifier).changePharmacistAddress(
          ref.read(pharmacistMainProvider.notifier).userDataMap?["address"]);

      print(
          "Known Software: ${ref.read(pharmacistMainProvider.notifier).userDataMap?["knownSoftware"]}");
      ref.read(pharmacistMainProvider.notifier).clearResumePDF();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic>? softwareList =
        ref.read(pharmacistMainProvider.notifier).userDataMap?["knownSoftware"];
    List<dynamic>? skillList =
        ref.read(pharmacistMainProvider.notifier).userDataMap?["knownSkills"];
    List<dynamic>? languageList =
        ref.read(pharmacistMainProvider.notifier).userDataMap?["knownLanguages"];

    Map<String, dynamic>? userData = ref.read(pharmacistMainProvider.notifier).userDataMap;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0,
            title: new Text(
              "Edit Profile",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily,
              ),
            ),
            backgroundColor: Color(0xFF0069C1),
            foregroundColor: Colors.white,
            bottomOpacity: 1,
            shadowColor: Colors.white,
          ),
          backgroundColor: Color(0xFF0069C1),
          body: Consumer(
            builder: (context, ref, child) {
              ref.watch(userSignUpProvider);
              return GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //Photo/Name
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            minRadius: 10,
                            maxRadius: 55,
                            child: CircleAvatar(
                                minRadius: 5,
                                maxRadius: 52,
                                backgroundImage:
                                    NetworkImage(userData?["profilePhotoDownloadURL"])),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 20, 10, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                    text: "Account Information",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      color: Color(0xFF505050),
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                              SizedBox(height: 15),
                              //First Name
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(
                                            text: "First Name",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.5,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    TextFormField(
                                      keyboardType: TextInputType.name,
                                      textCapitalization: TextCapitalization.words,
                                      onChanged: (String firstName) {
                                        ref
                                            .read(userSignUpProvider.notifier)
                                            .changeFirstName(firstName);
                                        checkIfChanged(ref, firstName, "firstName");
                                      },
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                      ),
                                      validator: (value) {
                                        if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                            .hasMatch(value ?? "")) {
                                          return "Invalid field";
                                        }
                                        return null;
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      initialValue: userData?["firstName"],
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: "Enter your first name",
                                        hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFFC6C6C6),
                                          fontFamily:
                                              GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                                  .fontFamily,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              //Last Name
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(
                                            text: "Last Name",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.5,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    TextFormField(
                                      keyboardType: TextInputType.name,
                                      textCapitalization: TextCapitalization.words,
                                      onChanged: (String lastName) {
                                        ref
                                            .read(userSignUpProvider.notifier)
                                            .changeLastName(lastName);
                                        checkIfChanged(ref, lastName, "lastName");
                                      },
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                      ),
                                      validator: (value) {
                                        if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                            .hasMatch(value ?? "")) {
                                          return "Invalid field";
                                        }
                                        return null;
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      initialValue: userData?["lastName"],
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: "Enter your last name",
                                        hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFFC6C6C6),
                                          fontFamily:
                                              GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                                  .fontFamily,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              //Phone Number
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(
                                            text: "Phone Number",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.5,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    TextFormField(
                                      keyboardType: TextInputType.phone,
                                      onChanged: (String phoneNumber) {
                                        ref
                                            .read(userSignUpProvider.notifier)
                                            .changePhoneNumber(phoneNumber);
                                        checkIfChanged(ref, phoneNumber, "phoneNumber");
                                      },
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                      ),
                                      validator: (value) {
                                        if (!RegExp(r"^[0-9]{10}$").hasMatch(value ?? "")) {
                                          return "Invalid field";
                                        }
                                        return null;
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      initialValue: userData?["phoneNumber"],
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: "Enter your phone number",
                                        hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFFC6C6C6),
                                          fontFamily:
                                              GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                                  .fontFamily,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              //Address
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(
                                            text: "Address",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.5,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.85,
                                      //height: 50,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: streetAddressController,
                                        onTap: () async {
                                          final sessionToken = Uuid().v4();
                                          final Suggestion? result = await showSearch<Suggestion?>(
                                            context: context,
                                            delegate: AddressSearch(sessionToken),
                                          );

                                          if (result != null) {
                                            final placeDetails =
                                                await PlaceApiProvider(sessionToken)
                                                    .getPlaceDetailFromId(result.placeId);
                                            ref
                                                .read(userSignUpProvider.notifier)
                                                .changePharmacistAddress(
                                                    placeDetails.streetNumber! +
                                                        " " +
                                                        placeDetails.street.toString() +
                                                        ", " +
                                                        placeDetails.city.toString() +
                                                        ", " +
                                                        placeDetails.country.toString());
                                            checkIfChanged(
                                                ref,
                                                placeDetails.streetNumber! +
                                                    " " +
                                                    placeDetails.street.toString() +
                                                    ", " +
                                                    placeDetails.city.toString() +
                                                    ", " +
                                                    placeDetails.country.toString(),
                                                "address");
                                            setState(() {
                                              streetAddressController.text =
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
                                          isDense: true,
                                          errorStyle: TextStyle(fontWeight: FontWeight.w500),
                                          hintText: "Enter the street address...",
                                          hintStyle: GoogleFonts.montserrat(
                                              color: Color(0xFF505050), fontSize: 15),
                                        ),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          color: Color(0xFF505050),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              //First Year Licensed
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: "First Year Licensed",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.5,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    TextFormField(
                                      keyboardType: TextInputType.phone,
                                      onChanged: (String licenseYear) {
                                        checkIfChanged(ref, licenseYear, "firstYearLicensed");

                                        ref
                                            .read(userSignUpProvider.notifier)
                                            .changeFirstYearLicensed(licenseYear);
                                      },
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                      ),
                                      validator: (value) {
                                        if (!RegExp(r"^(19|20)\d{2}$").hasMatch(value!)) {
                                          return "Incorrect year format";
                                        }
                                        return null;
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      initialValue: userData?["firstYearLicensed"],
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: "Enter the first year licensed",
                                        hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFFC6C6C6),
                                          fontFamily:
                                              GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                                  .fontFamily,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              //Registration Number
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: "Registration Number",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.5,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    TextFormField(
                                      keyboardType: TextInputType.phone,
                                      onChanged: (String registrationNumber) {
                                        checkIfChanged(
                                            ref, registrationNumber, "registrationNumber");
                                        ref
                                            .read(userSignUpProvider.notifier)
                                            .changeRegistrationNumber(registrationNumber);
                                      },
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                      ),
                                      validator: (value) {
                                        if (!RegExp(r"^[0-9]+$").hasMatch(value!)) {
                                          return "Incorrect registration number format";
                                        }
                                        return null;
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      initialValue: userData?["registrationNumber"],
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: "Enter the registration number",
                                        hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFFC6C6C6),
                                          fontFamily:
                                              GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                                  .fontFamily,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              //Registration Province
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: "Registration Province",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.5,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    TextFormField(
                                      onChanged: (String registrationProvince) {
                                        checkIfChanged(
                                            ref, registrationProvince, "registrationProvince");
                                        ref
                                            .read(userSignUpProvider.notifier)
                                            .changeRegistrationProvince(registrationProvince);
                                      },
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                      ),
                                      validator: (value) {
                                        if (value!.length < 4) {
                                          return "Please enter the full registration province";
                                        }
                                        return null;
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      initialValue: userData?["registrationProvince"],
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: "Enter the registration province",
                                        hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFFC6C6C6),
                                          fontFamily:
                                              GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                                  .fontFamily,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              //Gradutation Year
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: "Graduation Year",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.5,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    TextFormField(
                                      keyboardType: TextInputType.phone,
                                      onChanged: (String graduationYear) {
                                        checkIfChanged(ref, graduationYear, "gradutationYear");
                                        ref
                                            .read(userSignUpProvider.notifier)
                                            .changeGraduationYear(graduationYear);
                                      },
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                      ),
                                      validator: (value) {
                                        if (!RegExp(r"^(19|20)\d{2}$").hasMatch(value!)) {
                                          return "Incorrect year format";
                                        }
                                        return null;
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      initialValue: userData?["gradutationYear"],
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: "Enter the graduation year",
                                        hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFFC6C6C6),
                                          fontFamily:
                                              GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                                  .fontFamily,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              //Institution Name
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: "Institution Name",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.5,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    TextFormField(
                                      onChanged: (String institutionName) {
                                        checkIfChanged(ref, institutionName, "institutionName");
                                        ref
                                            .read(userSignUpProvider.notifier)
                                            .changeInstitutionName(institutionName);
                                      },
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                      ),
                                      validator: (value) {
                                        if (value!.length < 4) {
                                          return "Please enter the full institution name";
                                        }
                                        return null;
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      initialValue: userData?["institutionName"],
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: "Enter the institution name",
                                        hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFFC6C6C6),
                                          fontFamily:
                                              GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                                  .fontFamily,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              //Year of Working Experience
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: "Year of Working Experience",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.5,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    TextFormField(
                                      keyboardType: TextInputType.phone,
                                      onChanged: (String workingExperience) {
                                        checkIfChanged(ref, workingExperience, "workingExperience");
                                        ref
                                            .read(userSignUpProvider.notifier)
                                            .changeWorkingExperience(workingExperience);
                                      },
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                      ),
                                      validator: (value) {
                                        if (!RegExp(r"^(19|20)\d{2}$").hasMatch(value!)) {
                                          return "Incorrect year format";
                                        }
                                        return null;
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      initialValue: userData?["workingExperience"],
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: "Enter the working experience",
                                        hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFFC6C6C6),
                                          fontFamily:
                                              GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                                  .fontFamily,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              //Software
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(
                                            text: "Software",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.5,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    Column(
                                      children: <Widget>[
                                        CustomMultiSelectBottomSheetField<Software?>(
                                          selectedColor: Color(0xFF0069C1),
                                          selectedItemsTextStyle: TextStyle(color: Colors.white),
                                          initialChildSize: 0.4,
                                          decoration: BoxDecoration(),
                                          listType: MultiSelectListType.CHIP,
                                          initialValue: softwareList
                                              ?.map((e) => new Software(id: 1, name: e))
                                              .toList(),
                                          searchable: true,
                                          items: _softwareItems,
                                          buttonText: Text("Select know software...",
                                              style: GoogleFonts.inter(
                                                  color: Color(0xFFBDBDBD), fontSize: 16)),
                                          onConfirm: (values) {
                                            softwareListToUpload?.addAll(values);
                                            ref
                                                .read(userSignUpProvider.notifier)
                                                .changeSoftwareList(values);
                                          },
                                          chipDisplay: CustomMultiSelectChipDisplay(
                                            items: ref
                                                .read(userSignUpProvider.notifier)
                                                .softwareList
                                                ?.map((e) => MultiSelectItem(e, e.toString()))
                                                .toList(),
                                            chipColor: Color(0xFF0069C1),
                                            onTap: (value) {
                                              softwareListToUpload?.remove(value);
                                              softwareListToUpload?.removeWhere((element) =>
                                                  element?.name.toString() == value.toString());
                                              ref
                                                  .read(userSignUpProvider.notifier)
                                                  .softwareList
                                                  ?.cast()
                                                  .remove(value);
                                              ref
                                                  .read(userSignUpProvider.notifier)
                                                  .softwareList
                                                  ?.removeWhere((element) =>
                                                      element?.name.toString() == value.toString());

                                              return ref
                                                  .read(userSignUpProvider.notifier)
                                                  .softwareList;
                                            },
                                            textStyle: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Divider(
                                          color: Color(0xFFC6C6C6),
                                          thickness: 1,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              //Skills
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(
                                            text: "Skills",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.5,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    Column(
                                      children: <Widget>[
                                        CustomMultiSelectBottomSheetField<Skill?>(
                                          selectedColor: Color(0xFF0069C1),
                                          selectedItemsTextStyle: TextStyle(color: Colors.white),
                                          initialChildSize: 0.4,
                                          decoration: BoxDecoration(),
                                          listType: MultiSelectListType.CHIP,
                                          initialValue: skillList
                                              ?.map((e) => new Skill(id: 1, name: e))
                                              .toList(),
                                          searchable: true,
                                          items: _skillItems,
                                          buttonText: Text("Select known skills...",
                                              style: GoogleFonts.inter(
                                                  color: Color(0xFFBDBDBD), fontSize: 16)),
                                          onConfirm: (values) {
                                            skillListToUpload?.addAll(values);
                                            ref
                                                .read(userSignUpProvider.notifier)
                                                .changeSkillList(values);
                                          },
                                          chipDisplay: CustomMultiSelectChipDisplay(
                                            items: ref
                                                .read(userSignUpProvider.notifier)
                                                .skillList
                                                ?.map((e) => MultiSelectItem(e, e.toString()))
                                                .toList(),
                                            chipColor: Color(0xFF0069C1),
                                            onTap: (value) {
                                              skillListToUpload?.remove(value);
                                              skillListToUpload?.removeWhere((element) =>
                                                  element?.name.toString() == value.toString());
                                              ref
                                                  .read(userSignUpProvider.notifier)
                                                  .skillList
                                                  ?.cast()
                                                  .remove(value);
                                              ref
                                                  .read(userSignUpProvider.notifier)
                                                  .skillList
                                                  ?.removeWhere((element) =>
                                                      element?.name.toString() == value.toString());

                                              return ref
                                                  .read(userSignUpProvider.notifier)
                                                  .skillList;
                                            },
                                            textStyle: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Divider(
                                          color: Color(0xFFC6C6C6),
                                          thickness: 1,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              //Languages
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(
                                            text: "Languages",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.5,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    Column(
                                      children: <Widget>[
                                        CustomMultiSelectBottomSheetField<Language?>(
                                          selectedColor: Color(0xFF0069C1),
                                          selectedItemsTextStyle: TextStyle(color: Colors.white),
                                          initialChildSize: 0.4,
                                          decoration: BoxDecoration(),
                                          listType: MultiSelectListType.CHIP,
                                          initialValue: languageList
                                              ?.map((e) => new Language(id: 1, name: e))
                                              .toList(),
                                          searchable: true,
                                          items: _languageItems,
                                          buttonText: Text("Select known languages...",
                                              style: GoogleFonts.inter(
                                                  color: Color(0xFFBDBDBD), fontSize: 16)),
                                          onConfirm: (values) {
                                            languageListToUpload?.addAll(values);
                                            ref
                                                .read(userSignUpProvider.notifier)
                                                .changeLanguageList(values);
                                          },
                                          chipDisplay: CustomMultiSelectChipDisplay(
                                            items: ref
                                                .read(userSignUpProvider.notifier)
                                                .languageList
                                                ?.map((e) => MultiSelectItem(e, e.toString()))
                                                .toList(),
                                            chipColor: Color(0xFF0069C1),
                                            onTap: (value) {
                                              languageListToUpload?.remove(value);
                                              languageListToUpload?.removeWhere((element) =>
                                                  element?.name.toString() == value.toString());
                                              ref
                                                  .read(userSignUpProvider.notifier)
                                                  .languageList
                                                  ?.cast()
                                                  .remove(value);
                                              ref
                                                  .read(userSignUpProvider.notifier)
                                                  .languageList
                                                  ?.removeWhere((element) =>
                                                      element?.name.toString() == value.toString());

                                              return ref
                                                  .read(userSignUpProvider.notifier)
                                                  .languageList;
                                            },
                                            textStyle: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Divider(
                                          color: Color(0xFFC6C6C6),
                                          thickness: 1,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                              ),
                              //Resume
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(
                                            text: "Resume (PDF only)",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.5,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w500,
                                            ))),
                                    SizedBox(height: 10),
                                    if (ref.read(pharmacistMainProvider.notifier).resumePDFData !=
                                        null)
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 45,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.resolveWith<Color>(
                                                          (states) {
                                                    return Color(0xFFF0069C1); // Regular color
                                                  }),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ))),
                                              onPressed: () async {
                                                file = ref
                                                    .read(pharmacistMainProvider.notifier)
                                                    .resumePDFData;
                                                print("FILE PATH: " + file!.path.toString());
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
                                          SizedBox(
                                            height: 45,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.resolveWith<Color>(
                                                          (states) {
                                                    return Color(0xFFF0069C1); // Regular color
                                                  }),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ))),
                                              onPressed: () async {
                                                setState(() {
                                                  _result = null;
                                                  file = null;
                                                });

                                                ref
                                                    .read(pharmacistMainProvider.notifier)
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
                                        height: 45,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.resolveWith<Color>(
                                                      (states) {
                                                return Color(0xFFF0069C1); // Regular color
                                              }),
                                              shape:
                                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ))),
                                          onPressed: () async {
                                            try {
                                              _result = await FilePicker.platform.pickFiles(
                                                type: FileType.custom,
                                                allowedExtensions: ['pdf'],
                                                //withData: true,
                                              );
                                              if (_result?.files.first.path != null) {
                                                setState(() {
                                                  filePicked = true;
                                                });
                                                file = File(_result!.files.first.path.toString());

                                                ref
                                                    .read(pharmacistMainProvider.notifier)
                                                    .changeResumePDF(file);
                                                print(ref
                                                    .read(pharmacistMainProvider.notifier)
                                                    .resumePDFData);
                                              } else {
                                                // User canceled the picker
                                              }
                                            } catch (error) {
                                              print("ERROR: " + error.toString());
                                              final snackBar = SnackBar(
                                                content:
                                                    Text('There was an error, please try again.'),
                                                duration: Duration(seconds: 3),
                                                behavior: SnackBarBehavior.floating,
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                              ),
                              SizedBox(height: 30),
                              //Save
                              Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.85,
                                  height: 51,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(MaterialState.pressed)) {
                                              return Color(0xFF0069C1);
                                            } else if (states.contains(MaterialState.disabled)) {
                                              return Colors.grey;
                                            }
                                            return Color(0xFF0069C1);
                                          },
                                        ),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ))),
                                    onPressed: (uploadDataMap.isNotEmpty ||
                                            softwareListToUpload!.isNotEmpty ||
                                            skillListToUpload!.isNotEmpty ||
                                            languageListToUpload!.isNotEmpty ||
                                            ref
                                                    .read(pharmacistMainProvider.notifier)
                                                    .resumePDFData !=
                                                null)
                                        ? () async {
                                            print(ref
                                                .read(userSignUpProvider.notifier)
                                                .skillList);
                                            print(uploadDataMap);
                                            if (ref
                                                    .read(userSignUpProvider.notifier)
                                                    .softwareList !=
                                                null) {
                                              uploadDataMap["knownSoftware"] = ref
                                                  .read(userSignUpProvider.notifier)
                                                  .softwareList
                                                  ?.map((e) => e?.name)
                                                  .toList();
                                            }
                                            if (ref
                                                    .read(userSignUpProvider.notifier)
                                                    .skillList !=
                                                null) {
                                              uploadDataMap["knownSkills"] = ref
                                                  .read(userSignUpProvider.notifier)
                                                  .skillList
                                                  ?.map((e) => e?.name)
                                                  .toList();
                                            }
                                            if (ref
                                                    .read(userSignUpProvider.notifier)
                                                    .languageList !=
                                                null) {
                                              uploadDataMap["knownLanguages"] = ref
                                                  .read(userSignUpProvider.notifier)
                                                  .languageList
                                                  ?.map((e) => e?.name)
                                                  .toList();
                                            }
                                            if (ref
                                                    .read(pharmacistMainProvider.notifier)
                                                    .resumePDFData !=
                                                null) {
                                              print("Resume PDF DATA: ");
                                              print(ref
                                                  .read(pharmacistMainProvider.notifier)
                                                  .resumePDFData);
                                              String resumePDFURL = await ref
                                                  .read(authProviderMain.notifier)
                                                  .saveAsset(
                                                      ref
                                                          .read(pharmacistMainProvider.notifier)
                                                          .resumePDFData,
                                                      ref.read(userProviderLogin.notifier).userUID,
                                                      "Resume",
                                                      ref
                                                          .read(pharmacistMainProvider.notifier)
                                                          .userDataMap?["firstName"]);
                                              uploadDataMap["resumeDownloadURL"] = resumePDFURL;
                                            }
                                            log("Upload Data Map: $uploadDataMap",
                                                name: "Final Pharmacist Edit Upload Map");

                                            String? result = await ref
                                                .read(authProviderMain.notifier)
                                                .updatePharmacistUserInformation(
                                                    ref.read(userProviderLogin.notifier).userUID,
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
                                                                color: Color(0xFFF0069C1)),
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
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}

/**
 SingleChildScrollView(
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
                    color: Color(0xFFF0069C1),
                  ),
                  //First Name
                  Padding(
                    padding: const EdgeInsets.fromLTRB(11, 10, 0, 0),
                    child: CustomFormField(
                      fieldTitle: "First Name",
                      hintText: "Enter your First Name...",
                      keyboardStyle: TextInputType.name,
                      containerWidth: MediaQuery.of(context).size.width * 0.85,
                      titleFont: 22,
                      onChanged: (String firstName) {
                        ref
                            .read(userSignUpProvider.notifier)
                            .changeFirstName(firstName);
                        checkIfChanged(ref, firstName, "firstName");
                      },
                      validation: (value) {
                        if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                            .hasMatch(value)) {
                          return "Invalid field";
                        }
                        return null;
                      },
                      initialValue: ref
                          .read(pharmacistMainProvider.notifier)
                          .userDataMap?["firstName"],
                    ),
                  ),
                  SizedBox(height: 20),
                  //Last Name
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: CustomFormField(
                      fieldTitle: "Last Name",
                      hintText: "Enter your Last Name...",
                      keyboardStyle: TextInputType.name,
                      containerWidth: MediaQuery.of(context).size.width * 0.85,
                      titleFont: 22,
                      onChanged: (String lastName) {
                        ref
                            .read(userSignUpProvider.notifier)
                            .changeLastName(lastName);
                        checkIfChanged(ref, lastName, "lastName");
                      },
                      validation: (value) {
                        if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                            .hasMatch(value)) {
                          return "Invalid field";
                        }
                        return null;
                      },
                      initialValue: ref
                          .read(pharmacistMainProvider.notifier)
                          .userDataMap?["lastName"],
                    ),
                  ),
                  SizedBox(height: 20),
                  //Phone Number
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: CustomFormField(
                      fieldTitle: "Phone Number",
                      hintText: "Enter your Phone Number...",
                      keyboardStyle: TextInputType.number,
                      containerWidth: MediaQuery.of(context).size.width * 0.85,
                      titleFont: 22,
                      onChanged: (String phoneNumber) {
                        ref
                            .read(userSignUpProvider.notifier)
                            .changePhoneNumber(phoneNumber);
                        checkIfChanged(ref, phoneNumber, "phoneNumber");
                      },
                      validation: (value) {
                        if (value.length < 4) {
                          return "Phone is invalid";
                        }
                        return null;
                      },
                      initialValue: ref
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
                          width: MediaQuery.of(context).size.width * 0.85,
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
                                        .getPlaceDetailFromId(result.placeId);
                                ref
                                    .read(userSignUpProvider.notifier)
                                    .changePharmacistAddress(
                                        placeDetails.streetNumber! +
                                            " " +
                                            placeDetails.street.toString() +
                                            ", " +
                                            placeDetails.city.toString() +
                                            ", " +
                                            placeDetails.country.toString());
                                checkIfChanged(
                                    ref,
                                    placeDetails.streetNumber! +
                                        " " +
                                        placeDetails.street.toString() +
                                        ", " +
                                        placeDetails.city.toString() +
                                        ", " +
                                        placeDetails.country.toString(),
                                    "address");
                                setState(() {
                                  streetAddress.text = placeDetails.streetNumber! +
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
                              errorStyle: TextStyle(fontWeight: FontWeight.w500),
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 30),
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
                                  borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFE8E8E8)),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              hintText: "Enter the address...",
                              hintStyle: GoogleFonts.inter(
                                  color: Color(0xFFBDBDBD), fontSize: 16),
                            ),
                            style:
                                GoogleFonts.inter(color: Colors.black, fontSize: 16),
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
                    containerWidth: MediaQuery.of(context).size.width * 0.85,
                    titleFont: 22,
                    keyboardStyle: TextInputType.number,
                    onChanged: (String licenseYear) {
                      checkIfChanged(ref, licenseYear, "firstYearLicensed");

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
                    initialValue: ref
                        .read(pharmacistMainProvider.notifier)
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
                    containerWidth: MediaQuery.of(context).size.width * 0.85,
                    titleFont: 22,
                    onChanged: (String registrationNumber) {
                      checkIfChanged(ref, registrationNumber, "registrationNumber");
                      ref
                          .read(userSignUpProvider.notifier)
                          .changeRegistrationNumber(registrationNumber);
                    },
                    validation: (value) {
                      if (value.length < 5) {
                        return "Registration Number must be greater then 5 characters";
                      }
                      return null;
                    },
                    initialValue: ref
                        .read(pharmacistMainProvider.notifier)
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
                    containerWidth: MediaQuery.of(context).size.width * 0.85,
                    titleFont: 22,
                    onChanged: (String registrationProvince) {
                      checkIfChanged(
                          ref, registrationProvince, "registrationProvince");
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
                        .read(pharmacistMainProvider.notifier)
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
                    containerWidth: MediaQuery.of(context).size.width * 0.85,
                    titleFont: 22,
                    onChanged: (String graduationYear) {
                      checkIfChanged(ref, graduationYear, "gradutationYear");
                      ref
                          .read(userSignUpProvider.notifier)
                          .changeGraduationYear(graduationYear);
                    },
                    validation: (value) {
                      if (!RegExp(r"^(19|20)\d{2}$").hasMatch(value)) {
                        return "Incorrect year format";
                      }
                      return null;
                    },
                    initialValue: ref
                        .read(pharmacistMainProvider.notifier)
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
                    containerWidth: MediaQuery.of(context).size.width * 0.85,
                    titleFont: 22,
                    onChanged: (String institutionName) {
                      checkIfChanged(ref, institutionName, "institutionName");

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
                    initialValue: ref
                        .read(pharmacistMainProvider.notifier)
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
                    containerWidth: MediaQuery.of(context).size.width * 0.85,
                    titleFont: 22,
                    onChanged: (String workingExperience) {
                      checkIfChanged(ref, workingExperience, "workingExperience");
                      ref
                          .read(userSignUpProvider.notifier)
                          .changeWorkingExperience(workingExperience);
                    },
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                    initialValue: ref
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
                        width: MediaQuery.of(context).size.width * 0.85,
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
                            CustomMultiSelectBottomSheetField<Software?>(
                              selectedColor: Color(0xFFF0069C1),
                              selectedItemsTextStyle: TextStyle(color: Colors.white),
                              initialChildSize: 0.4,
                              decoration: BoxDecoration(),
                              listType: MultiSelectListType.CHIP,
                              initialValue: ref
                                  .read(userSignUpProvider.notifier)
                                  .softwareList,
                              searchable: true,
                              items: _softwareItems,
                              buttonText: Text("Select known software...",
                                  style: GoogleFonts.inter(
                                      color: Color(0xFFBDBDBD), fontSize: 16)),
                              onConfirm: (values) {
                                softwareListToUpload?.addAll(values);
                                ref
                                    .read(userSignUpProvider.notifier)
                                    .changeSoftwareList(values);
                              },
                              chipDisplay: CustomMultiSelectChipDisplay(
                                items: ref
                                    .read(userSignUpProvider.notifier)
                                    .softwareList
                                    ?.map((e) => MultiSelectItem(e, e.toString()))
                                    .toList(),
                                chipColor: Color(0xFFF0069C1),
                                onTap: (value) {
                                  softwareListToUpload?.remove(value);
                                  softwareListToUpload?.removeWhere((element) =>
                                      element?.name.toString() == value.toString());
                                  ref
                                      .read(userSignUpProvider.notifier)
                                      .softwareList
                                      ?.cast()
                                      .remove(value);
                                  ref
                                      .read(userSignUpProvider.notifier)
                                      .softwareList
                                      ?.removeWhere((element) =>
                                          element?.name.toString() ==
                                          value.toString());

                                  return ref
                                      .read(userSignUpProvider.notifier)
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
                        width: MediaQuery.of(context).size.width * 0.85,
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
                            CustomMultiSelectBottomSheetField<Skill?>(
                              selectedColor: Color(0xFFF0069C1),
                              selectedItemsTextStyle: TextStyle(color: Colors.white),
                              initialChildSize: 0.4,
                              decoration: BoxDecoration(),
                              listType: MultiSelectListType.CHIP,
                              initialValue: ref
                                  .read(userSignUpProvider.notifier)
                                  .skillList,
                              searchable: true,
                              items: _skillItems,
                              buttonText: Text("Select your skills...",
                                  style: GoogleFonts.inter(
                                      color: Color(0xFFBDBDBD), fontSize: 16)),
                              onConfirm: (values) {
                                skillListToUpload?.addAll(values);
                                ref
                                    .read(userSignUpProvider.notifier)
                                    .changeSkillList(values);
                              },
                              chipDisplay: CustomMultiSelectChipDisplay(
                                items: ref
                                    .read(userSignUpProvider.notifier)
                                    .skillList
                                    ?.map((e) => MultiSelectItem(e, e.toString()))
                                    .toList(),
                                chipColor: Color(0xFFF0069C1),
                                onTap: (value) {
                                  skillListToUpload?.remove(value);
                                  skillListToUpload?.removeWhere((element) =>
                                      element?.name.toString() == value.toString());
                                  ref
                                      .read(userSignUpProvider.notifier)
                                      .skillList
                                      ?.cast()
                                      .remove(value);
                                  ref
                                      .read(userSignUpProvider.notifier)
                                      .skillList
                                      ?.removeWhere((element) =>
                                          element?.name.toString() ==
                                          value.toString());
                                  return ref
                                      .read(userSignUpProvider.notifier)
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
                        width: MediaQuery.of(context).size.width * 0.85,
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
                            CustomMultiSelectBottomSheetField<Language?>(
                              selectedColor: Color(0xFFF0069C1),
                              selectedItemsTextStyle: TextStyle(color: Colors.white),
                              initialChildSize: 0.4,
                              decoration: BoxDecoration(),
                              listType: MultiSelectListType.CHIP,
                              initialValue: ref
                                  .read(userSignUpProvider.notifier)
                                  .languageList,
                              searchable: true,
                              items: _languageItems,
                              buttonText: Text("Select known languages...",
                                  style: GoogleFonts.inter(
                                      color: Color(0xFFBDBDBD), fontSize: 16)),
                              onConfirm: (values) {
                                languageListToUpload?.addAll(values);
                                ref
                                    .read(userSignUpProvider.notifier)
                                    .changeLanguageList(values);
                              },
                              chipDisplay: CustomMultiSelectChipDisplay(
                                items: ref
                                    .read(userSignUpProvider.notifier)
                                    .languageList
                                    ?.map((e) => MultiSelectItem(e, e.toString()))
                                    .toList(),
                                chipColor: Color(0xFFF0069C1),
                                onTap: (value) {
                                  languageListToUpload?.remove(value);
                                  languageListToUpload?.removeWhere((element) =>
                                      element?.name.toString() == value.toString());
                                  ref
                                      .read(userSignUpProvider.notifier)
                                      .languageList
                                      ?.remove(value);
                                  ref
                                      .read(userSignUpProvider.notifier)
                                      .languageList
                                      ?.removeWhere((element) =>
                                          element?.name.toString() ==
                                          value.toString());
                                  return ref
                                      .read(userSignUpProvider.notifier)
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
                      if (ref.read(pharmacistMainProvider.notifier).resumePDFData !=
                          null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 170,
                              height: 45,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith<Color>(
                                            (states) {
                                      return Color(0xFFF0069C1); // Regular color
                                    }),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                                onPressed: () async {
                                  file = ref
                                      .read(pharmacistMainProvider.notifier)
                                      .resumePDFData;
                                  print("FILE PATH: " + file!.path.toString());
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
                                        MaterialStateProperty.resolveWith<Color>(
                                            (states) {
                                      return Color(0xFFF0069C1); // Regular color
                                    }),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                                onPressed: () async {
                                  setState(() {
                                    _result = null;
                                    file = null;
                                  });

                                  ref
                                      .read(pharmacistMainProvider.notifier)
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
                                    MaterialStateProperty.resolveWith<Color>(
                                        (states) {
                                  return Color(0xFFF0069C1); // Regular color
                                }),
                                shape:
                                    MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ))),
                            onPressed: () async {
                              try {
                                _result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf'],
                                  //withData: true,
                                );
                                if (_result?.files.first.path != null) {
                                  setState(() {
                                    filePicked = true;
                                  });
                                  file = File(_result!.files.first.path.toString());

                                  ref
                                      .read(pharmacistMainProvider.notifier)
                                      .changeResumePDF(file);
                                  print(ref
                                      .read(pharmacistMainProvider.notifier)
                                      .resumePDFData);
                                } else {
                                  // User canceled the picker
                                }
                              } catch (error) {
                                print("ERROR: " + error.toString());
                                final snackBar = SnackBar(
                                  content:
                                      Text('There was an error, please try again.'),
                                  duration: Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Color(0xFFF0069C1);
                    } else if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    return Color(0xFFF0069C1); // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ))),
            onPressed: (uploadDataMap.isNotEmpty ||
                    softwareListToUpload!.isNotEmpty ||
                    skillListToUpload!.isNotEmpty ||
                    languageListToUpload!.isNotEmpty ||
                    ref.read(pharmacistMainProvider.notifier).resumePDFData != null)
                ? () async {
                    print(ref.read(userSignUpProvider.notifier).skillList);
                    if (ref.read(userSignUpProvider.notifier).softwareList !=
                        null) {
                      uploadDataMap["knownSoftware"] = ref
                          .read(userSignUpProvider.notifier)
                          .softwareList
                          .toString();
                    }
                    if (ref.read(userSignUpProvider.notifier).skillList !=
                        null) {
                      uploadDataMap["knownSkills"] = ref
                          .read(userSignUpProvider.notifier)
                          .skillList
                          .toString();
                    }
                    if (ref.read(userSignUpProvider.notifier).languageList !=
                        null) {
                      uploadDataMap["knownLanguages"] = ref
                          .read(userSignUpProvider.notifier)
                          .languageList
                          .toString();
                    }
                    if (ref.read(pharmacistMainProvider.notifier).resumePDFData !=
                        null) {
                      String resumePDFURL = await ref
                          .read(authProviderMain.notifier)
                          .saveAsset(
                              ref.read(pharmacistMainProvider.notifier).resumePDFData,
                              ref.read(userProviderLogin.notifier).userUID,
                              "Resume",
                              ref
                                  .read(pharmacistMainProvider.notifier)
                                  .userDataMap?["firstName"]);
                      uploadDataMap["resumeDownloadURL"] = resumePDFURL;
                    }
                    print("Upload Data Map: $uploadDataMap");

                    String? result = await ref
                        .read(authProviderMain.notifier)
                        .updatePharmacistUserInformation(
                            ref.read(userProviderLogin.notifier).userUID,
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
                                    style: TextStyle(color: Color(0xFFF0069C1)),
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
                              builder: (context) => JobHistoryPharmacist()));
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
 */
