import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/createShift.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/availablePharmacistProfile.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';

import '../../../../all_used.dart';

// ignore: must_be_immutable
class AvailablePharmacists extends StatefulWidget {
  bool showFullTimePharmacists;
  AvailablePharmacists({Key? key, required this.showFullTimePharmacists})
      : super(key: key);

  @override
  _AvailablePharmacistsState createState() => _AvailablePharmacistsState();
}

class _AvailablePharmacistsState extends State<AvailablePharmacists> {
  CollectionReference aggregationRef =
      FirebaseFirestore.instance.collection("aggregation");

  List<Skill?>? skillList;

  Map pharmacistDataMap = Map();
  Map pharmacistDataMapTemp = Map();

  void changeSkillToList(String? stringList) {
    int indexOfOpenBracket = stringList!.indexOf("[");
    int indexOfLastBracket = stringList.lastIndexOf("]");
    var noBracketString =
        stringList.substring(indexOfOpenBracket + 1, indexOfLastBracket);
    List<Skill?>? templist = [];
    var list = noBracketString.split(", ");
    for (var i = 0; i < list.length; i++) {
      templist.add(Skill(id: 1, name: list[i].toString()));
    }
    setState(() {
      skillList = templist;
    });
  }

  void getAggregatedPharmacists() async {
    DocumentReference pharmacistData = aggregationRef.doc("pharmacists");
    pharmacistData.get().then((pharmacistData) {
      setState(() {
        pharmacistDataMapTemp = pharmacistData.data() as Map;
      });
      pharmacistDataMapTemp.forEach((key, value) {
        print(value["uid"]);
        print("UserType: ${value["userType"]}");
        print(
            "Position: ${context.read(pharmacyMainProvider.notifier).position}");
        print(
            "Permanent Job: ${context.read(pharmacyMainProvider.notifier).position}");

        print("--------------------------------------------");
        for (var i = 0; i < value["availability"].length; i++) {
          if (widget.showFullTimePharmacists) {
            if (value["permanentJob"] != null &&
                value["permanentJob"] &&
                value["userType"] ==
                    context.read(pharmacyMainProvider.notifier).position) {
              print(value["uid"]);
              pharmacistDataMap[key] = value;
              print(pharmacistDataMap.keys);

              print("YESR");
            }
          } else if (checkAvailability(value, i)) {
            if (context.read(pharmacyMainProvider.notifier).skillList != null) {
              if (value["knownSkills"] != null)
                changeSkillToList(value["knownSkills"]);
              print(value["uid"]);
              pharmacistDataMap[key] = value;
              print(pharmacistDataMap.keys);

              print("YESR");
            } else {
              print(value["uid"]);
              pharmacistDataMap[key] = value;
              print(pharmacistDataMap.keys);

              print("YESR");
            }
          } else {
            print(value["uid"]);

            print("NO");
          }
          //print(value["availability"][i.toString()]["endDate"]);
        }
      });
      print(pharmacistDataMap);
    });
  }

  bool checkAvailability(value, int i) {
    return ((value["availability"][i.toString()]["startDate"] as Timestamp)
                .toDate()
                .isAfter(context.read(pharmacyMainProvider.notifier).startDate
                    as DateTime) &&
            ((value["availability"][i.toString()]["startDate"] as Timestamp)
                .toDate()
                .isBefore(context.read(pharmacyMainProvider.notifier).endDate
                    as DateTime))) ||
        ((value["availability"][i.toString()]["endDate"] as Timestamp)
                .toDate()
                .isAfter(context.read(pharmacyMainProvider.notifier).startDate
                    as DateTime) &&
            ((value["availability"][i.toString()]["endDate"] as Timestamp)
                .toDate()
                .isBefore(context.read(pharmacyMainProvider.notifier).endDate
                    as DateTime)));
  }

  @override
  void initState() {
    super.initState();
    getAggregatedPharmacists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 12,
        title: Text(
          "Available Pharmacists",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
        ),
        backgroundColor: Color(0xFFF6F6F6),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          if (widget.showFullTimePharmacists) ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                child: Text(
                  "Showing pharmacists looking for full time job.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
            )
          ],

          pharmacistDataMap.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: pharmacistDataMap.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key = pharmacistDataMap.keys.elementAt(index);

                      return new Column(
                        children: <Widget>[
                          Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              height: 90,
                              child: Center(
                                child: ListTile(
                                  title: new Text(
                                    "${pharmacistDataMap[key]["name"]}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  subtitle: new Text(
                                    "Years of working experience: " +
                                        "${pharmacistDataMap[key]["yearsOfExperience"]}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      pharmacistDataMap[key]["profilePhoto"],
                                    ),
                                    radius: 30,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChosenPharmacistProfile(
                                                  pharmacistDataMap:
                                                      pharmacistDataMap[key],
                                                )));
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10)

                          // new Divider(
                          //   height: 10.0,
                          //   thickness: 2,
                          // ),
                        ],
                      );
                    },
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: 50,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,  
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (context
                                    .read(pharmacyMainProvider.notifier)
                                    .position ==
                                "Pharmacist") ...[
                              Center(
                                  child: Text(
                                "No available pharamcists found",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              )),
                            ] else if (context
                                    .read(pharmacyMainProvider.notifier)
                                    .position ==
                                "Pharmacy Assistant") ...[
                              Center(
                                  child: Text(
                                "No available pharmacy assistant found",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                              )),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          //Search Button
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateShift()));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Post a shift",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text:
                              "Can’t find a pharmacist? Post a shift for a future date",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
