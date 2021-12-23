import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/createShift.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/availablePharmacistProfile.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';

import '../../../../all_used.dart';

// ignore: must_be_immutable
class AvailablePharmacists extends ConsumerStatefulWidget {
  bool showFullTimePharmacists;
  AvailablePharmacists({Key? key, required this.showFullTimePharmacists})
      : super(key: key);

  @override
  _AvailablePharmacistsState createState() => _AvailablePharmacistsState();
}

class _AvailablePharmacistsState extends ConsumerState<AvailablePharmacists> {
  CollectionReference aggregationRef =
      FirebaseFirestore.instance.collection("aggregation");

  List<Skill?>? skillList;

  Map allUserDataMapTemp = Map();
  Map allUserDataMap = Map();
  Map pharmacistDataMapTemp = Map();
  Map pharmacyAssistantDataMapTemp = Map();
  Map pharmacyTechnicianDataMapTemp = Map();


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

  void getAggregatedPharmacists(WidgetRef ref) async {
    DocumentReference pharmacistData = aggregationRef.doc("pharmacists");
    DocumentReference pharmacyAssistantData =
        aggregationRef.doc("pharmacyAssistant");
    DocumentReference pharmacyTechnicianData =
        aggregationRef.doc("pharmacyTechnician");

    await pharmacyAssistantData.get().then((pharmacyAssistantData) {
      setState(() {
        pharmacyAssistantDataMapTemp = pharmacyAssistantData.data() as Map;
      });
      print("Pharmacy Assistant Data: $pharmacyAssistantDataMapTemp");
    });
    await pharmacistData.get().then((pharmacistData) {
      setState(() {
        pharmacistDataMapTemp = pharmacistData.data() as Map;
      });
      print("Pharmacist Data: $pharmacistDataMapTemp");
    });
    await pharmacyTechnicianData.get().then((pharmacyTechnicianData) {
      setState(() {
        pharmacyTechnicianDataMapTemp = pharmacyTechnicianData.data() as Map;
      });
      print("Pharmacist Data: $pharmacyTechnicianDataMapTemp");
    });

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
      print(
          "Position: ${ref.read(pharmacyMainProvider.notifier).position}");
      print(
          "Permanent Job: ${ref.read(pharmacyMainProvider.notifier).fullTime}");

      print("--------------------------------------------");
      for (var i = 0; i < value["availability"].length; i++) {
        if (widget.showFullTimePharmacists) {
          if (value["permanentJob"] != null &&
              value["permanentJob"] &&
              value["userType"] ==
                  ref.read(pharmacyMainProvider.notifier).position) {
            print(value["uid"]);
            allUserDataMap[key] = value;
            print(allUserDataMap.keys);

            print("YESR");
          }
        } else if (checkAvailability(ref, value, i) &&
            value["userType"] ==
                ref.read(pharmacyMainProvider.notifier).position) {
          if (ref.read(pharmacyMainProvider.notifier).skillList != null) {
            if (value["knownSkills"] != null)
              changeSkillToList(value["knownSkills"]);
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
                .isAfter(ref.read(pharmacyMainProvider.notifier).startDate
                    as DateTime) &&
            ((value["availability"][i.toString()]["startDate"] as Timestamp)
                .toDate()
                .isBefore(ref.read(pharmacyMainProvider.notifier).endDate
                    as DateTime))) ||
        ((value["availability"][i.toString()]["endDate"] as Timestamp)
                .toDate()
                .isAfter(ref.read(pharmacyMainProvider.notifier).startDate
                    as DateTime) &&
            ((value["availability"][i.toString()]["endDate"] as Timestamp)
                .toDate()
                .isBefore(ref.read(pharmacyMainProvider.notifier).endDate
                    as DateTime)));
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
            if (ref.read(pharmacyMainProvider.notifier).position ==
                "Pharmacist")
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
            else if (ref.read(pharmacyMainProvider.notifier).position ==
                "Pharmacy Assistant")
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
                                    "${allUserDataMap[key]["name"]}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  subtitle: new Text(
                                    "Years of working experience: " +
                                        "${allUserDataMap[key]["yearsOfExperience"]}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      allUserDataMap[key]["profilePhoto"],
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
                                                      allUserDataMap[key],
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
                            if (ref.read(pharmacyMainProvider.notifier)
                                    .position ==
                                "Pharmacist") ...[
                              Center(
                                  child: Text(
                                "No available pharamcists found",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              )),
                            ] else if (ref.read(pharmacyMainProvider.notifier)
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
