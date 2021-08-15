import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/createShift.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/availablePharmacistProfile.dart';

class AvailablePharmacists extends StatefulWidget {
  AvailablePharmacists({Key? key}) : super(key: key);

  @override
  _AvailablePharmacistsState createState() => _AvailablePharmacistsState();
}

class _AvailablePharmacistsState extends State<AvailablePharmacists> {
  CollectionReference aggregationRef =
      FirebaseFirestore.instance.collection("aggregation");

  Map dataMap = Map();
  @override
  void initState() {
    super.initState();
    getAggregatedPharmacists();
  }

  void getAggregatedPharmacists() async {
    DocumentReference pharmacistData = aggregationRef.doc("pharmacists");
    pharmacistData.get().then((pharmacistData) {
      setState(() {
        dataMap = pharmacistData.data() as Map;
      });
    });
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
          Expanded(
            child: ListView.builder(
              itemCount: dataMap.length,
              itemBuilder: (BuildContext context, int index) {
                String key = dataMap.keys.elementAt(index);
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
                              "${dataMap[key]["name"]}",
                              style: TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text(
                              "Years of working experience: " +
                                  "${dataMap[key]["yearsOfExperience"]}",
                              style: TextStyle(fontSize: 15),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                dataMap[key]["profilePhoto"],
                              ),
                              radius: 30,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChosenPharmacistProfile(
                                            pharmacistDataMap: dataMap[key],
                                          )));
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                    // new Divider(
                    //   height: 10.0,
                    //   thickness: 2,
                    // ),
                  ],
                );
              
              },
            ),
          ),

          //Search Button
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 10),
            child: SizedBox(
              width: 370,
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
                  //TODO: Search for all pharmacist from the Aggregated pharmacist collection in Firestore with a query using the dates from the fields
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateShift()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
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
        ],
      ),
    );
  }
}
