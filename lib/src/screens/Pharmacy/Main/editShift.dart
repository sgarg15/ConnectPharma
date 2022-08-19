import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:connectpharma/Custom%20Widgets/custom_multiSelect_field.dart';
import 'package:connectpharma/Custom%20Widgets/custom_multi_select_display.dart';

import 'package:connectpharma/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';
import 'package:connectpharma/src/screens/Pharmacy/Sign%20Up/1pharmacy_signup.dart';
import 'package:connectpharma/src/screens/login.dart';
import '../../../../Custom Widgets/custom_dateTimeField.dart';
import '../../../../all_used.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class EditShift extends ConsumerStatefulWidget {
  Map? jobDataMap = Map();
  String? jobUID = "";

  EditShift({Key? key, this.jobDataMap, this.jobUID}) : super(key: key);

  @override
  _EditShiftPharmacyState createState() => _EditShiftPharmacyState();
}

class _EditShiftPharmacyState extends ConsumerState<EditShift> {
  Map<String, dynamic> uploadDataMap = Map();
  List<Software?>? softwareListToUpload = [];
  List<Skill?>? skillListToUpload = [];
  List<Language?>? languageListToUpload = [];

  List<dynamic>? skillList = [];
  List<dynamic>? languageList = [];
  List<dynamic>? softwareList = [];
  Map<dynamic, dynamic>? jobDataMap = Map();

  String calendarIcon = "assets/icons/calendar2.svg";
  String clockIcon = "assets/icons/clock2.svg";
  String person = "assets/icons/person.svg";
  String gearIcon = "assets/icons/gear2.svg";
  String moneyIcon = "assets/icons/money.svg";

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController commentsController = TextEditingController();
  TextEditingController hourlyRateController = TextEditingController();

  final _softwareItems =
      software.map((software) => MultiSelectItem<Software>(software, software.name)).toList();
  final _skillItems = skill.map((skill) => MultiSelectItem<Skill>(skill, skill.name)).toList();
  final _languageItems =
      language.map((language) => MultiSelectItem<Language>(language, language.name)).toList();

  bool softwareFieldEnabled = false;
  void checkIfChanged(WidgetRef ref, final currentVal, String firestoreVal) {
    if (currentVal == widget.jobDataMap?[firestoreVal]) {
      uploadDataMap.remove(firestoreVal);
      print("uploadDataMap Removed: $uploadDataMap");
    } else {
      uploadDataMap[firestoreVal] = currentVal;
      print("uploadDataMap Changed: $uploadDataMap");
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pharmacyMainProvider.notifier).changeSkillList(
            (widget.jobDataMap?["skillsNeeded"] as List)
                .map((e) => new Skill(id: 1, name: e))
                .toList(),
          );

      print("Provider Skills List: ${ref.read(pharmacyMainProvider.notifier).skillList}");

      ref.read(pharmacyMainProvider.notifier).changeSoftwareList(
            (widget.jobDataMap?["softwareNeeded"] as List)
                .map((e) => new Software(id: 1, name: e))
                .toList(),
          );

      print("Provider Software List: ${ref.read(pharmacyMainProvider.notifier).softwareList}");

      ref.read(pharmacyMainProvider.notifier).changeLanguageList(
            (widget.jobDataMap?["languageNeeded"] as List)
                .map((e) => new Language(id: 1, name: e))
                .toList(),
          );

      print("Provider Language List: ${ref.read(pharmacyMainProvider.notifier).languageList}");

      ref.read(pharmacyMainProvider.notifier).changeTechOnSite(widget.jobDataMap?["techOnSite"]);

      ref
          .read(pharmacyMainProvider.notifier)
          .changeAssistantOnSite(widget.jobDataMap?["assistantOnSite"]);

      ref.read(pharmacyMainProvider.notifier).changeHourlyRate(widget.jobDataMap?["hourlyRate"]);
      print("Hourly Rate: ${ref.read(pharmacyMainProvider.notifier).hourlyRate}");

      ref.read(pharmacyMainProvider.notifier).changeLIMAStatus(widget.jobDataMap?["limaStatus"]);
      ref.read(pharmacyMainProvider.notifier).changeComments(widget.jobDataMap?["comments"]);
      hourlyRateController.text = widget.jobDataMap?["hourlyRate"];
      commentsController.text = widget.jobDataMap?["comments"];
    });

    jobDataMap = widget.jobDataMap;
    skillList = jobDataMap?["skillsNeeded"];
    softwareList = jobDataMap?["softwareNeeded"];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Skill List ref: ${ref.read(pharmacyMainProvider.notifier).skillList} ");
    print("Skill List: $skillList");

    return WillPopScope(
      onWillPop: () async {
        //ref.read(pharmacyMainProvider.notifier).clearValues();
        uploadDataMap.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          title: new Text(
            "Edit Shift",
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
        body: Consumer(
          builder: (context, ref, child) {
            ref.watch(pharmacyMainProvider);
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Start Date and Time
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(calendarIcon, height: 20, width: 20),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: RichText(
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
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      child: DateTimeField(
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: GoogleFonts.montserrat().fontFamily,
                                        ),
                                        format: DateFormat("MMM dd, yyyy"),
                                        initialValue:
                                            (jobDataMap?["startDate"] as Timestamp).toDate(),
                                        decoration: InputDecoration(
                                            isDense: true,
                                            hintText: "Select a date",
                                            hintStyle: TextStyle(
                                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                                color: Color(0xFFC6C6C6))),
                                        onShowPicker: (context, currentValue) async {
                                          if ((widget.jobDataMap?["startDate"] as Timestamp)
                                              .toDate()
                                              .isBefore(DateTime.now().subtract(
                                                  Duration(hours: TimeOfDay.now().hour)))) {
                                            showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                      title: Text("Error"),
                                                      content: Text(
                                                          "Dates past today's date cannot be edited."),
                                                      actions: <Widget>[
                                                        new TextButton(
                                                          child: new Text("Ok"),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    ));
                                          } else {
                                            final date = await showDatePicker(
                                                context: context,
                                                firstDate: DateTime.now(),
                                                initialDate: currentValue ?? DateTime.now(),
                                                lastDate: DateTime(2100));
                                            if (date != null) {
                                              checkIfChanged(ref, date, "startDate");
                                              ref
                                                  .read(pharmacyMainProvider.notifier)
                                                  .changeStartDate(date);
                                              print(date);
                                              return date;
                                            } else {
                                              ref
                                                  .read(pharmacyMainProvider.notifier)
                                                  .changeStartDate(currentValue);
                                              return currentValue;
                                            }
                                          }
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
                                    Row(
                                      children: [
                                        SvgPicture.asset(clockIcon, height: 20, width: 20),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: RichText(
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
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      child: DateTimeField(
                                        format: DateFormat('h:mm a'),
                                        initialValue:
                                            (jobDataMap?["startTime"] as Timestamp).toDate(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: GoogleFonts.montserrat().fontFamily,
                                        ),
                                        decoration: InputDecoration(
                                            isDense: true,
                                            hintText: "Select a time",
                                            hintStyle: TextStyle(
                                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                                color: Color(0xFFC6C6C6))),
                                        onShowPicker: (context, currentValue) async {
                                          final time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.fromDateTime(
                                                currentValue ?? DateTime.now()),
                                          );
                                          if (time != null) {
                                            checkIfChanged(ref, time, "startTime");
                                            ref
                                                .read(pharmacyMainProvider.notifier)
                                                .changeStartTime(time);
                                            print(time);
                                            return DateTimeField.convert(time);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      //End Date and Time
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(calendarIcon, height: 20, width: 20),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: RichText(
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
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: DateTimeField(
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: GoogleFonts.montserrat().fontFamily,
                                      ),
                                      format: DateFormat("MMM dd, yyyy"),
                                      initialValue: (jobDataMap?["endDate"] as Timestamp).toDate(),
                                      decoration: InputDecoration(
                                          isDense: true,
                                          hintText: "Select a date",
                                          hintStyle: TextStyle(
                                              fontFamily: GoogleFonts.montserrat().fontFamily,
                                              color: Color(0xFFC6C6C6))),
                                      onShowPicker: (context, currentValue) async {
                                        if ((widget.jobDataMap?["endDate"] as Timestamp)
                                            .toDate()
                                            .isBefore(DateTime.now()
                                                .subtract(Duration(hours: TimeOfDay.now().hour)))) {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Text("Error"),
                                                    content: Text(
                                                        "Dates past today's date cannot be edited."),
                                                    actions: <Widget>[
                                                      new TextButton(
                                                        child: new Text("Ok"),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  ));
                                        } else {
                                          final date = await showDatePicker(
                                              context: context,
                                              firstDate: DateTime.now(),
                                              initialDate: currentValue ?? DateTime.now(),
                                              lastDate: DateTime(2100));
                                          if (date != null) {
                                            checkIfChanged(ref, date, "endDate");
                                            ref
                                                .read(pharmacyMainProvider.notifier)
                                                .changeEndDate(date);
                                            print(date);
                                            return date;
                                          } else {
                                            ref
                                                .read(pharmacyMainProvider.notifier)
                                                .changeEndDate(currentValue);
                                            return currentValue;
                                          }
                                        }
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
                                  Row(
                                    children: [
                                      SvgPicture.asset(clockIcon, height: 20, width: 20),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: RichText(
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
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: DateTimeField(
                                      format: DateFormat('h:mm a'),
                                      initialValue:
                                          (widget.jobDataMap?["endTime"] as Timestamp).toDate(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: GoogleFonts.montserrat().fontFamily,
                                      ),
                                      decoration: InputDecoration(
                                          isDense: true,
                                          hintText: "Select a time",
                                          hintStyle: TextStyle(
                                              fontFamily: GoogleFonts.montserrat().fontFamily,
                                              color: Color(0xFFC6C6C6))),
                                      onShowPicker: (context, currentValue) async {
                                        final time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(
                                              currentValue ?? DateTime.now()),
                                        );
                                        if (time != null) {
                                          checkIfChanged(ref, time, "endTime");
                                          ref
                                              .read(pharmacyMainProvider.notifier)
                                              .changeEndTime(time);
                                          print(time);
                                          return DateTimeField.convert(time);
                                        }
                                      },
                                    ),
                                  ),
                                ],
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
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(gearIcon, height: 22, width: 22),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: RichText(
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
                                ),
                              ],
                            ),
                            CustomMultiSelectBottomSheetField<Skill?>(
                              //enabled: softwareFieldEnabled,
                              selectedColor: Color(0xFF0069C1),
                              selectedItemsTextStyle: TextStyle(color: Colors.white),
                              initialChildSize: 0.4,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1, color: Color(0xFFB6B5B5)),
                                ),
                              ),
                              listType: MultiSelectListType.CHIP,
                              initialValue: (jobDataMap?["skillsNeeded"] as List)
                                  .map((e) => new Skill(id: 1, name: e))
                                  .toList(),
                              searchable: true,
                              items: _skillItems,
                              buttonText: Text(
                                "Need to know skills",
                                style: GoogleFonts.montserrat(
                                  color: Color(0xFFC6C6C6),
                                  fontSize: 16,
                                ),
                              ),
                              onConfirm: (values) {
                                skillListToUpload?.addAll(values);
                                print("skillListToUpload $skillListToUpload");

                                ref.read(pharmacyMainProvider.notifier).changeSkillList(values);
                              },
                              chipDisplay: CustomMultiSelectChipDisplay(
                                items: ref
                                    .read(pharmacyMainProvider.notifier)
                                    .skillList
                                    ?.map((e) => MultiSelectItem(e, e.toString()))
                                    .toList(),
                                chipColor: Color(0xFF0069C1),
                                onTap: (value) {
                                  skillListToUpload?.remove(value);
                                  skillListToUpload?.removeWhere((element) => element == value);

                                  print("Removing $value");
                                  ref
                                      .read(pharmacyMainProvider.notifier)
                                      .skillList
                                      ?.cast()
                                      .remove(value);
                                  ref
                                      .read(pharmacyMainProvider.notifier)
                                      .skillList
                                      ?.removeWhere((element) => element == value);

                                  skillListToUpload =
                                      ref.read(pharmacyMainProvider.notifier).skillList;

                                  print("skillListToUpload $skillListToUpload");

                                  return ref.read(pharmacyMainProvider.notifier).skillList;
                                },
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
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(gearIcon, height: 22, width: 22),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: RichText(
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
                                ),
                              ],
                            ),
                            CustomMultiSelectBottomSheetField<Software?>(
                              //enabled: softwareFieldEnabled,
                              selectedColor: Color(0xFF0069C1),
                              selectedItemsTextStyle: TextStyle(color: Colors.white),
                              initialChildSize: 0.4,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1, color: Color(0xFFB6B5B5)),
                                ),
                              ),
                              listType: MultiSelectListType.CHIP,
                              initialValue: (widget.jobDataMap?["softwareNeeded"] as List<dynamic>)
                                  .map((e) => new Software(id: 1, name: e))
                                  .toList(),
                              searchable: true,
                              items: _softwareItems,
                              buttonText: Text(
                                "Need to know software",
                                style: GoogleFonts.montserrat(
                                  color: Color(0xFFC6C6C6),
                                  fontSize: 16,
                                ),
                              ),
                              onConfirm: (values) {
                                softwareListToUpload?.addAll(values);
                                ref.read(pharmacyMainProvider.notifier).changeSoftwareList(values);
                              },
                              chipDisplay: CustomMultiSelectChipDisplay(
                                items: ref
                                    .read(pharmacyMainProvider.notifier)
                                    .softwareList
                                    ?.map((e) => MultiSelectItem(e, e.toString()))
                                    .toList(),
                                chipColor: Color(0xFF0069C1),
                                onTap: (value) {
                                  print("Removing $value");

                                  softwareListToUpload?.remove(value);
                                  softwareListToUpload?.removeWhere((element) => element == value);

                                  ref
                                      .read(pharmacyMainProvider.notifier)
                                      .softwareList
                                      ?.cast()
                                      .remove(value);

                                  ref
                                      .read(pharmacyMainProvider.notifier)
                                      .softwareList
                                      ?.removeWhere((element) => element == value);

                                  softwareListToUpload =
                                      ref.read(pharmacyMainProvider.notifier).softwareList;

                                  print("softwareListToUpload: $softwareListToUpload");

                                  return ref.read(pharmacyMainProvider.notifier).softwareList;
                                },
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
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(gearIcon, height: 22, width: 22),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: RichText(
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
                                ),
                              ],
                            ),
                            CustomMultiSelectBottomSheetField<Language?>(
                              //enabled: softwareFieldEnabled,
                              selectedColor: Color(0xFF0069C1),
                              selectedItemsTextStyle: TextStyle(color: Colors.white),
                              initialChildSize: 0.4,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1, color: Color(0xFFB6B5B5)),
                                ),
                              ),
                              listType: MultiSelectListType.CHIP,
                              initialValue: (widget.jobDataMap?["languageNeeded"] as List<dynamic>)
                                  .map((e) => new Language(id: 1, name: e))
                                  .toList(),
                              searchable: true,
                              items: _languageItems,
                              buttonText: Text(
                                "Need to know languages",
                                style: GoogleFonts.montserrat(
                                  color: Color(0xFFC6C6C6),
                                  fontSize: 16,
                                ),
                              ),
                              onConfirm: (values) {
                                languageListToUpload?.addAll(values);
                                ref.read(pharmacyMainProvider.notifier).changeLanguageList(values);
                              },
                              chipDisplay: CustomMultiSelectChipDisplay(
                                items: (widget.jobDataMap?["languageNeeded"] as List<dynamic>)
                                    .map((e) => new Language(id: 1, name: e))
                                    .toList()
                                    .map((e) => MultiSelectItem(e, e.toString()))
                                    .toList(),
                                chipColor: Color(0xFF0069C1),
                                onTap: (value) {
                                  print("Removing $value");

                                  languageListToUpload?.remove(value);
                                  languageListToUpload?.removeWhere(
                                      (element) => element?.name.toString() == value.toString());
                                  ref
                                      .read(pharmacyMainProvider.notifier)
                                      .languageList
                                      ?.cast()
                                      .remove(value);

                                  ref.read(pharmacyMainProvider.notifier).languageList?.removeWhere(
                                      (element) => element?.name.toString() == value.toString());

                                  languageListToUpload =
                                      ref.read(pharmacyMainProvider.notifier).languageList;

                                  print("LanguageListToUpload: $languageListToUpload");

                                  return ref.read(pharmacyMainProvider.notifier).languageList;
                                },
                                textStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      //Tech On Site
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
                                value: ref.read(pharmacyMainProvider.notifier).techOnSite,
                                onChanged: (value) {
                                  checkIfChanged(ref, value, "techOnSite");
                                  ref.read(pharmacyMainProvider.notifier).changeTechOnSite(value);
                                },
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
                      //Assitant On Site
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
                                value: ref.read(pharmacyMainProvider.notifier).assistantOnSite,
                                onChanged: (value) {
                                  checkIfChanged(ref, value, "assistantOnSite");
                                  ref
                                      .read(pharmacyMainProvider.notifier)
                                      .changeAssistantOnSite(value);
                                },
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
                      //Lima
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
                                value: ref.read(pharmacyMainProvider.notifier).limaStatus,
                                onChanged: (value) {
                                  checkIfChanged(ref, value, "limaStatus");
                                  ref.read(pharmacyMainProvider.notifier).changeLIMAStatus(value);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: RichText(
                                text: TextSpan(
                                  text: "Can provide LIMA?",
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
                      //Hourly Rate
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: SvgPicture.asset(moneyIcon, height: 22, width: 22),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Hourly Rate",
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
                              child: TextField(
                                controller: hourlyRateController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Eg. \$10",
                                ),
                                onChanged: (value) {
                                  checkIfChanged(ref, value, "hourlyRate");
                                  ref.read(pharmacyMainProvider.notifier).changeHourlyRate(value);
                                },
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.montserrat().fontFamily,
                                ),
                                inputFormatters: [MaskedInputFormatter('\$##.##')],
                              ),
                            )
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
                              child: TextField(
                                controller: commentsController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Eg. Comments",
                                ),
                                onChanged: (value) {
                                  checkIfChanged(ref, value, "comments");
                                  ref.read(pharmacyMainProvider.notifier).changeComments(value);
                                },
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.montserrat().fontFamily,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      //Submit Button
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
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
                                  borderRadius: BorderRadius.circular(10),
                                ))),
                            onPressed: (uploadDataMap.isNotEmpty ||
                                    softwareListToUpload!.isNotEmpty ||
                                    skillListToUpload!.isNotEmpty ||
                                    languageListToUpload!.isNotEmpty)
                                ? () async {
                                    print("Pressed");
                                    if (ref.read(pharmacyMainProvider.notifier).softwareList !=
                                        null) {
                                      uploadDataMap["softwareNeeded"] = ref
                                          .read(pharmacyMainProvider.notifier)
                                          .softwareList
                                          ?.map((e) => e?.name)
                                          .toList();
                                    }
                                    if (ref.read(pharmacyMainProvider.notifier).skillList != null) {
                                      uploadDataMap["skillsNeeded"] = ref
                                          .read(pharmacyMainProvider.notifier)
                                          .skillList
                                          ?.map((e) => e?.name)
                                          .toList();
                                    }

                                    if (ref.read(pharmacyMainProvider.notifier).languageList !=
                                        null) {
                                      uploadDataMap["languageNeeded"] = ref
                                          .read(pharmacyMainProvider.notifier)
                                          .languageList
                                          ?.map((e) => e?.name)
                                          .toList();
                                    }

                                    print(uploadDataMap);

                                    String? result = await ref
                                        .read(authProvider.notifier)
                                        .updateJobInformation(
                                            ref.read(userProviderLogin.notifier).userUID,
                                            uploadDataMap,
                                            widget.jobUID);

                                    if (result == "Job Update Failed") {
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
                                              builder: (context) => JobHistoryPharmacy()));
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
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/*
SingleChildScrollView(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(60),
          child: Container(
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.grey[100]),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: <Widget>[
                  //Start Date
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        //Text
                        RichText(
                          text: TextSpan(
                            text: "Start Date",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                                color: Colors.black),
                          ),
                        ),
                        //Date and Time Picker
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                          child: Material(
                            elevation: 7,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 55,
                              width: 200,
                              child: DateTimeField(
                                initialValue:
                                    (widget.jobDataMap?["startDate"]).toDate(),
                                format: DateFormat("MM/dd/yyyy hh:mm a"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black, width: 1.5),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black, width: 1.5),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onShowPicker: (context, currentValue) async {
                                  if ((widget.jobDataMap?["startDate"] as Timestamp)
                                      .toDate()
                                      .isBefore(DateTime.now().subtract(
                                          Duration(hours: TimeOfDay.now().hour)))) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Error"),
                                              content: Text(
                                                  "Dates past today's date cannot be edited."),
                                              actions: <Widget>[
                                                new TextButton(
                                                  child: new Text("Ok"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ));
                                  } else {
                                    final date = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        initialDate: currentValue ?? DateTime.now(),
                                        lastDate: DateTime(2100));
                                    if (date != null) {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            currentValue ?? DateTime.now()),
                                      );
                                      checkIfChanged(
                                          ref,
                                          DateTimeField.combine(date, time),
                                          "startDate");
                                      ref
                                          .read(pharmacyMainProvider.notifier)
                                          .changeStartDate(
                                              DateTimeField.combine(date, time));
                                      print(DateTimeField.combine(date, time));
                                      return DateTimeField.combine(date, time);
                                    } else {
                                      ref
                                          .read(pharmacyMainProvider.notifier)
                                          .changeStartDate(currentValue);
                                      return currentValue;
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //End Date
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 25, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        //Text
                        RichText(
                          text: TextSpan(
                            text: "End Date",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                                color: Colors.black),
                          ),
                        ),
                        //Date and Time Picker
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                          child: Material(
                            elevation: 7,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 55,
                              width: 200,
                              child: DateTimeField(
                                initialValue: (widget.jobDataMap?["endDate"]).toDate(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                                format: DateFormat("MM/dd/yyyy hh:mm a"),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black, width: 1.5),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black, width: 1.5),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onShowPicker: (context, currentValue) async {
                                  if ((widget.jobDataMap?["startDate"] as Timestamp)
                                      .toDate()
                                      .isBefore(DateTime.now().subtract(
                                          Duration(hours: TimeOfDay.now().hour)))) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Error"),
                                              content: Text(
                                                  "Dates past today's date cannot be edited."),
                                              actions: <Widget>[
                                                new TextButton(
                                                  child: new Text("Ok"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ));
                                  } else {
                                    final date = await showDatePicker(
                                        context: context,
                                        firstDate: ref
                                            .read(pharmacyMainProvider.notifier)
                                            .startDate as DateTime,
                                        initialDate: ref
                                            .read(pharmacyMainProvider.notifier)
                                            .startDate as DateTime,
                                        lastDate: DateTime(2100));
                                    if (date != null) {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            currentValue ?? DateTime.now()),
                                      );
                                      checkIfChanged(ref,
                                          DateTimeField.combine(date, time), "endDate");
                                      ref
                                          .read(pharmacyMainProvider.notifier)
                                          .changeEndDate(
                                              DateTimeField.combine(date, time));

                                      return DateTimeField.combine(date, time);
                                    } else {
                                      ref
                                          .read(pharmacyMainProvider.notifier)
                                          .changeEndDate(currentValue);
                                      return currentValue;
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Skills
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: "Specialization Skills",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 330,
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
                                initialValue:
                                    ref.read(pharmacyMainProvider.notifier).skillList,
                                searchable: true,
                                items: _skillItems,
                                buttonText: Text("Select known skills...",
                                    style: GoogleFonts.inter(
                                        color: Color(0xFFBDBDBD), fontSize: 16)),
                                onConfirm: (values) {
                                  skillListToUpload?.addAll(values);
                                  ref
                                      .read(pharmacyMainProvider.notifier)
                                      .changeSkillList(values);
                                },
                                chipDisplay: CustomMultiSelectChipDisplay(
                                  items: ref
                                      .read(pharmacyMainProvider.notifier)
                                      .skillList
                                      ?.map((e) => MultiSelectItem(e, e.toString()))
                                      .toList(),
                                  chipColor: Color(0xFFF0069C1),
                                  onTap: (value) {
                                    skillListToUpload?.remove(value);
                                    skillListToUpload?.removeWhere((element) =>
                                        element?.name.toString() == value.toString());
                                    ref
                                        .read(pharmacyMainProvider.notifier)
                                        .skillList
                                        ?.cast()
                                        .remove(value);
                                    ref
                                        .read(pharmacyMainProvider.notifier)
                                        .skillList
                                        ?.removeWhere((element) =>
                                            element?.name.toString() ==
                                            value.toString());
                                    return ref
                                        .read(pharmacyMainProvider.notifier)
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
                  ),
                  //Software
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                text: "Pharmacy Software",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              width: 55,
                            ),
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                  activeColor: Color(0xFFF0069C1),
                                  value: softwareFieldEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      softwareFieldEnabled = !softwareFieldEnabled;
                                      //print(softwareFieldEnabled);
                                    });
                                  }),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 330,
                          decoration: softwareFieldEnabled
                              ? BoxDecoration(
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
                                )
                              : null,
                          child: Column(
                            children: <Widget>[
                              softwareFieldEnabled
                                  ? CustomMultiSelectBottomSheetField<Software?>(
                                      selectedColor: Color(0xFFF0069C1),
                                      selectedItemsTextStyle:
                                          TextStyle(color: Colors.white),
                                      initialChildSize: 0.4,
                                      decoration: BoxDecoration(),
                                      listType: MultiSelectListType.CHIP,
                                      initialValue: ref
                                          .read(pharmacyMainProvider.notifier)
                                          .softwareList,
                                      searchable: true,
                                      items: _softwareItems,
                                      buttonText: Text("Select known skills...",
                                          style: GoogleFonts.inter(
                                              color: Color(0xFFBDBDBD), fontSize: 16)),
                                      onConfirm: (values) {
                                        softwareListToUpload?.addAll(values);
                                        ref
                                            .read(pharmacyMainProvider.notifier)
                                            .changeSoftwareList(values);
                                      },
                                      chipDisplay: CustomMultiSelectChipDisplay(
                                        items: ref
                                            .read(pharmacyMainProvider.notifier)
                                            .softwareList
                                            ?.map(
                                                (e) => MultiSelectItem(e, e.toString()))
                                            .toList(),
                                        chipColor: Color(0xFFF0069C1),
                                        onTap: (value) {
                                          softwareListToUpload?.remove(value);
                                          softwareListToUpload?.removeWhere((element) =>
                                              element?.name.toString() ==
                                              value.toString());
                                          ref
                                              .read(pharmacyMainProvider.notifier)
                                              .softwareList
                                              ?.cast()
                                              .remove(value);
                                          ref
                                              .read(pharmacyMainProvider.notifier)
                                              .softwareList
                                              ?.removeWhere((element) =>
                                                  element?.name.toString() ==
                                                  value.toString());

                                          return ref
                                              .read(pharmacyMainProvider.notifier)
                                              .softwareList;
                                        },
                                        textStyle: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Tech On Site Check Box
                  Padding(
                    padding: softwareFieldEnabled
                        ? EdgeInsets.fromLTRB(0, 15, 65, 0)
                        : EdgeInsets.fromLTRB(0, 0, 65, 0),
                    child: Container(
                      width: 293,
                      child: CheckboxListTile(
                        title: RichText(
                          text: TextSpan(
                            text: "Technician On-Site",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                                color: Colors.black),
                          ),
                        ),
                        activeColor: Color(0xFFF0069C1),
                        value: ref.read(pharmacyMainProvider.notifier).techOnSite,
                        onChanged: (value) {
                          checkIfChanged(ref, value, "techOnSite");
                          ref
                              .read(pharmacyMainProvider.notifier)
                              .changeTechOnSite(value);
                        },
                        controlAffinity:
                            ListTileControlAffinity.trailing, //  <-- leading Checkbox
                      ),
                    ),
                  ),

                  //Assistant On Site Check Box
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 65, 0),
                    child: Container(
                      width: 293,
                      child: CheckboxListTile(
                        title: RichText(
                          text: TextSpan(
                            text: "Assistant On-Site",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                                color: Colors.black),
                          ),
                        ),
                        activeColor: Color(0xFFF0069C1),
                        value: ref.read(pharmacyMainProvider.notifier).assistantOnSite,
                        onChanged: (value) {
                          checkIfChanged(ref, value, "assistantOnSite");
                          ref
                              .read(pharmacyMainProvider.notifier)
                              .changeAssistantOnSite(value);
                        },
                        controlAffinity:
                            ListTileControlAffinity.trailing, //  <-- leading Checkbox
                      ),
                    ),
                  ),
                  //Hourly Rate
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: "Hourly Rate",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(47, 0, 0, 0),
                          child: Material(
                            elevation: 7,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              height: 55,
                              width: 174,
                              alignment: Alignment.center,
                              child: TextFormField(
                                initialValue:
                                    ref.read(pharmacyMainProvider.notifier).hourlyRate,
                                onChanged: (value) {
                                  checkIfChanged(ref, value, "hourlyRate");
                                  ref
                                      .read(pharmacyMainProvider.notifier)
                                      .changeHourlyRate(value);
                                },
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black, width: 1.5),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black, width: 1.5),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                inputFormatters: [MaskedInputFormatter('\$##.##')],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  //LIMA
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 65, 0),
                    child: Container(
                      width: 293,
                      child: CheckboxListTile(
                        title: RichText(
                          text: TextSpan(
                            text: "Can provide LIMA?",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                                color: Colors.black),
                          ),
                        ),
                        activeColor: Color(0xFFF0069C1),
                        value: ref.read(pharmacyMainProvider.notifier).limaStatus,
                        onChanged: (value) {
                          checkIfChanged(ref, value, "limaStatus");
                          ref
                              .read(pharmacyMainProvider.notifier)
                              .changeLIMAStatus(value);
                        },
                        controlAffinity:
                            ListTileControlAffinity.trailing, //  <-- leading Checkbox
                      ),
                    ),
                  ),
                  //Comments section
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: "Comments",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Container(
                            color: Colors.white,
                            width: 324,
                            constraints: BoxConstraints(minHeight: 60),
                            child: TextField(
                              controller: commentsController,
                              maxLines: 3,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.start,
                              onChanged: (value) {
                                ref
                                    .read(pharmacyMainProvider.notifier)
                                    .changeComments(value);
                                checkIfChanged(ref, value, "comments");
                              },
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    "Include any important comments for the pharmacist...",
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1.5),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1.5),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      //Edit Shift Button
      Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: SizedBox(
            width: 340,
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
              onPressed: (uploadDataMap.isNotEmpty ||
                      softwareListToUpload!.isNotEmpty ||
                      skillListToUpload!.isNotEmpty)
                  ? () async {
                      print("Pressed");
                      if (ref.read(pharmacyMainProvider.notifier).softwareList !=
                          null) {
                        uploadDataMap["softwareList"] = ref
                            .read(pharmacyMainProvider.notifier)
                            .softwareList
                            .toString();
                      }
                      if (ref.read(pharmacyMainProvider.notifier).skillList != null) {
                        uploadDataMap["skillList"] = ref
                            .read(pharmacyMainProvider.notifier)
                            .skillList
                            .toString();
                      }
                      print(uploadDataMap);

                      String? result = await ref
                          .read(authProvider.notifier)
                          .updateJobInformation(
                              ref.read(userProviderLogin.notifier).userUID,
                              uploadDataMap,
                              widget.jobUID);

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
                                builder: (context) => JobHistoryPharmacy()));
                      }
                    }
                  : null,
              child: RichText(
                text: TextSpan(
                  text: "Post Shift",
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
      ),
      //Edit Shift Button
      Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: SizedBox(
            width: 150,
            height: 40,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey; // Disabled color
                    }
                    return Colors.red; // Regular color
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ))),
              onPressed: () {
                print("Pressed");
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Important!"),
                        content: Text(
                            "This job will be deleted and cannot be retrieved once deleted."),
                        actions: [
                          TextButton(
                            child: Text(
                              "Ok",
                              style: TextStyle(color: Color(0xFFF0069C1)),
                            ),
                            onPressed: () async {
                              String? result = await ref
                                  .read(authProvider.notifier)
                                  .deleteJob(
                                      ref.read(userProviderLogin.notifier).userUID,
                                      widget.jobUID);
                              if (result == "Job Delete Failed") {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Important!"),
                                        content: Text(
                                            "There was an error trying to delete this job. Please try again in a few minutes."),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              "Ok",
                                              style:
                                                  TextStyle(color: Color(0xFFF0069C1)),
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
                                        builder: (context) => JobHistoryPharmacy()));
                              }
                            },
                          )
                        ],
                      );
                    });
              },
              child: RichText(
                text: TextSpan(
                  text: "Delete shift",
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
      ),

      SizedBox(
        height: 20,
      )
    ],
  ),
)
 */
