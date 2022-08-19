import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:connectpharma/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';
import 'package:connectpharma/src/screens/Pharmacy/Sign%20Up/1pharmacy_signup.dart';
import 'package:connectpharma/src/screens/login.dart';
import '../../../../Custom Widgets/custom_dateTimeField.dart';
import '../../../../all_used.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateShift extends ConsumerStatefulWidget {
  CreateShift({Key? key}) : super(key: key);

  @override
  _CreateShiftPharmacyState createState() => _CreateShiftPharmacyState();
}

class _CreateShiftPharmacyState extends ConsumerState<CreateShift> {
  final _softwareItems =
      software.map((software) => MultiSelectItem<Software>(software, software.name)).toList();
  final _skillItems = skill.map((skill) => MultiSelectItem<Skill>(skill, skill.name)).toList();
  final _languageItems =
      language.map((language) => MultiSelectItem<Language>(language, language.name)).toList();

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController commentsController = TextEditingController();
  TextEditingController hourlyRateController = TextEditingController();

  bool softwareFieldEnabled = false;
  bool showAllPharmacists = false;
  String calendarIcon = "assets/icons/calendar2.svg";
  String clockIcon = "assets/icons/clock2.svg";
  String person = "assets/icons/person.svg";
  String gearIcon = "assets/icons/gear2.svg";
  String moneyIcon = "assets/icons/money.svg";

  @override
  void initState() {
    super.initState();
    print("CreateShift initState");
    print("state.startDate: ${ref.read(pharmacyMainProvider).startDate}");
    print("state.endDate: ${ref.read(pharmacyMainProvider).endDate}");
    print("state.startTime: ${ref.read(pharmacyMainProvider).startTime}");
    print("state.endTime: ${ref.read(pharmacyMainProvider).endTime}");
    startDateController.text =
        "${ref.read(pharmacyMainProvider).startDate!.day} ${DateFormat('MMM').format(ref.read(pharmacyMainProvider).startDate as DateTime)}, ${ref.read(pharmacyMainProvider).startDate!.year}";
    endDateController.text =
        "${ref.read(pharmacyMainProvider).endDate!.day} ${DateFormat('MMM').format(ref.read(pharmacyMainProvider).endDate as DateTime)}, ${ref.read(pharmacyMainProvider).endDate!.year}";
    startTimeController.text =
        "${ref.read(pharmacyMainProvider).startTime!.hourOfPeriod}:${ref.read(pharmacyMainProvider).startTime!.minute} ${ref.read(pharmacyMainProvider).startTime!.period.name}";
    endTimeController.text =
        "${ref.read(pharmacyMainProvider).endTime!.hourOfPeriod}:${ref.read(pharmacyMainProvider).endTime!.minute} ${ref.read(pharmacyMainProvider).endTime!.period.name}";
    if (ref.read(pharmacyMainProvider).jobComments != null ||
        ref.read(pharmacyMainProvider).jobComments != "") {
      commentsController.text = ref.read(pharmacyMainProvider).jobComments!;
    }

    hourlyRateController.text = ref.read(pharmacyMainProvider).hourlyRate.toString();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0,
            title: new Text(
              "Create Shift",
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
          body: Consumer(
            builder: (context, ref, child) {
              ref.watch(pharmacyMainProvider);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                                      controller: startDateController,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: GoogleFonts.montserrat().fontFamily,
                                      ),
                                      format: DateFormat("dd MMM, yyyy"),
                                      initialValue: ref.read(pharmacyMainProvider).startDate,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          hintText: "Select a date",
                                          hintStyle: TextStyle(
                                              fontFamily: GoogleFonts.montserrat().fontFamily,
                                              color: Color(0xFFC6C6C6))),
                                      onShowPicker: (context, currentValue) async {
                                        final date = await showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            initialDate: currentValue ?? DateTime.now(),
                                            lastDate: DateTime(2100));

                                        if (date != null) {
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
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
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
                                      initialValue: DateTimeField.convert(
                                          ref.read(pharmacyMainProvider).startTime),
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
                                          ref
                                              .read(pharmacyMainProvider.notifier)
                                              .changeStartTime(time);
                                        }
                                        print(time);
                                        return DateTimeField.convert(time);
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
                    SizedBox(
                      height: 30,
                    ),

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
                                    controller: endDateController,
                                    format: DateFormat("dd MMM, yyyy"),
                                    initialValue: DateTime.now().add(Duration(days: 1)),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: GoogleFonts.montserrat().fontFamily,
                                    ),
                                    decoration: InputDecoration(
                                        isDense: true,
                                        hintText: "Select a date",
                                        hintStyle: TextStyle(
                                            fontFamily: GoogleFonts.montserrat().fontFamily,
                                            color: Color(0xFFC6C6C6))),
                                    onShowPicker: (context, currentValue) async {
                                      final date = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime.now(),
                                          initialDate: currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));

                                      if (date != null) {
                                        ref.read(pharmacyMainProvider.notifier).changeEndDate(date);
                                        print(date);
                                        return date;
                                      } else {
                                        ref
                                            .read(pharmacyMainProvider.notifier)
                                            .changeEndDate(currentValue);
                                        return currentValue;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
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
                                    format: DateFormat("h:mm a"),
                                    initialValue: DateTimeField.convert(
                                        ref.read(pharmacyMainProvider).endTime),
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
                                        initialTime:
                                            TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                      );

                                      ref.read(pharmacyMainProvider.notifier).changeEndTime(time);
                                      print(time);
                                      return DateTimeField.convert(time);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    //Position Dropdown
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(person, width: 17),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: RichText(
                                  text: TextSpan(
                                    text: "Position",
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
                          DropdownButtonFormField<String>(
                            itemHeight: 80,
                            icon: Icon(Icons.arrow_downward, color: Colors.black),
                            hint: Text(
                              "Select your Position...",
                              style: GoogleFonts.inter(color: Color(0xFFBDBDBD), fontSize: 16),
                            ),
                            value: ref.read(pharmacyMainProvider.notifier).position,
                            items: <String>[
                              'Pharmacist',
                              'Pharmacy Assistant',
                              'Pharmacy Technician'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(child: Text(value), value: value);
                            }).toList(),
                            onChanged: (String? value) {
                              ref.read(pharmacyMainProvider.notifier).changePosition(value);
                            },
                            style: GoogleFonts.questrial(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    //Specialization Skills
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Column(children: [
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
                        MultiSelectBottomSheetField<Skill?>(
                          //enabled: softwareFieldEnabled,
                          selectedColor: Color(0xFFF0069C1),
                          selectedItemsTextStyle: TextStyle(color: Colors.white),
                          initialChildSize: 0.4,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(width: 1, color: Color(0xFFB6B5B5)),
                            ),
                          ),
                          listType: MultiSelectListType.CHIP,
                          initialValue: ref.read(pharmacyMainProvider.notifier).skillList,
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
                            ref.read(pharmacyMainProvider.notifier).changeSkillList(values);
                          },
                          chipDisplay: MultiSelectChipDisplay(
                            items: ref
                                .read(pharmacyMainProvider.notifier)
                                .skillList
                                ?.map((e) => MultiSelectItem(e, e.toString()))
                                .toList(),
                            chipColor: Color(0xFFF0069C1),
                            onTap: (value) {
                              ref.read(pharmacyMainProvider.notifier).skillList?.remove(value);
                              return ref.read(pharmacyMainProvider.notifier).skillList;
                            },
                            textStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 30,
                    ),

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
                          MultiSelectBottomSheetField<Software?>(
                            //enabled: softwareFieldEnabled,
                            selectedColor: Color(0xFFF0069C1),
                            selectedItemsTextStyle: TextStyle(color: Colors.white),
                            initialChildSize: 0.4,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1, color: Color(0xFFB6B5B5)),
                              ),
                            ),
                            listType: MultiSelectListType.CHIP,
                            initialValue: ref.read(pharmacyMainProvider.notifier).softwareList,
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
                              ref.read(pharmacyMainProvider.notifier).changeSoftwareList(values);
                            },
                            chipDisplay: MultiSelectChipDisplay(
                              items: ref
                                  .read(pharmacyMainProvider.notifier)
                                  .softwareList
                                  ?.map((e) => MultiSelectItem(e, e.toString()))
                                  .toList(),
                              chipColor: Color(0xFFF0069C1),
                              onTap: (value) {
                                ref.read(pharmacyMainProvider.notifier).softwareList?.remove(value);
                                return ref.read(pharmacyMainProvider.notifier).softwareList;
                              },
                              textStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

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
                          MultiSelectBottomSheetField<Language?>(
                            //enabled: softwareFieldEnabled,
                            selectedColor: Color(0xFFF0069C1),
                            selectedItemsTextStyle: TextStyle(color: Colors.white),
                            initialChildSize: 0.4,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1, color: Color(0xFFB6B5B5)),
                              ),
                            ),
                            listType: MultiSelectListType.CHIP,
                            initialValue: ref.read(pharmacyMainProvider.notifier).languageList,
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
                              ref.read(pharmacyMainProvider.notifier).changeLanguageList(values);
                            },
                            chipDisplay: MultiSelectChipDisplay(
                              items: ref
                                  .read(pharmacyMainProvider.notifier)
                                  .languageList
                                  ?.map((e) => MultiSelectItem(e, e.toString()))
                                  .toList(),
                              chipColor: Color(0xFF0069C1),
                              onTap: (value) {
                                ref.read(pharmacyMainProvider.notifier).languageList?.remove(value);
                                return ref.read(pharmacyMainProvider.notifier).languageList;
                              },
                              textStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

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
                    SizedBox(
                      height: 20,
                    ),

                    //Assistant On Site
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
                    SizedBox(
                      height: 20,
                    ),

                    // //Full Time
                    // Container(
                    //   width: MediaQuery.of(context).size.width * 0.85,
                    //   child: Row(
                    //     children: [
                    //       SizedBox(
                    //         height: 25,
                    //         width: 25,
                    //         child: Checkbox(
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(5),
                    //           ),
                    //           side: BorderSide(color: Color(0xFFC4C4C4), width: 2),
                    //           visualDensity: VisualDensity.compact,
                    //           value: ref.read(pharmacyMainProvider.notifier).fullTime,
                    //           onChanged: (value) {
                    //             ref.read(pharmacyMainProvider.notifier).changeFullTimeStatus(value);
                    //             setState(() {
                    //               startDateController.text = "N/A";
                    //               endDateController.text = "N/A";
                    //               startTimeController.text = "N/A";
                    //               endTimeController.text = "N/A";
                    //               ref.read(pharmacyMainProvider.notifier).clearDateValues();
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    //         child: RichText(
                    //           text: TextSpan(
                    //             text: "Full Time Position",
                    //             style: TextStyle(
                    //               fontSize: 18.0,
                    //               color: Colors.black,
                    //               fontFamily: GoogleFonts.montserrat().fontFamily,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),

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

                    SizedBox(
                      height: 20
                    ),

                    //Job Comments
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
                          TextField(
                            controller: commentsController,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            textAlign: TextAlign.start,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (value) {
                              ref.read(pharmacyMainProvider.notifier).changeComments(value);
                            },
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                            ),
                            decoration: InputDecoration(
                              hintText: "Include any important comments \nfor the pharmacist...",
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    //Submit Button
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: 51,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors.grey; // Disabled color
                                  }
                                  return Color(0xFF0069C1); // Regular color
                                }),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ))),
                            onPressed: (!ref
                                    .read(pharmacyMainProvider.notifier)
                                    .isValidCreateShift())
                                ? () {
                                    print("Pressed");
                                    print("Start Date: " +
                                        ref
                                            .read(pharmacyMainProvider.notifier)
                                            .startDate
                                            .toString());
                                    print("End Date: " +
                                        ref.read(pharmacyMainProvider.notifier).endDate.toString());
                                    print("Start Time: " +
                                        ref
                                            .read(pharmacyMainProvider.notifier)
                                            .startTime
                                            .toString());
                                    print("End Time: " +
                                        ref.read(pharmacyMainProvider.notifier).endTime.toString());
                                    print("Full Time: " +
                                        ref
                                            .read(pharmacyMainProvider.notifier)
                                            .fullTime
                                            .toString());
                                    print("Hourly Rate: " +
                                        ref
                                            .read(pharmacyMainProvider.notifier)
                                            .hourlyRate
                                            .toString());
                                    print("Assistant On-site: " +
                                        ref
                                            .read(pharmacyMainProvider.notifier)
                                            .assistantOnSite
                                            .toString());
                                    print("Skills: " +
                                        ref
                                            .read(pharmacyMainProvider.notifier)
                                            .skillList
                                            .toString());
                                    print("Software: " +
                                        ref
                                            .read(pharmacyMainProvider.notifier)
                                            .softwareList
                                            .toString());

                                    print("Languages: " +
                                        ref
                                            .read(pharmacyMainProvider.notifier)
                                            .languageList
                                            .toString());

                                    ref.read(authProvider.notifier).uploadJobToPharmacy(
                                        ref, ref.read(userProviderLogin.notifier).userUID, context);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JobHistoryPharmacy()));
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
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/*
Padding(
  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
  child: Material(
    elevation: 5,
    borderRadius: BorderRadius.circular(60),
    child: Container(
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey[100]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: DateTimeField(
                          controller: startDateController,
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
                            if (!showAllPharmacists) {
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
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: DateTimeField(
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                          controller: endDateController,
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
                            if (!showAllPharmacists) {
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
            // //Show all pharmacist options
            Container(
              width: 266,
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: RichText(
                  text: TextSpan(
                    text: "Full-Time Pharmacists",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                        color: Colors.black),
                  ),
                ),
                activeColor: Color(0xFFF0069C1),
                value: ref.read(pharmacyMainProvider.notifier).fullTime,
                onChanged: (value) {
                  ref
                      .read(pharmacyMainProvider.notifier)
                      .changeFullTimeStatus(value);
                  setState(() {
                    startDateController.text = "dd/mm/yyyy hh:mm";
                    endDateController.text = "dd/mm/yyyy hh:mm";

                    ref.read(pharmacyMainProvider.notifier).clearDateValues();
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.trailing, //  <-- leading Checkbox
              ),
            ),

            //Add User Type Option
            //Position Drop Box
            SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: "Position",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                    color: Colors.black),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 45,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                constraints: BoxConstraints(maxHeight: 60, minHeight: 10),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0.3, 5),
                        blurRadius: 3.0,
                        spreadRadius: 0.5,
                        color: Colors.grey.shade400)
                  ],
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200,
                ),
                child: DropdownButtonFormField<String>(
                    itemHeight: 80,
                    icon: Icon(Icons.arrow_downward, color: Colors.black),
                    hint: Text(
                      "Select your Position...",
                      style: GoogleFonts.inter(
                          color: Color(0xFFBDBDBD), fontSize: 16),
                    ),
                    value: ref.read(pharmacyMainProvider.notifier).position,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF0F0F0),
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                    ),
                    items: <String>[
                      'Pharmacist',
                      'Pharmacy Assistant',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          child: Text(value), value: value);
                    }).toList(),
                    onChanged: (String? value) {
                      ref
                          .read(pharmacyMainProvider.notifier)
                          .changePosition(value);
                    },
                    style: GoogleFonts.questrial(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )),
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
                    width: MediaQuery.of(context).size.width * 0.9,
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
                            ref
                                .read(pharmacyMainProvider.notifier)
                                .changeSkillList(values);
                          },
                          chipDisplay: MultiSelectChipDisplay(
                            items: ref
                                .read(pharmacyMainProvider.notifier)
                                .skillList
                                ?.map((e) => MultiSelectItem(e, e.toString()))
                                .toList(),
                            chipColor: Color(0xFFF0069C1),
                            onTap: (value) {
                              ref
                                  .read(pharmacyMainProvider.notifier)
                                  .skillList
                                  ?.remove(value);
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
                        width: 60,
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
                    width: MediaQuery.of(context).size.width * 0.9,
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
                            ? MultiSelectBottomSheetField<Software?>(
                                //enabled: softwareFieldEnabled,
                                selectedColor: Color(0xFFF0069C1),
                                selectedItemsTextStyle:
                                    TextStyle(color: Colors.white),
                                initialChildSize: 0.4,
                                decoration: BoxDecoration(),
                                listType: MultiSelectListType.CHIP,

                                searchable: true,
                                items: _softwareItems,
                                buttonText: Text("Select known skills...",
                                    style: GoogleFonts.inter(
                                        color: Color(0xFFBDBDBD), fontSize: 16)),
                                onConfirm: (values) {
                                  ref
                                      .read(pharmacyMainProvider.notifier)
                                      .changeSoftwareList(values);
                                },
                                chipDisplay: MultiSelectChipDisplay(
                                  items: ref
                                      .read(pharmacyMainProvider.notifier)
                                      .softwareList
                                      ?.map(
                                          (e) => MultiSelectItem(e, e.toString()))
                                      .toList(),
                                  chipColor: Color(0xFFF0069C1),
                                  onTap: (value) {
                                    ref
                                        .read(pharmacyMainProvider.notifier)
                                        .softwareList
                                        ?.remove(value);
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
              padding: EdgeInsets.zero,
              child: Container(
                width: 268,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
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
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                width: 268,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
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
                        width: MediaQuery.of(context).size.width * 0.48,
                        alignment: Alignment.center,
                        child: TextField(
                          onChanged: (value) {
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
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Container(
                width: 268,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
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
                        maxLines: 3,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        onChanged: (value) {
                          ref
                              .read(pharmacyMainProvider.notifier)
                              .changeComments(value);
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

*/
