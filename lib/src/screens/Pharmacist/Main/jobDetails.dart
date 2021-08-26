import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharma_connect/all_used.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'jobHistoryPharmacist.dart';

// ignore: must_be_immutable
class JobDetails extends StatelessWidget {
  Map? jobDetails = Map();

  JobDetails({Key? key, this.jobDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 12,
        title: Text(
          "Shift Details",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
        ),
        backgroundColor: Color(0xFFF6F6F6),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Data
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
              child: Material(
                elevation: 20,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[100]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Data
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //From Date
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "From",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text:
                                              "${DateFormat("EEE, MMM d yyyy").format((jobDetails?["startDate"] as Timestamp).toDate())}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Time
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "Time",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text:
                                              "${DateFormat("jm").format((jobDetails?["startDate"] as Timestamp).toDate())}"
                                              " - "
                                              "${DateFormat("jm").format((jobDetails?["endDate"] as Timestamp).toDate())} ",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //City
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "City",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text:
                                              "${jobDetails?["pharmacyAddress"]["city"]} ",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Hourly Rate
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "Hourly Rate",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text:
                                              "${jobDetails?["hourlyRate"]}/hr ",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Tech On Site
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "Technician On-Site",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      jobDetails?["techOnSite"]
                                          ? Icon(
                                              Icons.check,
                                              color: Color(0xFF5DB075),
                                              size: 30,
                                            )
                                          : Icon(
                                              Icons.check,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 30,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //To Date
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 15, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "To",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text:
                                              "${DateFormat("EEE, MMM d yyyy").format((jobDetails?["endDate"] as Timestamp).toDate())}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Duration
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 14, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "Duration",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text:
                                              "${getHourDiff(TimeOfDay.fromDateTime((jobDetails?["endDate"] as Timestamp).toDate()), TimeOfDay.fromDateTime((jobDetails?["startDate"] as Timestamp).toDate()))[0]} hrs"
                                              "${getHourDiff(TimeOfDay.fromDateTime((jobDetails?["endDate"] as Timestamp).toDate()), TimeOfDay.fromDateTime((jobDetails?["startDate"] as Timestamp).toDate()))[1]}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Distance
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 15, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "Distance",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      FutureBuilder(
                                        future: getDistance(
                                            jobDetails!,
                                            context
                                                .read(pharmacistMainProvider
                                                    .notifier)
                                                .userDataMap?["address"]),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          return RichText(
                                            textAlign: TextAlign.start,
                                            text: TextSpan(
                                              text:
                                                  "${snapshot.data}${jobDetails?["pharmacyAddress"]["city"]}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                //Job Type
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 15, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "Worker Type",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "Pharmacist",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Assistant Site
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 15, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "Assistant On-Site",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      jobDetails?["assistantOnSite"]
                                          ? Icon(
                                              Icons.check,
                                              color: Color(0xFF5DB075),
                                              size: 30,
                                            )
                                          : Icon(
                                              Icons.check,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 5,
                      ),
                      //Software
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          //mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: "Software",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: jobDetails?["softwareNeeded"]
                                    .toString()
                                    .substring(
                                        jobDetails?["softwareNeeded"]
                                                .indexOf("[") +
                                            1,
                                        jobDetails?["softwareNeeded"]
                                            .lastIndexOf("]")),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Specialization
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 5, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          //mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: "Specialization",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: jobDetails?["skillsNeeded"]
                                    .toString()
                                    .substring(
                                        jobDetails?["skillsNeeded"]
                                                .indexOf("[") +
                                            1,
                                        jobDetails?["skillsNeeded"]
                                            .lastIndexOf("]")),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Comments
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 5, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          //mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: "Comments",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: "${jobDetails?["comments"]}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            //Search Button
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                  onPressed: () {
                    print("Pressed");
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(jobDetails?["pharmacyName"]),
                              content: Text(
                                "Email: ${jobDetails?["email"]} \n \n" +
                                    "Pharmacy Phone Number: \n${jobDetails?["phoneNumber"]}",
                              ),
                              actions: <Widget>[
                                new TextButton(
                                  child: new Text("Ok"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Pharmacy Information",
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
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
