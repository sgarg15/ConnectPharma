import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/src/screens/Pharmacist/Main/editPharmacistProfile.dart';
import 'package:connectpharma/src/screens/Pharmacist/Main/jobHistoryPharmacist.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';

class PharmacistProfile extends ConsumerStatefulWidget {
  PharmacistProfile({Key? key}) : super(key: key);

  @override
  _PharmacistProfileState createState() => _PharmacistProfileState();
}

class _PharmacistProfileState extends ConsumerState<PharmacistProfile> {
  Map<String, dynamic>? userDataMap;

  @override
  void initState() {
    setState(() {
      userDataMap = ref.read(pharmacistMainProvider.notifier).userDataMap;
    });
    super.initState();
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
            fontSize: 16,
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
                        backgroundImage: NetworkImage(userDataMap?["profilePhotoDownloadURL"])),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.07,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        userDataMap?["firstName"] + " " + userDataMap?["lastName"],
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                          fontFamily:
                              GoogleFonts.montserrat(fontWeight: FontWeight.w500).fontFamily,
                        ),
                      ),
                      Text(
                        userDataMap?["userType"],
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

            //Personal Details
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPharmacistProfile(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
                        child: Icon(
                          Icons.edit,
                          color: Color(0xFF0069C1),
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 10, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Email
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                  text: "Email",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            RichText(
                                text: TextSpan(
                                    text: userDataMap?["email"],
                                    style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                        fontWeight: FontWeight.w300))),
                          ],
                        ),
                        SizedBox(height: 15),
                        //Phone Number
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                  text: "Phone",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            RichText(
                                text: TextSpan(
                                    text: userDataMap?["phoneNumber"],
                                    style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                        fontWeight: FontWeight.w300))),
                          ],
                        ),
                        SizedBox(height: 15),
                        //Address
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                  text: "Address",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            RichText(
                                text: TextSpan(
                                    text: userDataMap?["address"],
                                    style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                        fontWeight: FontWeight.w300))),
                          ],
                        ),
                        SizedBox(height: 15),
                        //Graduated From and what year
                        Wrap(
                          runSpacing: 10,
                          children: [
                            //Graduated From
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                      text: "Graduated From",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                                RichText(
                                    text: TextSpan(
                                        text: userDataMap?["institutionName"],
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            color: Color(0xFF505050),
                                            fontWeight: FontWeight.w300))),
                              ],
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                            //Graduated In
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                      text: "Graduated In",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                                RichText(
                                    text: TextSpan(
                                        text: userDataMap?["gradutationYear"],
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            color: Color(0xFF505050),
                                            fontWeight: FontWeight.w300))),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        //Year Licensed and license number
                        Wrap(
                          runSpacing: 10,
                          children: [
                            //Graduated From
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                      text: "Year Licensed",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                                RichText(
                                    text: TextSpan(
                                        text: userDataMap?["firstYearLicensed"],
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            color: Color(0xFF505050),
                                            fontWeight: FontWeight.w300))),
                              ],
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                            //Graduated In
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                      text: "License Number",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Color(0xFF505050),
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                                RichText(
                                    text: TextSpan(
                                        text: userDataMap?["registrationNumber"],
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            color: Color(0xFF505050),
                                            fontWeight: FontWeight.w300))),
                              ],
                            ),
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
                              children: userDataMap!["knownSoftware"].map<Widget>((item) {
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
                              children: userDataMap!["knownSkills"].map<Widget>((item) {
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
                              children: userDataMap!["knownLanguages"].map<Widget>((item) {
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //View Signature
                            TextButton(
                              onPressed: userDataMap?["signatureDownloadURL"] != null
                                  ? () {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return Dialog(
                                              child: Container(
                                                height: 120,
                                                //padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 3,
                                                    color: Color(0xFF0069C1),
                                                  ),
                                                ),
                                                child: userDataMap?["signatureDownloadURL"] == null
                                                    ? Image.network(
                                                        userDataMap?["signatureDownloadURL"])
                                                    : Center(
                                                        child: Text(
                                                          "No Signature Found",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 15,
                                                              fontFamily: GoogleFonts.montserrat()
                                                                  .fontFamily),
                                                        ),
                                                      ),
                                              ),
                                            );
                                          });
                                    }
                                  : () {
                                      final snackBar = SnackBar(
                                        content: Text("No Signature Found."),
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
                                      "View \nSignature",
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
                              onPressed: userDataMap?["resumeDownloadURL"] != null
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                          builder: (_) => PDFViewerCachedFromUrl(
                                            url: userDataMap!["resumeDownloadURL"].toString(),
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
                      ],
                    ),
                  ),
                ],
              ),
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
 Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: RichText(
                    text: TextSpan(
                      text: "Software:",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: GoogleFonts.montserrat().fontFamily),
                    ),
                  ),
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: userDataMap!["knownSoftware"].map<Widget>((item) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: RichText(
                    text: TextSpan(
                      text: "Skills:",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: GoogleFonts.montserrat().fontFamily),
                    ),
                  ),
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: userDataMap!["knownSkills"].map<Widget>((item) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: RichText(
                    text: TextSpan(
                      text: "Languages:",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: GoogleFonts.montserrat().fontFamily),
                    ),
                  ),
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: userDataMap!["knownLanguages"].map<Widget>((item) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
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
            SizedBox(
              height: 10,
            ),

*/

/*
Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      constraints: BoxConstraints(minHeight: 320),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //Title/Profile Image/Edit Button
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //Title Text/Edit Button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: "User Information",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22.0,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EditPharmacistProfile()));
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(Color(0xFFF0069C1))),
                                      child: RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "Edit",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18.0,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //Profile Picture
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: CircleAvatar(
                                    radius: 52,
                                    backgroundColor: Color(0xFFF0069C1),
                                    child: CircleAvatar(
                                      radius: 49,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          NetworkImage(userDataMap?["profilePhotoDownloadURL"]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //Info
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.48,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      //Name
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Name",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                              text: userDataMap?["firstName"] != null
                                                  ? TextSpan(
                                                      text: userDataMap?["firstName"] +
                                                          " " +
                                                          userDataMap?["lastName"],
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 20.0,
                                                          color: Colors.grey[800]),
                                                    )
                                                  : TextSpan(
                                                      text: "N/A",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 20.0,
                                                          color: Colors.grey[800])),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //Email
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Email",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: userDataMap?["email"] ?? "N/A",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20.0,
                                                      color: Colors.grey[800]),
                                                )),
                                          ],
                                        ),
                                      ),
                                      //Address
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Address",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: userDataMap?["address"] ?? "N/A",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20.0,
                                                      color: Colors.grey[800]),
                                                )),
                                          ],
                                        ),
                                      ),
                                      //Graduation Date
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Graduated In",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: userDataMap?["gradutationYear"] ?? "N/A",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20.0,
                                                      color: Colors.grey[800]),
                                                )),
                                          ],
                                        ),
                                      ),
                                      //First Year Licensed Date
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "First Year Licensed In",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: userDataMap?["firstYearLicensed"] ?? "N/A",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20.0,
                                                      color: Colors.grey[800]),
                                                )),
                                          ],
                                        ),
                                      ),

                                      //Signature
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Signature",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: userDataMap?["signatureDownloadURL"] != null
                                                  ? () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) {
                                                            return Dialog(
                                                              child: Container(
                                                                height: 120,
                                                                //padding: EdgeInsets.all(3),
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    width: 3,
                                                                    color: Color(0xFFF0069C1),
                                                                  ),
                                                                ),
                                                                child: Image.network(userDataMap?[
                                                                    "signatureDownloadURL"]),
                                                              ),
                                                            );
                                                          });
                                                    }
                                                  : () {
                                                      final snackBar = SnackBar(
                                                        content: Text("No Signature Found."),
                                                        behavior: SnackBarBehavior.floating,
                                                        duration: Duration(seconds: 2),
                                                      );
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(snackBar);
                                                    },
                                              child: RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: "View",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 18.0,
                                                      color: Color(0xFFF0069C1)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.41,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //Type
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Type",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: userDataMap?["userType"] ?? "N/A",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20.0,
                                                    color: Colors.grey[800]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //Phone
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Phone",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: userDataMap?["phoneNumber"] ?? "N/A",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20.0,
                                                    color: Colors.grey[800]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      //Graduated From
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Graduated From",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: userDataMap?["institutionName"] ?? "N/A",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20.0,
                                                      color: Colors.grey[800]),
                                                )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 22,
                                      ),
                                      //License Number
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "License Number",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: userDataMap?["registrationNumber"] ?? "N/A",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20.0,
                                                      color: Colors.grey[800]),
                                                )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      //First Year Licensed Date
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Year Licensed",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: userDataMap?["firstYearLicensed"] ?? "N/A",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20.0,
                                                      color: Colors.grey[800]),
                                                )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1,
                                      ),
                                      //Resume
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Resume",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: userDataMap?["resumeDownloadURL"] != null
                                                  ? () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute<dynamic>(
                                                          builder: (_) => PDFViewerCachedFromUrl(
                                                            url: userDataMap!["resumeDownloadURL"]
                                                                .toString(),
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
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(snackBar);
                                                    },
                                              child: RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: "View",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 18.0,
                                                      color: Color(0xFFF0069C1)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            //Software
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                      text: "Software",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.0,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  if (userDataMap!["knownSoftware"] == null) ...[
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: "No Software Found",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20.0,
                                            color: Colors.grey[800]),
                                      ),
                                    ),
                                  ] else
                                    ...[],
                                ],
                              ),
                            ),
                            //Skills
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                      text: "Skills",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.0,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  if (userDataMap!["knownSkills"] == null) ...[
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: "No Skills Found",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                            color: Colors.grey[800]),
                                      ),
                                    ),
                                  ] else ...[
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: userDataMap?["knownSkills"].toString().substring(
                                            userDataMap?["knownSkills"].indexOf("[") + 1,
                                            userDataMap?["knownSkills"].lastIndexOf("]")),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                            color: Colors.grey[800]),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            //Languages
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                      text: "Languages",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.0,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  if (userDataMap!["knownLanguages"] == null) ...[
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: "No Languages Found",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                            color: Colors.grey[800]),
                                      ),
                                    ),
                                  ] else ...[
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: userDataMap?["knownLanguages"].toString().substring(
                                            userDataMap?["knownLanguages"].indexOf("[") + 1,
                                            userDataMap?["knownLanguages"].lastIndexOf("]")),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                            color: Colors.grey[800]),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
            
            */
