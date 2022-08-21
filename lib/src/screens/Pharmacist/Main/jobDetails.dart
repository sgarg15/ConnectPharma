import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectpharma/Custom%20Widgets/custom_dateTimeField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:connectpharma/all_used.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/src/screens/login.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:connectpharma/Custom%20Widgets/custom_multiSelect_field.dart';
import 'package:connectpharma/Custom%20Widgets/custom_multi_select_display.dart';

import 'jobHistoryPharmacist.dart';

// ignore: must_be_immutable
class JobDetails extends ConsumerWidget {
  Map<String, dynamic>? jobDetails = Map();
  bool viewing = false;

  JobDetails({Key? key, this.jobDetails, required this.viewing}) : super(key: key);

  final _softwareItems =
      software.map((software) => MultiSelectItem<Software>(software, software.name)).toList();
  final _skillItems = skill.map((skill) => MultiSelectItem<Skill>(skill, skill.name)).toList();
  final _languageItems =
      language.map((language) => MultiSelectItem<Language>(language, language.name)).toList();

  String fullAddress() {
    String ret = "";
    if (jobDetails?["pharmacyAddress"]["streetAddress"] != null &&
        jobDetails?["pharmacyAddress"]["streetAddress"] != "") {
      ret += jobDetails?["pharmacyAddress"]["streetAddress"];
    }

    if (jobDetails?["pharmacyAddress"]["city"] != null &&
        jobDetails?["pharmacyAddress"]["city"] != "") {
      ret += ", " + jobDetails?["pharmacyAddress"]["city"];
    }

    if (jobDetails?["pharmacyAddress"]["country"] != null &&
        jobDetails?["pharmacyAddress"]["country"] != "") {
      ret += ", " + jobDetails?["pharmacyAddress"]["country"];
    }

    if (jobDetails?["pharmacyAddress"]["postalCode"] != null &&
        jobDetails?["pharmacyAddress"]["postalCode"] != "") {
      ret += ", " + jobDetails?["pharmacyAddress"]["postalCode"];
    }
    return ret;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: new Text(
          "Shift Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily,
          ),
        ),
        backgroundColor: Color(0xFFF0069C1),
        foregroundColor: Colors.white,
        bottomOpacity: 1,
        shadowColor: Colors.white,
      ),
      backgroundColor: Color(0xFF0069C1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Pharmacy Name and Adreess
            Center(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    minRadius: 10,
                    maxRadius: 55,
                    child: CircleAvatar(
                        minRadius: 5,
                        maxRadius: 52,
                        child: Text(jobDetails?["pharmacyName"][0],
                            style: TextStyle(
                                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold))),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        jobDetails?["pharmacyName"],
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                          fontFamily:
                              GoogleFonts.montserrat(fontWeight: FontWeight.w500).fontFamily,
                        ),
                      ),
                      Text(
                        fullAddress(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily:
                              GoogleFonts.montserrat(fontWeight: FontWeight.w300).fontFamily,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            //Details
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Start Date and Time
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: "Start Date",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontFamily: GoogleFonts.montserrat().fontFamily,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      child: DateTimeField(
                                        enabled: false,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: GoogleFonts.montserrat().fontFamily,
                                        ),
                                        format: DateFormat("dd MMM, yyyy"),
                                        initialValue:
                                            (jobDetails?["startDate"] as Timestamp).toDate(),
                                        decoration: InputDecoration(
                                            isDense: true,
                                            hintText: "Start Date",
                                            hintStyle: TextStyle(
                                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                                color: Color(0xFFC6C6C6))),
                                        onShowPicker: (context, currentValue) async {
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: "Start Time",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontFamily: GoogleFonts.montserrat().fontFamily,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      child: DateTimeField(
                                        enabled: false,
                                        format: DateFormat('h:mm a'),
                                        initialValue:
                                            (jobDetails?["startTime"] as Timestamp).toDate(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: GoogleFonts.montserrat().fontFamily,
                                        ),
                                        decoration: InputDecoration(
                                            isDense: true,
                                            hintText: "Start Time",
                                            hintStyle: TextStyle(
                                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                                color: Color(0xFFC6C6C6))),
                                        onShowPicker: (context, currentValue) async {
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(height: 20),
                    //End Date And Time
                    Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: "End Date",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18.0,
                                        color: Colors.black,
                                        fontFamily: GoogleFonts.montserrat().fontFamily,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: DateTimeField(
                                      enabled: false,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: GoogleFonts.montserrat().fontFamily,
                                      ),
                                      format: DateFormat("dd MMM, yyyy"),
                                      initialValue: (jobDetails?["endDate"] as Timestamp).toDate(),
                                      decoration: InputDecoration(
                                          isDense: true,
                                          hintText: "End Date",
                                          hintStyle: TextStyle(
                                              fontFamily: GoogleFonts.montserrat().fontFamily,
                                              color: Color(0xFFC6C6C6))),
                                      onShowPicker: (context, currentValue) async {
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: "End Time",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18.0,
                                        color: Colors.black,
                                        fontFamily: GoogleFonts.montserrat().fontFamily,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: DateTimeField(
                                      enabled: false,
                                      format: DateFormat('h:mm a'),
                                      initialValue: (jobDetails?["endTime"] as Timestamp).toDate(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: GoogleFonts.montserrat().fontFamily,
                                      ),
                                      decoration: InputDecoration(
                                          isDense: true,
                                          hintText: "End Time",
                                          hintStyle: TextStyle(
                                              fontFamily: GoogleFonts.montserrat().fontFamily,
                                              color: Color(0xFFC6C6C6))),
                                      onShowPicker: (context, currentValue) async {
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 20),
                    //Hourly Rate
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Hourly Rate",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: TextFormField(
                                enabled: false,
                                initialValue: jobDetails?["hourlyRate"],
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Eg. \$10",
                                ),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.montserrat().fontFamily,
                                ),
                                inputFormatters: [MaskedInputFormatter('\$##.##')],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    //Worker Type
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Worker Type",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: TextFormField(
                                enabled: false,
                                initialValue: jobDetails?["position"],
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Eg. Pharmacist",
                                ),
                                keyboardType: TextInputType.name,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.montserrat().fontFamily,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    //Technician On-Site
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 25,
                            width: 25,
                            child: Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide(color: Color(0xFFC4C4C4), width: 2),
                              visualDensity: VisualDensity.compact,
                              value: jobDetails?["techOnSite"],
                              onChanged: (value) {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: RichText(
                              text: TextSpan(
                                text: "Technician On-site",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontFamily: GoogleFonts.montserrat().fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    //Assistant On-Site
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 25,
                            width: 25,
                            child: Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide(color: Color(0xFFC4C4C4), width: 2),
                              visualDensity: VisualDensity.compact,
                              value: jobDetails?["assistantOnSite"],
                              onChanged: (value) {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: RichText(
                              text: TextSpan(
                                text: "Assistant On-site",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontFamily: GoogleFonts.montserrat().fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    //LIMA
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 25,
                            width: 25,
                            child: Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide(color: Color(0xFFC4C4C4), width: 2),
                              visualDensity: VisualDensity.compact,
                              value: jobDetails?["limaStatus"],
                              onChanged: (value) {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: RichText(
                              text: TextSpan(
                                text: "LIMA Provided",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontFamily: GoogleFonts.montserrat().fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    //Specialization Skills
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Specialization Skills",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.0,
                                color: Colors.black,
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                              ),
                            ),
                          ),
                          CustomMultiSelectBottomSheetField<Skill?>(
                            enabled: false,
                            selectedColor: Color(0xFF0069C1),
                            selectedItemsTextStyle: TextStyle(color: Colors.white),
                            initialChildSize: 0.4,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1, color: Color(0xFFB6B5B5)),
                              ),
                            ),
                            listType: MultiSelectListType.CHIP,
                            initialValue: (jobDetails?["skillsNeeded"] as List)
                                .map((e) => new Skill(id: 1, name: e))
                                .toList(),
                            items: _skillItems,
                            buttonText: Text(
                              "Need to know skills",
                              style: GoogleFonts.montserrat(
                                color: Color(0xFFC6C6C6),
                                fontSize: 16,
                              ),
                            ),
                            onConfirm: (values) {},
                            chipDisplay: CustomMultiSelectChipDisplay(
                              items: (jobDetails?["skillsNeeded"] as List)
                                  .map((e) => new Skill(id: 1, name: e))
                                  .toList()
                                  .map((e) => MultiSelectItem(e, e.toString()))
                                  .toList(),
                              chipColor: Color(0xFF0069C1),
                              onTap: (value) {},
                              textStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    //Software
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Software",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.0,
                                color: Colors.black,
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                              ),
                            ),
                          ),
                          CustomMultiSelectBottomSheetField<Software?>(
                            enabled: false,
                            selectedColor: Color(0xFF0069C1),
                            selectedItemsTextStyle: TextStyle(color: Colors.white),
                            initialChildSize: 0.4,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1, color: Color(0xFFB6B5B5)),
                              ),
                            ),
                            listType: MultiSelectListType.CHIP,
                            initialValue: (jobDetails?["softwareNeeded"] as List)
                                .map((e) => new Software(id: 1, name: e))
                                .toList(),
                            items: _softwareItems,
                            buttonText: Text(
                              "Need to know software",
                              style: GoogleFonts.montserrat(
                                color: Color(0xFFC6C6C6),
                                fontSize: 16,
                              ),
                            ),
                            onConfirm: (values) {},
                            chipDisplay: CustomMultiSelectChipDisplay(
                              items: (jobDetails?["softwareNeeded"] as List)
                                  .map((e) => new Software(id: 1, name: e))
                                  .toList()
                                  .map((e) => MultiSelectItem(e, e.toString()))
                                  .toList(),
                              chipColor: Color(0xFF0069C1),
                              onTap: (value) {},
                              textStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    //Languages
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Languages",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.0,
                                color: Colors.black,
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                              ),
                            ),
                          ),
                          CustomMultiSelectBottomSheetField<Language?>(
                            enabled: false,
                            selectedColor: Color(0xFF0069C1),
                            selectedItemsTextStyle: TextStyle(color: Colors.white),
                            initialChildSize: 0.4,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1, color: Color(0xFFB6B5B5)),
                              ),
                            ),
                            listType: MultiSelectListType.CHIP,
                            initialValue: (jobDetails?["languageNeeded"] as List)
                                .map((e) => new Language(id: 1, name: e))
                                .toList(),
                            items: _languageItems,
                            buttonText: Text(
                              "Need to know languages",
                              style: GoogleFonts.montserrat(
                                color: Color(0xFFC6C6C6),
                                fontSize: 16,
                              ),
                            ),
                            onConfirm: (values) {},
                            chipDisplay: CustomMultiSelectChipDisplay(
                              items: (jobDetails?["languageNeeded"] as List)
                                  .map((e) => new Language(id: 1, name: e))
                                  .toList()
                                  .map((e) => MultiSelectItem(e, e.toString()))
                                  .toList(),
                              chipColor: Color(0xFF0069C1),
                              onTap: (value) {},
                              textStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    //Comments
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.comment_outlined, size: 20),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: RichText(
                                  text: TextSpan(
                                    text: "Comments",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontFamily: GoogleFonts.montserrat().fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: TextFormField(
                              enabled: false,
                              initialValue: jobDetails?["comments"],
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "Eg. Comments",
                              ),
                              onChanged: (value) {},
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              textAlign: TextAlign.start,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    //Apply for job
                    if (!viewing) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: SizedBox(
                          width: 324,
                          height: 51,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors.grey; // Disabled color
                                  }
                                  return Color(0xFFF0069C1); // Regular color
                                }),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ))),
                            onPressed: () {
                              //TODO: Application System

                              // 1) Click Apply
                              //Send Applicant info (and pharmacist user uid) to pharmacy job UID and place under applicants map field within the job uid document

                              // 2) Add job information to pharmacist user/main jobs field

                              //In pharmacist Job History, have (Active) section and (Past) Section
                              //Under (Active) section, have a section for Applied jobs
                              //Under (Past) section, have a section for Rejected jobs

                              //For Pharmacy:
                              //On Job Delete have cloud function also delete job from any pharmacist with that job id in their applicants field using the where command
                              //Send a notification either through app or showdialog that there job was deleted
                              //For job dialog, show number of applicants for that job
                              //By clicking on job and then on applicants button, you can view all the applied applications,
                              //The Applicant dialogue will have pharmacist profile photo, name, years of work experience and then on the right hand side, the option to reject and accept the applicant
                              //After clicking the reject button, send the updated applicant field to firestore with the pharmacist uid removed and also send an email to the applicant email about rejection
                              //After clicking the accept button, show pharmacy the applicant contact information, and send an email to the applicant pharmacist about the acception

                              print("Pressed");
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(jobDetails?["pharmacyName"]),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                  text:
                                                      "Are you sure you want to apply for this job? \n\n\n",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontFamily:
                                                          GoogleFonts.montserrat().fontFamily),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "Please only apply for jobs you are interested in and do not spam the pharmacy email or phone, you can and will be reported for such actions. Resulting in withrawal from this service.",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily:
                                                              GoogleFonts.montserrat().fontFamily),
                                                    )
                                                  ]),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                TextButton(
                                                  child: new Text(
                                                    "No",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.red[400], fontSize: 16),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: new Text(
                                                    "Yes",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        color: Color(0xFFF0069C1), fontSize: 16),
                                                  ),
                                                  onPressed: () async {
                                                    WriteBatch jobApplicationBatch =
                                                        FirebaseFirestore.instance.batch();

                                                    //Follow step 1)
                                                    await sendApplicantDataToPharmacy(
                                                        ref, context, jobApplicationBatch);
                                                    //Follow step 2)
                                                    await sendJobDataToPharmacist(
                                                        ref, context, jobApplicationBatch);

                                                    jobApplicationBatch
                                                        .commit()
                                                        .onError((error, stackTrace) {
                                                      print("ERROR APPLYING: $error");
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) => AlertDialog(
                                                                title: Text("Error"),
                                                                content: Text(
                                                                    "There was an error trying to apply for this job. Please try again after restarting the app."),
                                                              ));
                                                    });
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                JobHistoryPharmacist()));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ));
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Apply",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendJobDataToPharmacist(
      WidgetRef ref, BuildContext context, WriteBatch batchValue) async {
    jobDetails?.addAll({"applicationStatus": "applied", "userType": "Pharmacist"});

    try {
      DocumentReference pharmacistJobsCollection = FirebaseFirestore.instance
          .collection("Users")
          .doc(ref.read(userProviderLogin.notifier).userUID)
          .collection("PharmacistJobs")
          .doc(jobDetails?["jobID"]);
      batchValue.set(pharmacistJobsCollection, jobDetails);
    } on Exception catch (e) {
      print("ERROR: $e");
    }

    // String? result = await context
    //     .read(authProviderMain.notifier)
    //     .sendJobInfoToPharmacistProfile(
    //         ref.read(userProviderLogin.notifier).userUID,
    //         jobDetails?["jobID"],
    //         jobDetails);
  }

  Future<void> sendApplicantDataToPharmacy(
      WidgetRef ref, BuildContext context, WriteBatch batchValue) async {
    Map<String, dynamic>? applicantInformation = Map();
    Map<String, dynamic>? userDataMap = ref.read(pharmacistMainProvider.notifier).userDataMap;
    applicantInformation.addAll({
      "jobStatus": "applied",
      "availability": userDataMap?["availability"],
      "email": userDataMap?["email"],
      "knownLanguages": userDataMap?["knownLanguages"],
      "knownSkills": userDataMap?["knownSkills"],
      "knownSoftware": userDataMap?["knownSoftware"],
      "name": userDataMap?["firstName"] + " " + userDataMap?["lastName"],
      "phoneNumber": userDataMap?["phoneNumber"],
      "profilePhoto": userDataMap?["profilePhotoDownloadURL"],
      "resume": userDataMap?["resumeDownloadURL"],
      "uid": ref.read(userProviderLogin.notifier).userUID,
      "yearsOfExperience": userDataMap?["workingExperience"],
    });

    print("Uploading applicant data to pharmacy");
    print("applicantInformation: ${jobDetails?["pharmacyUID"]}");
    print("applicantInformation: ${jobDetails?["jobID"]}");

    try {
      batchValue.update(
        FirebaseFirestore.instance
            .collection("Users")
            .doc(jobDetails?["pharmacyUID"])
            .collection("Main")
            .doc(jobDetails?["jobID"]),
        {"applicants.${ref.read(userProviderLogin.notifier).userUID}": applicantInformation},
      );
    } on Exception catch (e) {
      print("ERROR: $e");
    }

    // String? result = await context
    //     .read(authProviderMain.notifier)
    //     .sendApplicantInfoToPharmacyJob(
    //         jobDetails?["pharmacyUID"],
    //         ,
    //         ref.read(userProviderLogin.notifier).userUID,
    //         applicantInformation);

    // if (result == "Applicant Upload Failed") {
    //   showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //             title: Text("Error"),
    //             content: Text(
    //                 "There was an error trying to apply for this job. Please try again after restarting the app."),
    //           ));
    // } else {
    //   // Navigator.push(context,
    //   //     MaterialPageRoute(builder: (context) => JobHistoryPharmacist()));
    // }
  }
}

/*
//Data
Padding(
  padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Data
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //From Date
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "From",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text:
                                "${DateFormat("EEE, MMM d yyyy").format((jobDetails?["startDate"] as Timestamp).toDate())}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Time
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "Time",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text:
                                "${DateFormat("jm").format((jobDetails?["startDate"] as Timestamp).toDate())}"
                                " - "
                                "${DateFormat("jm").format((jobDetails?["endDate"] as Timestamp).toDate())} ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //City
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "City",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "${jobDetails?["pharmacyAddress"]["city"]} ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Hourly Rate
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "Hourly Rate",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "${jobDetails?["hourlyRate"]}/hr ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Tech On Site
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "Technician On-Site",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        jobDetails?["techOnSite"]
                            ? Icon(
                                Icons.check,
                                color: Color(0xFFF0069C1),
                                size: 30,
                              )
                            : Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 30,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2 - 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //To Date
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "To",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text:
                                "${DateFormat("EEE, MMM d yyyy").format((jobDetails?["endDate"] as Timestamp).toDate())}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Duration
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 14, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "Duration",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text:
                                "${getHourDiff(TimeOfDay.fromDateTime((jobDetails?["endDate"] as Timestamp).toDate()), TimeOfDay.fromDateTime((jobDetails?["startDate"] as Timestamp).toDate()))[0]} hrs"
                                "${getHourDiff(TimeOfDay.fromDateTime((jobDetails?["endDate"] as Timestamp).toDate()), TimeOfDay.fromDateTime((jobDetails?["startDate"] as Timestamp).toDate()))[1]}/day",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Distance
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "Distance",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        FutureBuilder(
                          future: getDistance(
                              jobDetails!,
                              ref
                                  .read(pharmacistMainProvider.notifier)
                                  .userDataMap?["address"]),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            return RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: "${snapshot.data}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  //Job Type
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "Worker Type",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "Pharmacist",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Assistant Site
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "Assistant On-Site",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        jobDetails?["assistantOnSite"]
                            ? Icon(
                                Icons.check,
                                color: Color(0xFFF0069C1),
                                size: 30,
                              )
                            : Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 30,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(
          thickness: 2,
        ),
        //Software
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "Software",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              RichText(
                textAlign: TextAlign.start,
                text: (jobDetails?["softwareNeeded"] == "null" ||
                        jobDetails?["softwareNeeded"] == "[]")
                    ? TextSpan(
                        text: "No software skills needed!",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : TextSpan(
                        text: jobDetails?["softwareNeeded"].toString().substring(
                            jobDetails?["softwareNeeded"].indexOf("[") + 1,
                            jobDetails?["softwareNeeded"].lastIndexOf("]")),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
        //Specialization
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 5, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "Specialization",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: jobDetails?["skillsNeeded"].toString().substring(
                      jobDetails?["skillsNeeded"].indexOf("[") + 1,
                      jobDetails?["skillsNeeded"].lastIndexOf("]")),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        //Comments
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 5, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "Comments",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "${jobDetails?["comments"]}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
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
//Search Button
Padding(
  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
  child: SizedBox(
    width: 324,
    height: 51,
    child: ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey; // Disabled color
            }
            return Color(0xFFF0069C1); // Regular color
          }),
          shape:
              MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ))),
      onPressed: () {
        //TODO: Application System

        // 1) Click Apply
        //Send Applicant info (and pharmacist user uid) to pharmacy job UID and place under applicants map field within the job uid document

        // 2) Add job information to pharmacist user/main jobs field

        //In pharmacist Job History, have (Active) section and (Past) Section
        //Under (Active) section, have a section for Applied jobs
        //Under (Past) section, have a section for Rejected jobs

        //For Pharmacy:
        //On Job Delete have cloud function also delete job from any pharmacist with that job id in their applicants field using the where command
        //Send a notification either through app or showdialog that there job was deleted
        //For job dialog, show number of applicants for that job
        //By clicking on job and then on applicants button, you can view all the applied applications,
        //The Applicant dialogue will have pharmacist profile photo, name, years of work experience and then on the right hand side, the option to reject and accept the applicant
        //After clicking the reject button, send the updated applicant field to firestore with the pharmacist uid removed and also send an email to the applicant email about rejection
        //After clicking the accept button, show pharmacy the applicant contact information, and send an email to the applicant pharmacist about the acception

        print("Pressed");
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(jobDetails?["pharmacyName"]),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: "Are you sure you want to apply for this job? \n\n\n",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            children: const [
                              TextSpan(
                                text:
                                    "Please only apply for jobs you are interested in and do not spam the pharmacy email or phone, you can and will be reported for such actions. Resulting in withrawal from this service.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              )
                            ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: new Text(
                              "No",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.red[400], fontSize: 16),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: new Text(
                              "Yes",
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Color(0xFFF0069C1), fontSize: 16),
                            ),
                            onPressed: () async {
                              WriteBatch jobApplicationBatch =
                                  FirebaseFirestore.instance.batch();

                              //Follow step 1)
                              await sendApplicantDataToPharmacy(
                                  ref, context, jobApplicationBatch);
                              //Follow step 2)
                              await sendJobDataToPharmacist(
                                  ref, context, jobApplicationBatch);

                              jobApplicationBatch.commit().onError((error, stackTrace) {
                                print("ERROR APPLYING: $error");
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("Error"),
                                          content: Text(
                                              "There was an error trying to apply for this job. Please try again after restarting the app."),
                                        ));
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => JobHistoryPharmacist()));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
      },
      child: RichText(
        text: TextSpan(
          text: "Apply",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ),
),
SizedBox(
  height: 20,
),

 */
