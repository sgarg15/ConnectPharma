import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// ignore: must_be_immutable
class ChosenPharmacistProfile extends StatefulWidget {
  Map? pharmacistDataMap = Map();
  ChosenPharmacistProfile({Key? key, this.pharmacistDataMap}) : super(key: key);

  @override
  _PharmacistProfileState createState() => _PharmacistProfileState();
}

class _PharmacistProfileState extends State<ChosenPharmacistProfile> {
  List knownSoftwareList = [];
  DateRangePickerController _controller = DateRangePickerController();
  List<DateTime> _blackoutDateCollection = <DateTime>[];
  List<PickerDateRange> availabilityPharmacist = [];

  List<DateTime> getDaysInBeteween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  void changeAvailabilityToCalendar() {
    List<PickerDateRange> dateRangesCalendarTemp = [];
    for (var i = 0; i < widget.pharmacistDataMap?["availability"].length; i++) {
      dateRangesCalendarTemp.add(PickerDateRange(
          widget.pharmacistDataMap?["availability"][i.toString()]["startDate"]
              .toDate(),
          widget.pharmacistDataMap?["availability"][i.toString()]["endDate"]
              .toDate()));
    }
    setState(() {
      availabilityPharmacist = dateRangesCalendarTemp;
      availabilityPharmacist
          .sort((a, b) => a.startDate!.compareTo(b.startDate as DateTime));
    });
  }

  void viewChanged(DateRangePickerViewChangedArgs args) {
    DateTime date;
    DateTime startDate = args.visibleDateRange.startDate as DateTime;
    DateTime endDate = args.visibleDateRange.endDate as DateTime;
    print("Start Date: $startDate");
    print("End Date: $endDate");

    List<DateTime> _blackDates = <DateTime>[];
    for (date = startDate;
        date.isBefore(endDate) || date == endDate;
        date = date.add(const Duration(days: 1))) {
      if (availabilityPharmacist.contains(date)) {
        continue;
      }
      _blackDates.add(date);
    }
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {
        _blackoutDateCollection = _blackDates;
      });
    });
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _controller.selectedRanges = availabilityPharmacist;
    });
  }

  @override
  void initState() {
    super.initState();
    changeAvailabilityToCalendar();
    print("Dates: $availabilityPharmacist");
    print("BlackOutDates: $_blackoutDateCollection");
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
                                                print("PRESSED");
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      20.0))),
                                                      titlePadding:
                                                          EdgeInsets.all(0),
                                                      title: Text(''),
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 0, 10, 0),
                                                      content: Container(
                                                          height: 300,
                                                          width: 500,
                                                          child:
                                                              showAvailability()),
                                                      actionsPadding:
                                                          EdgeInsets.all(0),
                                                      actions: [
                                                        Center(
                                                          child: TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text("Ok",
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFF228a4d)))),
                                                        )
                                                      ],
                                                    );
                                                  },
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
                                                      name: widget
                                                          .pharmacistDataMap![
                                                              "name"]
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
                              content: RichText(
                                text: TextSpan(
                                    text:
                                        "Email: ${widget.pharmacistDataMap?["email"]}\nPhone:${widget.pharmacistDataMap?["phoneNumber"]} \n\n\n",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    children: [
                                      TextSpan(
                                        text:
                                            "Please do not spam the pharmacist email, you can and will be reported for such actions. Resulting in withrawal from this service.",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ]),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: new Text("Report Pharmacist",
                                      textAlign: TextAlign.left),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Report Pharmacist"),
                                              content: RichText(
                                                text: TextSpan(
                                                  //TODO: Insert App official Email
                                                  text:
                                                      "Please email __ with the pharmacist name and email as the subject and the body as the reasoning for this report. \n\nThank you, \nPharmaConnect",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: new Text("Ok",
                                                      textAlign:
                                                          TextAlign.right),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ));
                                  },
                                ),
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

  Container showAvailability() {
    return Container(
      height: 350,
      width: 350,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
          child: SfDateRangePicker(
            controller: _controller,
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.multiRange,
            selectionShape: DateRangePickerSelectionShape.rectangle,
            initialSelectedRanges: availabilityPharmacist,
            startRangeSelectionColor: Color(0xFF228a4d),
            endRangeSelectionColor: Color(0xFF228a4d),
            rangeSelectionColor: Color(0xFF5DB075),
            onSelectionChanged: selectionChanged,
            monthViewSettings: DateRangePickerMonthViewSettings(
              blackoutDates: _blackoutDateCollection,
            ),
            monthCellStyle: DateRangePickerMonthCellStyle(
                blackoutDateTextStyle: TextStyle(
                    color: Colors.black87, fontSize: 16, fontFamily: 'Roboto')),
            onViewChanged: viewChanged,
          ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}

class PDFViewerCachedFromUrl extends StatelessWidget {
  const PDFViewerCachedFromUrl(
      {Key? key, required this.url, required this.name})
      : super(key: key);

  final String url;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("$name Resume"),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          child: const PDF(fitEachPage: false, fitPolicy: FitPolicy.WIDTH)
              .cachedFromUrl(
            url,
            placeholder: (double progress) =>
                Center(child: Text('$progress %')),
            errorWidget: (dynamic error) =>
                Center(child: Text(error.toString())),
          ),
        ),
      ),
    );
  }
}
