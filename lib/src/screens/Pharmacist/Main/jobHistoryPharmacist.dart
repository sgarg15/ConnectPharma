import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectpharma/src/screens/Pharmacist/Main/jobDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/main.dart';
import 'package:connectpharma/model/pharmacistMainModel.dart';
import 'package:connectpharma/src/providers/auth_provider.dart';
import 'package:connectpharma/src/providers/pharmacist_mainProvider.dart';
import 'package:connectpharma/src/screens/Pharmacist/Main/findShiftPharmacist.dart';
import 'package:connectpharma/src/screens/Pharmacist/Main/notifications.dart';
import 'package:connectpharma/src/screens/Pharmacist/Main/pharmacistAvailibility.dart';
import 'package:connectpharma/src/screens/Pharmacist/Main/pharmacistProfile.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign%20Up/1pharmacistSignUp.dart';
import 'package:connectpharma/src/screens/login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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

class JobHistoryPharmacist extends ConsumerStatefulWidget {
  JobHistoryPharmacist({Key? key}) : super(key: key);

  @override
  _JobHistoryState createState() => _JobHistoryState();
}

class _JobHistoryState extends ConsumerState<JobHistoryPharmacist> {
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

  String magnifyIcon = "assets/icons/magnify.svg";

  void clearFilesOrDirectory() async {
    print("All Files Local: ${localStorage.allDirectoryFiles(path: await localStorage.localPath)}");

    final directory = Directory("${await localStorage.localPath}/jobsList");
    //directory.deleteSync(recursive: true);

    print(
        "All Files Jobs List: ${localStorage.allDirectoryFiles(path: "${await localStorage.localPath}/jobsList")}");
  }

  Future<void> updateJobAlerts(WidgetRef ref) async {
    String jobsListDirectoryPath = "${await localStorage.localPath}/jobsList";

    String userDirectoryPath =
        "${await localStorage.localPath}/jobsList/${ref.read(userProviderLogin.notifier).userUID}";

    String userJobsFilePath =
        "${await localStorage.localPath}/jobsList/${ref.read(userProviderLogin.notifier).userUID}/storageJobsList";

    String userNotificationsFilePath =
        "${await localStorage.localPath}/jobsList/${ref.read(userProviderLogin.notifier).userUID}/notifications";

    print("Jobs List Directory: $jobsListDirectoryPath");

    print("All Files: ${localStorage.allDirectoryFiles(path: jobsListDirectoryPath)}");
    print("All User Files: ${localStorage.allDirectoryFiles(path: userDirectoryPath)}");

    print("All User Jobs Storage: ${localStorage.readFile(filePath: userJobsFilePath)}");

    print("All User Notifications: ${localStorage.readFile(filePath: userNotificationsFilePath)}");

    if (!File(userNotificationsFilePath).existsSync()) {
      File(userNotificationsFilePath).createSync();
      localStorage.writeFile(filePath: userNotificationsFilePath, data: "");
    }

    print("Notifications File Path: ${localStorage.readFile(filePath: userNotificationsFilePath)}");

    if (localStorage.readFile(filePath: userNotificationsFilePath).isNotEmpty) {
      alertJobs = jsonDecode(localStorage.readFile(filePath: userNotificationsFilePath));
    }

    // print("Updated Job Alerts");
    print("Updated Job Alerts: $alertJobs");
  }

  Future<void> checkIfJobUpdated(WidgetRef ref, Map allJobs) async {
    //print(allJobs);
    String jobsListDirectoryPath = "${await localStorage.localPath}/jobsList";

    String userDirectoryPath =
        "${await localStorage.localPath}/jobsList/${ref.read(userProviderLogin.notifier).userUID}";

    String userJobsFilePath =
        "${await localStorage.localPath}/jobsList/${ref.read(userProviderLogin.notifier).userUID}/storageJobsList";

    String userNotificationsFilePath =
        "${await localStorage.localPath}/jobsList/${ref.read(userProviderLogin.notifier).userUID}/notifications";

    Map storageJobsMap = Map();
    print("All Jobs: $allJobs");
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
      print("\n---------Creating all directories---------\n");
      jobsListDirectory = await localStorage.createLocalDirectory(directoryName: 'jobsList');

      userDirectory = await localStorage.createDirectory(path: userDirectoryPath);

      File(userJobsFilePath).createSync();

      File(userNotificationsFilePath).createSync();

      await localStorage.writeFile(filePath: userJobsFilePath, data: jsonEncode(storageJobsMap));
    } else if (!File(userJobsFilePath).existsSync()) {
      print("Writing File");
      File(userJobsFilePath).createSync(recursive: true);

      await localStorage.writeFile(filePath: userJobsFilePath, data: jsonEncode(storageJobsMap));
    }

    String jobsListFile = localStorage.readFile(filePath: userJobsFilePath);

    print("File: $jobsListFile");

    if (jobsListFile.isEmpty) {
      await localStorage.writeFile(filePath: userJobsFilePath, data: jsonEncode(storageJobsMap));

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

    print("Jobs Map: $jobsMap");
    //print("All Jobs: $allJobs");
    jobsMap.forEach((key, value) {
      print("Key: $key");
      if (!allJobs.containsKey(key)) {
        print("Key: $key");
        removedJob[key] = value;
        alertJobs.addAll({key: value});
        print("Removed Job: $removedJob");
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

    await localStorage.writeFile(filePath: userJobsFilePath, data: jsonEncode(storageJobsMap));

    if (alertJobs.isNotEmpty) {
      if (!File(userNotificationsFilePath).existsSync()) {
        File(userNotificationsFilePath).createSync(recursive: true);
      }

      String previousNotifications = File(userNotificationsFilePath).readAsStringSync();

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
    print("Init State");

    print("User UID: ${ref.read(userProviderLogin.notifier).userUID}");
    //clearFilesOrDirectory();
    userDataFirestoreSort(ref);
    //checkIfJobUpdated(ref, allJobs);
    jobsFirestoreSort(ref);
  }

  void userDataFirestoreSort(WidgetRef ref) {
    userDataStreamSub?.cancel();
    userDataStreamSub = userRef
        .doc(ref.read(userProviderLogin.notifier).userUID)
        .collection("SignUp")
        .doc("Information")
        .snapshots()
        .listen((docData) {
      setState(() {
        userDataMap = docData.data();
      });
      ref.read(pharmacistMainProvider.notifier).changeUserDataMap(userDataMap);
      print("UserData Map: ${ref.read(pharmacistMainProvider.notifier).userDataMap}");
      if (ref.read(pharmacistMainProvider.notifier).userDataMap?["availability"].isEmpty) {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text("Availability Status"),
                  content: Text(
                      "Please fill out your availability to use this app to its full potential. And allow pharmacies to discover your profile."),
                ));
      }
    });
  }

  void jobsFirestoreSort(WidgetRef ref) {
    print("--------------\nCALLING PHARMACIST JOBS\n-----------------");
    jobsStreamPharmacist = userRef
        .doc(ref.read(userProviderLogin.notifier).userUID)
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
        print(ref.read(pharmacistMainProvider.notifier).userDataMap?["userType"] == "Pharmacist");
        if (ref.read(pharmacistMainProvider.notifier).userDataMap?["userType"] == "Pharmacist" ||
            ref.read(pharmacistMainProvider.notifier).userDataMap?["userType"] ==
                "Pharmacy Assistant" ||
            ref.read(pharmacistMainProvider.notifier).userDataMap?["userType"] ==
                "Pharmacy Technician") {
          await checkIfJobUpdated(ref, allJobs);

          updateJobAlerts(ref).whenComplete(() {
            setState(() {});
          });
        }
      } else {
        print("Writing Empty File");
        clearFilesOrDirectory();
        // print(
        //     "All Files USER: ${localStorage.allDirectoryFiles(path: "${await localStorage.localPath}/jobsList/${ref.read(userProviderLogin.notifier).userUID}")}");
        userDirectory = await localStorage.createDirectory(
            path:
                "${await localStorage.localPath}/jobsList/${ref.read(userProviderLogin.notifier).userUID}");

        File("${await localStorage.localPath}/jobsList/${ref.read(userProviderLogin.notifier).userUID}/storageJobsList")
            .createSync();

        File("${await localStorage.localPath}/jobsList/${ref.read(userProviderLogin.notifier).userUID}/notifications")
            .createSync();
        print(
            "All Files USER: ${await localStorage.localPath}/jobsList/${ref.read(userProviderLogin.notifier).userUID}/storageJobsList");
        localStorage.writeFile(
            filePath:
                "${await localStorage.localPath}/jobsList/${ref.read(userProviderLogin.notifier).userUID}/storageJobsList",
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
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: SideMenuDrawer(
          jobsStreamSub: jobsStreamSub,
          userDataStreamSub: userDataStreamSub,
        ),
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: ColoredBox(
              color: Colors.white,
              child: TabBar(
                  labelColor: Color(0xFF0069C1),
                  unselectedLabelColor: Color(0xFF4F4F4F),
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily,
                  ),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily,
                  ),
                  tabs: const [
                    Tab(
                      text: "Active Jobs",
                    ),
                    Tab(
                      text: "Past Jobs",
                    ),
                  ]),
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: new Text(
            "Job History",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily,
            ),
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
                      padding: const EdgeInsets.all(1),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
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
              color: Colors.white,
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
          backgroundColor: Color(0xFFF0069C1),
          foregroundColor: Colors.white,
          elevation: 0,
          bottomOpacity: 1,
          shadowColor: Colors.white,
        ),
        floatingActionButton: Container(
          height: 60.0,
          width: 60.0,
          margin: EdgeInsets.only(bottom: 10, right: 10),
          child: FloatingActionButton(
            onPressed: (ref.read(pharmacistMainProvider.notifier).userDataMap?["availability"] !=
                        null &&
                    ref
                        .read(pharmacistMainProvider.notifier)
                        .userDataMap?["availability"]
                        .isNotEmpty)
                ? () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => FindShiftForPharmacist()));
                  }
                : () {
                    print("No Shifts Available");
                    showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                              title: Text("Availability Status"),
                              content: Text(
                                  "Please fill out your availability to use this app to its full potential. And allow pharmacies to discover your profile."),
                            ));
                  },
            child: SvgPicture.asset(magnifyIcon),
            backgroundColor: Color(0xFF0069C1),
          ),
        ),
        body: StreamBuilder(
            stream: jobsStreamPharmacist,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                print("No data");
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              appliedJobDataMap.clear();
              currentJobDataMap.clear();
              pastJobDataMap.clear();
              rejectedJobDataMap.clear();

              snapshot.data?.docs.forEach((doc) {
                if ((doc.data() as Map)["applicationStatus"] == "applied") {
                  dataID = doc.id;
                  appliedJobDataMap[dataID] = doc.data();
                } else if ((doc.data() as Map)["applicationStatus"] == "current" ||
                    (doc.data() as Map)["applicationStatus"] == "accept") {
                  dataID = doc.id;
                  currentJobDataMap[dataID] = doc.data();
                } else if ((doc.data() as Map)["applicationStatus"] == "past") {
                  dataID = doc.id;
                  pastJobDataMap[dataID] = doc.data();
                } else if ((doc.data() as Map)["applicationStatus"] == "rejected") {
                  dataID = doc.id;
                  rejectedJobDataMap[dataID] = doc.data();
                }
              });

              return TabBarView(
                children: [
                  //Active Jobs
                  Column(
                    children: [
                      ExpansionTile(
                        
                          textColor: Color(0xFF0069C1),
                          title: Text(
                            "Current Jobs (${currentJobDataMap.length})",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: GoogleFonts.montserrat().fontFamily),
                          ),
                        children: [
                          Divider(
                            color: Color(0xFFC6C6C6),
                            thickness: 0.7,
                          ),
                          buildCurrentJobsList(context)
                        ],
                      ),
                      ExpansionTile(
                          textColor: Color(0xFF0069C1),
                          title: Text(
                            "Applied Jobs (${appliedJobDataMap.length})",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: GoogleFonts.montserrat().fontFamily),
                          ),
                          children: [
                            Divider(
                              color: Color(0xFFC6C6C6),
                              thickness: 0.7,
                            ),
                            buildAppliedJobsList(context)
                          ]),
                    ],
                  ),
                  //Past Jobs
                  Column(
                    children: [
                      ExpansionTile(
                          textColor: Color(0xFF0069C1),
                          title: Text(
                            "Past Jobs (${pastJobDataMap.length})",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: GoogleFonts.montserrat().fontFamily),
                          ),
                          children: [
                            Divider(
                              color: Color(0xFFC6C6C6),
                              thickness: 0.7,
                            ),
                            buildPastJobsList(context)
                          ]),
                      ExpansionTile(
                          textColor: Color(0xFF0069C1),
                          title: Text(
                            "Rejected Jobs (${rejectedJobDataMap.length})",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: GoogleFonts.montserrat().fontFamily),
                          ),
                          children: [
                            Divider(
                              color: Color(0xFFC6C6C6),
                              thickness: 0.7,
                            ),
                            buildRejectedJobsList(context)
                          ]),
                    ],
                  )
                ],
              );
            }),
      ),
    );
  }

  Column buildCurrentJobsList(BuildContext context) {
    print("Building Current Jobs");
    return Column(children: <Widget>[
      //Headline

      if (currentJobDataMap.isEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 30,
            child: const Center(
                child: Text(
              "No current jobs found",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            )),
          ),
        )
      else
        ListView.builder(
          physics: new BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: currentJobDataMap.length,
          itemBuilder: (BuildContext context, int index) {
            String key = currentJobDataMap.keys.elementAt(index).toString();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: new Text(
                      DateFormat("MMM d, y").format(DateTime.parse(
                              currentJobDataMap[key]["startDate"].toDate().toString())) +
                          " to " +
                          DateFormat("MMM d, y").format(DateTime.parse(
                              currentJobDataMap[key]["endDate"].toDate().toString())),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "${DateFormat("jm").format(DateTime.parse(currentJobDataMap[key]["startDate"].toDate().toString()))} - "
                      "${DateFormat("jm").format(DateTime.parse(currentJobDataMap[key]["endDate"].toDate().toString()))} \n"
                      "${currentJobDataMap[key]["hourlyRate"] + " Hourly Rate"}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                    enabled: true,
                    onTap: () {
                      print("Tapped");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JobDetails(
                                    jobDetails: currentJobDataMap[key],
                                    viewing: true,
                                  )));
                    },
                  ),
                ),

                if (index != currentJobDataMap.length - 1)
                  Divider(
                    color: Color(0xFFC6C6C6),
                    thickness: 1,
                  ),
               
              ],
            );
          },
        ),
    ]);
  }

  Column buildAppliedJobsList(BuildContext context) {
    return Column(children: <Widget>[
      if (appliedJobDataMap.isEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 30,
            child: const Center(
                child: Text(
              "No applied jobs found",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            )),
          ),
        )
      else
        ListView.builder(
          physics: new BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: appliedJobDataMap.length,
          itemBuilder: (BuildContext context, int index) {
            String key = appliedJobDataMap.keys.elementAt(index).toString();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(

                    title: new Text(
                      DateFormat("MMM d, y").format(DateTime.parse(
                              appliedJobDataMap[key]["startDate"].toDate().toString())) +
                          " to " +
                          DateFormat("MMM d, y").format(DateTime.parse(
                              appliedJobDataMap[key]["endDate"].toDate().toString())),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "${DateFormat("jm").format(DateTime.parse(appliedJobDataMap[key]["startDate"].toDate().toString()))} - "
                      "${DateFormat("jm").format(DateTime.parse(appliedJobDataMap[key]["endDate"].toDate().toString()))} \n"
                      "${appliedJobDataMap[key]["hourlyRate"] + " Hourly Rate"}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                          
                    onTap: () {
                      print("Tapped");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JobDetails(
                                    jobDetails: appliedJobDataMap[key],
                                    viewing: true,
                                  )));
                    },
                  ),
                ),
                if (index != appliedJobDataMap.length - 1)
                  Divider(
                    color: Color(0xFFC6C6C6),
                    thickness: 1,
                  ),
              ],
            );
          },
        ),
    ]);
  }

  Column buildPastJobsList(BuildContext context) {
    print("Building Past Jobs");
    return Column(children: <Widget>[
      if (pastJobDataMap.isEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 30,
            child: const Center(
                child: Text(
              "No past jobs found",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            )),
          ),
        )
      else
        ListView.builder(
          physics: new BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: pastJobDataMap.length,
          itemBuilder: (BuildContext context, int index) {
            String key = pastJobDataMap.keys.elementAt(index).toString();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    enabled: false,

                    title: new Text(
                      DateFormat("MMM d, y").format(DateTime.parse(
                              pastJobDataMap[key]["startDate"].toDate().toString())) +
                          " to " +
                          DateFormat("MMM d, y").format(
                              DateTime.parse(pastJobDataMap[key]["endDate"].toDate().toString())),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "${DateFormat("jm").format(DateTime.parse(pastJobDataMap[key]["startDate"].toDate().toString()))} - "
                      "${DateFormat("jm").format(DateTime.parse(pastJobDataMap[key]["endDate"].toDate().toString()))} \n"
                      "${pastJobDataMap[key]["hourlyRate"] + " Hourly Rate"}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
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
                if (index != currentJobDataMap.length - 1)
                  Divider(
                    color: Color(0xFFC6C6C6),
                    thickness: 1,
                  ),
              ],
            );
          },
        ),
    ]);
  }

  Column buildRejectedJobsList(BuildContext context) {
    print("Building Rejected Jobs List");

    return Column(children: <Widget>[
      if (rejectedJobDataMap.isEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 30,
            child: const Center(
                child: Text(
              "No rejected jobs found",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            )),
          ),
        )
      else
        ListView.builder(
          physics: new NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: rejectedJobDataMap.length,
          
          itemBuilder: (BuildContext context, int index) {
            String key = rejectedJobDataMap.keys.elementAt(index).toString();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    enabled: false,
                    title: new Text(
                      DateFormat("MMM d, y").format(DateTime.parse(
                              rejectedJobDataMap[key]["startDate"].toDate().toString())) +
                          " to " +
                          DateFormat("MMM d, y").format(DateTime.parse(
                              rejectedJobDataMap[key]["endDate"].toDate().toString())),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "${DateFormat("jm").format(DateTime.parse(rejectedJobDataMap[key]["startDate"].toDate().toString()))} - "
                      "${DateFormat("jm").format(DateTime.parse(rejectedJobDataMap[key]["endDate"].toDate().toString()))} \n"
                      "${rejectedJobDataMap[key]["hourlyRate"] + " Hourly Rate"}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
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
                if (index != rejectedJobDataMap.length - 1)
                  Divider(
                    color: Color(0xFFC6C6C6),
                    thickness: 1,
                  ),
              ],
            );
          },
        ),
    ]);
  }
}

// ignore: must_be_immutable
class SideMenuDrawer extends ConsumerWidget {
  StreamSubscription? jobsStreamSub;
  StreamSubscription? userDataStreamSub;

  SideMenuDrawer({
    Key? key,
    this.jobsStreamSub,
    this.userDataStreamSub,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: const BoxConstraints(minWidth: 250, maxWidth: 290),
      child: Drawer(
        child: Column(
          children: <Widget>[
            //Drawer Header
            const _CreateDrawerHeader(),
            //Home Button
            ListTile(
              title: Row(
                children: [
                  const Icon(
                    Icons.home,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: RichText(
                      text: const TextSpan(
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
                    context, MaterialPageRoute(builder: (context) => JobHistoryPharmacist()));
              },
            ),

            //Profile Button
            ListTile(
              title: Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: RichText(
                      text: const TextSpan(
                        text: "Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 17.0, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => PharmacistProfile()));
              },
            ),

            //Availability Button
            ListTile(
              title: Row(
                children: [
                  const Icon(
                    Icons.event_available,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: RichText(
                      text: const TextSpan(
                        text: "Availability",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 17.0, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => PharmacistAvailability()));
              },
            ),

            //Terms of Srvice Button
            ListTile(
              title: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: RichText(
                      text: const TextSpan(
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
                  const Icon(
                    Icons.info_outline,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: RichText(
                      text: const TextSpan(
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
            const Expanded(
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
                  const Icon(
                    Icons.exit_to_app,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: RichText(
                      text: const TextSpan(
                        text: "Sign Out",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 17.0, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                jobsStreamSub?.cancel();
                userDataStreamSub?.cancel();
                ref.read(authProviderMain.notifier).signOut().then((value) {
                  ref.read(pharmacistMainProvider.notifier).resetValues();
                  ref.read(userSignUpProvider.notifier).clearAllValues();
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
  const _CreateDrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("Creating Header");
    String? profilePhotoDownloadURL =
        ref.read(pharmacistMainProvider.notifier).userDataMap?["profilePhotoDownloadURL"];
    return Container(
      height: 140,
      child: DrawerHeader(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.fromLTRB(17, 24, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Profile Photo
            CircleAvatar(
                radius: 30.0,
                backgroundColor: const Color(0xFF778899),
                //Change to retrieve photo from firestore
                backgroundImage: NetworkImage(profilePhotoDownloadURL ?? "")),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 8, 0, 5),
                  child: RichText(
                    text: TextSpan(
                      //change to retrieve name from Firestore
                      text: ref.read(pharmacistMainProvider.notifier).userDataMap?["firstName"] +
                          " " +
                          ref.read(pharmacistMainProvider.notifier).userDataMap?["lastName"],
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: RichText(
                    text: TextSpan(
                      //change to retrieve email from firestore
                      text: ref.read(pharmacistMainProvider.notifier).userDataMap?["email"],
                      style: const TextStyle(
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
