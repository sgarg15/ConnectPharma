import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/availablePharmacistProfile.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../login.dart';

// ignore: must_be_immutable
class PharmacistApplied extends StatefulWidget {
  Map? applicants;
  String? jodID;
  PharmacistApplied({Key? key, this.applicants, this.jodID}) : super(key: key);

  @override
  _PharmacistAppliedState createState() => _PharmacistAppliedState();
}

class _PharmacistAppliedState extends State<PharmacistApplied> {
  @override
  void initState() {
    print(widget.applicants);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => JobHistoryPharmacy()));
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 12,
          title: Text(
            "Pharmacists",
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
                itemCount: widget.applicants?.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = widget.applicants?.keys.elementAt(index);

                  if (widget.applicants?[key]["jobStatus"] == "current") {
                    return new Column(
                      children: <Widget>[
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            constraints: BoxConstraints(minHeight: 90),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Basic Info about applicant
                                Center(
                                  child: ListTile(
                                    title: new Text(
                                      "${widget.applicants?[key]["name"]}",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    subtitle: new Text(
                                      "Years of working experience: " +
                                          "${widget.applicants?[key]["yearsOfExperience"]}",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        widget.applicants?[key]["profilePhoto"],
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
                                                        widget.applicants?[key],
                                                  )));
                                    },
                                  ),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    //Accepted Button
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height: 40,
                                      child: ElevatedButton(
                                        child: Text("Accepted"),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color>(
                                                        (states) {
                                              if (states.contains(
                                                  MaterialState.disabled)) {
                                                return Colors
                                                    .grey; // Disabled color
                                              }
                                              return Color(
                                                  0xFF5DB075); // Regular color
                                            }),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ))),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                  } else if (widget.applicants?[key]["jobStatus"] ==
                      "rejected") {
                    return new Column(
                      children: <Widget>[
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            constraints: BoxConstraints(minHeight: 90),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Basic Info about applicant
                                Center(
                                  child: ListTile(
                                    title: new Text(
                                      "${widget.applicants?[key]["name"]}",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    subtitle: new Text(
                                      "Years of working experience: " +
                                          "${widget.applicants?[key]["yearsOfExperience"]}",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        widget.applicants?[key]["profilePhoto"],
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
                                                        widget.applicants?[key],
                                                  )));
                                    },
                                  ),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    //Accepted Button
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height: 40,
                                      child: ElevatedButton(
                                        child: Text("Rejected"),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color?>(
                                                        (states) {
                                              if (states.contains(
                                                  MaterialState.disabled)) {
                                                return Colors
                                                    .grey; // Disabled color
                                              }
                                              return Colors
                                                  .red[400]; // Regular color
                                            }),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ))),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                  } else {
                    return new Column(
                      children: <Widget>[
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            constraints: BoxConstraints(minHeight: 90),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Basic Info about applicant
                                Center(
                                  child: ListTile(
                                    title: new Text(
                                      "${widget.applicants?[key]["name"]}",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    subtitle: new Text(
                                      "Years of working experience: " +
                                          "${widget.applicants?[key]["yearsOfExperience"]}",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        widget.applicants?[key]["profilePhoto"],
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
                                                        widget.applicants?[key],
                                                  )));
                                    },
                                  ),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    //Reject Button
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.42,
                                      height: 51,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color?>(
                                                        (states) {
                                              if (states.contains(
                                                  MaterialState.disabled)) {
                                                return Colors
                                                    .grey; // Disabled color
                                              }
                                              return Colors
                                                  .red[400]; // Regular color
                                            }),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ))),
                                        child: Text("Reject"),
                                        onPressed: () {
                                          _rejectPharmacist(context, key);
                                        },
                                      ),
                                    ),
                                    //Space
                                    SizedBox(
                                      width:
                                          ((MediaQuery.of(context).size.width *
                                                      0.95) -
                                                  ((MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.42) *
                                                      2)) *
                                              0.1,
                                    ),
                                    //Accept Button
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.42,
                                      height: 51,
                                      child: ElevatedButton(
                                        child: Text("Accept"),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color>(
                                                        (states) {
                                              if (states.contains(
                                                  MaterialState.disabled)) {
                                                return Colors
                                                    .grey; // Disabled color
                                              }
                                              return Color(
                                                  0xFF5DB075); // Regular color
                                            }),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ))),
                                        onPressed: () {
                                          _acceptPharmacist(context, key);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _acceptPharmacist(
      BuildContext context, String pharmacistUID) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(widget.applicants?[pharmacistUID]["name"]),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 70,
                    child: RichText(
                      text: TextSpan(
                        text:
                            "Are you sure you want to accept this pharmacist?? \n\n\n",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //no
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey; // Disabled color
                              }
                              return Colors.red[400]; // Regular color
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),
                        child: new Text(
                          "No",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      //yes
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey; // Disabled color
                              }
                              return Color(0xFF5DB075); // Regular color
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),
                        child: new Text(
                          "Yes",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () async {
                          WriteBatch acceptPharmacistBatch =
                              FirebaseFirestore.instance.batch();

                          sendPharmacyAcceptionData(
                              context, acceptPharmacistBatch, pharmacistUID);

                          sendPharmacistAcceptionData(
                              pharmacistUID, acceptPharmacistBatch);

                          acceptPharmacistBatch
                              .commit()
                              .onError((error, stackTrace) {
                            print("ERROR Accepting: $error");
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text(
                                          "There was an error trying to accept this pharmacist. Please try again after restarting the app."),
                                    ));
                          });

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JobHistoryPharmacy()));
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: RichText(
                                      text: TextSpan(
                                          text:
                                              "The pharmacist has been notified. Please contact them at \n${widget.applicants?[pharmacistUID]["phoneNumber"]}\nor\n${widget.applicants?[pharmacistUID]["email"]}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16)),
                                    ),
                                  ));

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => JobHistoryPharmacy()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }

  void sendPharmacyAcceptionData(BuildContext context,
      WriteBatch acceptPharmacistBatch, String pharmacistUID) {
    DocumentReference jobDocument = FirebaseFirestore.instance
        .collection("Users")
        .doc(context.read(userProviderLogin.notifier).userUID)
        .collection("Main")
        .doc(widget.jodID);
    acceptPharmacistBatch.update(
        jobDocument, {"applicants.$pharmacistUID.jobStatus": "current"});
  }

  void sendPharmacistAcceptionData(
      String pharmacistUID, WriteBatch acceptPharmacistBatch) {
    DocumentReference pharmacistDocument = FirebaseFirestore.instance
        .collection("Users")
        .doc(pharmacistUID)
        .collection("PharmacistJobs")
        .doc(widget.jodID);
    acceptPharmacistBatch
        .update(pharmacistDocument, {"applicationStatus": "current"});
  }

  Future<dynamic> _rejectPharmacist(
      BuildContext context, String pharmacistUID) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(widget.applicants?[pharmacistUID]["name"]),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 70,
                    child: RichText(
                      text: TextSpan(
                        text:
                            "Are you sure you want to reject this pharmacist?? \n\n\n",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //no
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey; // Disabled color
                              }
                              return Colors.red[400]; // Regular color
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),
                        child: new Text(
                          "No",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      //yes
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey; // Disabled color
                              }
                              return Color(0xFF5DB075); // Regular color
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),
                        child: new Text(
                          "Yes",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () async {
                          WriteBatch rejectPharmacistBatch =
                              FirebaseFirestore.instance.batch();

                          sendPharmacyRejectionData(
                              context, rejectPharmacistBatch, pharmacistUID);

                          sendPharmacistRejectionData(
                              pharmacistUID, rejectPharmacistBatch);

                          rejectPharmacistBatch
                              .commit()
                              .onError((error, stackTrace) {
                            print("ERROR Rejecting: $error");
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text(
                                          "There was an error trying to reject this pharmacist. Please try again after restarting the app."),
                                    ));
                          });

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JobHistoryPharmacy()));
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: RichText(
                                      text: TextSpan(
                                          text:
                                              "The pharmacist has been notified.",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16)),
                                    ),
                                  ));

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => JobHistoryPharmacy()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }

  void sendPharmacyRejectionData(BuildContext context,
      WriteBatch rejectPharmacistBatch, String pharmacistUID) {
    DocumentReference jobDocument = FirebaseFirestore.instance
        .collection("Users")
        .doc(context.read(userProviderLogin.notifier).userUID)
        .collection("Main")
        .doc(widget.jodID);
    rejectPharmacistBatch.update(
        jobDocument, {"applicants.$pharmacistUID.jobStatus": "rejected"});
  }

  void sendPharmacistRejectionData(
      String pharmacistUID, WriteBatch rejectPharmacistBatch) {
    DocumentReference pharmacistDocument = FirebaseFirestore.instance
        .collection("Users")
        .doc(pharmacistUID)
        .collection("PharmacistJobs")
        .doc(widget.jodID);
    rejectPharmacistBatch
        .update(pharmacistDocument, {"applicationStatus": "rejected"});
  }
}
