import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/availablePharmacists.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';
import '../../../../Custom Widgets/custom_dateTimeField.dart';
import '../../../../all_used.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//TODO: Add Show All pharmacist options

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
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  bool softwareFieldEnabled = false;
  bool skillFieldEnabled = false;
  bool showAllPharmacists = false;

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      child: DateTimeField(
                                        controller: startDateController,
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
                                            context
                                                .read(pharmacyMainProvider
                                                    .notifier)
                                                .changeStartDate(date);
                                            print(date);
                                            return date;
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
                            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      child: DateTimeField(
                                        controller: endDateController,
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
                                          if (context
                                                  .read(pharmacyMainProvider
                                                      .notifier)
                                                  .startDate !=
                                              null) {
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
                                              context
                                                  .read(pharmacyMainProvider
                                                      .notifier)
                                                  .changeEndDate(date);
                                              print(date);
                                              return date;
                                            } else {
                                              context
                                                  .read(pharmacyMainProvider
                                                      .notifier)
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
                              activeColor: Color(0xFF5DB075),
                              value: showAllPharmacists,
                              onChanged: (value) {
                                setState(() {
                                  showAllPharmacists = !showAllPharmacists;
                                  startDateController.text = "dd/mm/yyyy hh:mm";
                                  endDateController.text = "dd/mm/yyyy hh:mm";
                                  context
                                      .read(pharmacyMainProvider.notifier)
                                      .clearDateValues();
                                });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .trailing, //  <-- leading Checkbox
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
                              constraints:
                                  BoxConstraints(maxHeight: 60, minHeight: 10),
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
                                  icon: Icon(Icons.arrow_downward,
                                      color: Colors.black),
                                  hint: Text(
                                    "Select your Position...",
                                    style: GoogleFonts.inter(
                                        color: Color(0xFFBDBDBD), fontSize: 16),
                                  ),
                                  value: context
                                      .read(pharmacyMainProvider.notifier)
                                      .position,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF0F0F0),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Color(0xFFE8E8E8))),
                                  ),
                                  items: <String>[
                                    'Pharmacist',
                                    'Pharmacy Assistant',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                        child: Text(value), value: value);
                                  }).toList(),
                                  onChanged: (String? value) {
                                    context
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
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
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
                                      width: 55,
                                    ),
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Checkbox(
                                          activeColor: Color(0xFF5DB075),
                                          value: skillFieldEnabled,
                                          onChanged: (value) {
                                            setState(() {
                                              skillFieldEnabled =
                                                  !skillFieldEnabled;
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: skillFieldEnabled
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
                                      skillFieldEnabled
                                          ? MultiSelectBottomSheetField<Skill?>(
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
                                                    .read(pharmacyMainProvider
                                                        .notifier)
                                                    .changeSkillList(values);
                                              },
                                              chipDisplay:
                                                  MultiSelectChipDisplay(
                                                items: context
                                                    .read(pharmacyMainProvider
                                                        .notifier)
                                                    .skillList
                                                    ?.map((e) =>
                                                        MultiSelectItem(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
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
              //Test Job Upload Button
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
              //   child: SizedBox(
              //     width: 340,
              //     height: 51,
              //     child: ElevatedButton(
              //       style: ButtonStyle(
              //           backgroundColor:
              //               MaterialStateProperty.resolveWith<Color>((states) {
              //             if (states.contains(MaterialState.disabled)) {
              //               return Colors.grey; // Disabled color
              //             }
              //             return Color(0xFF5DB075); // Regular color
              //           }),
              //           shape:
              //               MaterialStateProperty.all<RoundedRectangleBorder>(
              //                   RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(100),
              //           ))),
              //       onPressed: () {
              //         print("Pressed");
              //         context
              //             .read(authProvider.notifier)
              //             .uploadTestJobToPharmacy(
              //                 context.read(userProviderLogin.notifier).userUID,
              //                 context);
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => AvailablePharmacists()));
              //       },
              //       child: RichText(
              //         text: TextSpan(
              //           text: "Upload Test Job",
              //           style: TextStyle(
              //             fontSize: 18,
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

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
                          onPressed: (context
                                  .read(pharmacyMainProvider.notifier)
                                  .isValidSearchPharmacist(showAllPharmacists))
                              ? () {
                                  print("Pressed");
                                  print(context
                                      .read(pharmacyMainProvider)
                                      .position);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AvailablePharmacists(
                                                showFullTimePharmacists:
                                                    showAllPharmacists,
                                              )));
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
