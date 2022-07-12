import 'package:flutter/material.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign%20Up/1pharmacistSignUp.dart';
import 'package:connectpharma/src/screens/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'jobHistoryPharmacist.dart';

class PharmacistAvailability extends ConsumerStatefulWidget {
  PharmacistAvailability({Key? key}) : super(key: key);

  @override
  _PharmacistAvailabilityState createState() => _PharmacistAvailabilityState();
}

class _PharmacistAvailabilityState extends ConsumerState<PharmacistAvailability> {
  String bullet = "\u2022";
  Map dateRangesTemp = Map();
  Map dateRangesToUpload = Map();
  List<PickerDateRange> dateRangesFromFirestore = [];
  String permanentJobBool = "";
  String nightShiftBool = "";

  void changeAvailabilityToCalendar(WidgetRef ref) {
    List<PickerDateRange> dateRangesCalendarTemp = [];
    print(ref.read(pharmacistMainProvider.notifier).userDataMap?["availability"]);
    for (var i = 0;
        i < ref.read(pharmacistMainProvider.notifier).userDataMap?["availability"].length;
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
      dateRangesFromFirestore.sort((a, b) => a.startDate!.compareTo(b.startDate as DateTime));
    });
  }

  @override
  void initState() {
    super.initState();
    changeAvailabilityToCalendar(ref);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pharmacistMainProvider.notifier).changeDateRanges(dateRangesFromFirestore);
    });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    ref.read(pharmacistMainProvider.notifier).changeDateRanges(args.value);

    ref
        .read(pharmacistMainProvider.notifier)
        .dateRanges
        .sort((a, b) => a.startDate!.compareTo(b.startDate as DateTime));
    dateRangesTemp.clear();
    for (var i = 0; i < ref.read(pharmacistMainProvider.notifier).dateRanges.length; i++) {
      dateRangesTemp[i.toString()] = {
        "startDate": args.value[i].startDate,
        "endDate": args.value[i].endDate
      };
    }
    print("Before setstate");
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          dateRangesToUpload = dateRangesTemp;
        }));

    print(dateRangesToUpload);
    //print(ref.read(pharmacistMainProvider.notifier).dateRanges);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: new Text(
          "Availability",
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Calendar
            Container(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: SfDateRangePicker(
                monthViewSettings: DateRangePickerMonthViewSettings(
                  showTrailingAndLeadingDates: true,
                ),
                headerStyle: DateRangePickerHeaderStyle(
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )),
                onSelectionChanged: _onSelectionChanged,
                initialSelectedRanges: dateRangesFromFirestore,
                view: DateRangePickerView.month,
                navigationDirection: DateRangePickerNavigationDirection.vertical,
                selectionShape: DateRangePickerSelectionShape.circle,
                selectionMode: DateRangePickerSelectionMode.multiRange,
                selectionTextStyle: TextStyle(color: Colors.white),
                selectionColor: Color(0xFFE8F4FF),
                startRangeSelectionColor: Color(0xFF0069C1),
                endRangeSelectionColor: Color(0xFF0069C1),
                rangeSelectionColor: Color(0xFFE8F4FF),
                rangeTextStyle: TextStyle(color: Colors.black),
              ),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            ),

            Divider(),

            //List view of Calendar
            Container(
              width: 350,
              height: 200,
              child: Column(
                children: <Widget>[
                  //Title of conatiner
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              text: "List View",
                              style: TextStyle(
                                  fontFamily: GoogleFonts.montserrat().fontFamily,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                  color: Color(0xFF808080)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 10, 0),
                        child: IconButton(
                            constraints: BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Center(
                                            child: Text(
                                          "Clear Calendar?",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: GoogleFonts.montserrat(
                                                      fontWeight: FontWeight.w500)
                                                  .fontFamily),
                                        )),
                                        content: Text(
                                          "Clear Availability Calender?",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: GoogleFonts.montserrat(
                                                      fontWeight: FontWeight.normal)
                                                  .fontFamily),
                                        ),
                                        actions: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: TextButton(
                                                  child: Center(
                                                      child: Text(
                                                    "Confirm",
                                                    style: TextStyle(color: Colors.white),
                                                  )),
                                                  style: ButtonStyle(backgroundColor:
                                                      MaterialStateProperty.resolveWith<Color>(
                                                          (Set<MaterialState> states) {
                                                    if (states.contains(MaterialState.pressed)) {
                                                      return Color(0xFF0069C1);
                                                    } else if (states
                                                        .contains(MaterialState.disabled)) {
                                                      return Colors.grey;
                                                    }
                                                    return Color(0xFF0069C1);
                                                  })),
                                                  onPressed: () {
                                                    setState(() {
                                                      dateRangesToUpload.clear();
                                                      dateRangesFromFirestore.clear();
                                                      print("Date ranges from firestore: " +
                                                          dateRangesFromFirestore.toString());
                                                      ref
                                                          .read(pharmacistMainProvider.notifier)
                                                          .changeDateRanges(
                                                              dateRangesFromFirestore);
                                                      ref
                                                          .read(authProvider.notifier)
                                                          .clearAvailabilityData(ref
                                                              .read(userProviderLogin.notifier)
                                                              .userUID);
                                                    });
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                JobHistoryPharmacist()));
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ));
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            )),
                      ),
                    ],
                  ),
                  //List view of calendar
                  Container(
                    child: Expanded(
                      child: ListView(
                        children: <Widget>[
                          for (var i = 0;
                              i < ref.read(pharmacistMainProvider.notifier).dateRanges.length;
                              i++) ...[
                            ListTile(
                              leading: Container(
                                height: double.infinity,
                                child: MyBullet(),
                              ),
                              minLeadingWidth: 0,
                              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                              title: Text(
                                DateFormat.yMMMMd('en_US')
                                        .format(ref
                                            .read(pharmacistMainProvider.notifier)
                                            .dateRanges[i]
                                            .startDate as DateTime)
                                        .toString() +
                                    ' - ' +
                                    DateFormat.yMMMMd('en_US')
                                        .format(ref
                                                .read(pharmacistMainProvider.notifier)
                                                .dateRanges[i]
                                                .endDate ??
                                            ref
                                                .read(pharmacistMainProvider.notifier)
                                                .dateRanges[i]
                                                .startDate as DateTime)
                                        .toString(),
                                style: TextStyle(
                                    fontFamily: GoogleFonts.montserrat().fontFamily, fontSize: 15),
                              ),
                            )
                          ],
                          if (ref.read(pharmacistMainProvider.notifier).dateRanges.isEmpty) ...[
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
                  ),
                ],
              ),
            ),

            Divider(),
            //Night Shift job
            CheckboxListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 0, 20, 0),
              title: RichText(
                text: TextSpan(
                  text: "Night Shift?",
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black),
                ),
              ),
              activeColor: Color(0xFFF0069C1),
              value: ref.read(pharmacistMainProvider.notifier).nightShift,
              onChanged: (value) {
                setState(() {
                  nightShiftBool = "true";
                });
                ref.read(pharmacistMainProvider.notifier).changeNightShift(value);
              },
              controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),

            //Permanent Job
            CheckboxListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 0, 20, 0),
              title: RichText(
                text: TextSpan(
                  text: "Permanent Job?",
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black),
                ),
              ),
              activeColor: Color(0xFFF0069C1),
              value: ref.read(pharmacistMainProvider.notifier).permanentJob,
              onChanged: (value) {
                setState(() {
                  permanentJobBool = "true";
                });
                ref.read(pharmacistMainProvider.notifier).changePermanentJob(value);
              },
              controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),

            //Save Button
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
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
                    onPressed: (dateRangesToUpload.isNotEmpty ||
                            permanentJobBool != "" ||
                            nightShiftBool != "")
                        ? () {
                            print("Pressed");
                            
                            ref.read(authProvider.notifier).uploadAvailalibitlityData(
                                ref.read(userProviderLogin.notifier).userUID,
                                dateRangesToUpload,
                                ref.read(pharmacistMainProvider.notifier).permanentJob,
                                ref.read(pharmacistMainProvider.notifier).nightShift);
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

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 10.0,
      width: 10.0,
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      decoration: new BoxDecoration(
        color: Color(0xFF0069C1),
        shape: BoxShape.circle,
      ),
    );
  }
}
