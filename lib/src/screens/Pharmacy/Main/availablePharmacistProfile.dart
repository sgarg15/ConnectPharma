import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

// ignore: must_be_immutable
class ChosenPharmacistProfile extends StatefulWidget {
  Map? pharmacistDataMap = Map();
  ChosenPharmacistProfile({Key? key, this.pharmacistDataMap}) : super(key: key);

  @override
  _PharmacistProfileState createState() => _PharmacistProfileState();
}

class _PharmacistProfileState extends State<ChosenPharmacistProfile> {
  List knownSoftwareList = [];

  @override
  void initState() {
    super.initState();
    print(widget.pharmacistDataMap);
    final pharmacistKnownSoftwareString =
        widget.pharmacistDataMap!["knownSoftware"];
    knownSoftwareList = pharmacistKnownSoftwareString
        .toString()
        .substring(pharmacistKnownSoftwareString.indexOf("[") + 1,
            pharmacistKnownSoftwareString.lastIndexOf("]"))
        .split(", ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            //back button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                  )),
            ),
            //Profile Photo and Name
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.pharmacistDataMap?["profilePhoto"],
                      ),
                      radius: 70,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: widget.pharmacistDataMap!["name"],
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Highlights
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(60),
                child: Container(
                  constraints: BoxConstraints(minHeight: 400),
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[300]),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 10, 0),
                    child: Column(
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Highlights",
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              //Experience
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: "Experience",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: widget.pharmacistDataMap![
                                                "yearsOfExperience"] +
                                            " years",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //Software
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: "Software",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    if (widget.pharmacistDataMap![
                                            "knownSkills"] ==
                                        null) ...[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "No Software Found",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: widget.pharmacistDataMap?[
                                                  "knownSoftware"]
                                              .toString()
                                              .substring(
                                                  widget.pharmacistDataMap?[
                                                              "knownSoftware"]
                                                          .indexOf("[") +
                                                      1,
                                                  widget.pharmacistDataMap?[
                                                          "knownSoftware"]
                                                      .lastIndexOf("]")),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              //Skills
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: "Skills",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    if (widget.pharmacistDataMap![
                                            "knownSkills"] ==
                                        null) ...[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "No Skills Found",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: widget
                                              .pharmacistDataMap?["knownSkills"]
                                              .toString()
                                              .substring(
                                                  widget.pharmacistDataMap?[
                                                              "knownSkills"]
                                                          .indexOf("[") +
                                                      1,
                                                  widget.pharmacistDataMap?[
                                                          "knownSkills"]
                                                      .lastIndexOf("]")),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              //Languages
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: "Languages",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    if (widget.pharmacistDataMap![
                                            "knownLanguages"] ==
                                        null) ...[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "No Languages Found",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: widget.pharmacistDataMap?[
                                                  "knownLanguages"]
                                              .toString()
                                              .substring(
                                                  widget.pharmacistDataMap?[
                                                              "knownLanguages"]
                                                          .indexOf("[") +
                                                      1,
                                                  widget.pharmacistDataMap?[
                                                          "knownLanguages"]
                                                      .lastIndexOf("]")),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              //Availability
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: "Availability",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    if (widget.pharmacistDataMap![
                                            "availability"] ==
                                        null) ...[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "No availability Found",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                            text: "View Availability",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                showDateRangePicker(
                                                  context: context,
                                                  firstDate:
                                                      DateTime(2019, 12, 05),
                                                  lastDate:
                                                      DateTime(2029, 12, 05),
                                                  initialEntryMode:
                                                      DatePickerEntryMode
                                                          .calendarOnly,
                                                );
                                              }),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              //Resume
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: "Resume",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    if (widget.pharmacistDataMap!["resume"] ==
                                        null) ...[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "No resume Found",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                            text: "View Resume",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                print("PRESSED");
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute<dynamic>(
                                                    builder: (_) =>
                                                        PDFViewerCachedFromUrl(
                                                      url: widget
                                                          .pharmacistDataMap![
                                                              "resume"]
                                                          .toString(),
                                                    ),
                                                  ),
                                                );
                                                // MaterialPageRoute<dynamic>(
                                                //   builder: (_) =>
                                                //       const PDFViewerFromUrl(
                                                //     url:
                                                //         'http://africau.edu/images/default/sample.pdf',
                                                //   ),
                                                // );
                                              }),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Contact Button
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: SizedBox(
                width: 340,
                height: 51,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey; // Disabled color
                        }
                        return Color(0xFF5DB075); // Regular color
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ))),
                  onPressed: () {
                    print("Pressed");
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(widget.pharmacistDataMap?["name"]),
                              content: Text(
                                "Email: " + widget.pharmacistDataMap?["email"],
                              ),
                              actions: <Widget>[
                                new TextButton(
                                  child: new Text("Ok"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => AvailablePharmacists()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Contact Pharmacist",
                      style: TextStyle(
                        fontSize: 18,
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
        ),
      ),
    );
  }
}

class PDFViewerCachedFromUrl extends StatelessWidget {
  const PDFViewerCachedFromUrl({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cached PDF From Url'),
      ),
      body: const PDF().cachedFromUrl(
        url,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
