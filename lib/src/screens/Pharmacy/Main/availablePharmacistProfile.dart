import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
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
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
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
    // final pharmacistKnownSoftwareString =
    //     widget.pharmacistDataMap!["knownSoftware"];
    // knownSoftwareList = pharmacistKnownSoftwareString
    //     .toString()
    //     .substring(pharmacistKnownSoftwareString.indexOf("[") + 1,
    //         pharmacistKnownSoftwareString.lastIndexOf("]"))
    //     .split(", ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: new Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily,
          ),
        ),
        backgroundColor: Color(0xFFF0069C1),
        foregroundColor: Colors.white,
        bottomOpacity: 1,
        shadowColor: Colors.white,
      ),
      backgroundColor: Color(0xFF0069C1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Photo/Name
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    minRadius: 10,
                    maxRadius: 55,
                    child: CircleAvatar(
                        minRadius: 5,
                        maxRadius: 52,
                        backgroundImage: NetworkImage(widget.pharmacistDataMap?["profilePhoto"])),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.07,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        widget.pharmacistDataMap?["name"],
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                          fontFamily:
                              GoogleFonts.montserrat(fontWeight: FontWeight.w500).fontFamily,
                        ),
                      ),
                      Text(
                        widget.pharmacistDataMap?["userType"],
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily:
                              GoogleFonts.montserrat(fontWeight: FontWeight.w300).fontFamily,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            //Info
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 10, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Years of Experience
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text: "Experience",
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                color: Color(0xFF505050),
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        RichText(
                            text: TextSpan(
                                text: widget.pharmacistDataMap?["yearsOfExperience"] + " years",
                                style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                    fontWeight: FontWeight.w300))),
                      ],
                    ),
                    SizedBox(height: 15),
                    //Software
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Software:",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              color: Color(0xFF505050),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: 10,
                          children: widget.pharmacistDataMap!["knownSoftware"].map<Widget>((item) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  color: Color(0xFFDEEBF7),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                                  child: Text(item,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: GoogleFonts.montserrat().fontFamily)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    //Skills
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Skills:",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              color: Color(0xFF505050),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: 10,
                          children: widget.pharmacistDataMap!["knownSkills"].map<Widget>((item) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  color: Color(0xFFDEEBF7),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                                  child: Text(item,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: GoogleFonts.montserrat().fontFamily)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    //Languages
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Languages:",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              color: Color(0xFF505050),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: 10,
                          children: widget.pharmacistDataMap!["knownLanguages"].map<Widget>((item) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  color: Color(0xFFDEEBF7),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                                  child: Text(item,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: GoogleFonts.montserrat().fontFamily)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    //View Availability and Resume
                    Wrap(
                      spacing: 15,
                      children: [
                        //View Availability
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                  titlePadding: EdgeInsets.all(0),
                                  title: Text(''),
                                  backgroundColor: Colors.transparent,
                                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  content: showAvailability(),
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(color: Color(0xFF0069C1))))),
                          child: SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "View \nAvailability",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      color: Color(0xFF0069C1),
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.edit,
                                  size: 25,
                                  color: Color(0xFF0069C1),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //View Resume
                        TextButton(
                          onPressed: widget.pharmacistDataMap?["resume"] != null
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (_) => PDFViewerCachedFromUrl(
                                        url: widget.pharmacistDataMap!["resume"].toString(),
                                      ),
                                    ),
                                  );
                                }
                              : () {
                                  final snackBar = SnackBar(
                                    content: Text("No Resume Found."),
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(color: Color(0xFF0069C1))))),
                          child: SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "View \nResume",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      color: Color(0xFF0069C1),
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.picture_as_pdf_rounded,
                                  size: 25,
                                  color: Color(0xFF0069C1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    //Contact
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: 51,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.grey; // Disabled color
                                }
                                return Color(0xFFF0069C1); // Regular color
                              }),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ))),
                          onPressed: () {
                            print("Pressed");
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Center(
                                        child: Text(
                                          widget.pharmacistDataMap?["name"],
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.montserrat().fontFamily,
                                          ),
                                        ),
                                      ),
                                      content: RichText(
                                        text: TextSpan(
                                            text: "Email\n",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: GoogleFonts.montserrat().fontFamily,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "${widget.pharmacistDataMap?["email"]} \n\n",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily: GoogleFonts.montserrat().fontFamily,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "Phone",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily: GoogleFonts.montserrat().fontFamily,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "\n${widget.pharmacistDataMap?["phoneNumber"]}\n\n",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily: GoogleFonts.montserrat().fontFamily,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "\nPlease do not spam the pharmacist email, you can and will be reported for such actions. Resulting in withrawal from this service.",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: GoogleFonts.montserrat().fontFamily,
                                                ),
                                              )
                                            ]),
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              child: new Text("Report Pharmacist",
                                                  textAlign: TextAlign.left),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                          title: Center(
                                                            child: Text(
                                                              "Report Pharmacist",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontFamily: GoogleFonts.montserrat()
                                                                    .fontFamily,
                                                              ),
                                                            ),
                                                          ),
                                                          content: RichText(
                                                            text: TextSpan(
                                                              //TODO: Insert App official Email
                                                              text:
                                                                  "Please email connectpharmaltd@gmail.com with the pharmacist name and email as the subject and the body as the reasoning for this report. \n\nThank you, \ConnectPharma Team",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      GoogleFonts.montserrat()
                                                                          .fontFamily),
                                                            ),
                                                          ),
                                                          
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
                    SizedBox(height: 30),
                  
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container showAvailability() {
    return Container(
      height: 260,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
          child: SfDateRangePicker(
            controller: _controller,
            initialSelectedRanges: availabilityPharmacist,
            view: DateRangePickerView.month,
            navigationDirection: DateRangePickerNavigationDirection.vertical,
            selectionShape: DateRangePickerSelectionShape.circle,
            selectionMode: DateRangePickerSelectionMode.multiRange,
            selectionTextStyle: TextStyle(color: Colors.white),
            selectionColor: Color(0xFFE8F4FF),
            startRangeSelectionColor: Color(0xFF0069C1),
            endRangeSelectionColor: Color(0xFF0069C1),
            rangeSelectionColor: Color(0xFFE8F4FF),
            rangeTextStyle: TextStyle(color: Colors.black),
            monthViewSettings: DateRangePickerMonthViewSettings(
              blackoutDates: _blackoutDateCollection,
            ),
            monthCellStyle: DateRangePickerMonthCellStyle(
                blackoutDateTextStyle:
                    TextStyle(color: Colors.black87, fontSize: 16, fontFamily: 'Roboto')),
            onViewChanged: viewChanged,
          ),
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
      backgroundColor: Colors.grey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: new Text(
          "Resume",
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
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const PDF(fitEachPage: false, fitPolicy: FitPolicy.WIDTH).cachedFromUrl(
            url,
            placeholder: (double progress) => Center(child: Text('$progress %')),
            errorWidget: (dynamic error) => Center(child: Text(error.toString())),
          ),
        ),
      ),
    );
  }
}


/*
            
            //Highlights
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Container(
                constraints: BoxConstraints(minHeight: 400),
                width: MediaQuery.of(context).size.width,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey[300]),
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
                              padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                      text:
                                          widget.pharmacistDataMap!["yearsOfExperience"] + " years",
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
                              padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  if (widget.pharmacistDataMap!["knownSkills"] == null) ...[
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
                                        text: widget.pharmacistDataMap?["knownSoftware"]
                                            .toString()
                                            .substring(
                                                widget.pharmacistDataMap?["knownSoftware"]
                                                        .indexOf("[") +
                                                    1,
                                                widget.pharmacistDataMap?["knownSoftware"]
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
                              padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  if (widget.pharmacistDataMap!["knownSkills"] == null) ...[
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
                                        text: widget.pharmacistDataMap?["knownSkills"]
                                            .toString()
                                            .substring(
                                                widget.pharmacistDataMap?["knownSkills"]
                                                        .indexOf("[") +
                                                    1,
                                                widget.pharmacistDataMap?["knownSkills"]
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
                              padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  if (widget.pharmacistDataMap!["knownLanguages"] == null) ...[
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
                                        text: widget.pharmacistDataMap?["knownLanguages"]
                                            .toString()
                                            .substring(
                                                widget.pharmacistDataMap?["knownLanguages"]
                                                        .indexOf("[") +
                                                    1,
                                                widget.pharmacistDataMap?["knownLanguages"]
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
                              padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  if (widget.pharmacistDataMap!["availability"] == null) ...[
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
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(20.0))),
                                                    titlePadding: EdgeInsets.all(0),
                                                    title: Text(''),
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                    content: Container(
                                                        height: 300,
                                                        width: 500,
                                                        child: showAvailability()),
                                                    actionsPadding: EdgeInsets.all(0),
                                                    actions: [
                                                      Center(
                                                        child: TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: Text("Ok",
                                                                style: TextStyle(
                                                                    color: Color(0xFF228a4d)))),
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
                              padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  if (widget.pharmacistDataMap!["resume"] == null) ...[
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
                                                  builder: (_) => PDFViewerCachedFromUrl(
                                                    url: widget.pharmacistDataMap!["resume"]
                                                        .toString(),
                                                    name: widget.pharmacistDataMap!["name"]
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
                        return Color(0xFFF0069C1); // Regular color
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
 */