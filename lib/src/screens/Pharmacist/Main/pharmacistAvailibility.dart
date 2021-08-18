import 'package:flutter/material.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Sign%20Up/1pharmacistSignUp.dart';
import 'package:pharma_connect/src/screens/login.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'jobHistoryPharmacist.dart';

class PharmacistAvailability extends StatefulWidget {
  PharmacistAvailability({Key? key}) : super(key: key);

  @override
  _PharmacistAvailabilityState createState() => _PharmacistAvailabilityState();
}

class _PharmacistAvailabilityState extends State<PharmacistAvailability> {
  String bullet = "\u2022";
  Map dateRangesTemp = Map();
  Map dateRangesToUpload = Map();
  List<PickerDateRange> dateRangesFromFirestore = [];

  void changeAvailabilityToCalendar() {
    List<PickerDateRange> dateRangesCalendarTemp = [];
    for (var i = 0;
        i <
            context
                .read(pharmacistMainProvider.notifier)
                .userDataMap?["availability"]
                .length;
        i++) {
      dateRangesCalendarTemp.add(PickerDateRange(
          context
              .read(pharmacistMainProvider.notifier)
              .userDataMap?["availability"][i.toString()]["startDate"]
              .toDate(),
          context
              .read(pharmacistMainProvider.notifier)
              .userDataMap?["availability"][i.toString()]["endDate"]
              .toDate()));
    }
    setState(() {
      dateRangesFromFirestore = dateRangesCalendarTemp;
      dateRangesFromFirestore
          .sort((a, b) => a.startDate!.compareTo(b.startDate as DateTime));
    });
  }

  @override
  void initState() {
    super.initState();
    changeAvailabilityToCalendar();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context
          .read(pharmacistMainProvider.notifier)
          .changeDateRanges(dateRangesFromFirestore);
    });
  }

  @override
  Widget build(BuildContext context) {
    void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      //TODO: This function gets the list of ranges of dates and updates the list view of the calendar.
      // setState(() {
      //   dateRanges = args.value;
      // });
      context
          .read(pharmacistMainProvider.notifier)
          .changeDateRanges(args.value);

      context
          .read(pharmacistMainProvider.notifier)
          .dateRanges
          .sort((a, b) => a.startDate!.compareTo(b.startDate as DateTime));
      dateRangesTemp.clear();
      for (var i = 0;
          i < context.read(pharmacistMainProvider.notifier).dateRanges.length;
          i++) {
        dateRangesTemp[i.toString()] = {
          "startDate": args.value[i].startDate,
          "endDate": args.value[i].endDate
        };
      }
      setState(() {
        dateRangesToUpload = dateRangesTemp;
      });
      print(dateRangesToUpload);
      //print(context.read(pharmacistMainProvider.notifier).dateRanges);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 12,
        title: Text(
          "Availability",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
        ),
        backgroundColor: Color(0xFFF6F6F6),
      ),
      body: Column(
        children: <Widget>[
          //Calendar
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                child: SfDateRangePicker(
                  onSelectionChanged: _onSelectionChanged,
                  initialSelectedRanges: dateRangesFromFirestore,
                  view: DateRangePickerView.month,
                  navigationDirection:
                      DateRangePickerNavigationDirection.vertical,
                  selectionShape: DateRangePickerSelectionShape.rectangle,
                  selectionMode: DateRangePickerSelectionMode.multiRange,
                  selectionTextStyle:
                      TextStyle(color: Colors.white, fontSize: 20),
                  selectionColor: Color(0xFF5DB075),
                  startRangeSelectionColor: Color(0xFF228a4d),
                  endRangeSelectionColor: Color(0xFF228a4d),
                  rangeSelectionColor: Color(0xFF5DB075),
                  rangeTextStyle: TextStyle(color: Colors.white, fontSize: 20),
                ),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),

          //List view of Calendar
          Consumer(builder: (context, watch, child) {
            watch(pharmacistMainProvider);
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Material(
                elevation: 20,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 350,
                  height: 200,
                  child: Column(
                    children: <Widget>[
                      //Title of conatiner
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Container(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "List View",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      //List view of calendar
                      Expanded(
                        child: ListView(
                          //TODO: Add the system to get and display the ranges from the calendar to list view
                          children: <Widget>[
                            for (var i = 0;
                                i <
                                    context
                                        .read(pharmacistMainProvider.notifier)
                                        .dateRanges
                                        .length;
                                i++) ...[
                              ListTile(
                                visualDensity:
                                    VisualDensity(horizontal: 0, vertical: -4),
                                title: Text(bullet +
                                    " " +
                                    DateFormat.yMMMMd('en_US')
                                        .format(context
                                            .read(
                                                pharmacistMainProvider.notifier)
                                            .dateRanges[i]
                                            .startDate as DateTime)
                                        .toString() +
                                    ' - ' +
                                    DateFormat.yMMMMd('en_US')
                                        .format(context
                                                .read(pharmacistMainProvider
                                                    .notifier)
                                                .dateRanges[i]
                                                .endDate ??
                                            context
                                                .read(pharmacistMainProvider
                                                    .notifier)
                                                .dateRanges[i]
                                                .startDate as DateTime)
                                        .toString()),
                              )
                            ],
                            if (context
                                .read(pharmacistMainProvider.notifier)
                                .dateRanges
                                .isEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: "No Dates Selected",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18.0,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          //Save Button
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: SizedBox(
              width: 324,
              height: 51,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey; // Disabled color
                      }
                      return Color(0xFF5DB075); // Regular color
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ))),
                onPressed: dateRangesToUpload.isNotEmpty
                    ? () {
                        print("Pressed");
                        context
                            .read(authProvider.notifier)
                            .uploadAvailalibitlityData(
                                context
                                    .read(userProviderLogin.notifier)
                                    .userUID,
                                dateRangesToUpload);
                        //TODO: Start a cloud function which starts a timer for 5 min and then sends data to firestore, to prevent abuse of firestore writes and reads
                        Navigator.pop(context);
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
          )
        ],
      ),
    );
  }
}
