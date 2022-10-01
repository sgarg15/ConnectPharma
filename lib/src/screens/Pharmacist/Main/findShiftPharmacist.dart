import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:connectpharma/src/screens/Pharmacist/Main/jobDetails.dart';
import 'package:connectpharma/src/screens/Pharmacist/Main/jobHistoryPharmacist.dart';
import 'package:geocoding/geocoding.dart';
import 'package:connectpharma/src/screens/login.dart';

import '../../../../all_used.dart';
import '../../../../Custom Widgets/fileStorage.dart';
import 'package:geolocator/geolocator.dart';

class FindShiftForPharmacist extends ConsumerStatefulWidget {
  FindShiftForPharmacist({Key? key}) : super(key: key);

  @override
  _FindShiftForPharmacistState createState() => _FindShiftForPharmacistState();
}

class _FindShiftForPharmacistState extends ConsumerState<FindShiftForPharmacist> {
  CollectionReference aggregationRef = FirebaseFirestore.instance.collection("aggregation");
  Location pharmacistLocation = Location(latitude: 0, longitude: 0, timestamp: DateTime(0));
  Map jobsDataMap = Map();
  Map jobsMap = Map();
  Map jobsDataMapTemp = Map();
  Map sortedJobsDataMap = Map();
  StreamSubscription? scheduleJobsDataSub;
  final LocalStorage localStorage = LocalStorage();
  String calendarIcon = "assets/icons/calendar2.svg";

  double distanceWillingToTravel = 50;

  void _showDistanceDialog() async {
    // <-- note the async keyword here

    // this will contain the result from Navigator.pop(context, result)
    final selectedFistance = await showDialog<double>(
      context: context,
      builder: (context) =>
          DistanceTravelPickerDialog(distanceWillingToTravel: distanceWillingToTravel),
    );

    // execution of this code continues when the dialog was closed (popped)

    // note that the result can also be null, so check it
    // (back button or pressed outside of the dialog)
    if (selectedFistance != null) {
      setState(() {
        distanceWillingToTravel = selectedFistance;
      });
    }
  }

  void getAllJobs(DocumentSnapshot jobsData) async {
    setState(() {
      jobsDataMapTemp = jobsData.data() as Map;
    });

    print("jobsDataMapTemp: ${jobsDataMapTemp}");
  }

  void jobsSortedWithSchedule(WidgetRef ref) async {
    // String jobsListFile = localStorage.readFile(
    //     filePath:
    //         "${await localStorage.localPath}/jobsList/${ref.read(userProviderLogin.notifier).userUID}/storageJobsList");

    // print("File: $jobsListFile");
    // if (jobsListFile.isNotEmpty) {
    //   jobsMap = jsonDecode(jobsListFile);
    // }

    print("Jobs DataMap: $jobsDataMapTemp");

    // from here
    jobsDataMapTemp.forEach((key, value) async {
      debugPrint(value["pharmacyUID"]);
      print("jobsDataMapTemp: ${jobsDataMapTemp}");
      print("jobsDataMapTemp Length: ${jobsDataMapTemp.length}");
      print("--------------------------------------------");
      if (!jobsMap.containsKey(key)) {
        double distanceBetweenPharmacistAndPharmacy =
            await getDistanceBetweenPharmacyAndPharmacist(ref, value);
        print("Distance: $distanceBetweenPharmacistAndPharmacy");

        if (jobsBetweenDates(ref, value) &&
            distanceBetweenPharmacistAndPharmacy < distanceWillingToTravel) {
          print(value["pharmacyUID"]);
          print("Key: $key");

          print("Jobs Data Map Before: $jobsDataMap");
          jobsDataMap[key] = value;
          print("Jobs Data Map After: $jobsDataMap");
          print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ \n");
          print("YESS \n");
          print("Distance: $distanceBetweenPharmacistAndPharmacy");
          print("vvvvvvvvvvvvvvvvvvvvvvvvvvvvv \n");
          // to here
          print("Jobs Data Map: $jobsDataMap");
          setState(() {
            // await function
            sortedJobsDataMap = Map.fromEntries(jobsDataMap.entries.toList()
              ..sort((e1, e2) => e1.value["startDate"].compareTo(e2.value["startDate"])));
          });
          print("Sorted Jobs Data Map: $sortedJobsDataMap");
        } else {
          print("NO because of date or distance");
          print(value["pharmacyUID"]);
          print("Key: $key");
        }
      } else {
        print("NO because already applied");
        print(value["pharmacyUID"]);
        print("Key: $key");
      }
    });
  }

  Future<double> getDistanceBetweenPharmacyAndPharmacist(WidgetRef ref, value) async {
    var pharmacyAddress = value["pharmacyAddress"]["streetAddress"] +
        " " +
        value["pharmacyAddress"]["city"] +
        " " +
        value["pharmacyAddress"]["postalCode"] +
        " " +
        value["pharmacyAddress"]["country"];

    List<Location> pharmacistLocation = await locationFromAddress(
        ref.read(pharmacistMainProvider.notifier).userDataMap?["address"]);

    List<Location> pharmacyLocation = await locationFromAddress(pharmacyAddress);

    print("Pharmacy Location: $pharmacyLocation");

    double distanceBetweenPharmacistAndPharmacy = Geolocator.distanceBetween(
            pharmacistLocation.first.latitude,
            pharmacistLocation.first.longitude,
            pharmacyLocation.first.latitude,
            pharmacyLocation.first.longitude) /
        1000;
    return distanceBetweenPharmacistAndPharmacy;
  }

  bool jobsBetweenDates(WidgetRef ref, value) {
    return ((value["startDate"] as Timestamp)
                .toDate()
                .isAfter(ref.read(pharmacistMainProvider.notifier).startDate as DateTime) &&
            ((value["startDate"] as Timestamp)
                .toDate()
                .isBefore(ref.read(pharmacistMainProvider.notifier).endDate as DateTime))) ||
        ((value["startDate"] as Timestamp).toDate().day ==
            (ref.read(pharmacistMainProvider.notifier).startDate as DateTime).day);
  }

  void getAndSetJobsFromFirestore(WidgetRef ref) {
    print(ref.read(pharmacistMainProvider.notifier).startDate);
    scheduleJobsDataSub?.cancel();
    scheduleJobsDataSub = aggregationRef.doc("jobs").snapshots().listen((allJobsData) {
      getAllJobs(allJobsData);
    });
  }

  @override
  void initState() {
    super.initState();
    getAndSetJobsFromFirestore(ref);
  }

  @override
  void dispose() {
    scheduleJobsDataSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(pharmacistMainProvider);
        return WillPopScope(
          onWillPop: () async {
            ref.read(pharmacistMainProvider.notifier).clearDates();
            scheduleJobsDataSub?.cancel();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 0,
              title: new Text(
                "Find Shift",
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
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //Start and End Date Fields and Search
                Container(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 20),
                  child: Column(
                    children: <Widget>[
                      //Start and End Fields Date
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Start Date
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
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
                                        format: DateFormat("dd MMM, yyyy"),
                                        decoration: InputDecoration(
                                            isDense: true,
                                            hintText: "Select a date",
                                            hintStyle: TextStyle(
                                                fontFamily: GoogleFonts.montserrat().fontFamily)),
                                        onShowPicker: (context, currentValue) async {
                                          final date = await showDatePicker(
                                              context: context,
                                              firstDate: DateTime.now(),
                                              initialDate: currentValue ?? DateTime.now(),
                                              lastDate: DateTime(2100));

                                          if (date != null) {
                                            ref
                                                .read(pharmacistMainProvider.notifier)
                                                .changeStartDate(date);
                                            print(date);
                                            return date;
                                          } else {
                                            ref
                                                .read(pharmacistMainProvider.notifier)
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
                              //End Date
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
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
                                        format: DateFormat("dd MMM, yyyy"),
                                        decoration: InputDecoration(
                                            isDense: true,
                                            hintText: "Select a date",
                                            hintStyle: TextStyle(
                                                fontFamily: GoogleFonts.montserrat().fontFamily)),
                                        onShowPicker: (context, currentValue) async {
                                          final date = await showDatePicker(
                                              context: context,
                                              firstDate: ref
                                                      .read(pharmacistMainProvider.notifier)
                                                      .startDate ??
                                                  DateTime.now(),
                                              initialDate: ref
                                                      .read(pharmacistMainProvider.notifier)
                                                      .startDate ??
                                                  DateTime.now(),
                                              lastDate: DateTime(2100));

                                          if (date != null) {
                                            ref
                                                .read(pharmacistMainProvider.notifier)
                                                .changeEndDate(date);
                                            print(date);
                                            return date;
                                          } else {
                                            ref
                                                .read(pharmacistMainProvider.notifier)
                                                .changeEndDate(currentValue);
                                            return currentValue;
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

                      //Search Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 51,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith<Color>((states) {
                                      if (states.contains(MaterialState.disabled)) {
                                        return Colors.grey; // Disabled color
                                      }
                                      return Color(0xFFF0069C1); // Regular color
                                    }),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                                onPressed: (ref.read(pharmacistMainProvider.notifier).startDate !=
                                            null &&
                                        ref.read(pharmacistMainProvider.notifier).endDate != null)
                                    ? () {
                                        print("Finding Shifts for User");
                                        //sortedJobsDataMap = {};
                                        //jobsDataMap = {};
                                        //getAndSetJobsFromFirestore(ref);
                                        setState(() {
                                          sortedJobsDataMap.clear();
                                        });
                                        jobsSortedWithSchedule(ref);
                                      }
                                    : null,
                                child: RichText(
                                  text: TextSpan(
                                    text: "Search",
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: IconButton(
                                onPressed: () {
                                  _showDistanceDialog();
                                },
                                icon: Icon(Icons.filter_list_rounded)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.0, color: Color(0xFFE8E8E8)),
                      bottom: BorderSide(width: 1.0, color: Color(0xFFE8E8E8)),
                    ),
                    color: Color(0xFFF9F9F9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "${sortedJobsDataMap.length} results found",
                      style: TextStyle(
                          color: Color(0xFFA1A0A0),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: GoogleFonts.montserrat().fontFamily),
                    ),
                  ),
                ),

                //All Available Shifts
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 10),
                        sortedJobsDataMap.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: sortedJobsDataMap.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    String key = sortedJobsDataMap.keys.elementAt(index);
                                    //print(sortedJobsDataMap[key]);
                                    return FutureBuilder(
                                      future: getDistance(
                                          sortedJobsDataMap[key],
                                          ref
                                              .read(pharmacistMainProvider.notifier)
                                              .userDataMap?["address"]),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(child: CircularProgressIndicator());
                                        }
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.97,
                                              child: Center(
                                                child: ListTile(
                                                  isThreeLine: true,
                                                  //Date Text
                                                  title: new Text(
                                                    DateFormat("EEE, MMM d yyyy").format(
                                                            (sortedJobsDataMap[key]["startDate"]
                                                                    as Timestamp)
                                                                .toDate()) +
                                                        " - " +
                                                        "${DateFormat("EE, MMM d yyyy").format((sortedJobsDataMap[key]["endDate"] as Timestamp).toDate())}",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            GoogleFonts.montserrat().fontFamily),
                                                  ),
                                                  subtitle: RichText(
                                                    text: TextSpan(children: [
                                                      //Time Text
                                                      TextSpan(
                                                          text:
                                                              "${DateFormat("jm").format((sortedJobsDataMap[key]["startTime"] as Timestamp).toDate())}"
                                                              " - "
                                                              "${DateFormat("jm").format((sortedJobsDataMap[key]["endTime"] as Timestamp).toDate())} ",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 15,
                                                              fontFamily: GoogleFonts.montserrat()
                                                                  .fontFamily)),
                                                      //Time Diff Text
                                                      TextSpan(
                                                          text:
                                                              "(${getHourDiff(TimeOfDay.fromDateTime((sortedJobsDataMap[key]["endTime"] as Timestamp).toDate()), TimeOfDay.fromDateTime((sortedJobsDataMap[key]["startTime"] as Timestamp).toDate()))[0]} hrs"
                                                              "${getHourDiff(TimeOfDay.fromDateTime((sortedJobsDataMap[key]["endTime"] as Timestamp).toDate()), TimeOfDay.fromDateTime((sortedJobsDataMap[key]["startTime"] as Timestamp).toDate()))[1]}/day)\n",
                                                          style: TextStyle(
                                                              color: Colors.black, fontSize: 15)),
                                                    ]),
                                                  ),
                                                  trailing: Text(
                                                    "${sortedJobsDataMap[key]["hourlyRate"]}/hr",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontFamily:
                                                            GoogleFonts.montserrat().fontFamily),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => JobDetails(
                                                                  jobDetails:
                                                                      sortedJobsDataMap[key],
                                                                  viewing: false,
                                                                )));
                                                  },
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.grey,
                                              height: 1,
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              )
                            : Material(
                                elevation: 20,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 370,
                                  constraints: BoxConstraints(
                                    minHeight: 60,
                                  ),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        text: "No New Shifts Found",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20.0,
                                            color: Color(0xFFC5C5C5)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DistanceTravelPickerDialog extends StatefulWidget {
  /// initial selection for the slider
  final double distanceWillingToTravel;

  const DistanceTravelPickerDialog({Key? key, required this.distanceWillingToTravel})
      : super(key: key);

  @override
  _DistanceTravelPickerDialogState createState() => _DistanceTravelPickerDialogState();
}

class _DistanceTravelPickerDialogState extends State<DistanceTravelPickerDialog> {
  /// current selection of the slider
  double _distanceWillingToTravel = 0;

  @override
  void initState() {
    super.initState();
    _distanceWillingToTravel = widget.distanceWillingToTravel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: AlertDialog(
        title: Text('Distance Willing to Travel'),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Container(
              child: Slider(
                value: _distanceWillingToTravel,
                min: 0,
                max: 100,
                divisions: 20,
                onChanged: (value) {
                  setState(() {
                    _distanceWillingToTravel = num.parse(value.toStringAsFixed(0)).toDouble();
                  });
                },
                label: "$_distanceWillingToTravel km",
              ),
            ),
            Text("Distance: $_distanceWillingToTravel km"),
            TextButton(
              onPressed: () {
                // Use the second argument of Navigator.pop(...) to pass
                // back a result to the page that opened the dialog
                Navigator.pop(context, _distanceWillingToTravel);
              },
              child: Text('DONE'),
            )
          ],
        ),
        // actions: <Widget>[
        //   TextButton(
        //     onPressed: () {
        //       // Use the second argument of Navigator.pop(...) to pass
        //       // back a result to the page that opened the dialog
        //       Navigator.pop(context, _test);
        //     },
        //     child: Text('DONE'),
        //   )
        // ],
      ),
    );
  }
}
