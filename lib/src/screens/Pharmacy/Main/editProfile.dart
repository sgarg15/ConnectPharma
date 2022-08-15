import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:connectpharma/Custom%20Widgets/custom_multiSelect_field.dart';
import 'package:connectpharma/Custom%20Widgets/custom_multi_select_display.dart';
import 'package:connectpharma/src/Address%20Search/locationSearch.dart';
import 'package:connectpharma/src/Address%20Search/placeService.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';
import 'package:connectpharma/src/screens/Pharmacy/Sign%20Up/1pharmacy_signup.dart';
import 'package:connectpharma/src/screens/login.dart';
import 'package:signature/signature.dart';
import 'package:uuid/uuid.dart';

import '../../../../all_used.dart';

class EditPharmacyProfile extends ConsumerStatefulWidget {
  EditPharmacyProfile({Key? key}) : super(key: key);

  @override
  _EditPharmacyProfileState createState() => _EditPharmacyProfileState();
}

class _EditPharmacyProfileState extends ConsumerState<EditPharmacyProfile> {
  final SignatureController _sigController = SignatureController(
    penStrokeWidth: 3, //you can set pen stroke with by changing this value
    penColor: Colors.black, // change your pen color
    exportBackgroundColor: Colors.white, //set the color you want to see in final result
  );
  Map<String, dynamic> uploadDataMap = Map();
  List<Software?>? softwareList;
  List<Software?>? softwareListToUpload = [];

  final _items =
      software.map((software) => MultiSelectItem<Software>(software, software.name)).toList();

  void checkIfChanged(WidgetRef ref, String? currentVal, String firestoreVal) {
    if (currentVal == ref.read(pharmacyMainProvider.notifier).userData?[firestoreVal]) {
      uploadDataMap.remove(firestoreVal);
    } else {
      uploadDataMap[firestoreVal] = currentVal;
    }
  }

  TextEditingController city = TextEditingController();
  TextEditingController streetAddress = TextEditingController();
  TextEditingController postalCode = TextEditingController();
  TextEditingController country = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<dynamic> dynamicSoftwareList =
          ref.read(pharmacyMainProvider.notifier).userData?["softwareList"];

      List<Software?> softwareList =
          dynamicSoftwareList.map((e) => Software(id: 1, name: e)).toList();

      log(softwareList.runtimeType.toString(), name: "softwareList Runtime Type");
      log("SoftwareListToUpload: $softwareListToUpload", name: "SoftwareListToUpload");

      // ref.read(pharmacySignUpProvider.notifier).changeSoftwareList(softwareList);

      setState(() {
        ref.read(pharmacySignUpProvider.notifier).changeStreetAddress(
            ref.read(pharmacyMainProvider.notifier).userData?["address"]["streetAddress"]);
        ref
            .read(pharmacySignUpProvider.notifier)
            .changeCity(ref.read(pharmacyMainProvider.notifier).userData?["address"]["city"]);
        ref.read(pharmacySignUpProvider.notifier).changePostalCode(
            ref.read(pharmacyMainProvider.notifier).userData?["address"]["postalCode"]);
        ref
            .read(pharmacySignUpProvider.notifier)
            .changeCountry(ref.read(pharmacyMainProvider.notifier).userData?["address"]["country"]);
      });
    });
    city.text = ref.read(pharmacyMainProvider.notifier).userData?["address"]["city"];
    streetAddress.text =
        ref.read(pharmacyMainProvider.notifier).userData?["address"]["streetAddress"];
    postalCode.text = ref.read(pharmacyMainProvider.notifier).userData?["address"]["postalCode"];
    country.text = ref.read(pharmacyMainProvider.notifier).userData?["address"]["country"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? userData = ref.read(pharmacyMainProvider.notifier).userData;
    List<dynamic>? softwareList = ref.read(pharmacyMainProvider.notifier).userData?["softwareList"];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: new Text(
          "Edit Profile",
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
      body: Consumer(
        builder: (context, ref, child) {
          ref.watch(pharmacySignUpProvider);
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Photo/Name
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        minRadius: 10,
                        maxRadius: 55,
                        child: CircleAvatar(
                            minRadius: 5,
                            maxRadius: 52,
                            child: Text(getInitials(userData?["firstName"], userData?["lastName"]),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold))),
                      ),
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
                          //First Name
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "First Name",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  textCapitalization: TextCapitalization.words,
                                  onChanged: (String firstName) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changeFirstName(firstName);
                                    checkIfChanged(ref, firstName, "firstName");
                                  },
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                  ),
                                  validator: (value) {
                                    if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                        .hasMatch(value ?? "")) {
                                      return "Invalid field";
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  initialValue: ref
                                      .read(pharmacyMainProvider.notifier)
                                      .userData?["firstName"],
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your first name",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFC6C6C6),
                                      fontFamily:
                                          GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                              .fontFamily,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Last Name
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "Last Name",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  textCapitalization: TextCapitalization.words,
                                  onChanged: (String lastName) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changeLastName(lastName);
                                    checkIfChanged(ref, lastName, "lastName");
                                  },
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                  ),
                                  validator: (value) {
                                    if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                        .hasMatch(value ?? "")) {
                                      return "Invalid field";
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  initialValue:
                                      ref.read(pharmacyMainProvider.notifier).userData?["lastName"],
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your last name",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFC6C6C6),
                                      fontFamily:
                                          GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                              .fontFamily,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Phone Number
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "Phone Number",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  onChanged: (String phoneNumber) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changePhoneNumber(phoneNumber);
                                    checkIfChanged(ref, phoneNumber, "phoneNumber");
                                  },
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                  ),
                                  validator: (value) {
                                    if (!RegExp(r"^[0-9]{10}$").hasMatch(value ?? "")) {
                                      return "Invalid field";
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  initialValue: ref
                                      .read(pharmacyMainProvider.notifier)
                                      .userData?["phoneNumber"],
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your phone number",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFC6C6C6),
                                      fontFamily:
                                          GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                              .fontFamily,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Position
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "Position",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                DropdownButtonFormField<String>(
                                  hint: Text(
                                    "Select your Position...",
                                    style:
                                        GoogleFonts.inter(color: Color(0xFFBDBDBD), fontSize: 16),
                                  ),
                                  value:
                                      ref.read(pharmacyMainProvider.notifier).userData?["position"],
                                  items: <String>[
                                    'Pharmacy',
                                    'Pharmacist',
                                    'Technician',
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                        child: Text(value), value: value);
                                  }).toList(),
                                  onChanged: (String? value) {
                                    ref.read(pharmacySignUpProvider.notifier).changePosition(value);
                                    checkIfChanged(ref, value, "position");
                                  },
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Divider(
                            color: Color(0xFFE5E5E5),
                            thickness: 1,
                          ),
                          //Pharmacy Info
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
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "Pharmacy Name",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                TextFormField(
                                  onChanged: (String pharmacyName) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changePharmacyName(pharmacyName);
                                    checkIfChanged(ref, pharmacyName, "pharmacyName");
                                  },
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                  ),
                                  validator: (value) {
                                    if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                        .hasMatch(value ?? "")) {
                                      return "Invalid field";
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  initialValue: ref
                                      .read(pharmacyMainProvider.notifier)
                                      .userData?["pharmacyName"],
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your pharmacy name",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFC6C6C6),
                                      fontFamily:
                                          GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                              .fontFamily,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Street Address
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "Street Address",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                TextFormField(
                                  readOnly: true,
                                  controller: streetAddress,
                                  onTap: () async {
                                    final sessionToken = Uuid().v4();
                                    final Suggestion? result = await showSearch<Suggestion?>(
                                      context: context,
                                      delegate: AddressSearch(sessionToken),
                                    );

                                    if (result != null) {
                                      final placeDetails = await PlaceApiProvider(sessionToken)
                                          .getPlaceDetailFromId(result.placeId);
                                      ref.read(pharmacySignUpProvider.notifier).changeStreetAddress(
                                          placeDetails.streetNumber! +
                                              " " +
                                              placeDetails.street.toString());
                                      ref
                                          .read(pharmacySignUpProvider.notifier)
                                          .changeCity(placeDetails.city);
                                      ref
                                          .read(pharmacySignUpProvider.notifier)
                                          .changePostalCode(placeDetails.zipCode);
                                      ref
                                          .read(pharmacySignUpProvider.notifier)
                                          .changeCountry(placeDetails.country);

                                      setState(() {
                                        uploadDataMap["address"] = {
                                          "streetAddress": placeDetails.streetNumber! +
                                              " " +
                                              placeDetails.street.toString(),
                                          "postalCode": placeDetails.zipCode ?? "",
                                          "country": placeDetails.country ?? "",
                                          "city": placeDetails.city ?? ""
                                        };
                                      });
                                      log("Upload Data Map: $uploadDataMap",
                                          name: "Upload Data Map");

                                      setState(() {
                                        log("Updating street address");
                                        streetAddress.text = placeDetails.streetNumber! +
                                            " " +
                                            placeDetails.street.toString();
                                        postalCode.text = placeDetails.zipCode ?? " ";
                                        log("Postal Code: ${postalCode.text}");

                                        country.text = placeDetails.country ?? " ";
                                        city.text = placeDetails.city ?? " ";
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    errorStyle: TextStyle(fontWeight: FontWeight.w500),
                                    hintText: "Enter the street address...",
                                    hintStyle: GoogleFonts.montserrat(
                                        color: Color(0xFF505050), fontSize: 15),
                                  ),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //City
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "City",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                TextFormField(
                                  onChanged: (String city) {
                                    ref.read(pharmacySignUpProvider.notifier).changeCity(city);
                                    uploadDataMap["address"].addAll({"city": city});
                                  },
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                  ),
                                  validator: (value) {
                                    if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                        .hasMatch(value ?? "")) {
                                      return "Invalid field";
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: city,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your city",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFC6C6C6),
                                      fontFamily:
                                          GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                              .fontFamily,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Postal Code
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "Postal Code",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                TextFormField(
                                  onChanged: (String postalCode) {
                                    log("Postal Code: $postalCode");
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changePostalCode(postalCode);

                                    uploadDataMap["address"].addAll({"postalCode": postalCode});
                                    log("Upload Data Map: $uploadDataMap", name: "Upload Data Map");
                                  },
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: postalCode,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your postal code",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFC6C6C6),
                                      fontFamily:
                                          GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                              .fontFamily,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Country
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "Country",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                TextFormField(
                                  onChanged: (String country) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changeCountry(country);
                                    uploadDataMap["address"].addAll({"country": country});
                                  },
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                  ),
                                  validator: (value) {
                                    if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                        .hasMatch(value ?? "")) {
                                      return "Invalid field";
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: country,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your country",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFC6C6C6),
                                      fontFamily:
                                          GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                              .fontFamily,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Pharmacy Phone Number
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "Pharmacy Phone Number",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                TextFormField(
                                  onChanged: (String phoneNumber) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changePhoneNumberPharmacy(phoneNumber);

                                    checkIfChanged(ref, phoneNumber, "pharmacyPhoneNumber");
                                  },
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                  ),
                                  validator: (value) {
                                    if (!RegExp(r"^[0-9]{10}$").hasMatch(value ?? "")) {
                                      return "Invalid field";
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  initialValue: ref
                                      .read(pharmacyMainProvider.notifier)
                                      .userData?["pharmacyPhoneNumber"],
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your pharmacy phone number",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFC6C6C6),
                                      fontFamily:
                                          GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                              .fontFamily,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Pharmacy Fax Number
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "Pharmacy Fax Number",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                TextFormField(
                                  onChanged: (String faxNumber) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changeFaxNumber(faxNumber);

                                    uploadDataMap["pharmacyFaxNumber"] = faxNumber;
                                    checkIfChanged(ref, faxNumber, "pharmacyFaxNumber");
                                  },
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                  ),
                                  validator: (value) {
                                    if (!RegExp(r"^[0-9]{10}$").hasMatch(value ?? "")) {
                                      return "Invalid field";
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  initialValue: ref
                                      .read(pharmacyMainProvider.notifier)
                                      .userData?["pharmacyFaxNumber"],
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your pharmacy fax number",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFC6C6C6),
                                      fontFamily:
                                          GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                              .fontFamily,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Accreditation Province
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "Accreditation Province",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                TextFormField(
                                  onChanged: (String accreditationProvince) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changeAccreditationProvince(accreditationProvince);

                                    checkIfChanged(
                                        ref, accreditationProvince, "accreditationProvice");
                                  },
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                  ),
                                  validator: (value) {
                                    if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                        .hasMatch(value ?? "")) {
                                      return "Invalid field";
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  initialValue: ref
                                      .read(pharmacyMainProvider.notifier)
                                      .userData?["accreditationProvice"],
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your accreditation province",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFC6C6C6),
                                      fontFamily:
                                          GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                              .fontFamily,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Manager Name
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "Manager First Name",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                TextFormField(
                                  onChanged: (String managerFirstName) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changeManagerFirstName(managerFirstName);

                                    uploadDataMap["managerFirstName"] = managerFirstName;
                                    checkIfChanged(ref, managerFirstName, "managerFirstName");
                                  },
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                  ),
                                  validator: (value) {
                                    if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                        .hasMatch(value ?? "")) {
                                      return "Invalid field";
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  initialValue: ref
                                      .read(pharmacyMainProvider.notifier)
                                      .userData?["managerFirstName"],
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your manager's first name",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFC6C6C6),
                                      fontFamily:
                                          GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                              .fontFamily,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Manager Last Name
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "Manager Last Name",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                TextFormField(
                                  onChanged: (String managerLastName) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changeMangagerLastName(managerLastName);

                                    uploadDataMap["managerLastName"] = managerLastName;
                                    checkIfChanged(ref, managerLastName, "managerLastName");
                                  },
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                  ),
                                  validator: (value) {
                                    if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                        .hasMatch(value ?? "")) {
                                      return "Invalid field";
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  initialValue: ref
                                      .read(pharmacyMainProvider.notifier)
                                      .userData?["managerLastName"],
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your manager's last name",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFC6C6C6),
                                      fontFamily:
                                          GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                              .fontFamily,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Manager License Number
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "Manager License Number",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                TextFormField(
                                  onChanged: (String managerLicenseNumber) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changeLicenseNumber(managerLicenseNumber);

                                    uploadDataMap["managerLicenseNumber"] = managerLicenseNumber;
                                    checkIfChanged(
                                        ref, managerLicenseNumber, "managerLicenseNumber");
                                  },
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                  ),
                                  validator: (value) {
                                    if (!RegExp(r"^[^_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                        .hasMatch(value ?? "")) {
                                      return "Invalid field";
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  initialValue: ref
                                      .read(pharmacyMainProvider.notifier)
                                      .userData?["managerLicenseNumber"],
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your manager's license number",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFC6C6C6),
                                      fontFamily:
                                          GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                              .fontFamily,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Manager Phone Number
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "Manager Phone Number",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                TextFormField(
                                  onChanged: (String managerPhoneNumber) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changeManagerPhoneNumber(managerPhoneNumber);

                                    uploadDataMap["managerPhoneNumber"] = managerPhoneNumber;
                                    checkIfChanged(ref, managerPhoneNumber, "managerPhoneNumber");
                                  },
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Color(0xFF505050),
                                  ),
                                  validator: (value) {
                                    if (value!.length < 4) {
                                      return "Phone Number is invalid";
                                    }
                                    return null;
                                  },
                                  inputFormatters: [PhoneInputFormatter()],
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  initialValue: ref
                                      .read(pharmacyMainProvider.notifier)
                                      .userData?["managerPhoneNumber"],
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your manager's phone number",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFC6C6C6),
                                      fontFamily:
                                          GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                              .fontFamily,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Software
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "Software",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.5,
                                          color: Color(0xFF505050),
                                          fontWeight: FontWeight.w500,
                                        ))),
                                Column(
                                  children: <Widget>[
                                    CustomMultiSelectBottomSheetField<Software?>(
                                      selectedColor: Color(0xFF0069C1),
                                      selectedItemsTextStyle: TextStyle(color: Colors.white),
                                      initialChildSize: 0.4,
                                      decoration: BoxDecoration(),
                                      listType: MultiSelectListType.CHIP,
                                      initialValue: softwareList
                                          ?.map((e) => new Software(id: 1, name: e))
                                          .toList(),
                                      searchable: true,
                                      items: _items,
                                      buttonText: Text("Select Pharmacy Software...",
                                          style: GoogleFonts.inter(
                                              color: Color(0xFFBDBDBD), fontSize: 16)),
                                      onConfirm: (values) {
                                        softwareListToUpload?.addAll(values);
                                        ref
                                            .read(pharmacySignUpProvider.notifier)
                                            .changeSoftwareList(values);
                                      },
                                      chipDisplay: CustomMultiSelectChipDisplay(
                                        items: ref
                                            .read(pharmacySignUpProvider.notifier)
                                            .softwareList
                                            ?.map((e) => MultiSelectItem(e, e.toString()))
                                            .toList(),
                                        chipColor: Color(0xFFF0069C1),
                                        onTap: (value) {
                                          softwareListToUpload?.remove(value);
                                          softwareListToUpload?.removeWhere((element) =>
                                              element?.name.toString() == value.toString());
                                          ref
                                              .read(pharmacySignUpProvider.notifier)
                                              .softwareList
                                              ?.cast()
                                              .remove(value);
                                          ref
                                              .read(pharmacySignUpProvider.notifier)
                                              .softwareList
                                              ?.removeWhere((element) =>
                                                  element?.name.toString() == value.toString());

                                          return ref
                                              .read(pharmacySignUpProvider.notifier)
                                              .softwareList;
                                        },
                                        textStyle: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Divider(
                                      color: Color(0xFFC6C6C6),
                                      thickness: 1,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Save
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              height: 51,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.pressed)) {
                                          return Color(0xFFF0069C1);
                                        } else if (states.contains(MaterialState.disabled)) {
                                          return Colors.grey;
                                        }
                                        return Color(0xFFF0069C1); // Use the component's default.
                                      },
                                    ),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                                onPressed: (uploadDataMap.isNotEmpty ||
                                        softwareListToUpload!.isNotEmpty)
                                    ? () async {
                                        print(uploadDataMap);
                                        if (ref
                                                .read(pharmacySignUpProvider.notifier)
                                                .softwareList !=
                                            null) {
                                          uploadDataMap["softwareList"] = ref
                                              .read(pharmacySignUpProvider.notifier)
                                              .softwareList
                                              ?.map((e) => e?.name)
                                              .toList();
                                        }
                                        log("Upload Data Map: $uploadDataMap");
                                        String? result = await ref
                                            .read(authProvider.notifier)
                                            .updatePharmacyUserInformation(
                                                ref.read(userProviderLogin.notifier).userUID,
                                                uploadDataMap);

                                        if (result == "Profile Upload Failed") {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Important!"),
                                                  content: Text(
                                                      "There was an error trying to update your profile. Please try again."),
                                                  actions: [
                                                    TextButton(
                                                      child: Text(
                                                        "Ok",
                                                        style: TextStyle(color: Color(0xFFF0069C1)),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => JobHistoryPharmacy()));
                                        }
                                      }
                                    : null,
                                child: RichText(
                                  text: TextSpan(
                                    text: "Save",
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
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SignatureBox extends ConsumerStatefulWidget {
  const SignatureBox({
    Key? key,
    required SignatureController sigController,
  })  : _sigController = sigController,
        super(key: key);

  final SignatureController _sigController;

  @override
  _SignatureBoxState createState() => _SignatureBoxState();
}

class _SignatureBoxState extends ConsumerState<SignatureBox> {
  bool signatureSaved = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 40,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF0069C1)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ))),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Signature Pad
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 140,
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: Color(0xFFF0069C1),
                      ),
                    ),
                    child: Signature(
                      controller: widget._sigController,
                      height: 140,
                      width: MediaQuery.of(context).size.width - 20,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                //Buttons
                Material(
                  child: Container(
                    color: Colors.grey.shade200,
                    height: 40,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Row(
                      //mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 31,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 5),
                          child: TextButton.icon(
                            clipBehavior: Clip.none,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF0069C1)),
                            ),
                            onPressed: () async {
                              if (widget._sigController.isNotEmpty) {
                                ref
                                    .read(pharmacySignUpProvider.notifier)
                                    .changeSignature(await widget._sigController.toPngBytes());
                                setState(() {
                                  signatureSaved = true;
                                });
                              }

                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 13,
                            ),
                            label: Text(
                              "Apply",
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: 100,
                          height: 35,
                          child: TextButton(
                            onPressed: () {
                              widget._sigController.clear();
                              setState(() {
                                signatureSaved = false;
                              });
                            },
                            child: Text(
                              "Reset",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: !signatureSaved ? Text("Add") : Text("Change"),
      ),
    );
  }
}
