import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/createShift.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/availablePharmacistProfile.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../all_used.dart';

// ignore: must_be_immutable
class AvailablePharmacists extends ConsumerStatefulWidget {
  bool showFullTimePharmacists;
  AvailablePharmacists({Key? key, required this.showFullTimePharmacists}) : super(key: key);

  @override
  _AvailablePharmacistsState createState() => _AvailablePharmacistsState();
}

class _AvailablePharmacistsState extends ConsumerState<AvailablePharmacists> {
  CollectionReference aggregationRef = FirebaseFirestore.instance.collection("aggregation");

  List<Skill?>? skillList;

  Map allUserDataMapTemp = Map();
  Map allUserDataMap = Map();
  Map pharmacistDataMapTemp = Map();
  Map pharmacyAssistantDataMapTemp = Map();
  Map pharmacyTechnicianDataMapTemp = Map();

  void changeSkillToList(String? stringList) {
    int indexOfOpenBracket = stringList!.indexOf("[");
    int indexOfLastBracket = stringList.lastIndexOf("]");
    var noBracketString = stringList.substring(indexOfOpenBracket + 1, indexOfLastBracket);
    List<Skill?>? templist = [];
    var list = noBracketString.split(", ");
    for (var i = 0; i < list.length; i++) {
      templist.add(Skill(id: 1, name: list[i].toString()));
    }
    setState(() {
      skillList = templist;
    });
  }

  void getAggregatedPharmacists(WidgetRef ref) async {
    DocumentReference pharmacistData = aggregationRef.doc("pharmacists");
    DocumentReference pharmacyAssistantData = aggregationRef.doc("pharmacyAssistant");
    DocumentReference pharmacyTechnicianData = aggregationRef.doc("pharmacyTechnician");

    await pharmacyAssistantData.get().then((pharmacyAssistantData) {
      setState(() {
        pharmacyAssistantDataMapTemp = pharmacyAssistantData.data() as Map;
      });
      print("Pharmacy Assistant Data: $pharmacyAssistantDataMapTemp");
    }).catchError((error) => print("Failed to search pharmacy assistant: $error"));

    await pharmacistData.get().then((pharmacistData) {
      setState(() {
        pharmacistDataMapTemp = pharmacistData.data() as Map;
      });
      print("Pharmacist Data: $pharmacistDataMapTemp");
    }).catchError((error) => print("Failed to search Pharmacist: $error"));

    await pharmacyTechnicianData.get().then((pharmacyTechnicianData) {
      setState(() {
        pharmacyTechnicianDataMapTemp = pharmacyTechnicianData.data() as Map;
      });
      print("Pharmacy tech Data: $pharmacyTechnicianDataMapTemp");
    }).catchError((error) => print("Failed to search Pharmacy tech: $error"));

    setState(() {
      allUserDataMapTemp = {
        ...pharmacistDataMapTemp,
        ...pharmacyAssistantDataMapTemp,
        ...pharmacyTechnicianDataMapTemp
      };
    });

    print("All Users Data: $allUserDataMap");

    allUserDataMapTemp.forEach((key, value) {
      print("--------------------------------------------");
      print(value["uid"]);
      print("UserType: ${value["userType"]}");
      print("Position: ${ref.read(pharmacyMainProvider.notifier).position}");
      print("Permanent Job: ${ref.read(pharmacyMainProvider.notifier).fullTime}");

      print("--------------------------------------------");
      for (var i = 0; i < value["availability"].length; i++) {
        if (widget.showFullTimePharmacists) {
          if (value["permanentJob"] != null &&
              value["permanentJob"] &&
              value["userType"] == ref.read(pharmacyMainProvider.notifier).position) {
            print(value["uid"]);
            allUserDataMap[key] = value;
            print(allUserDataMap.keys);

            print("YESR");
          }
        } else if (checkAvailability(ref, value, i) &&
            value["userType"] == ref.read(pharmacyMainProvider.notifier).position) {
          if (ref.read(pharmacyMainProvider.notifier).skillList != null) {
            print(value["uid"]);
            allUserDataMap[key] = value;
            print(allUserDataMap.keys);

            print("YESR");
          } else {
            print(value["uid"]);
            allUserDataMap[key] = value;
            print(allUserDataMap.keys);

            print("YESR");
          }
        } else {
          print(value["uid"]);

          print("NO");
        }
        //print(value["availability"][i.toString()]["endDate"]);
      }
    });
    print(allUserDataMap);
  }

  bool checkAvailability(WidgetRef ref, value, int i) {
    return ((value["availability"][i.toString()]["startDate"] as Timestamp)
                .toDate()
                .isAfter(ref.read(pharmacyMainProvider.notifier).startDate as DateTime) &&
            ((value["availability"][i.toString()]["startDate"] as Timestamp)
                .toDate()
                .isBefore(ref.read(pharmacyMainProvider.notifier).endDate as DateTime))) ||
        ((value["availability"][i.toString()]["endDate"] as Timestamp)
                .toDate()
                .isAfter(ref.read(pharmacyMainProvider.notifier).startDate as DateTime) &&
            ((value["availability"][i.toString()]["endDate"] as Timestamp)
                .toDate()
                .isBefore(ref.read(pharmacyMainProvider.notifier).endDate as DateTime)));
  }

  @override
  void initState() {
    super.initState();
    getAggregatedPharmacists(ref);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFEAEAEA),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: "Can't find a pharmacist?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily,
                ),
                children: [
                  TextSpan(
                    text: " Post a shift for a future date",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 51,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey; // Disabled color
                      }
                      return Color(0xFFF0069C1); // Regular color
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ))),
                onPressed: () {
                  print("Pressed");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateShift()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Create a shift",
                        style: TextStyle(
                          fontSize: 18,
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
        ],
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: new Text(
          "Available Pharmacists",
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
          SizedBox(
            height: 10,
          ),
          if (widget.showFullTimePharmacists) ...[
            if (ref.read(pharmacyMainProvider.notifier).position == "Pharmacist")
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Text(
                    "Showing pharmacists looking for full time job.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
              )
            else if (ref.read(pharmacyMainProvider.notifier).position == "Pharmacy Assistant")
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Text(
                    "Showing pharmacy assistants looking for full time job.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              )
          ],

          allUserDataMap.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: allUserDataMap.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key = allUserDataMap.keys.elementAt(index);
                      // var softwareList = json.decode(allUserDataMap[key]["knownSoftware"]);
                      // print("softwareList: $softwareList");
                      print("allUserDataMap: ${allUserDataMap[key]}");
                      return GestureDetector(
                        onTap: () {
                          print("Pressed");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChosenPharmacistProfile(
                                            pharmacistDataMap: allUserDataMap[key],
                                          )));
                        },
                        child: new Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              height: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            minRadius: 10,
                                            maxRadius: 35,
                                            backgroundImage:
                                                NetworkImage(allUserDataMap[key]["profilePhoto"]),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                allUserDataMap[key]["name"],
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xFF0E5999),
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: GoogleFonts.montserrat(
                                                          fontWeight: FontWeight.normal)
                                                      .fontFamily,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              RichText(
                                                textAlign: TextAlign.left,
                                                text: TextSpan(
                                                    text: "Working Experience \n",
                                                    style: TextStyle(
                                                        color: Color(0xFF6C6C6C),
                                                        fontSize: 16,
                                                        fontFamily: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.normal)
                                                            .fontFamily),
                                                    children: [
                                                      TextSpan(
                                                        text: allUserDataMap[key]
                                                                ["yearsOfExperience"] +
                                                            " yrs",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: GoogleFonts.montserrat(
                                                                  fontWeight: FontWeight.normal)
                                                              .fontFamily,
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ChosenPharmacistProfile(
                                                        pharmacistDataMap: allUserDataMap[key],
                                                      )));
                                        },
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color(0xFF0069C1),
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFEAEAEA),
                            ),
                          ],
                        ),
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
                            if (ref.read(pharmacyMainProvider.notifier).position ==
                                "Pharmacist") ...[
                              Center(
                                  child: Text(
                                "No available pharamcists found",
                                style: TextStyle(color: Colors.grey, fontSize: 20),
                              )),
                            ] else if (ref.read(pharmacyMainProvider.notifier).position ==
                                "Pharmacy Assistant") ...[
                              Center(
                                  child: Text(
                                "No available pharmacy assistant found",
                                style: TextStyle(color: Colors.grey, fontSize: 18),
                              )),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          //Search Button
        ],
      ),
    );
  }
}

/*
  Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey; // Disabled color
                      }
                      return Color(0xFFF0069C1); // Regular color
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ))),
                onPressed: () {
                  print("Pressed");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateShift()));
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
                          text: "Can’t find a pharmacist? Post a shift for a future date",
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
        
*/
