import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/main.dart';
import 'package:pharma_connect/model/pharmacistMainModel.dart';
import 'package:pharma_connect/src/providers/auth_provider.dart';
import 'package:pharma_connect/src/providers/pharmacist_mainProvider.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Main/findShiftPharmacist.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Main/notifications.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Main/pharmacistAvailibility.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Main/pharmacistProfile.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Sign%20Up/1pharmacistSignUp.dart';
import 'package:pharma_connect/src/screens/login.dart';
import '../../../../Custom Widgets/custom_sliding_segmented_control.dart';
import 'package:intl/intl.dart';
import '../../../../Custom Widgets/fileStorage.dart';

//TODO: Figure out the errors for notifications file and finish the notifications button/page

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
  Stream<QuerySnapshot<Map<String, dynamic>>>? jobsStreamPharmacist;
  StreamSubscription? jobsStreamSub;
  StreamSubscription? userDataStreamSub;
  String dataID = "";
  final LocalStorage localStorage = LocalStorage();
  Directory jobsListDirectory = Directory("");
  Directory userDirectory = Directory("");

  Map<String, dynamic> alertJobs = Map();
  Map jobsMap = Map();
  Map allJobs = Map();
  Map removedJob = Map();
  Map acceptedJob = Map();
  Map rejectedJob = Map();
  Map currentJobDataMap = Map();
  Map appliedJobDataMap = Map();
  Map pastJobDataMap = Map();
  Map rejectedJobDataMap = Map();

  void clearFilesOrDirectory() async {
    print(
        "All Files: ${localStorage.allDirectoryFiles(path: "${await localStorage.localPath}")}");

    final directory = Directory("${await localStorage.localPath}/jobsList");
    directory.deleteSync(recursive: true);

    print(
        "All Files: ${localStorage.allDirectoryFiles(path: "${await localStorage.localPath}")}");
  }

  Future<void> updateJobAlerts() async {
    String jobsListDirectoryPath = "${await localStorage.localPath}/jobsList";

    String userDirectoryPath =
        "${await localStorage.localPath}/jobsList/${context.read(userProviderLogin.notifier).userUID}";

    String userJobsFilePath =
        "${await localStorage.localPath}/jobsList/${context.read(userProviderLogin.notifier).userUID}/storageJobsList";

    String userNotificationsFilePath =
        "${await localStorage.localPath}/jobsList/${context.read(userProviderLogin.notifier).userUID}/notifications";

    print("Jobs List Directory: $jobsListDirectoryPath");

    print(
        "All Files: ${localStorage.allDirectoryFiles(path: "$jobsListDirectoryPath")}");
    print(
        "All User Files: ${localStorage.allDirectoryFiles(path: "$userDirectoryPath")}");

    print(
        "All User Jobs Storage: ${localStorage.readFile(filePath: "$userJobsFilePath")}");

    print(
        "All User Notifications: ${localStorage.readFile(filePath: "$userNotificationsFilePath")}");

    if (!File(userNotificationsFilePath).existsSync()) {
      File(userNotificationsFilePath).createSync();
      localStorage.writeFile(filePath: userNotificationsFilePath, data: "");
    }

    print(
        "Notifications File Path: ${localStorage.readFile(filePath: userNotificationsFilePath)}");

    if (localStorage.readFile(filePath: userNotificationsFilePath).isNotEmpty) {
      alertJobs = jsonDecode(
          localStorage.readFile(filePath: userNotificationsFilePath));
    }

    // print("Updated Job Alerts");
    print("Updated Job Alerts: $alertJobs");
  }

  Future<void> checkIfJobUpdated(Map allJobs, BuildContext context) async {
    //print(allJobs);
    String jobsListDirectoryPath = "${await localStorage.localPath}/jobsList";

    String userDirectoryPath =
        "${await localStorage.localPath}/jobsList/${context.read(userProviderLogin.notifier).userUID}";

    String userJobsFilePath =
        "${await localStorage.localPath}/jobsList/${context.read(userProviderLogin.notifier).userUID}/storageJobsList";

    String userNotificationsFilePath =
        "${await localStorage.localPath}/jobsList/${context.read(userProviderLogin.notifier).userUID}/notifications";

    Map storageJobsMap = Map();
    print(allJobs);
    allJobs.forEach((key, value) {
      storageJobsMap.addAll({
        key: {
          "pharmacyName": value["pharmacyName"],
          "startDate": value["startDate"].toDate().toIso8601String(),
          "endDate": value["endDate"].toDate().toIso8601String(),
          "applicationStatus": value["applicationStatus"],
        }
      });
    });
    print("Storage jobs data map: $storageJobsMap");

    //Check if both directory and file exists
    if (!Directory(jobsListDirectoryPath).existsSync()) {
      jobsListDirectory =
          await localStorage.createLocalDirectory(directoryName: 'jobsList');

      userDirectory =
          await localStorage.createDirectory(path: userDirectoryPath);

      File(userJobsFilePath).createSync();

      File(userNotificationsFilePath).createSync();

      await localStorage.writeFile(
          filePath: userJobsFilePath, data: jsonEncode(storageJobsMap));
    } else if (!File(userJobsFilePath).existsSync()) {
      print("Writing File");
      File(userJobsFilePath).createSync(recursive: true);

      await localStorage.writeFile(
          filePath: userJobsFilePath, data: jsonEncode(storageJobsMap));
    }

    String jobsListFile = localStorage.readFile(filePath: userJobsFilePath);

    print("File: $jobsListFile");

    if (jobsListFile.isEmpty) {
      await localStorage.writeFile(
          filePath: userJobsFilePath, data: jsonEncode(storageJobsMap));

      jobsListFile = localStorage.readFile(filePath: userJobsFilePath);
      print("Updated Job List File: $jobsListFile");
    }

    if (jobsListFile.isEmpty) {
      jobsMap = Map();
    } else {
      jobsMap = jsonDecode(jobsListFile);
    }

    removedJob.clear();
    acceptedJob.clear();
    rejectedJob.clear();
    alertJobs.clear();

    // if (jobsMap.isEmpty) {
    //   await localStorage.writeFile(
    //       filePath: userJobsFilePath, data: jsonEncode(storageJobsMap));

    //   jobsListFile = await localStorage.readFile(filePath: userJobsFilePath);

    //   if (jobsListFile.isEmpty) {
    //     jobsMap = Map();
    //   } else {
    //     jobsMap = jsonDecode(jobsListFile);
    //   }
    // }

    print("Jobs Map: $jobsMap");
    //print("All Jobs: $allJobs");
    jobsMap.forEach((key, value) {
      print("Key: $key");
      if (!allJobs.containsKey(key)) {
        print("Key: $key");
        removedJob[key] = value;
        alertJobs.addAll({key: value});
        alertJobs[key]["newJobStatus"] = "removed";
      } else if ((jobsMap.length >= allJobs.length)) {
        print(
            "Stored Value: ${value["applicationStatus"]}\nAll Jobs: ${allJobs[key]["applicationStatus"]}");

        if (value["applicationStatus"] != allJobs[key]["applicationStatus"]) {
          if (allJobs[key]["applicationStatus"] == "current") {
            acceptedJob.addAll({key: value});
            alertJobs.addAll({key: value});
            alertJobs[key]["newJobStatus"] = "current";
          } else if (allJobs[key]["applicationStatus"] == "rejected") {
            rejectedJob.addAll({key: value});
            alertJobs.addAll({key: value});
            alertJobs[key]["newJobStatus"] = "rejected";
          }
        }
      }
    });

    print("Accepted: $acceptedJob");
    print("Rejected: $rejectedJob");
    print("Removed: $removedJob");
    print("Alert Jobs: $alertJobs");

    // if ((jobsMap.length > allJobs.length) && removedJob.isNotEmpty) {
    //   print(removedJob);
    //   removedJob.forEach((key, value) {
    //     print(
    //         "The job by the pharmacy ${value["pharmacyName"]} from ${DateFormat("MMM d, y").format(DateTime.parse(value["startDate"])) + " to " + DateFormat("MMM d, y").format(DateTime.parse(value["endDate"]))} was deleted by the pharmacy.");
    //     showDialog(
    //         context: context,
    //         builder: (context) => AlertDialog(
    //               title: Text("Job Deleted"),
    //               content: Text(
    //                   "The job by the pharmacy ${value["pharmacyName"]} from ${DateFormat("MMM d, y").format(DateTime.parse(value["startDate"])) + " to " + DateFormat("MMM d, y").format(DateTime.parse(value["endDate"]))} was deleted by the pharmacy."),
    //             ));
    //   });
    // }
    // print("Accepted: $acceptedJob");
    // if ((jobsMap.length >= allJobs.length) && acceptedJob.isNotEmpty) {
    //   print("Job Length: ${acceptedJob.length}");
    //   acceptedJob.forEach((key, value) {
    //     print(
    //         "The job by the pharmacy ${value["pharmacyName"]} from ${DateFormat("MMM d, y").format(DateTime.parse(value["startDate"])) + " to " + DateFormat("MMM d, y").format(DateTime.parse(value["endDate"]))} has accepted you for the position. You will be contacted by the pharmacy soon.");
    //     showDialog(
    //         context: context,
    //         builder: (context) => AlertDialog(
    //               title: Text("Application Accepted"),
    //               content: Text(
    //                   "The job by the pharmacy ${value["pharmacyName"]} from ${DateFormat("MMM d, y").format(DateTime.parse(value["startDate"])) + " to " + DateFormat("MMM d, y").format(DateTime.parse(value["endDate"]))} has accepted you for the position. You will be contacted by the pharmacy soon."),
    //             ));
    //   });
    //   print(acceptedJob);
    //   setState(() {
    //     acceptedJob.clear();
    //   });
    //   print("Cleared");
    //   print(acceptedJob);
    // }

    // print("Rejected: $rejectedJob");
    // if ((jobsMap.length >= allJobs.length) && rejectedJob.isNotEmpty) {
    //   rejectedJob.forEach((key, value) {
    //     print(
    //         "The job by the pharmacy ${value["pharmacyName"]} from ${DateFormat("MMM d, y").format(DateTime.parse(value["startDate"])) + " to " + DateFormat("MMM d, y").format(DateTime.parse(value["endDate"]))} has rejected you for the position. To search and for more jobs please click the bottom at the bottom.");
    //     showDialog(
    //         context: context,
    //         builder: (context) => AlertDialog(
    //               title: Text("Application Rejected"),
    //               content: Text(
    //                   "The job by the pharmacy ${value["pharmacyName"]} from ${DateFormat("MMM d, y").format(DateTime.parse(value["startDate"])) + " to " + DateFormat("MMM d, y").format(DateTime.parse(value["endDate"]))} has rejected you for the position. To search and apply for more jobs please click the bottom at the bottom."),
    //             ));
    //   });
    // }

    await localStorage.writeFile(
        filePath: userJobsFilePath, data: jsonEncode(storageJobsMap));

    if (alertJobs.isNotEmpty) {
      if (!File(userNotificationsFilePath).existsSync()) {
        File(userNotificationsFilePath).createSync(recursive: true);
      }

      String previousNotifications =
          File(userNotificationsFilePath).readAsStringSync();

      print("Previous Notifications: $previousNotifications");
      if (previousNotifications.isNotEmpty) {
        print("Previous Notifications: $previousNotifications");
        alertJobs.addAll(jsonDecode(previousNotifications));
      }

      await localStorage.writeFile(
          filePath: userNotificationsFilePath, data: jsonEncode(alertJobs));
    }
    print("File: $jobsListFile");
    print("Alert Jobs: $alertJobs");
  }

  @override
  void initState() {
    super.initState();

    print("User UID: ${context.read(userProviderLogin.notifier).userUID}");

    userDataFirestoreSort();

    jobsFirestoreSort();
  }

  void userDataFirestoreSort() {
    userDataStreamSub?.cancel();
    userDataStreamSub = userRef
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
      print(
          "UserData Map: ${context.read(pharmacistMainProvider.notifier).userDataMap}");
      if (context
          .read(pharmacistMainProvider.notifier)
          .userDataMap?["availability"]
          .isEmpty) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Availability Status"),
                  content: Text(
                      "Please fill out your availability to use this app to its full potential. And allow pharmacies to discover your profile."),
                ));
      }
    });
  }

  void jobsFirestoreSort() async {
    jobsStreamPharmacist = userRef
        .doc(context.read(userProviderLogin.notifier).userUID)
        .collection("PharmacistJobs")
        .snapshots();
    //To Check if a job is deleted
    jobsStreamSub?.cancel();
    jobsStreamSub = jobsStreamPharmacist!.distinct().listen((event) async {
      print("Checking");
      if (event.size != 0) {
        event.docs.forEach((doc) {
          if ((doc.data())["applicationStatus"] == "applied" ||
              (doc.data())["applicationStatus"] == "current" ||
              (doc.data())["applicationStatus"] == "rejected") {
            dataID = doc.id;
            allJobs[dataID] = doc.data();
          }
        });
        print(context
                .read(pharmacistMainProvider.notifier)
                .userDataMap?["userType"] ==
            "Pharmacist");
        if (context
                .read(pharmacistMainProvider.notifier)
                .userDataMap?["userType"] ==
            "Pharmacist") {
          await checkIfJobUpdated(allJobs, context);

          updateJobAlerts().whenComplete(() {
            setState(() {});
          });
        }
      } else {
        localStorage.writeLocalFile(
            fileName: "${context.read(userProviderLogin.notifier).userUID}",
            data: "");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    print("In Pharmacist Job History dispose");
    jobsStreamSub?.cancel();
    userDataStreamSub?.cancel();
    print("_jobsStreamSub: $jobsStreamSub");
    print("_userDataStreamSub: $userDataStreamSub");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xFFE3E3E3),
        key: _scaffoldKey,
        drawer: SideMenuDrawer(
          jobsStreamSub: jobsStreamSub,
          userDataStreamSub: userDataStreamSub,
        ),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: RichText(
            text: TextSpan(
              text: "Job History",
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
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: new Stack(
                children: <Widget>[
                  new Icon(Icons.notifications, size: 30),
                  new Positioned(
                    right: 0,
                    child: new Container(
                      padding: EdgeInsets.all(1),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: new Text(
                        '${alertJobs.length}',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
              color: Color(0xFF5DB075),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsPharmacist(
                              jobAlerts: alertJobs,
                            )));
              },
            ),
          ],
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Icon(
                  Icons.search,
                  color: Color(0xFF5DB075),
                  size: 50,
                ),
                onTap: (context
                                .read(pharmacistMainProvider.notifier)
                                .userDataMap?["availability"] !=
                            null &&
                        context
                            .read(pharmacistMainProvider.notifier)
                            .userDataMap?["availability"]
                            .isNotEmpty)
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FindShiftForPharmacist()));
                      }
                    : () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Availability Status"),
                                  content: Text(
                                      "Please fill out your availability to use this app to its full potential. And allow pharmacies to discover your profile."),
                                ));
                      },
              ),
              //SizedBox(width: MediaQuery.of(context).size.width * 0.3),
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
                    stream: jobsStreamPharmacist,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      if (snapshot.data != null) {
                        appliedJobDataMap.clear();
                        currentJobDataMap.clear();
                        snapshot.data?.docs.forEach((doc) {
                          if ((doc.data() as Map)["applicationStatus"] ==
                              "applied") {
                            dataID = doc.id;
                            appliedJobDataMap[dataID] = doc.data();
                          } else if ((doc.data() as Map)["applicationStatus"] ==
                                  "current" ||
                              (doc.data() as Map)["applicationStatus"] ==
                                  "accept") {
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
                    stream: jobsStreamPharmacist,
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

// ignore: must_be_immutable
class SideMenuDrawer extends StatelessWidget {
  StreamSubscription? jobsStreamSub;
  StreamSubscription? userDataStreamSub;

  SideMenuDrawer({
    Key? key,
    this.jobsStreamSub,
    this.userDataStreamSub,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 250, maxWidth: 290),
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
                jobsStreamSub?.cancel();
                userDataStreamSub?.cancel();
                context.read(authProviderMain.notifier).signOut().then((value) {
                  context.read(pharmacistMainProvider.notifier).resetValues();
                  context
                      .read(pharmacistSignUpProvider.notifier)
                      .clearAllValues();
                });
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

class _CreateDrawerHeader extends StatelessWidget {
  const _CreateDrawerHeader({
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
