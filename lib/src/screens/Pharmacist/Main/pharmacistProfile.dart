import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Main/editPharmacistProfile.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Main/jobHistoryPharmacist.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

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
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 12,
        title: Text(
          "Profile",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
        ),
        backgroundColor: Color(0xFFF6F6F6),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //User Information
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                builder: (context) =>
                                                    EditPharmacistProfile()));
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color(0xFF5DB075))),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: CircleAvatar(
                                    radius: 52,
                                    backgroundColor: Color(0xFF5DB075),
                                    child: CircleAvatar(
                                      radius: 49,
                                      backgroundColor: Colors.grey,
                                      backgroundImage: NetworkImage(
                                          userDataMap?[
                                              "profilePhotoDownloadURL"]),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.48,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      //Name
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              text: userDataMap?["firstName"] !=
                                                      null
                                                  ? TextSpan(
                                                      text: userDataMap?[
                                                              "firstName"] +
                                                          " " +
                                                          userDataMap?[
                                                              "lastName"],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 20.0,
                                                          color:
                                                              Colors.grey[800]),
                                                    )
                                                  : TextSpan(
                                                      text: "N/A",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 20.0,
                                                          color: Colors
                                                              .grey[800])),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //Email
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  text: userDataMap?["email"] ??
                                                      "N/A",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20.0,
                                                      color: Colors.grey[800]),
                                                )),
                                          ],
                                        ),
                                      ),
                                      //Address
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  text:
                                                      userDataMap?["address"] ??
                                                          "N/A",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20.0,
                                                      color: Colors.grey[800]),
                                                )),
                                          ],
                                        ),
                                      ),
                                      //Graduation Date
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  text: userDataMap?[
                                                          "gradutationYear"] ??
                                                      "N/A",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20.0,
                                                      color: Colors.grey[800]),
                                                )),
                                          ],
                                        ),
                                      ),
                                      //First Year Licensed Date
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  text: userDataMap?[
                                                          "firstYearLicensed"] ??
                                                      "N/A",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20.0,
                                                      color: Colors.grey[800]),
                                                )),
                                          ],
                                        ),
                                      ),

                                      //Signature
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              onTap: userDataMap?[
                                                          "signatureDownloadURL"] !=
                                                      null
                                                  ? () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) {
                                                            return Dialog(
                                                              child: Container(
                                                                height: 120,
                                                                //padding: EdgeInsets.all(3),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    width: 3,
                                                                    color: Color(
                                                                        0xFF5DB075),
                                                                  ),
                                                                ),
                                                                child: Image.network(
                                                                    userDataMap?[
                                                                        "signatureDownloadURL"]),
                                                              ),
                                                            );
                                                          });
                                                    }
                                                  : () {
                                                      final snackBar = SnackBar(
                                                        content: Text(
                                                            "No Signature Found."),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        duration: Duration(
                                                            seconds: 2),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    },
                                              child: RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: "View",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18.0,
                                                      color: Color(0xFF5DB075)),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.41,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //Type
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 12, 0, 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                text:
                                                    userDataMap?["userType"] ??
                                                        "N/A",
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
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                text: userDataMap?[
                                                        "phoneNumber"] ??
                                                    "N/A",
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
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  text: userDataMap?[
                                                          "institutionName"] ??
                                                      "N/A",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  text: userDataMap?[
                                                          "registrationNumber"] ??
                                                      "N/A",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  text: userDataMap?[
                                                          "firstYearLicensed"] ??
                                                      "N/A",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              onTap: userDataMap?[
                                                          "resumeDownloadURL"] !=
                                                      null
                                                  ? () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute<
                                                            dynamic>(
                                                          builder: (_) =>
                                                              PDFViewerCachedFromUrl(
                                                            url: userDataMap![
                                                                    "resumeDownloadURL"]
                                                                .toString(),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  : () {
                                                      final snackBar = SnackBar(
                                                        content: Text(
                                                            "No Resume Found."),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        duration: Duration(
                                                            seconds: 2),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    },
                                              child: RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: "View",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18.0,
                                                      color: Color(0xFF5DB075)),
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
                                  if (userDataMap!["knownSkills"] == null) ...[
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
                                  ] else ...[
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: userDataMap?["knownSoftware"]
                                            .toString()
                                            .substring(
                                                userDataMap?["knownSoftware"]
                                                        .indexOf("[") +
                                                    1,
                                                userDataMap?["knownSoftware"]
                                                    .lastIndexOf("]")),
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
                                        text: userDataMap?["knownSkills"]
                                            .toString()
                                            .substring(
                                                userDataMap?["knownSkills"]
                                                        .indexOf("[") +
                                                    1,
                                                userDataMap?["knownSkills"]
                                                    .lastIndexOf("]")),
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
                                  if (userDataMap!["knownLanguages"] ==
                                      null) ...[
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
                                        text: userDataMap?["knownLanguages"]
                                            .toString()
                                            .substring(
                                                userDataMap?["knownLanguages"]
                                                        .indexOf("[") +
                                                    1,
                                                userDataMap?["knownLanguages"]
                                                    .lastIndexOf("]")),
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
            SizedBox(
              height: 10,
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
        title: Text("Resume"),
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
