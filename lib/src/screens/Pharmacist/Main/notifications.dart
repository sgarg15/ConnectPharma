import 'package:flutter/material.dart';
import 'package:connectpharma/Custom%20Widgets/fileStorage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/src/screens/Pharmacist/Main/jobHistoryPharmacist.dart';
import 'package:connectpharma/src/screens/login.dart';

// ignore: must_be_immutable
class NotificationsPharmacist extends ConsumerStatefulWidget {
  Map jobAlerts;
  NotificationsPharmacist({Key? key, required this.jobAlerts}) : super(key: key);

  @override
  _NotificationsPharmacistState createState() => _NotificationsPharmacistState();
}

class _NotificationsPharmacistState extends ConsumerState<NotificationsPharmacist> {
  final LocalStorage localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    print("Job Alerts: ${widget.jobAlerts}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 12,
          title: Text(
            "Notifications",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
          ),
          backgroundColor: Color(0xFFF6F6F6),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 10),
                    widget.jobAlerts.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: widget.jobAlerts.length,
                              itemBuilder: (BuildContext context, int index) {
                                String key = widget.jobAlerts.keys.elementAt(index);
                                if (widget.jobAlerts[key]["newJobStatus"] == "current") {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Material(
                                        elevation: 10,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.97,
                                          constraints: BoxConstraints(minHeight: 90),
                                          child: Center(
                                            child: ListTile(
                                              isThreeLine: true,
                                              title: new Text(
                                                "${widget.jobAlerts[key]["pharmacyName"]} Accepted Application",
                                                style: TextStyle(
                                                    fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                              subtitle: RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 15)),
                                                  TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 15)),
                                                  TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                          color: Colors.black, fontSize: 15)),
                                                ]),
                                              ),
                                              onTap: () {},
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10)
                                    ],
                                  );
                                } else if (widget.jobAlerts[key]["newJobStatus"] == "rejected") {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Material(
                                        elevation: 10,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.97,
                                          constraints: BoxConstraints(minHeight: 90),
                                          child: Center(
                                            child: ListTile(
                                              isThreeLine: true,
                                              title: new Text(
                                                "${widget.jobAlerts[key]["pharmacyName"]} Rejected Application",
                                                style: TextStyle(
                                                    fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                              subtitle: RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 15)),
                                                  TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 15)),
                                                  TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                          color: Colors.black, fontSize: 15)),
                                                ]),
                                              ),
                                              onTap: () {},
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10)
                                    ],
                                  );
                                } else if (widget.jobAlerts[key]["newJobStatus"] == "removed") {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Material(
                                        elevation: 10,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.97,
                                          constraints: BoxConstraints(minHeight: 90),
                                          child: Center(
                                            child: ListTile(
                                              isThreeLine: true,
                                              title: new Text(
                                                "${widget.jobAlerts[key]["pharmacyName"]} Removed Job",
                                                style: TextStyle(
                                                    fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                              subtitle: RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 15)),
                                                  TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 15)),
                                                  TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                          color: Colors.black, fontSize: 15)),
                                                ]),
                                              ),
                                              onTap: () {},
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10)
                                    ],
                                  );
                                }
                                return Container();
                              },
                            ),
                          )
                        : Center(
                            child: Material(
                              elevation: 20,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                constraints: BoxConstraints(
                                  minHeight: 40,
                                ),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "No new notifications",
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
              ),
            ),
            Center(
              child: SizedBox(
                width: 324,
                height: 51,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Color(0xFF5DB075);
                          else if (states.contains(MaterialState.disabled)) return Colors.grey;
                          return Color(0xFF5DB075); // Use the component's default.
                        },
                      ),
                      shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ))),
                  onPressed: () async {
                    await localStorage.writeFile(
                        filePath:
                            "${await localStorage.localPath}/jobsList/${ref.read(userProviderLogin.notifier).userUID}/notifications",
                        data: "");
                    print("Storage Cleared");
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => JobHistoryPharmacist()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Clear Notifications",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}
