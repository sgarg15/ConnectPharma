import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/all_used.dart';
import 'package:connectpharma/main.dart';
import 'package:connectpharma/model/pharmacyMainModel.dart';
import 'package:connectpharma/src/providers/pharmacyMainProvider.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/appliedPharmacists.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/editShift.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/pharmacyProfile.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/searchPharmacist.dart';
import 'package:connectpharma/src/screens/Pharmacy/Sign%20Up/1pharmacy_signup.dart';
import 'package:connectpharma/src/screens/login.dart';
import '../../../../Custom Widgets/custom_sliding_segmented_control.dart';
import 'package:intl/intl.dart';
//TODO: Permanent Hiring for Pharmacy, show permanent option, for pharmacist in availability show looking for permanent job

final pharmacyMainProvider = StateNotifierProvider<PharmacyMainProvider, PharmacyMainModel>((ref) {
  return PharmacyMainProvider();
});

class JobHistoryPharmacy extends ConsumerStatefulWidget {
  const JobHistoryPharmacy({Key? key}) : super(key: key);

  @override
  _JobHistoryState createState() => _JobHistoryState();
}

class _JobHistoryState extends ConsumerState<JobHistoryPharmacy> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int segmentedControlGroupValue = 0;
  CollectionReference usersRef = FirebaseFirestore.instance.collection("Users");
  String dataID = "";
  Map jobDataMap = Map();
  Map sortedJobDataMap = Map();
  Map activeJobDataMap = Map();
  Map pastJobDataMap = Map();
  Map<String, dynamic>? userDataMap = Map();
  Stream<QuerySnapshot<Map<String, dynamic>>>? jobsStreamPharmacy;
  StreamSubscription? userDataSub;
  StreamSubscription? jobsDataSub;
  int numActiveJobs = 0;
  int numPastJobs = 0;
  bool jobDataMapEmpty = false;

  @override
  void initState() {
    super.initState();
    print("User UID: ${ref.read(userProviderLogin.notifier).userUID}");
    print(ref.read(pharmacyMainProvider.notifier).userData);
    jobsDataSub?.cancel();
    userDataSub?.cancel();

    numActiveJobs = 0;
    numPastJobs = 0;
    //getJobs();
    jobsStreamPharmacy =
        usersRef.doc(ref.read(userProviderLogin.notifier).userUID).collection("Main").snapshots();

    jobsDataSub = usersRef
        .doc(ref.read(userProviderLogin.notifier).userUID)
        .collection("Main")
        .snapshots()
        .listen((event) {});

    userDataSub = usersRef
        .doc(ref.read(userProviderLogin.notifier).userUID)
        .collection("SignUp")
        .doc("Information")
        .snapshots()
        .listen((docData) {
      setState(() {
        userDataMap = docData.data();
      });
      ref.read(pharmacyMainProvider.notifier).changeUserDataMap(userDataMap);
      print(ref.read(pharmacyMainProvider.notifier).userData);
      print("First Name: ${ref.read(pharmacyMainProvider.notifier).userData?["firstName"]}");
      print("Last Name: ${ref.read(pharmacyMainProvider.notifier).userData?["lastName"]}");
    });

    ref.read(pharmacyMainProvider.notifier).clearDateValues();
    print("In Pharmacy Job History InitState");
    // getUserData();
  }

  @override
  void dispose() {
    super.dispose();
    print("In Pharmacy Job History dispose");
    jobsDataSub?.cancel();
    userDataSub?.cancel();
    print("jobsDataSub: $jobsDataSub");
    print("userDataSub: $userDataSub");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xFFE3E3E3),
        key: _scaffoldKey,
        drawer: SideMenuDrawer(
          jobsDataSub: jobsDataSub,
          userDataSub: userDataSub,
        ),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: RichText(
            text: TextSpan(
              text: "Job History Pharmacy",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.0, color: Colors.black),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          actions: [],
        ),
        bottomNavigationBar: Container(
          height: 65,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [
                0.9,
                1,
              ],
              colors: [Colors.white, Color(0xFFE3E3E3)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                child: GestureDetector(
                  child: Icon(
                    Icons.perm_contact_calendar_outlined,
                    color: Color(0xFFF0069C1),
                    size: 50,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SearchPharmacistPharmacy()));
                  },
                ),
              ),
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              //Slider
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                width: MediaQuery.of(context).size.width,
                height: 75,
                alignment: Alignment.topCenter,
                //color: Colors.white,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.9,
                      1,
                    ],
                    colors: [Colors.white, Color(0xFFE3E3E3)],
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: CupertinoSlidingSegmentedControl(
                      thumbColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      backgroundColor: Color(0xFFC4C4C4),
                      groupValue: segmentedControlGroupValue,
                      children: <int, Widget>{
                        0: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 34),
                          child: segmentedControlGroupValue == 0
                              ? Text(
                                  "Active Jobs",
                                  style: TextStyle(
                                    color: Color(0xFFF0069C1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                )
                              : Text(
                                  "Active Jobs",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                ),
                        ),
                        1: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40.45),
                          child: segmentedControlGroupValue == 1
                              ? Text(
                                  "Past Jobs",
                                  style: TextStyle(
                                    color: Color(0xFFF0069C1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                )
                              : Text(
                                  "Past Jobs",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                ),
                        ),
                      },
                      onValueChanged: (int? i) {
                        setState(() {
                          segmentedControlGroupValue = i!.toInt();
                        });
                      }),
                ),
              ),
              if (segmentedControlGroupValue == 0) ...[
                if (jobDataMapEmpty == true) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: 50,
                        child: Center(
                            child: Text(
                          "No active jobs found",
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        )),
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: StreamBuilder(
                      stream: jobsStreamPharmacy,
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                        if (snapshot.data != null) {
                          snapshot.data?.docs.forEach((doc) {
                            dataID = doc.id;
                            jobDataMap[dataID] = doc.data();
                          });

                          sortedJobDataMap = Map.fromEntries(jobDataMap.entries.toList()
                            ..sort((e1, e2) =>
                                e1.value["startDate"].compareTo(e2.value["startDate"])));

                          if (jobDataMap.isEmpty) {
                            WidgetsBinding.instance?.addPostFrameCallback((_) => setState(() {
                                  jobDataMapEmpty = true;
                                }));

                            return Container();
                          } else {
                            return ListView.builder(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              itemCount: sortedJobDataMap.length,
                              itemBuilder: (BuildContext context, int index) {
                                String key = sortedJobDataMap.keys.elementAt(index).toString();
                                if (sortedJobDataMap[key]["jobStatus"] == "active") {
                                  numActiveJobs = 0;
                                  numActiveJobs += 1;
                                }
                                if (index == (sortedJobDataMap.length - 1) && numActiveJobs == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    child: Material(
                                      elevation: 10,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.95,
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                          "No active jobs found",
                                          style: TextStyle(color: Colors.grey, fontSize: 20),
                                        )),
                                      ),
                                    ),
                                  );
                                }
                                if (sortedJobDataMap[key]["jobStatus"] == "past") {
                                  return Container();
                                }

                                if (numActiveJobs > 0) {
                                  if (sortedJobDataMap[key]["jobStatus"] == "active") {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Material(
                                        elevation: 10,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.95,
                                          constraints: BoxConstraints(minHeight: 90),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                title: new Text(
                                                  DateFormat("MMM d, y").format(DateTime.parse(
                                                          sortedJobDataMap[key]["startDate"]
                                                              .toDate()
                                                              .toString())) +
                                                      " to " +
                                                      DateFormat("MMM d, y").format(DateTime.parse(
                                                          sortedJobDataMap[key]["endDate"]
                                                              .toDate()
                                                              .toString())),
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                                subtitle: Text(
                                                  "${DateFormat("jm").format(DateTime.parse(sortedJobDataMap[key]["startDate"].toDate().toString()))} - "
                                                  "${DateFormat("jm").format(DateTime.parse(sortedJobDataMap[key]["endDate"].toDate().toString()))} \n"
                                                  "${sortedJobDataMap[key]["hourlyRate"] + "/hr"}",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => EditShift(
                                                                jobDataMap: sortedJobDataMap[key],
                                                                jobUID: key,
                                                              )));
                                                },
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context).size.width * 0.9,
                                                  child: Divider(
                                                    height: 5,
                                                    thickness: 2,
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(17, 5, 0, 10),
                                                child: GestureDetector(
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width * 0.95,
                                                    child: Text(
                                                      "Number of Applicants: ${sortedJobDataMap[key]["applicants"] != null ? sortedJobDataMap[key]["applicants"].length : "0"}",
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    if (sortedJobDataMap[key]["applicants"] !=
                                                        null) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PharmacistApplied(
                                                                    jodID: key,
                                                                    applicants:
                                                                        sortedJobDataMap[key]
                                                                            ["applicants"],
                                                                  )));
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                } else
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Material(
                                      elevation: 10,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.95,
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                          "No active jobs found",
                                          style: TextStyle(color: Colors.grey, fontSize: 20),
                                        )),
                                      ),
                                    ),
                                  );

                                return Container();
                              },
                            );
                          }
                        }
                        return Container();
                      },
                    ),
                  )
                ]
              ] else if (segmentedControlGroupValue == 1) ...[
                if (jobDataMapEmpty == true) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: 50,
                        child: Center(
                            child: Text(
                          "No past jobs found",
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        )),
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: StreamBuilder(
                      stream: jobsStreamPharmacy,
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                        if (snapshot.data != null) {
                          snapshot.data?.docs.forEach((doc) {
                            dataID = doc.id;
                            jobDataMap[dataID] = doc.data();
                          });

                          sortedJobDataMap = Map.fromEntries(jobDataMap.entries.toList()
                            ..sort((e1, e2) =>
                                e1.value["startDate"].compareTo(e2.value["startDate"])));
                          if (jobDataMap.isEmpty) {
                            WidgetsBinding.instance?.addPostFrameCallback((_) => setState(() {
                                  jobDataMapEmpty = true;
                                }));
                            return Container();
                          }

                          return ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            itemCount: sortedJobDataMap.length,
                            itemBuilder: (BuildContext context, int index) {
                              String key = sortedJobDataMap.keys.elementAt(index).toString();
                              if (sortedJobDataMap[key]["jobStatus"] == "past") {
                                numPastJobs = 0;
                                numPastJobs += 1;
                              }
                              if (index == (sortedJobDataMap.length - 1) && numPastJobs == 0) {
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Material(
                                    elevation: 10,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.95,
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                        "No past jobs found",
                                        style: TextStyle(color: Colors.grey, fontSize: 20),
                                      )),
                                    ),
                                  ),
                                );
                              }
                              if (sortedJobDataMap[key]["jobStatus"] == "active") {
                                return Container();
                              }

                              if (numPastJobs > 0) {
                                if (sortedJobDataMap[key]["jobStatus"] == "past") {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      elevation: 10,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.95,
                                        height: 90,
                                        child: Center(
                                          child: ListTile(
                                            title: new Text(
                                              DateFormat("MMMM d, y").format(DateTime.parse(
                                                      sortedJobDataMap[key]["startDate"]
                                                          .toDate()
                                                          .toString())) +
                                                  " to " +
                                                  DateFormat("MMMM d, y").format(DateTime.parse(
                                                      sortedJobDataMap[key]["endDate"]
                                                          .toDate()
                                                          .toString())),
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            subtitle: Text(
                                              "${DateFormat("jm").format(DateTime.parse(sortedJobDataMap[key]["startDate"].toDate().toString()))} - "
                                              "${DateFormat("jm").format(DateTime.parse(sortedJobDataMap[key]["endDate"].toDate().toString()))} \n"
                                              "${sortedJobDataMap[key]["hourlyRate"] + "/hr"}",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onTap: null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              } else if (jobDataMap.isEmpty)
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    elevation: 10,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.95,
                                      height: 90,
                                      child: Center(
                                        child: ListTile(
                                          title: new Text(
                                            "No Jobs Found",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          onTap: () {},
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              else
                                return Container();
                              return Container();
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  )
                ]
              ]
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SideMenuDrawer extends ConsumerWidget {
  StreamSubscription? userDataSub;
  StreamSubscription? jobsDataSub;

  SideMenuDrawer({
    Key? key,
    this.userDataSub,
    this.jobsDataSub,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: BoxConstraints(minWidth: 250),
      child: Drawer(
        child: Column(
          children: <Widget>[
            //Drawer Header
            _CreateDrawerHeader(),
            //Home Button
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.home,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        text: "Home",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 17.0, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => JobHistoryPharmacy()));
              },
            ),

            //Profile Button
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        text: "Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 17.0, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PharmacyProfile()));
              },
            ),

            //Terms of Srvice Button
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        text: "Terms of Service",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 17.0, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                //TODO:Send to Terms of Service Page
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => PharmacistAvailability()));
              },
            ),

            //Privacy Policy Button
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 17.0, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                //TODO:Send to Privacy Policy Page
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => PharmacistAvailability()));
              },
            ),

            //Sign Out Button
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Divider(
                  thickness: 2,
                ),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        text: "Sign Out",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 17.0, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                jobsDataSub?.cancel();
                userDataSub?.cancel();
                ref.read(authProvider.notifier).signOut().then((value) {
                  ref.read(pharmacyMainProvider.notifier).resetValues();
                  ref.read(pharmacySignUpProvider.notifier).resetValues();
                });
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => ConnectPharma()),
                    result: Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => ConnectPharma())));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateDrawerHeader extends ConsumerWidget {
  const _CreateDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 140,
      child: DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.fromLTRB(17, 24, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Profile Photo
            CircleAvatar(
              radius: 32,
              backgroundColor: Color(0xFFF0069C1),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: Text(
                    getInitials(ref.read(pharmacyMainProvider.notifier).userData?["firstName"],
                        ref.read(pharmacyMainProvider.notifier).userData?["lastName"]),
                    style:
                        TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 8, 0, 5),
                  child: RichText(
                    text: TextSpan(
                      text: ref.read(pharmacyMainProvider.notifier).userData?["firstName"] +
                          " " +
                          ref.read(pharmacyMainProvider.notifier).userData?["lastName"],
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: RichText(
                    text: TextSpan(
                      text: ref.read(pharmacyMainProvider.notifier).userData?["email"],
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 13.0, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
