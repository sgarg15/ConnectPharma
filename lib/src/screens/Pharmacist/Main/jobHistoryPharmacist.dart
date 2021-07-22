import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/main.dart';
import 'package:pharma_connect/src/providers/auth_provider.dart';
import '../../../../Custom Widgets/custom_sliding_segmented_control.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class JobHistoryPharmacist extends StatefulWidget {
  JobHistoryPharmacist({Key? key}) : super(key: key);

  @override
  _JobHistoryState createState() => _JobHistoryState();
}

class _JobHistoryState extends State<JobHistoryPharmacist> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int segmentedControlGroupValue = 0;
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
              Icon(
                Icons.search,
                color: Color(0xFF5DB075),
                size: 50,
              ),
            ],
          ),
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                width: MediaQuery.of(context).size.width,
                height: 70,
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
                            EdgeInsets.symmetric(vertical: 12, horizontal: 29),
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
                            vertical: 12, horizontal: 35.4),
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
                      print(segmentedControlGroupValue);
                    }),
              ),
              if (segmentedControlGroupValue == 0)
                Align(
                  alignment: Alignment(-1, -0.7),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: FutureBuilder(
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.active:
                              case ConnectionState.done:
                                return Text("Done...");
                              case ConnectionState.waiting:
                                return Text("Loading...");
                            }
                          },
                        )),
                  ),
                )
              else if (segmentedControlGroupValue == 1)
                Container(
                  child: SingleChildScrollView(),
                )
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
    return Drawer(
      child: Center(
        child: ElevatedButton(
            onPressed: () {
              context.read(authProvider.notifier).signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => PharmaConnect()),
                  result: Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PharmaConnect())));
            },
            child: Text("Sign Out")),
      ),
    );
  }
}
