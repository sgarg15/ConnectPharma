import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
          Expanded(
            child: ListView.builder(
              itemCount: dataMap.length,
              itemBuilder: (BuildContext context, int index) {
                String key = dataMap.keys.elementAt(index);
                return new Column(
                  children: <Widget>[
                    ListTile(
                      title: new Text("$key"),
                      subtitle: new Text("${dataMap[key]["name"]}"),
                    ),
                    new Divider(
                      height: 2.0,
                    ),
                  ],
                );
              },
            ),
          ),

          //Search Button
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 10),
            child: SizedBox(
              width: 340,
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AvailablePharmacists()));
                },
                child: RichText(
                  text: TextSpan(
                    text: "Look for Pharmacists",
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
        ],
      ),
    );
  }
}
