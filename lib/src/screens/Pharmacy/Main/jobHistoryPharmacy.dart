import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/all_used.dart';
import 'package:pharma_connect/main.dart';
import 'package:pharma_connect/model/pharmacyMainModel.dart';
import 'package:pharma_connect/src/providers/pharmacyMainProvider.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/editShift.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/pharmacyProfile.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/searchPharmacist.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Sign%20Up/1pharmacy_signup.dart';
import 'package:pharma_connect/src/screens/login.dart';
import '../../../../Custom Widgets/custom_sliding_segmented_control.dart';
import 'package:intl/intl.dart';

final pharmacyMainProvider =
    StateNotifierProvider<PharmacyMainProvider, PharmacyMainModel>((ref) {
  return PharmacyMainProvider();
});

class JobHistoryPharmacy extends StatefulWidget {
  JobHistoryPharmacy({Key? key}) : super(key: key);

  @override
  _JobHistoryState createState() => _JobHistoryState();
}

class _JobHistoryState extends State<JobHistoryPharmacy> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int segmentedControlGroupValue = 0;
  CollectionReference usersRef = FirebaseFirestore.instance.collection("Users");
  String dataID = "";
  Map jobDataMap = Map();
  Map sortedJobDataMap = Map();
  Map<String, dynamic>? userDataMap = Map();
  Stream<QuerySnapshot<Map<String, dynamic>>>? jobsStream = null;
  int numActiveJobs = 0;
  int numPastJobs = 0;
  bool jobDataMapEmpty = false;

  // Stream<QuerySnapshot<Map<String, dynamic>>> getJobs() {
  //   final jobsStream = usersRef
  //       .doc(context.read(userProviderLogin.notifier).userUID)
  //       .collection("Main")
  //       .snapshots();
  //   return jobsStream;
  //   // await usersRef
  //   //     .doc(context.read(userProviderLogin.notifier).userUID)
  //   //     .collection("Main")
  //   //     .get()
  //   //     .then((querySnapshot) => {
  //   //           querySnapshot.docs.forEach((doc) {
  //   //             setState(() {
  //   //               dataID = doc.id;
  //   //               jobDataMap[dataID] = doc.data();
  //   //             });
  //   //           })
  //   //         });
  //   // setState(() {
  //   //   sortedJobDataMap = Map.fromEntries(jobDataMap.entries.toList()
  //   //     ..sort((e1, e2) =>
  //   //         e1.value["startDate"].compareTo(e2.value["startDate"])));
  //   // });
  //   // usersRef
  //   //     .doc(context.read(userProviderLogin.notifier).userUID)
  //   //     .collection("Main")
  //   //     .snapshots()
  //   //     .listen((event) {
  //   //   event.docs.forEach((doc) {
  //   //     setState(() {
  //   //       dataID = doc.id;
  //   //       jobDataMap[dataID] = doc.data();
  //   //     });
  //   //   });
  //   // });
  //   // setState(() {
  //   //   sortedJobDataMap = Map.fromEntries(jobDataMap.entries.toList()
  //   //     ..sort((e1, e2) =>
  //   //         e1.value["startDate"].compareTo(e2.value["startDate"])));
  //   // });
  // }

  // void getUserData() async {
  //   await usersRef
  //       .doc(context.read(userProviderLogin.notifier).userUID)
  //       .collection("SignUp")
  //       .doc("Information")
  //       .get()
  //       .then((querySnapshot) => {
  //             setState(() {
  //               userDataMap = querySnapshot.data();
  //             })
  //           });
  //   context.read(pharmacyMainProvider.notifier).changeUserDataMap(userDataMap);
  // }

  @override
  void initState() {
    super.initState();
    numActiveJobs = 0;
    numPastJobs = 0;
    //getJobs();
    jobsStream = usersRef
        .doc(context.read(userProviderLogin.notifier).userUID)
        .collection("Main")
        .snapshots();
    usersRef
        .doc(context.read(userProviderLogin.notifier).userUID)
        .collection("SignUp")
        .doc("Information")
        .snapshots()
        .listen((docData) {
      setState(() {
        userDataMap = docData.data();
      });
      context
          .read(pharmacyMainProvider.notifier)
          .changeUserDataMap(userDataMap);
      print(context.read(pharmacyMainProvider.notifier).userData);
    });

    context.read(pharmacyMainProvider.notifier).clearDateValues();
    // getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xFFE3E3E3),
        key: _scaffoldKey,
        drawer: SideMenuDrawer(),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: RichText(
            text: TextSpan(
              text: "Job History Pharmacy",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24.0,
                  color: Colors.black),
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
                    color: Color(0xFF5DB075),
                    size: 50,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchPharmacistPharmacy()));
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
                child: CupertinoSlidingSegmentedControl(
                    thumbColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    backgroundColor: Color(0xFFC4C4C4),
                    groupValue: segmentedControlGroupValue,
                    children: <int, Widget>{
                      0: Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 34),
                        child: segmentedControlGroupValue == 0
                            ? Text(
                                "Active Jobs",
                                style: TextStyle(
                                  color: Color(0xFF5DB075),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              )
                            : Text(
                                "Active Jobs",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                      ),
                      1: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 40.45),
                        child: segmentedControlGroupValue == 1
                            ? Text(
                                "Past Jobs",
                                style: TextStyle(
                                  color: Color(0xFF5DB075),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              )
                            : Text(
                                "Past Jobs",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                      ),
                    },
                    onValueChanged: (int? i) {
                      setState(() {
                        segmentedControlGroupValue = i!.toInt();
                      });
                    }),
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
                      stream: jobsStream,
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        if (!snapshot.hasData)
                          return Center(child: CircularProgressIndicator());
                        if (snapshot.data != null) {
                          snapshot.data?.docs.forEach((doc) {
                            dataID = doc.id;
                            jobDataMap[dataID] = doc.data();
                          });

                          sortedJobDataMap = Map.fromEntries(
                              jobDataMap.entries.toList()
                                ..sort((e1, e2) => e1.value["startDate"]
                                    .compareTo(e2.value["startDate"])));

                          if (jobDataMap.isEmpty) {
                            WidgetsBinding.instance
                                ?.addPostFrameCallback((_) => setState(() {
                                      jobDataMapEmpty = true;
                                    }));

                            return Container();
                          } else {
                            return ListView.builder(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              itemCount: sortedJobDataMap.length,
                              itemBuilder: (BuildContext context, int index) {
                                String key = sortedJobDataMap.keys
                                    .elementAt(index)
                                    .toString();
                                if (sortedJobDataMap[key]["jobStatus"] ==
                                    "active") {
                                  numActiveJobs = 0;
                                  numActiveJobs += 1;
                                }
                                if (index == (sortedJobDataMap.length - 1) &&
                                    numActiveJobs == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 0),
                                    child: Material(
                                      elevation: 10,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95,
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                          "No active jobs found",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 20),
                                        )),
                                      ),
                                    ),
                                  );
                                }
                                if (sortedJobDataMap[key]["jobStatus"] ==
                                    "past") {
                                  return Container();
                                }

                                if (numActiveJobs > 0) {
                                  if (sortedJobDataMap[key]["jobStatus"] ==
                                      "active") {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Material(
                                        elevation: 10,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.95,
                                          constraints:
                                              BoxConstraints(minHeight: 90),
                                          child: Center(
                                            child: ListTile(
                                              title: new Text(
                                                DateFormat("MMMM d, y").format(
                                                        DateTime.parse(
                                                            sortedJobDataMap[
                                                                        key][
                                                                    "startDate"]
                                                                .toDate()
                                                                .toString())) +
                                                    " to " +
                                                    DateFormat("MMMM d, y")
                                                        .format(DateTime.parse(
                                                            sortedJobDataMap[
                                                                        key]
                                                                    ["endDate"]
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditShift(
                                                              jobDataMap:
                                                                  sortedJobDataMap[
                                                                      key],
                                                              jobUID: key,
                                                            )));
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                } else
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Material(
                                      elevation: 10,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95,
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                          "No active jobs found",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 20),
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
                      stream: jobsStream,
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        if (!snapshot.hasData)
                          return Center(child: CircularProgressIndicator());
                        if (snapshot.data != null) {
                          snapshot.data?.docs.forEach((doc) {
                            dataID = doc.id;
                            jobDataMap[dataID] = doc.data();
                          });

                          sortedJobDataMap = Map.fromEntries(
                              jobDataMap.entries.toList()
                                ..sort((e1, e2) => e1.value["startDate"]
                                    .compareTo(e2.value["startDate"])));
                          if (jobDataMap.isEmpty) {
                            WidgetsBinding.instance
                                ?.addPostFrameCallback((_) => setState(() {
                                      jobDataMapEmpty = true;
                                    }));
                            return Container();
                          }

                          return ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            itemCount: sortedJobDataMap.length,
                            itemBuilder: (BuildContext context, int index) {
                              String key = sortedJobDataMap.keys
                                  .elementAt(index)
                                  .toString();
                              if (sortedJobDataMap[key]["jobStatus"] ==
                                  "past") {
                                numPastJobs = 0;
                                numPastJobs += 1;
                              }
                              if (index == (sortedJobDataMap.length - 1) &&
                                  numPastJobs == 0) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Material(
                                    elevation: 10,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                        "No past jobs found",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 20),
                                      )),
                                    ),
                                  ),
                                );
                              }
                              if (sortedJobDataMap[key]["jobStatus"] ==
                                  "active") {
                                return Container();
                              }

                              if (numPastJobs > 0) {
                                if (sortedJobDataMap[key]["jobStatus"] ==
                                    "past") {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      elevation: 10,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95,
                                        height: 90,
                                        child: Center(
                                          child: ListTile(
                                            title: new Text(
                                              DateFormat("MMMM d, y").format(
                                                      DateTime.parse(
                                                          sortedJobDataMap[key]
                                                                  ["startDate"]
                                                              .toDate()
                                                              .toString())) +
                                                  " to " +
                                                  DateFormat("MMMM d, y")
                                                      .format(DateTime.parse(
                                                          sortedJobDataMap[key]
                                                                  ["endDate"]
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
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
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

class SideMenuDrawer extends StatelessWidget {
  const SideMenuDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 250),
      child: Drawer(
        child: Column(
          children: <Widget>[
            //Drawer Header
            _createDrawerHeader(),
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
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JobHistoryPharmacy()));
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
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PharmacyProfile()));
              },
            ),

            //Availability Button
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.event_available,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        text: "Availability",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => PharmacistAvailability()));
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
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0,
                            color: Colors.blue),
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
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0,
                            color: Colors.blue),
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
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                context.read(authProvider.notifier).signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => PharmaConnect()),
                    result: Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PharmaConnect())));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _createDrawerHeader extends StatelessWidget {
  const _createDrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: Color(0xFF5DB075),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: Text(
                    getInitials(
                        context
                            .read(pharmacyMainProvider.notifier)
                            .userData?["firstName"],
                        context
                            .read(pharmacyMainProvider.notifier)
                            .userData?["lastName"]),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
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
                      text: context
                              .read(pharmacyMainProvider.notifier)
                              .userData?["firstName"] +
                          " " +
                          context
                              .read(pharmacyMainProvider.notifier)
                              .userData?["lastName"],
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                          color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: RichText(
                    text: TextSpan(
                      text: context
                          .read(pharmacyMainProvider.notifier)
                          .userData?["email"],
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,
                          color: Colors.black),
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
