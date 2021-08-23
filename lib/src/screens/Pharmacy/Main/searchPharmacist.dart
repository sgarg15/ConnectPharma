import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/availablePharmacists.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';
import '../../../../Custom Widgets/custom_dateTimeField.dart';
import '../../../../all_used.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPharmacistPharmacy extends StatefulWidget {
  SearchPharmacistPharmacy({Key? key}) : super(key: key);

  @override
  _SearchPharmacistPharmacyState createState() =>
      _SearchPharmacistPharmacyState();
}

class _SearchPharmacistPharmacyState extends State<SearchPharmacistPharmacy> {
  final _softwareItems = software
      .map((software) => MultiSelectItem<Software>(software, software.name))
      .toList();
  final _skillItems =
      skill.map((skill) => MultiSelectItem<Skill>(skill, skill.name)).toList();

  bool softwareFieldEnabled = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read(pharmacyMainProvider.notifier).clearDateValues();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 12,
          title: Text(
            "Search Pharmacists",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
          ),
          backgroundColor: Color(0xFFF6F6F6),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(60),
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[100]),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                  child: Material(
                                    elevation: 7,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height: 55,
                                      width: 200,
                                      child: DateTimeField(
                                        format:
                                            DateFormat("MM/dd/yyyy hh:mm a"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                        ),
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.5),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.5),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        onShowPicker:
                                            (context, currentValue) async {
                                          final date = await showDatePicker(
                                              context: context,
                                              firstDate: DateTime.now(),
                                              initialDate: currentValue ??
                                                  DateTime.now(),
                                              lastDate: DateTime(2100));
                                          if (date != null) {
                                            final time = await showTimePicker(
                                              context: context,
                                              initialTime:
                                                  TimeOfDay.fromDateTime(
                                                      currentValue ??
                                                          DateTime.now()),
                                            );
                                            context
                                                .read(pharmacyMainProvider
                                                    .notifier)
                                                .changeStartDate(
                                                    DateTimeField.combine(
                                                        date, time));
                                            print(DateTimeField.combine(
                                                date, time));
                                            return DateTimeField.combine(
                                                date, time);
                                          } else {
                                            context
                                                .read(pharmacyMainProvider
                                                    .notifier)
                                                .changeStartDate(currentValue);
                                            return currentValue;
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
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 0, 0, 0),
                                  child: Material(
                                    elevation: 7,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height: 55,
                                      width: 200,
                                      child: DateTimeField(
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                        ),
                                        format:
                                            DateFormat("MM/dd/yyyy hh:mm a"),
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.5),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.5),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        onShowPicker:
                                            (context, currentValue) async {
                                          final date = await showDatePicker(
                                              context: context,
                                              firstDate: context
                                                  .read(pharmacyMainProvider
                                                      .notifier)
                                                  .startDate as DateTime,
                                              initialDate: context
                                                  .read(pharmacyMainProvider
                                                      .notifier)
                                                  .startDate as DateTime,
                                              lastDate: DateTime(2100));
                                          if (date != null) {
                                            final time = await showTimePicker(
                                              context: context,
                                              initialTime:
                                                  TimeOfDay.fromDateTime(
                                                      currentValue ??
                                                          DateTime.now()),
                                            );
                                            context
                                                .read(pharmacyMainProvider
                                                    .notifier)
                                                .changeEndDate(
                                                    DateTimeField.combine(
                                                        date, time));

                                            return DateTimeField.combine(
                                                date, time);
                                          } else {
                                            context
                                                .read(pharmacyMainProvider
                                                    .notifier)
                                                .changeEndDate(currentValue);
                                            return currentValue;
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
                                      MultiSelectBottomSheetField<Skill?>(
                                        selectedColor: Color(0xFF5DB075),
                                        selectedItemsTextStyle:
                                            TextStyle(color: Colors.white),
                                        initialChildSize: 0.4,
                                        decoration: BoxDecoration(),
                                        listType: MultiSelectListType.CHIP,
                                        initialValue: context
                                            .read(pharmacyMainProvider.notifier)
                                            .skillList,
                                        searchable: true,
                                        items: _skillItems,
                                        buttonText: Text(
                                            "Select known skills...",
                                            style: GoogleFonts.inter(
                                                color: Color(0xFFBDBDBD),
                                                fontSize: 16)),
                                        onConfirm: (values) {
                                          context
                                              .read(
                                                  pharmacyMainProvider.notifier)
                                              .changeSkillList(values);
                                        },
                                        chipDisplay: MultiSelectChipDisplay(
                                          items: context
                                              .read(
                                                  pharmacyMainProvider.notifier)
                                              .skillList
                                              ?.map((e) => MultiSelectItem(
                                                  e, e.toString()))
                                              .toList(),
                                          chipColor: Color(0xFF5DB075),
                                          onTap: (value) {
                                            context
                                                .read(pharmacyMainProvider
                                                    .notifier)
                                                .skillList
                                                ?.remove(value);
                                            return context
                                                .read(pharmacyMainProvider
                                                    .notifier)
                                                .skillList;
                                          },
                                          textStyle:
                                              TextStyle(color: Colors.white),
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
                                          activeColor: Color(0xFF5DB075),
                                          value: softwareFieldEnabled,
                                          onChanged: (value) {
                                            setState(() {
                                              softwareFieldEnabled =
                                                  !softwareFieldEnabled;
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        )
                                      : null,
                                  child: Column(
                                    children: <Widget>[
                                      softwareFieldEnabled
                                          ? MultiSelectBottomSheetField<
                                              Software?>(
                                              //enabled: softwareFieldEnabled,
                                              selectedColor: Color(0xFF5DB075),
                                              selectedItemsTextStyle: TextStyle(
                                                  color: Colors.white),
                                              initialChildSize: 0.4,
                                              decoration: BoxDecoration(),
                                              listType:
                                                  MultiSelectListType.CHIP,
                                              initialValue: context
                                                  .read(pharmacyMainProvider
                                                      .notifier)
                                                  .softwareList,
                                              searchable: true,
                                              items: _softwareItems,
                                              buttonText: Text(
                                                  "Select known skills...",
                                                  style: GoogleFonts.inter(
                                                      color: Color(0xFFBDBDBD),
                                                      fontSize: 16)),
                                              onConfirm: (values) {
                                                context
                                                    .read(pharmacyMainProvider
                                                        .notifier)
                                                    .changeSoftwareList(values);
                                              },
                                              chipDisplay:
                                                  MultiSelectChipDisplay(
                                                items: context
                                                    .read(pharmacyMainProvider
                                                        .notifier)
                                                    .softwareList
                                                    ?.map((e) =>
                                                        MultiSelectItem(
                                                            e, e.toString()))
                                                    .toList(),
                                                chipColor: Color(0xFF5DB075),
                                                onTap: (value) {
                                                  context
                                                      .read(pharmacyMainProvider
                                                          .notifier)
                                                      .softwareList
                                                      ?.remove(value);
                                                  return context
                                                      .read(pharmacyMainProvider
                                                          .notifier)
                                                      .softwareList;
                                                },
                                                textStyle: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
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
              //Search Button
              Consumer(
                builder: (context, watch, child) {
                  watch(pharmacyMainProvider);
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: SizedBox(
                        width: 340,
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
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ))),
                          onPressed: (!context
                                  .read(pharmacyMainProvider.notifier)
                                  .isValidSearchPharmacist())
                              ? () {
                                  print("Pressed");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AvailablePharmacists()));
                                }
                              : null,
                          child: RichText(
                            text: TextSpan(
                              text: "Look for Pharmacists",
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
                  );
                },
              ),

              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
