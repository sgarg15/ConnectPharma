import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/main.dart';
import 'package:pharma_connect/model/pharmacistMainModel.dart';
import 'package:pharma_connect/src/providers/auth_provider.dart';
import 'package:pharma_connect/src/providers/pharmacist_mainProvider.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Main/findShiftPharmacist.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Main/pharmacistAvailibility.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Main/pharmacistProfile.dart';
import 'package:pharma_connect/src/screens/login.dart';
import '../../../../Custom Widgets/custom_sliding_segmented_control.dart';
import 'package:intl/intl.dart';

final authProviderMain = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

final pharmacistMainProvider =
    StateNotifierProvider<PharmacistMainProvider, PharmacistMainModel>((ref) {
  return PharmacistMainProvider();
});

class JobHistoryPharmacist extends StatefulWidget {
  JobHistoryPharmacist({Key? key}) : super(key: key);

  @override
  _JobHistoryState createState() => _JobHistoryState();
}

class _JobHistoryState extends State<JobHistoryPharmacist> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int segmentedControlGroupValue = 0;
  CollectionReference userRef = FirebaseFirestore.instance.collection("Users");
  Map<String, dynamic>? userDataMap = Map();
  Stream<QuerySnapshot<Map<String, dynamic>>>? jobsStream = null;
  String dataID = "";

  Map currentJobDataMap = Map();
  Map appliedJobDataMap = Map();
  Map pastJobDataMap = Map();
  Map rejectedJobDataMap = Map();

  @override
  void initState() {
    super.initState();

    jobsStream = userRef
        .doc(context.read(userProviderLogin.notifier).userUID)
        .collection("Main")
        .snapshots();

    userRef
        .doc(context.read(userProviderLogin.notifier).userUID)
        .collection("SignUp")
        .doc("Information")
        .snapshots()
        .listen((docData) {
      setState(() {
        userDataMap = docData.data();
      });
      context
          .read(pharmacistMainProvider.notifier)
          .changeUserDataMap(userDataMap);
      //print(context.read(pharmacistMainProvider.notifier).userDataMap);
    });
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
              text: "Job History Pharmacist",
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
          height: 55,
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
            children: <Widget>[
              GestureDetector(
                child: Icon(
                  Icons.search,
                  color: Color(0xFF5DB075),
                  size: 50,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FindShiftForPharmacist()));
                },
              ),
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              //Slider
              Container(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
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
              //Active
              if (segmentedControlGroupValue == 0)
                StreamBuilder(
                    stream: jobsStream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      if (snapshot.data != null) {
                        snapshot.data?.docs.forEach((doc) {
                          if ((doc.data() as Map)["applicationStatus"] ==
                              "applied") {
                            dataID = doc.id;
                            appliedJobDataMap[dataID] = doc.data();
                          } else if ((doc.data() as Map)["applicationStatus"] ==
                              "current") {
                            dataID = doc.id;
                            currentJobDataMap[dataID] = doc.data();
                          }
                        });

                        return Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                //Current Jobs
                                buildCurrentJobsList(context),
                                //Applied Jobs
                                buildAppliedJobsList(context),
                              ],
                            ),
                          ),
                        );
                      }
                      return Container();
                    })

              //Past
              else if (segmentedControlGroupValue == 1)
                StreamBuilder(
                    stream: jobsStream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      if (snapshot.data != null) {
                        snapshot.data?.docs.forEach((doc) {
                          if ((doc.data() as Map)["applicationStatus"] ==
                              "past") {
                            dataID = doc.id;
                            pastJobDataMap[dataID] = doc.data();
                          } else if ((doc.data() as Map)["applicationStatus"] ==
                              "rejected") {
                            dataID = doc.id;
                            rejectedJobDataMap[dataID] = doc.data();
                          }
                        });

                        return Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                //Current Jobs
                                buildPastJobsList(context),
                                //Applied Jobs
                                buildRejectedJobsList(context),
                              ],
                            ),
                          ),
                        );
                      }
                      return Container();
                    })
            ],
          ),
        ),
      ),
    );
  }

  Column buildCurrentJobsList(BuildContext context) {
    return Column(children: <Widget>[
      //Headline
      Row(children: <Widget>[
        Text(
          "   Current (${currentJobDataMap.length})",
        ),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                color: Colors.grey,
                height: 36,
                thickness: 4,
              )),
        ),
      ]),
      if (currentJobDataMap.length == 0)
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: 30,
              child: Center(
                  child: Text(
                "No current jobs found",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
            ),
          ),
        )
      else
        ListView.builder(
          physics: new NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: currentJobDataMap.length,
          itemBuilder: (BuildContext context, int index) {
            String key = currentJobDataMap.keys.elementAt(index).toString();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  constraints: BoxConstraints(minHeight: 90),
                  child: Center(
                    child: ListTile(
                      title: new Text(
                        DateFormat("MMM d, y").format(DateTime.parse(
                                currentJobDataMap[key]["startDate"]
                                    .toDate()
                                    .toString())) +
                            " to " +
                            DateFormat("MMM d, y").format(DateTime.parse(
                                currentJobDataMap[key]["endDate"]
                                    .toDate()
                                    .toString())),
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "${DateFormat("jm").format(DateTime.parse(currentJobDataMap[key]["startDate"].toDate().toString()))} - "
                        "${DateFormat("jm").format(DateTime.parse(currentJobDataMap[key]["endDate"].toDate().toString()))} \n"
                        "${currentJobDataMap[key]["hourlyRate"] + "/hr"}",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             EditShift(
                        //               jobDataMap:
                        //                   sortedJobDataMap[
                        //                       key],
                        //               jobUID: key,
                        //             )));
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
    ]);
  }

  Column buildAppliedJobsList(BuildContext context) {
    return Column(children: <Widget>[
      //Headline
      Row(children: <Widget>[
        Text(
          "   Applied (${appliedJobDataMap.length})",
        ),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                color: Colors.grey,
                height: 36,
                thickness: 4,
              )),
        ),
      ]),
      if (appliedJobDataMap.length == 0)
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: 30,
              child: Center(
                  child: Text(
                "No applied jobs found",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
            ),
          ),
        )
      else
        ListView.builder(
          physics: new NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: appliedJobDataMap.length,
          itemBuilder: (BuildContext context, int index) {
            String key = appliedJobDataMap.keys.elementAt(index).toString();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  constraints: BoxConstraints(minHeight: 90),
                  child: Center(
                    child: ListTile(
                      title: new Text(
                        DateFormat("MMM d, y").format(DateTime.parse(
                                appliedJobDataMap[key]["startDate"]
                                    .toDate()
                                    .toString())) +
                            " to " +
                            DateFormat("MMM d, y").format(DateTime.parse(
                                appliedJobDataMap[key]["endDate"]
                                    .toDate()
                                    .toString())),
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "${DateFormat("jm").format(DateTime.parse(appliedJobDataMap[key]["startDate"].toDate().toString()))} - "
                        "${DateFormat("jm").format(DateTime.parse(appliedJobDataMap[key]["endDate"].toDate().toString()))} \n"
                        "${appliedJobDataMap[key]["hourlyRate"] + "/hr"}",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             EditShift(
                        //               jobDataMap:
                        //                   sortedJobDataMap[
                        //                       key],
                        //               jobUID: key,
                        //             )));
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
    ]);
  }

  Column buildPastJobsList(BuildContext context) {
    return Column(children: <Widget>[
      //Headline
      Row(children: <Widget>[
        Text(
          "   Past (${pastJobDataMap.length})",
        ),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                color: Colors.grey,
                height: 36,
                thickness: 4,
              )),
        ),
      ]),
      if (pastJobDataMap.length == 0)
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: 30,
              child: Center(
                  child: Text(
                "No past jobs found",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
            ),
          ),
        )
      else
        ListView.builder(
          physics: new NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: pastJobDataMap.length,
          itemBuilder: (BuildContext context, int index) {
            String key = pastJobDataMap.keys.elementAt(index).toString();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  constraints: BoxConstraints(minHeight: 90),
                  child: Center(
                    child: ListTile(
                      title: new Text(
                        DateFormat("MMM d, y").format(DateTime.parse(
                                pastJobDataMap[key]["startDate"]
                                    .toDate()
                                    .toString())) +
                            " to " +
                            DateFormat("MMM d, y").format(DateTime.parse(
                                pastJobDataMap[key]["endDate"]
                                    .toDate()
                                    .toString())),
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "${DateFormat("jm").format(DateTime.parse(pastJobDataMap[key]["startDate"].toDate().toString()))} - "
                        "${DateFormat("jm").format(DateTime.parse(pastJobDataMap[key]["endDate"].toDate().toString()))} \n"
                        "${pastJobDataMap[key]["hourlyRate"] + "/hr"}",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             EditShift(
                        //               jobDataMap:
                        //                   sortedJobDataMap[
                        //                       key],
                        //               jobUID: key,
                        //             )));
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
    ]);
  }

  Column buildRejectedJobsList(BuildContext context) {
    return Column(children: <Widget>[
      //Headline
      Row(children: <Widget>[
        Text(
          "   Rejected (${rejectedJobDataMap.length})",
        ),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                color: Colors.grey,
                height: 36,
                thickness: 4,
              )),
        ),
      ]),
      if (rejectedJobDataMap.length == 0)
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: 30,
              child: Center(
                  child: Text(
                "No rejected jobs found",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
            ),
          ),
        )
      else
        ListView.builder(
          physics: new NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: rejectedJobDataMap.length,
          itemBuilder: (BuildContext context, int index) {
            String key = rejectedJobDataMap.keys.elementAt(index).toString();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  constraints: BoxConstraints(minHeight: 90),
                  child: Center(
                    child: ListTile(
                      title: new Text(
                        DateFormat("MMM d, y").format(DateTime.parse(
                                rejectedJobDataMap[key]["startDate"]
                                    .toDate()
                                    .toString())) +
                            " to " +
                            DateFormat("MMM d, y").format(DateTime.parse(
                                rejectedJobDataMap[key]["endDate"]
                                    .toDate()
                                    .toString())),
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "${DateFormat("jm").format(DateTime.parse(rejectedJobDataMap[key]["startDate"].toDate().toString()))} - "
                        "${DateFormat("jm").format(DateTime.parse(rejectedJobDataMap[key]["endDate"].toDate().toString()))} \n"
                        "${rejectedJobDataMap[key]["hourlyRate"] + "/hr"}",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             EditShift(
                        //               jobDataMap:
                        //                   sortedJobDataMap[
                        //                       key],
                        //               jobUID: key,
                        //             )));
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
    ]);
  }
}

class SideMenuDrawer extends StatelessWidget {
  const SideMenuDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 250, maxWidth: 290),
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
                        builder: (context) => JobHistoryPharmacist()));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PharmacistProfile()));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PharmacistAvailability()));
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
                context.read(authProviderMain.notifier).signOut();
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
                radius: 30.0,
                backgroundColor: const Color(0xFF778899),
                //Change to retrieve photo from firestore
                backgroundImage: NetworkImage(context
                    .read(pharmacistMainProvider.notifier)
                    .userDataMap?["profilePhotoDownloadURL"])),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 8, 0, 5),
                  child: RichText(
                    text: TextSpan(
                      //change to retrieve name from Firestore
                      text: context
                              .read(pharmacistMainProvider.notifier)
                              .userDataMap?["firstName"] +
                          " " +
                          context
                              .read(pharmacistMainProvider.notifier)
                              .userDataMap?["lastName"],
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
                      //change to retrieve email from firestore
                      text: context
                          .read(pharmacistMainProvider.notifier)
                          .userDataMap?["email"],
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
