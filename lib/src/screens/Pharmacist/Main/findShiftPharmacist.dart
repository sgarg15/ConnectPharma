import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Main/jobHistoryPharmacist.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';

//TODO: Look at job details upon clicking job
//TODO: Figure out what to do with Pharmacist Job History

class FindShiftForPharmacist extends StatefulWidget {
  FindShiftForPharmacist({Key? key}) : super(key: key);

  @override
  _FindShiftForPharmacistState createState() => _FindShiftForPharmacistState();
}

class _FindShiftForPharmacistState extends State<FindShiftForPharmacist> {
  CollectionReference aggregationRef =
      FirebaseFirestore.instance.collection("aggregation");
  Location pharmacistLocation =
      Location(latitude: 0, longitude: 0, timestamp: DateTime(0));
  Map jobsDataMap = Map();
  Map jobsDataMapTemp = Map();
  Map sortedJobsDataMap = Map();
  Dio dio = new Dio();
  static final String? googleMapsKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
  final apiKey = googleMapsKey;

  Future<Location> getLocationFromAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    print(address);
    print(locations.first);
    return locations.first;
  }

  Future<Response> getDistanceBetweenLocation(double startLatitude,
      double startLongitude, double endLatitude, double endLongitude) async {
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${startLatitude},${startLongitude}&destinations=${endLatitude},${endLongitude}&key=${apiKey}");
    return response.data;
  }

  List<String> getHourDiff(TimeOfDay tod1, TimeOfDay tod2) {
    var totalDifferenceInMin =
        (tod1.hour * 60 + tod1.minute) - (tod2.hour * 60 + tod2.minute);
    var leftOverminutes = (totalDifferenceInMin % 60);
    var totalHours =
        ((totalDifferenceInMin - leftOverminutes) / 60).toStringAsFixed(0);
    if (leftOverminutes == 0) {
      return [totalHours, ""];
    } else {
      return [totalHours, " " + leftOverminutes.toString() + " mins"];
    }
  }

  Future getDistance(Map pharmacyData, String pharmacistAddress) async {
    var distance = "";
    Location startingLocation = await getLocationFromAddress(
        pharmacyData["pharmacyAddress"]["streetAddress"] +
            " " +
            pharmacyData["pharmacyAddress"]["city"] +
            " " +
            pharmacyData["pharmacyAddress"]["country"]);
    Location endingLocation = await getLocationFromAddress(pharmacistAddress);
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${startingLocation.latitude},${startingLocation.longitude}&destinations=${endingLocation.latitude},${endingLocation.longitude}&key=${apiKey}");
    print(response);
    if (response.data != null) {
      distance = double.parse(
              "${response.data["rows"][0]["elements"][0]["distance"]["value"] / 1000}")
          .toStringAsFixed(2);
    } else {
      distance = "";
    }
    print(distance);

    if (distance == "0.00") {
      return "Close by in ";
    } else {
      return distance + "km away in ";
    }
  }

  void getAllJobs() async {
    DocumentReference jobsData = aggregationRef.doc("jobs");
    jobsData.get().then((jobData) {
      setState(() {
        jobsDataMapTemp = jobData.data() as Map;
      });

      jobsDataMapTemp.forEach((key, value) {
        print(value["pharmacyUID"]);
        print("--------------------------------------------");
        if (((value["startDate"] as Timestamp).toDate().isAfter(context
                    .read(pharmacistMainProvider.notifier)
                    .startDate as DateTime) &&
                ((value["startDate"] as Timestamp).toDate().isBefore(context
                    .read(pharmacistMainProvider.notifier)
                    .endDate as DateTime))) ||
            ((value["startDate"] as Timestamp).toDate().day ==
                (context.read(pharmacistMainProvider.notifier).startDate
                        as DateTime)
                    .day)) {
          print(value["pharmacyUID"]);
          print("Key: $key");
          jobsDataMap[key] = value;
          print("YEAS");
        } else {
          print(value["pharmacyUID"]);
          print("Key: $key");
          print("NO");
        }
      });
      print("Jobs Data Map: ${jobsDataMap.keys}");
      setState(() {
        sortedJobsDataMap = Map.fromEntries(jobsDataMap.entries.toList()
          ..sort((e1, e2) =>
              e1.value["startDate"].compareTo(e2.value["startDate"])));
      });
    });
  }

  @override
  void initState() {
    print(context.read(pharmacistMainProvider.notifier).startDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        watch(pharmacistMainProvider);
        return WillPopScope(
          onWillPop: () async {
            context.read(pharmacistMainProvider.notifier).clearDates();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 12,
              title: Text(
                "Find Shift",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 22),
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
                            children: [
                              //Start Date
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 5),
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
                                    width: 175,
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: DateTimeField(
                                      format: DateFormat("yyyy-MM-dd"),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          labelText: "Select a date"),
                                      onShowPicker:
                                          (context, currentValue) async {
                                        final date = await showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            initialDate:
                                                currentValue ?? DateTime.now(),
                                            lastDate: DateTime(2100));

                                        if (date != null) {
                                          context
                                              .read(pharmacistMainProvider
                                                  .notifier)
                                              .changeStartDate(date);
                                          print(date);
                                          return date;
                                        } else {
                                          context
                                              .read(pharmacistMainProvider
                                                  .notifier)
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 5),
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
                                    width: 175,
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: DateTimeField(
                                      format: DateFormat("yyyy-MM-dd"),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          labelText: "Select a date"),
                                      onShowPicker:
                                          (context, currentValue) async {
                                        final date = await showDatePicker(
                                            context: context,
                                            firstDate: context
                                                .read(pharmacistMainProvider
                                                    .notifier)
                                                .startDate as DateTime,
                                            initialDate: context
                                                .read(pharmacistMainProvider
                                                    .notifier)
                                                .startDate as DateTime,
                                            lastDate: DateTime(2100));
                                        if (date != null) {
                                          context
                                              .read(pharmacistMainProvider
                                                  .notifier)
                                              .changeEndDate(date);
                                          print(date);

                                          return date;
                                        } else {
                                          context
                                              .read(pharmacistMainProvider
                                                  .notifier)
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
                          //Search Button
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: SizedBox(
                              width: 324,
                              height: 51,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>((states) {
                                      if (states
                                          .contains(MaterialState.disabled)) {
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
                                                .read(pharmacistMainProvider
                                                    .notifier)
                                                .startDate !=
                                            null &&
                                        context
                                                .read(pharmacistMainProvider
                                                    .notifier)
                                                .endDate !=
                                            null)
                                    ? () {
                                        print("Pressed");
                                        //sortedJobsDataMap = {};
                                        //jobsDataMap = {};

                                        getAllJobs();
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
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String key =
                                        sortedJobsDataMap.keys.elementAt(index);
                                    print(sortedJobsDataMap[key]);
                                    return FutureBuilder(
                                      future: getDistance(
                                          sortedJobsDataMap[key],
                                          context
                                              .read(pharmacistMainProvider
                                                  .notifier)
                                              .userDataMap?["address"]),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Material(
                                              elevation: 10,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.97,
                                                height: 90,
                                                child: Center(
                                                  child: ListTile(
                                                    isThreeLine: true,
                                                    title: new Text(
                                                      "${DateFormat("EEE, MMM d yyyy").format((sortedJobsDataMap[key]["startDate"] as Timestamp).toDate())}" +
                                                          " - " +
                                                          "${DateFormat("EE, MMM d yyyy").format((sortedJobsDataMap[key]["endDate"] as Timestamp).toDate())}",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    subtitle: RichText(
                                                      text: TextSpan(children: [
                                                        TextSpan(
                                                            text:
                                                                "${DateFormat("jm").format((sortedJobsDataMap[key]["startDate"] as Timestamp).toDate())}"
                                                                " - "
                                                                "${DateFormat("jm").format((sortedJobsDataMap[key]["endDate"] as Timestamp).toDate())} ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 15)),
                                                        TextSpan(
                                                            text:
                                                                "(${getHourDiff(TimeOfDay.fromDateTime((sortedJobsDataMap[key]["endDate"] as Timestamp).toDate()), TimeOfDay.fromDateTime((sortedJobsDataMap[key]["startDate"] as Timestamp).toDate()))[0]} hrs"
                                                                "${getHourDiff(TimeOfDay.fromDateTime((sortedJobsDataMap[key]["endDate"] as Timestamp).toDate()), TimeOfDay.fromDateTime((sortedJobsDataMap[key]["startDate"] as Timestamp).toDate()))[1]})\n",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 15)),
                                                        TextSpan(
                                                            text:
                                                                "${snapshot.data}${sortedJobsDataMap[key]["pharmacyAddress"]["city"]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15)),
                                                      ]),
                                                    ),
                                                    trailing: Text(
                                                      "${sortedJobsDataMap[key]["hourlyRate"]}/hr\n"
                                                      "Pharmacist",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    onTap: () {
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) =>
                                                      //             ChosenPharmacistProfile(
                                                      //               pharmacistDataMap:
                                                      //                   pharmacistDataMap[
                                                      //                       key],
                                                      //             )));
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
                                  //TODO:Get a list of all available shifts within the time period from the aggregated jobs collection on firestore and display here
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        text: "No Shifts Found",
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
