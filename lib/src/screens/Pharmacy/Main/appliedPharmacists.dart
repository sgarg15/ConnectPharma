import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectpharma/all_used.dart';
import 'package:flutter/material.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/availablePharmacistProfile.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../login.dart';

// ignore: must_be_immutable
class PharmacistApplied extends ConsumerStatefulWidget {
  Map? applicants;
  String? jodID;
  PharmacistApplied({Key? key, this.applicants, this.jodID}) : super(key: key);

  @override
  _PharmacistAppliedState createState() => _PharmacistAppliedState();
}

class _PharmacistAppliedState extends ConsumerState<PharmacistApplied> {
  @override
  void initState() {
    print(widget.applicants);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) => JobHistoryPharmacy()));
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          title: new Text(
            "Pharmacists",
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
            Expanded(
              child: ListView.builder(
                itemCount: widget.applicants?.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = widget.applicants?.keys.elementAt(index);
                  print("allUserDataMap: ${widget.applicants?[key]}");
                  return GestureDetector(
                    onTap: () {
                      print("Pressed");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChosenPharmacistProfile(
                                    pharmacistDataMap: widget.applicants?[key],
                                  )));
                    },
                    child: new Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
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
                                        foregroundImage:
                                            NetworkImage(widget.applicants?[key]["profilePhoto"]),
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
                                            widget.applicants?[key]["name"],
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
                                                    text: widget.applicants?[key]
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
                                                    pharmacistDataMap: widget.applicants?[key],
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
                              (widget.applicants?[key]["jobStatus"] != "rejected" &&
                                      widget.applicants?[key]["jobStatus"] != "current")
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          //Reject Button
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.42,
                                            height: 51,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.resolveWith<Color?>(
                                                          (states) {
                                                    if (states.contains(MaterialState.disabled)) {
                                                      return Colors.grey; // Disabled color
                                                    }
                                                    return Colors.red.shade900; // Regular color
                                                  }),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ))),
                                              child: Text("Reject"),
                                              onPressed: () {
                                                _rejectPharmacist(ref, context, key);
                                              },
                                            ),
                                          ),
                                          //Accept Button
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.42,
                                            height: 51,
                                            child: ElevatedButton(
                                              child: Text("Accept"),
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.resolveWith<Color>(
                                                          (states) {
                                                    if (states.contains(MaterialState.disabled)) {
                                                      return Colors.grey; // Disabled color
                                                    }
                                                    return Color(0xFFF0069C1); // Regular color
                                                  }),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ))),
                                              onPressed: () {
                                                _acceptPharmacist(ref, context, key);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: widget.applicants?[key]["jobStatus"] == "rejected"
                                          ? SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.9,
                                              height: 51,
                                              child: ElevatedButton(
                                                child: Text(
                                                  "Rejected",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.resolveWith<Color?>(
                                                            (states) {
                                                      if (states.contains(MaterialState.disabled)) {
                                                        return Colors.grey; // Disabled color
                                                      }
                                                      return Colors.red.shade900; // Regular color
                                                    }),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ))),
                                                onPressed: () {},
                                              ),
                                            )
                                          : SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.9,
                                              height: 51,
                                              child: ElevatedButton(
                                                child: Text(
                                                  "Accepted",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.resolveWith<Color?>(
                                                            (states) {
                                                      if (states.contains(MaterialState.disabled)) {
                                                        return Colors.grey; // Disabled color
                                                      }
                                                      return Color(0xFF0069C1); // Regular color
                                                    }),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ))),
                                                onPressed: () {},
                                              ),
                                            ),
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
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _acceptPharmacist(WidgetRef ref, BuildContext context, String pharmacistUID) {
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
                        text: "Are you sure you want to accept this pharmacist?? \n\n\n",
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
                            backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey; // Disabled color
                              }
                              return Colors.red[400]; // Regular color
                            }),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
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
                            backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey; // Disabled color
                              }
                              return Color(0xFFF0069C1); // Regular color
                            }),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),
                        child: new Text(
                          "Yes",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () async {
                          WriteBatch acceptPharmacistBatch = FirebaseFirestore.instance.batch();

                          sendPharmacyAcceptionData(
                              ref, context, acceptPharmacistBatch, pharmacistUID);

                          sendPharmacistAcceptionData(pharmacistUID, acceptPharmacistBatch);

                          acceptPharmacistBatch.commit().onError((error, stackTrace) {
                            print("ERROR Accepting: $error");
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text(
                                          "There was an error trying to accept this pharmacist. Please try again after restarting the app."),
                                    ));
                          });

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => JobHistoryPharmacy()));
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: RichText(
                                      text: TextSpan(
                                          text:
                                              "The pharmacist has been notified. Please contact them at \n${widget.applicants?[pharmacistUID]["phoneNumber"]}\nor\n${widget.applicants?[pharmacistUID]["email"]}",
                                          style: TextStyle(color: Colors.black, fontSize: 16)),
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

  void sendPharmacyAcceptionData(
      WidgetRef ref, BuildContext context, WriteBatch acceptPharmacistBatch, String pharmacistUID) {
    DocumentReference jobDocument = FirebaseFirestore.instance
        .collection("Users")
        .doc(ref.read(userProviderLogin.notifier).userUID)
        .collection("Main")
        .doc(widget.jodID);
    acceptPharmacistBatch.update(jobDocument, {"applicants.$pharmacistUID.jobStatus": "current"});
  }

  void sendPharmacistAcceptionData(String pharmacistUID, WriteBatch acceptPharmacistBatch) {
    DocumentReference pharmacistDocument = FirebaseFirestore.instance
        .collection("Users")
        .doc(pharmacistUID)
        .collection("PharmacistJobs")
        .doc(widget.jodID);
    acceptPharmacistBatch.update(pharmacistDocument, {"applicationStatus": "current"});
  }

  Future<dynamic> _rejectPharmacist(WidgetRef ref, BuildContext context, String pharmacistUID) {
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
                        text: "Are you sure you want to reject this pharmacist?? \n\n\n",
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
                            backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey; // Disabled color
                              }
                              return Colors.red.shade900; // Regular color
                            }),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
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
                            backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey; // Disabled color
                              }
                              return Color(0xFFF0069C1); // Regular color
                            }),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),
                        child: new Text(
                          "Yes",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () async {
                          WriteBatch rejectPharmacistBatch = FirebaseFirestore.instance.batch();

                          sendPharmacyRejectionData(
                              ref, context, rejectPharmacistBatch, pharmacistUID);

                          sendPharmacistRejectionData(pharmacistUID, rejectPharmacistBatch);

                          rejectPharmacistBatch.commit().onError((error, stackTrace) {
                            print("ERROR Rejecting: $error");
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text(
                                          "There was an error trying to reject this pharmacist. Please try again after restarting the app."),
                                    ));
                          });

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => JobHistoryPharmacy()));
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: RichText(
                                      text: TextSpan(
                                          text: "The pharmacist has been notified.",
                                          style: TextStyle(color: Colors.black, fontSize: 16)),
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

  void sendPharmacyRejectionData(
      WidgetRef ref, BuildContext context, WriteBatch rejectPharmacistBatch, String pharmacistUID) {
    DocumentReference jobDocument = FirebaseFirestore.instance
        .collection("Users")
        .doc(ref.read(userProviderLogin.notifier).userUID)
        .collection("Main")
        .doc(widget.jodID);
    rejectPharmacistBatch.update(jobDocument, {"applicants.$pharmacistUID.jobStatus": "rejected"});
  }

  void sendPharmacistRejectionData(String pharmacistUID, WriteBatch rejectPharmacistBatch) {
    DocumentReference pharmacistDocument = FirebaseFirestore.instance
        .collection("Users")
        .doc(pharmacistUID)
        .collection("PharmacistJobs")
        .doc(widget.jodID);
    rejectPharmacistBatch.update(pharmacistDocument, {"applicationStatus": "rejected"});
  }
}
