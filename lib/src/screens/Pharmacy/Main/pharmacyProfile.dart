import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/all_used.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/editProfile.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';

class PharmacyProfile extends ConsumerWidget {
  const PharmacyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 12,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
        ),
        backgroundColor: Color(0xFFF6F6F6),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
              height: 10,
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
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
