import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
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
  }

  void jobsSortedWithSchedule(WidgetRef ref) async {
    String jobsListFile = localStorage.readFile(
        filePath:
            "${await localStorage.localPath}/jobsList/${ref.read(userProviderLogin.notifier).userUID}/storageJobsList");

    print("File: $jobsListFile");
    if (jobsListFile.isNotEmpty) {
      jobsMap = jsonDecode(jobsListFile);
    }

    print("Jobs DataMap: $jobsDataMapTemp");

    jobsDataMapTemp.forEach((key, value) async {
      print(value["pharmacyUID"]);
      print("--------------------------------------------");
      double distanceBetweenPharmacistAndPharmacy =
          await getDistanceBetweenPharmacyAndPharmacist(ref, value);
      print("Distance: $distanceBetweenPharmacistAndPharmacy");

      if (jobsBetweenDates(ref, value) &&
          distanceBetweenPharmacistAndPharmacy < distanceWillingToTravel) {
        print(value["pharmacyUID"]);
        print("Key: $key");
        if (!jobsMap.containsKey(key)) {
          jobsDataMap[key] = value;
          print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ \n");
          print("YESS \n");
          print("Distance: $distanceBetweenPharmacistAndPharmacy");
          print("vvvvvvvvvvvvvvvvvvvvvvvvvvvvv \n");
        }
      } else {
        print(value["pharmacyUID"]);
        print("Key: $key");
        print("NO");
      }
    });
    print("Jobs Data Map: ${jobsDataMap.keys}");
    setState(() {
      sortedJobsDataMap = Map.fromEntries(jobsDataMap.entries.toList()
        ..sort((e1, e2) => e1.value["startDate"].compareTo(e2.value["startDate"])));
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

    List<Location> pharmacyLocation = await locationFromAddress(pharmacyAddress);

    List<Location> pharmacistLocation = await locationFromAddress(
        ref.read(pharmacistMainProvider.notifier).userDataMap?["address"]);

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

  @override
  void initState() {
    super.initState();
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
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 12,
              title: Text(
                "Find Shift",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
              ),
              backgroundColor: Color(0xFFF6F6F6),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //Start and End Date Fields and Search
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 20),
                      child: Column(
                        children: <Widget>[
                          //Start and End Fields Date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Start Date
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Start Date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width * 0.44,
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: DateTimeField(
                                      format: DateFormat("yyyy-MM-dd"),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(12),
                                          isDense: true,
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30)),
                                          labelText: "Select a date"),
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

                              //End Date
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    child: RichText(
                                      text: TextSpan(
                                        text: "End Date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width * 0.44,
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: DateTimeField(
                                      format: DateFormat("yyyy-MM-dd"),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(12),
                                          isDense: true,
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30)),
                                          labelText: "Select a date"),
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
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.6,
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
                                          borderRadius: BorderRadius.circular(100),
                                        ))),
                                    onPressed:
                                        (ref.read(pharmacistMainProvider.notifier).startDate !=
                                                    null &&
                                                ref.read(pharmacistMainProvider.notifier).endDate !=
                                                    null)
                                            ? () {
                                                print("Pressed");
                                                //sortedJobsDataMap = {};
                                                //jobsDataMap = {};
                                                getAndSetJobsFromFirestore(ref);
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
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                //All Available Shifts
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
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
                                            Material(
                                              elevation: 10,
                                              borderRadius: BorderRadius.circular(20),
                                              child: Container(
                                                width: MediaQuery.of(context).size.width * 0.97,
                                                constraints: BoxConstraints(minHeight: 90),
                                                child: Center(
                                                  child: ListTile(
                                                    isThreeLine: true,
                                                    title: new Text(
                                                      "${DateFormat("EEE, MMM d yyyy").format((sortedJobsDataMap[key]["startDate"] as Timestamp).toDate())}" +
                                                          " - " +
                                                          "${DateFormat("EE, MMM d yyyy").format((sortedJobsDataMap[key]["endDate"] as Timestamp).toDate())}",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    subtitle: RichText(
                                                      text: TextSpan(children: [
                                                        TextSpan(
                                                            text:
                                                                "${DateFormat("jm").format((sortedJobsDataMap[key]["startDate"] as Timestamp).toDate())}"
                                                                " - "
                                                                "${DateFormat("jm").format((sortedJobsDataMap[key]["endDate"] as Timestamp).toDate())} ",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 15)),
                                                        TextSpan(
                                                            text:
                                                                "(${getHourDiff(TimeOfDay.fromDateTime((sortedJobsDataMap[key]["endDate"] as Timestamp).toDate()), TimeOfDay.fromDateTime((sortedJobsDataMap[key]["startDate"] as Timestamp).toDate()))[0]} hrs"
                                                                "${getHourDiff(TimeOfDay.fromDateTime((sortedJobsDataMap[key]["endDate"] as Timestamp).toDate()), TimeOfDay.fromDateTime((sortedJobsDataMap[key]["startDate"] as Timestamp).toDate()))[1]}/day)\n",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 15)),
                                                        TextSpan(
                                                            text: "${snapshot.data}",
                                                            style: TextStyle(
                                                                color: Colors.black, fontSize: 15)),
                                                      ]),
                                                    ),
                                                    trailing: Text(
                                                      "${sortedJobsDataMap[key]["hourlyRate"]}/hr\n"
                                                      "Pharmacist",
                                                      style: TextStyle(fontWeight: FontWeight.w600),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => JobDetails(
                                                                    jobDetails:
                                                                        sortedJobsDataMap[key],
                                                                  )));
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10)
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

  void getAndSetJobsFromFirestore(WidgetRef ref) {
    print(ref.read(pharmacistMainProvider.notifier).startDate);
    scheduleJobsDataSub?.cancel();
    scheduleJobsDataSub = aggregationRef.doc("jobs").snapshots().listen((allJobsData) {
      getAllJobs(allJobsData);
    });
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
