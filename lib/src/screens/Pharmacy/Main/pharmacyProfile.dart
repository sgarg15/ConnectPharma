
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/all_used.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/editProfile.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';
import 'package:google_fonts/google_fonts.dart';

class PharmacyProfile extends ConsumerWidget {
  const PharmacyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic>? userData = ref.read(pharmacyMainProvider.notifier).userData;
    String streetAddress = userData!['address']["streetAddress"] ?? "";
    String city = userData['address']["city"] ?? "";
    String country = userData['address']["country"] ?? "";
    String postalCode = userData['address']["postalCode"] ?? "";
    String address = streetAddress + ", " + city + ", " + country + ", " + postalCode;
    
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
        backgroundColor: Color(0xFF0069C1),
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
                        child: Text(getInitials(userData["firstName"], userData["lastName"]),
                            style: TextStyle(
                                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold))),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.07),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          userData["firstName"] + " " + userData["lastName"],
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            fontFamily:
                                GoogleFonts.montserrat(fontWeight: FontWeight.w500).fontFamily,
                          ),
                        ),
                      ),
                      Text(
                        userData["userType"],
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
            //Personal Info
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
                            builder: (context) => EditPharmacyProfile(),
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
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                                text: "Account Information",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Color(0xFF505050),
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                          SizedBox(height: 15),
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
                                      text: userData["email"],
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
                                      text: userData["phoneNumber"],
                                      style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w300))),
                            ],
                          ),
                          SizedBox(height: 15),
                          Divider(
                            color: Color(0xFFE5E5E5),
                            thickness: 1,
                          ),
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                                text: "Pharmacy Information",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Color(0xFF505050),
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                          SizedBox(height: 15),
                          //Pharmacy Name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                    text: "Pharmacy Name",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      color: Color(0xFF505050),
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: userData["pharmacyName"],
                                      style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w300))),
                            ],
                          ),
                          SizedBox(height: 15),
                          //Pharmacy Address
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                    text: "Pharmacy Address",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      color: Color(0xFF505050),
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: address,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w300))),
                            ],
                          ),
                          SizedBox(height: 15),
                          //Pharmacy Phone Number
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                    text: "Pharmacy Phone",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      color: Color(0xFF505050),
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: userData["pharmacyPhoneNumber"],
                                      style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w300))),
                            ],
                          ),
                          SizedBox(height: 15),
                          //Pharmacy Fax
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                    text: "Pharmacy Fax",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      color: Color(0xFF505050),
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: userData["pharmacyFaxNumber"],
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
                                children: userData["softwareList"].map<Widget>((item) {
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
                          //Manager Name and License Number
                          Wrap(
                            spacing: 20,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                        text: "Manager Name",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          text: userData["managerFirstName"] +
                                              " " +
                                              userData["managerLastName"],
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w300))),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                        text: "Manager License #",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          text: userData["managerLicenseNumber"],
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15,
                                              color: Color(0xFF505050),
                                              fontWeight: FontWeight.w300))),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          //Manager Phone Number
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                    text: "Manager Phone",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      color: Color(0xFF505050),
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: userData["managerPhoneNumber"],
                                      style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w300))),
                            ],
                          ),
                          SizedBox(height: 35),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
 //Account Owner Information
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
                                        text: "Account Owner",
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
                                                builder: (context) => EditPharmacyProfile()));
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
                                      child: Text(
                                          getInitials(
                                              ref
                                                  .read(pharmacyMainProvider.notifier)
                                                  .userData?["firstName"],
                                              ref
                                                  .read(pharmacyMainProvider.notifier)
                                                  .userData?["lastName"]),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
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
                                  width: MediaQuery.of(context).size.width * 0.47,
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
                                              text: ref
                                                          .read(pharmacyMainProvider.notifier)
                                                          .userData?["firstName"] !=
                                                      null
                                                  ? TextSpan(
                                                      text: ref
                                                              .read(pharmacyMainProvider.notifier)
                                                              .userData?["firstName"] +
                                                          " " +
                                                          ref
                                                              .read(pharmacyMainProvider.notifier)
                                                              .userData?["lastName"],
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
                                                  text: ref
                                                          .read(pharmacyMainProvider.notifier)
                                                          .userData?["email"] ??
                                                      "N/A",
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
                                              onTap: ref
                                                          .read(pharmacyMainProvider.notifier)
                                                          .userData?["signatureDownloadURL"] !=
                                                      null
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
                                                                child: Image.network(ref
                                                                        .read(pharmacyMainProvider
                                                                            .notifier)
                                                                        .userData?[
                                                                    "signatureDownloadURL"]),
                                                              ),
                                                            );
                                                          });
                                                    }
                                                  : null,
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
                                  width: MediaQuery.of(context).size.width * 0.42,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      //Position
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Position",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: ref
                                                        .read(pharmacyMainProvider.notifier)
                                                        .userData?["position"] ??
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
                                                text: ref
                                                        .read(pharmacyMainProvider.notifier)
                                                        .userData?["phoneNumber"] ??
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 10
            ),
            //Pharmacy Information
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
                            //Title/Edit Button
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                //Title Text
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: "Pharmacy Information",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22.0,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    // ElevatedButton(
                                    //   onPressed: () {},
                                    //   style: ButtonStyle(
                                    //       backgroundColor:
                                    //           MaterialStateProperty.all<Color>(
                                    //               Color(0xFFF0069C1))),
                                    //   child: RichText(
                                    //     textAlign: TextAlign.start,
                                    //     text: TextSpan(
                                    //       text: "Edit",
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.w400,
                                    //           fontSize: 18.0,
                                    //           color: Colors.white),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                            //Info
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.47,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      //PharmacyName
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Pharmacy Name",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: ref
                                                        .read(pharmacyMainProvider.notifier)
                                                        .userData?["pharmacyName"] ??
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
                                      //Address
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Pharmacy Address",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          ref
                                                                      .read(pharmacyMainProvider
                                                                          .notifier)
                                                                      .userData?["address"]
                                                                  ["streetAddress"] ??
                                                              "N/A"),
                                                  TextSpan(text: "\n"),
                                                  TextSpan(
                                                      text: ref
                                                          .read(pharmacyMainProvider.notifier)
                                                          .userData?["address"]["city"]),
                                                  TextSpan(text: " "),
                                                  TextSpan(
                                                      text: ref
                                                          .read(pharmacyMainProvider.notifier)
                                                          .userData?["address"]["country"]),
                                                  TextSpan(text: "\n"),
                                                  TextSpan(
                                                      text: ref
                                                              .read(pharmacyMainProvider.notifier)
                                                              .userData?["address"]["postalCode"] ??
                                                          "N/A"),
                                                ],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20.0,
                                                    color: Colors.grey[800]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //Pharmacy Phone Number
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Pharmacy Phone",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: ref
                                                        .read(pharmacyMainProvider.notifier)
                                                        .userData?["pharmacyPhoneNumber"] ??
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
                                      //Manager Number
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Manager Name",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: ref
                                                            .read(pharmacyMainProvider.notifier)
                                                            .userData?["managerFirstName"] +
                                                        " " +
                                                        ref
                                                            .read(pharmacyMainProvider.notifier)
                                                            .userData?["managerLastName"] ??
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
                                      //Manager license number
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Manager License Number",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: ref
                                                        .read(pharmacyMainProvider.notifier)
                                                        .userData?["managerLicenseNumber"] ??
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
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.42,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //Store Number
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 14, 0, 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Store Number",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: ref
                                                        .read(pharmacyMainProvider.notifier)
                                                        .userData?["storeNumber"] ??
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
                                      //Software
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: ref
                                                            .read(pharmacyMainProvider.notifier)
                                                            .userData?["softwareList"] !=
                                                        null
                                                    ? ref
                                                        .read(pharmacyMainProvider.notifier)
                                                        .userData!["softwareList"]
                                                        .toString()
                                                        .substring(
                                                            ref
                                                                    .read(pharmacyMainProvider
                                                                        .notifier)
                                                                    .userData?["softwareList"]
                                                                    .indexOf("[") +
                                                                1,
                                                            ref
                                                                .read(pharmacyMainProvider.notifier)
                                                                .userData?["softwareList"]
                                                                .lastIndexOf("]"))
                                                    : "N/A",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20.0,
                                                    color: Colors.grey[800]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //Pharmacy Fax Number
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Pharmacy Fax",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: ref
                                                        .read(pharmacyMainProvider.notifier)
                                                        .userData?["pharmacyFaxNumber"] ??
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
                                      //Manager Number
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: "Manager Phone",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: ref
                                                        .read(pharmacyMainProvider.notifier)
                                                        .userData?["managerPhoneNumber"] ??
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 20
            )
          

 */
