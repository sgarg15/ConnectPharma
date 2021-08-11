import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:pharma_connect/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Sign%20Up/1pharmacy_signup.dart';
import 'package:pharma_connect/src/screens/login.dart';
import '../../../../Custom Widgets/custom_dateTimeField.dart';
import '../../../../all_used.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateShift extends StatefulWidget {
  CreateShift({Key? key}) : super(key: key);

  @override
  _CreateShiftPharmacyState createState() => _CreateShiftPharmacyState();
}

class _CreateShiftPharmacyState extends State<CreateShift> {
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
        context.read(pharmacyMainProvider.notifier).clearValues();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 12,
          title: Text(
            "Create Shift",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
          ),
          backgroundColor: Color(0xFFF6F6F6),
        ),
        body: Consumer(
          builder: (context, watch, child) {
            watch(pharmacyMainProvider);
            return SingleChildScrollView(
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
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 0, 0, 0),
                                      child: Material(
                                        elevation: 7,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          height: 55,
                                          width: 200,
                                          child: DateTimeField(
                                            format: DateFormat(
                                                "MM/dd/yyyy hh:mm a"),
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
                                                final time =
                                                    await showTimePicker(
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
                                                    .changeStartDate(
                                                        currentValue);
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
                                      padding: const EdgeInsets.fromLTRB(
                                          50, 0, 0, 0),
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
                                            format: DateFormat(
                                                "MM/dd/yyyy hh:mm a"),
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
                                                final time =
                                                    await showTimePicker(
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
                                                    .changeEndDate(
                                                        currentValue);
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
                                            chipDisplay: MultiSelectChipDisplay(
                                              items: context
                                                  .read(pharmacyMainProvider
                                                      .notifier)
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
                                              textStyle: TextStyle(
                                                  color: Colors.white),
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
                                                  selectedColor:
                                                      Color(0xFF5DB075),
                                                  selectedItemsTextStyle:
                                                      TextStyle(
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
                                                          color:
                                                              Color(0xFFBDBDBD),
                                                          fontSize: 16)),
                                                  onConfirm: (values) {
                                                    context
                                                        .read(
                                                            pharmacyMainProvider
                                                                .notifier)
                                                        .changeSoftwareList(
                                                            values);
                                                  },
                                                  chipDisplay:
                                                      MultiSelectChipDisplay(
                                                    items: context
                                                        .read(
                                                            pharmacyMainProvider
                                                                .notifier)
                                                        .softwareList
                                                        ?.map((e) =>
                                                            MultiSelectItem(e,
                                                                e.toString()))
                                                        .toList(),
                                                    chipColor:
                                                        Color(0xFF5DB075),
                                                    onTap: (value) {
                                                      context
                                                          .read(
                                                              pharmacyMainProvider
                                                                  .notifier)
                                                          .softwareList
                                                          ?.remove(value);
                                                      return context
                                                          .read(
                                                              pharmacyMainProvider
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
                                    activeColor: Color(0xFF5DB075),
                                    value: context
                                        .read(pharmacyMainProvider.notifier)
                                        .techOnSite,
                                    onChanged: (value) {
                                      context
                                          .read(pharmacyMainProvider.notifier)
                                          .changeTechOnSite(value);
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .trailing, //  <-- leading Checkbox
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
                                    activeColor: Color(0xFF5DB075),
                                    value: context
                                        .read(pharmacyMainProvider.notifier)
                                        .assistantOnSite,
                                    onChanged: (value) {
                                      context
                                          .read(pharmacyMainProvider.notifier)
                                          .changeAssistantOnSite(value);
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .trailing, //  <-- leading Checkbox
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
                                      padding: const EdgeInsets.fromLTRB(
                                          47, 0, 0, 0),
                                      child: Material(
                                        elevation: 7,
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          height: 55,
                                          width: 174,
                                          alignment: Alignment.center,
                                          child: TextField(
                                            onChanged: (value) {
                                              context
                                                  .read(pharmacyMainProvider
                                                      .notifier)
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
                                            inputFormatters: [
                                              MaskedInputFormatter('\$##.##')
                                            ],
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
                                    activeColor: Color(0xFF5DB075),
                                    value: context
                                        .read(pharmacyMainProvider.notifier)
                                        .limaStatus,
                                    onChanged: (value) {
                                      context
                                          .read(pharmacyMainProvider.notifier)
                                          .changeLIMAStatus(value);
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .trailing, //  <-- leading Checkbox
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
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 0),
                                      child: Container(
                                        color: Colors.white,
                                        width: 324,
                                        constraints:
                                            BoxConstraints(minHeight: 60),
                                        child: TextField(
                                          maxLines: 3,
                                          keyboardType: TextInputType.text,
                                          textAlign: TextAlign.start,
                                          onSubmitted: (value) {
                                            context
                                                .read(pharmacyMainProvider
                                                    .notifier)
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
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                  //Search Button
                  Center(
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
                                  .isValidCreateShift())
                              ? () {
                                  print("Pressed");

                                  context
                                      .read(authProvider.notifier)
                                      .uploadJobToPharmacy(
                                          context
                                              .read(userProviderLogin.notifier)
                                              .userUID,
                                          context);
                                  //TODO: Send job data to under the pharmacy job collection and in the job aggregated data

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              JobHistoryPharmacy()));
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
    );
  }
}
