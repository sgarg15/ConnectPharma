import 'package:flutter/material.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Sign%20Up/1pharmacistSignUp.dart';
import 'package:pharma_connect/src/screens/login.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'jobHistoryPharmacist.dart';

class PharmacistAvailability extends ConsumerStatefulWidget {
  PharmacistAvailability({Key? key}) : super(key: key);

  @override
  _PharmacistAvailabilityState createState() => _PharmacistAvailabilityState();
}

class _PharmacistAvailabilityState
    extends ConsumerState<PharmacistAvailability> {
  String bullet = "\u2022";
  Map dateRangesTemp = Map();
  Map dateRangesToUpload = Map();
  List<PickerDateRange> dateRangesFromFirestore = [];
  String permanentJobBool = "";

  void changeAvailabilityToCalendar(WidgetRef ref) {
    List<PickerDateRange> dateRangesCalendarTemp = [];
    print(
        ref.read(pharmacistMainProvider.notifier)
        .userDataMap?["availability"]);
    for (var i = 0;
        i <
            ref
                .read(pharmacistMainProvider.notifier)
                .userDataMap?["availability"]
                .length;
        i++) {
      dateRangesCalendarTemp.add(PickerDateRange(
          ref
              .read(pharmacistMainProvider.notifier)
              .userDataMap?["availability"][i.toString()]["startDate"]
              .toDate(),
          ref
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
    changeAvailabilityToCalendar(ref);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref
          .read(pharmacistMainProvider.notifier)
          .changeDateRanges(dateRangesFromFirestore);
    });
  }

  @override
  Widget build(BuildContext context) {
    void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      ref.read(pharmacistMainProvider.notifier)
          .changeDateRanges(args.value);

      ref
          .read(pharmacistMainProvider.notifier)
          .dateRanges
          .sort((a, b) => a.startDate!.compareTo(b.startDate as DateTime));
      dateRangesTemp.clear();
      for (var i = 0;
          i < ref.read(pharmacistMainProvider.notifier).dateRanges.length;
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
      //print(ref.read(pharmacistMainProvider.notifier).dateRanges);
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    rangeTextStyle:
                        TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),

            //List view of Calendar
            Consumer(builder: (context, ref, child) {
              ref.watch(pharmacistMainProvider);
              return Center(
                child: Padding(
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
                              children: <Widget>[
                                for (var i = 0;
                                    i <
                                        ref
                                            .read(
                                                pharmacistMainProvider.notifier)
                                            .dateRanges
                                            .length;
                                    i++) ...[
                                  ListTile(
                                    visualDensity: VisualDensity(
                                        horizontal: 0, vertical: -4),
                                    title: Text(bullet +
                                        " " +
                                        DateFormat.yMMMMd('en_US')
                                            .format(ref
                                                .read(pharmacistMainProvider
                                                    .notifier)
                                                .dateRanges[i]
                                                .startDate as DateTime)
                                            .toString() +
                                        ' - ' +
                                        DateFormat.yMMMMd('en_US')
                                            .format(ref
                                                    .read(pharmacistMainProvider
                                                        .notifier)
                                                    .dateRanges[i]
                                                    .endDate ??
                                                ref
                                                    .read(pharmacistMainProvider
                                                        .notifier)
                                                    .dateRanges[i]
                                                    .startDate as DateTime)
                                            .toString()),
                                  )
                                ],
                                if (ref
                                    .read(pharmacistMainProvider.notifier)
                                    .dateRanges
                                    .isEmpty) ...[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 5, 0),
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
                ),
              );
            }),

            //Permanent job
            Consumer(builder: (context, ref, child) {
              ref.watch(pharmacistMainProvider);
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.fromLTRB(15, 0, 20, 0),
                  title: RichText(
                    text: TextSpan(
                      text: "Looking for a permanent job?",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.black),
                    ),
                  ),
                  activeColor: Color(0xFF5DB075),
                  value: ref.read(pharmacistMainProvider.notifier)
                      .permanentJob,
                  onChanged: (value) {
                    setState(() {
                      permanentJobBool = "true";
                    });
                    ref
                        .read(pharmacistMainProvider.notifier)
                        .changePermanentJob(value);
                  },
                  controlAffinity:
                      ListTileControlAffinity.trailing, //  <-- leading Checkbox
                ),
              );
            }),

            //Save Button
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ))),
                    onPressed: (dateRangesToUpload.isNotEmpty ||
                            permanentJobBool != "")
                        ? () {
                            print("Pressed");
                            ref
                                .read(authProvider.notifier)
                                .uploadAvailalibitlityData(
                                    ref
                                        .read(userProviderLogin.notifier)
                                        .userUID,
                                    dateRangesToUpload,
                                    ref
                                        .read(pharmacistMainProvider.notifier)
                                        .permanentJob);
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
