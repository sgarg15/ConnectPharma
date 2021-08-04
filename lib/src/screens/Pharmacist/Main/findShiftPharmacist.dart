import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class FindShiftForPharmacist extends StatefulWidget {
  FindShiftForPharmacist({Key? key}) : super(key: key);

  @override
  _FindShiftForPharmacistState createState() => _FindShiftForPharmacistState();
}

class _FindShiftForPharmacistState extends State<FindShiftForPharmacist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 12,
        title: Text(
          "Find Shift",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
        ),
        backgroundColor: Color(0xFFF6F6F6),
      ),
      body: Column(
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
                              width: 175,
                              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: DateTimeField(
                                format: DateFormat("yyyy-MM-dd"),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    labelText: "Select a date"),
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
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
                              width: 175,
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: DateTimeField(
                                format: DateFormat("yyyy-MM-dd"),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    labelText: "Select a date"),
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
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
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.grey; // Disabled color
                                }
                                return Color(0xFF5DB075); // Regular color
                              }),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ))),
                          onPressed: () {
                            print("Pressed");
                            //TODO: Search for all jobs from the Aggregated Jobs collection in Firestore with a query using the dates from the fields
                          },
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
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          //All Available Shifts
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(30),
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
          ),
        ],
      ),
    );
  }
}
