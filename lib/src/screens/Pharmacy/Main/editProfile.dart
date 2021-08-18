import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pharma_connect/src/Address%20Search/locationSearch.dart';
import 'package:pharma_connect/src/Address%20Search/placeService.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Sign%20Up/1pharmacy_signup.dart';
import 'package:pharma_connect/src/screens/login.dart';
import 'package:signature/signature.dart';
import 'package:uuid/uuid.dart';

import '../../../../all_used.dart';

class EditPharmacyProfile extends StatefulWidget {
  EditPharmacyProfile({Key? key}) : super(key: key);

  @override
  _EditPharmacyProfileState createState() => _EditPharmacyProfileState();
}

class _EditPharmacyProfileState extends State<EditPharmacyProfile> {
  final SignatureController _sigController = SignatureController(
    penStrokeWidth: 3, //you can set pen stroke with by changing this value
    penColor: Colors.black, // change your pen color
    exportBackgroundColor:
        Colors.white, //set the color you want to see in final result
  );
  Map<String, dynamic> uploadDataMap = Map();
  List<Software?> softwareList = [];

  final _items = software
      .map((software) => MultiSelectItem<Software>(software, software.name))
      .toList();

  void checkIfChanged(String? currentVal, String firestoreVal) {
    if (currentVal ==
        context.read(pharmacyMainProvider.notifier).userData?[firestoreVal]) {
      uploadDataMap.remove(firestoreVal);
    } else {
      uploadDataMap[firestoreVal] = currentVal;
    }
  }

  List<Software?> changeSoftwareToList(String? stringList) {
    int indexOfOpenBracket = stringList!.indexOf("[");
    int indexOfLastBracket = stringList.lastIndexOf("]");
    var noBracketString =
        stringList.substring(indexOfOpenBracket + 1, indexOfLastBracket);
    var list = noBracketString.split(", ");
    List<Software?> softwareListTemp = [];
    for (var i = 0; i < list.length; i++) {
      softwareListTemp.add(Software(id: 0, name: list[i]));
    }
    return softwareListTemp;
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        context.read(pharmacySignUpProvider.notifier).changeStreetAddress(
            context.read(pharmacyMainProvider.notifier).userData?["address"]
                ["streetAddress"]);
        context.read(pharmacySignUpProvider.notifier).changeCity(context
            .read(pharmacyMainProvider.notifier)
            .userData?["address"]["city"]);
        context.read(pharmacySignUpProvider.notifier).changePostalCode(context
            .read(pharmacyMainProvider.notifier)
            .userData?["address"]["postalCode"]);
        context.read(pharmacySignUpProvider.notifier).changeCountry(context
            .read(pharmacyMainProvider.notifier)
            .userData?["address"]["country"]);
        context.read(pharmacySignUpProvider.notifier).changeSoftwareList(
            changeSoftwareToList(context
                .read(pharmacyMainProvider.notifier)
                .userData?["softwareList"]));
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController city = TextEditingController(
        text: context.read(pharmacySignUpProvider.notifier).city);
    TextEditingController streetAddress = TextEditingController(
        text: context.read(pharmacySignUpProvider.notifier).streetAddress);
    TextEditingController postalCode = TextEditingController(
        text: context.read(pharmacySignUpProvider.notifier).postalCode);
    TextEditingController country = TextEditingController(
        text: context.read(pharmacySignUpProvider.notifier).country);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 12,
        title: Text(
          "Edit Profile",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
        ),
        backgroundColor: Color(0xFFF6F6F6),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Account Owner Information
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Center(
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    constraints: BoxConstraints(minHeight: 320),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Title
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: "Account Owner Information",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24.0,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0,
                          thickness: 2,
                          color: Color(0xFF5DB075),
                        ),
                        //First Name
                        Padding(
                          padding: const EdgeInsets.fromLTRB(11, 10, 0, 0),
                          child: formField(
                            fieldTitle: "First Name",
                            hintText: "Enter your First Name...",
                            keyboardStyle: TextInputType.name,
                            containerWidth: 345,
                            titleFont: 22,
                            onChanged: (String firstName) {
                              context
                                  .read(pharmacySignUpProvider.notifier)
                                  .changeFirstName(firstName);
                              checkIfChanged(firstName, "firstName");
                            },
                            validation: (value) {
                              if (!RegExp(
                                      r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                  .hasMatch(value)) {
                                return "Invalid field";
                              }
                              return null;
                            },
                            initialValue: context
                                .read(pharmacyMainProvider.notifier)
                                .userData?["firstName"],
                          ),
                        ),
                        SizedBox(height: 20),
                        //Last Name
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: formField(
                            fieldTitle: "Last Name",
                            hintText: "Enter your Last Name...",
                            keyboardStyle: TextInputType.name,
                            containerWidth: 345,
                            titleFont: 22,
                            onChanged: (String lastName) {
                              context
                                  .read(pharmacySignUpProvider.notifier)
                                  .changeLastName(lastName);
                              checkIfChanged(lastName, "lastName");
                            },
                            validation: (value) {
                              if (!RegExp(
                                      r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                  .hasMatch(value)) {
                                return "Invalid field";
                              }
                              return null;
                            },
                            initialValue: context
                                .read(pharmacyMainProvider.notifier)
                                .userData?["lastName"],
                          ),
                        ),
                        SizedBox(height: 20),
                        //Phone Number
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: formField(
                            fieldTitle: "Phone Number",
                            hintText: "Enter your Phone Number...",
                            keyboardStyle: TextInputType.number,
                            containerWidth: 345,
                            titleFont: 22,
                            onChanged: (String phoneNumber) {
                              context
                                  .read(pharmacySignUpProvider.notifier)
                                  .changePhoneNumber(phoneNumber);
                              checkIfChanged(phoneNumber, "phoneNumber");
                            },
                            validation: (value) {
                              if (value.length < 4) {
                                return "Phone is invalid";
                              }
                              return null;
                            },
                            initialValue: context
                                .read(pharmacyMainProvider.notifier)
                                .userData?["phoneNumber"],
                            formatter: [MaskedInputFormatter('(###) ###-####')],
                          ),
                        ),
                        SizedBox(height: 20),
                        //Email Address
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: formField(
                            fieldTitle: "Email",
                            hintText: "Enter your email address...",
                            keyboardStyle: TextInputType.name,
                            containerWidth: 345,
                            titleFont: 22,
                            onChanged: (String email) {
                              context
                                  .read(pharmacySignUpProvider.notifier)
                                  .changeEmail(email);
                              checkIfChanged(email, "email");
                            },
                            validation: (value) {
                              if (!EmailValidator.validate(value)) {
                                return "Incorrect Format";
                              }
                              return null;
                            },
                            initialValue: context
                                .read(pharmacyMainProvider.notifier)
                                .userData?["email"],
                          ),
                        ),
                        SizedBox(height: 20),
                        //Position
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                    text: "Position",
                                    style: GoogleFonts.questrial(
                                      fontSize: 22,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: 335,
                                constraints: BoxConstraints(
                                    maxHeight: 60, minHeight: 50),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0.3, 5),
                                        blurRadius: 3.0,
                                        spreadRadius: 0.5,
                                        color: Colors.grey.shade400)
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.shade200,
                                ),
                                child: DropdownButtonFormField<String>(
                                    hint: Text(
                                      "Select your Position...",
                                      style: GoogleFonts.inter(
                                          color: Color(0xFFBDBDBD),
                                          fontSize: 16),
                                    ),
                                    value: context
                                        .read(pharmacyMainProvider.notifier)
                                        .userData?["position"],
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFFF0F0F0),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Color(0xFFE8E8E8))),
                                    ),
                                    items: <String>[
                                      'Pharmacy',
                                      'Pharmacist',
                                      'Technician',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                          child: Text(value), value: value);
                                    }).toList(),
                                    onChanged: (String? value) {
                                      context
                                          .read(pharmacySignUpProvider.notifier)
                                          .changePosition(value);
                                      checkIfChanged(value, "position");
                                    },
                                    style: GoogleFonts.questrial(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        //Signature Overlay
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                                text: "E-Signature",
                                style: GoogleFonts.questrial(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: SignatureBox(sigController: _sigController),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Pharmacy Information
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Center(
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    constraints: BoxConstraints(minHeight: 320),
                    child: Consumer(
                      builder: (context, watch, child) {
                        watch(pharmacySignUpProvider);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //Title
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  text: "Pharmacy Information",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24.0,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            Divider(
                              height: 0,
                              thickness: 2,
                              color: Color(0xFF5DB075),
                            ),

                            //Pharmacy Name
                            Padding(
                              padding: const EdgeInsets.fromLTRB(11, 10, 0, 0),
                              child: formField(
                                fieldTitle: "Pharmacy Name",
                                hintText: "Enter the pharmacy name...",
                                keyboardStyle: TextInputType.name,
                                containerWidth: 345,
                                titleFont: 22,
                                onChanged: (String value) {
                                  context
                                      .read(pharmacySignUpProvider.notifier)
                                      .changePharmacyName(value);
                                  checkIfChanged(value, "pharmacyName");
                                },
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                initialValue: context
                                    .read(pharmacyMainProvider.notifier)
                                    .userData?["pharmacyName"],
                              ),
                            ),
                            SizedBox(height: 20),

                            //Street Address
                            Padding(
                              padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                        text: "Street Address",
                                        style: GoogleFonts.questrial(
                                          fontSize: 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 345,

                                    //height: 50,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0.3, 5),
                                            blurRadius: 3.0,
                                            spreadRadius: 0.5,
                                            color: Colors.grey.shade400)
                                      ],
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: streetAddress,
                                      onTap: () async {
                                        final sessionToken = Uuid().v4();
                                        final Suggestion? result =
                                            await showSearch<Suggestion?>(
                                          context: context,
                                          delegate: AddressSearch(sessionToken),
                                        );

                                        if (result != null) {
                                          final placeDetails =
                                              await PlaceApiProvider(
                                                      sessionToken)
                                                  .getPlaceDetailFromId(
                                                      result.placeId);
                                          context
                                              .read(pharmacySignUpProvider
                                                  .notifier)
                                              .changeStreetAddress(
                                                  placeDetails.streetNumber! +
                                                      " " +
                                                      placeDetails.street
                                                          .toString());
                                          context
                                              .read(pharmacySignUpProvider
                                                  .notifier)
                                              .changeCity(placeDetails.city);
                                          context
                                              .read(pharmacySignUpProvider
                                                  .notifier)
                                              .changePostalCode(
                                                  placeDetails.zipCode);
                                          context
                                              .read(pharmacySignUpProvider
                                                  .notifier)
                                              .changeCountry(
                                                  placeDetails.country);
                                          uploadDataMap["address"] = {
                                            "streetAddress": placeDetails
                                                    .streetNumber! +
                                                " " +
                                                placeDetails.street.toString(),
                                            "postalCode":
                                                placeDetails.zipCode.toString(),
                                            "country":
                                                placeDetails.country.toString(),
                                            "city": placeDetails.city.toString()
                                          };

                                          setState(() {
                                            streetAddress.text = placeDetails
                                                    .streetNumber! +
                                                " " +
                                                placeDetails.street.toString();
                                            postalCode.text =
                                                placeDetails.zipCode.toString();
                                            country.text =
                                                placeDetails.country.toString();
                                            city.text =
                                                placeDetails.city.toString();
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                            fontWeight: FontWeight.w500),
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 30),
                                        filled: true,
                                        fillColor: Color(0xFFF0F0F0),
                                        // focusedErrorBorder: OutlineInputBorder(
                                        //     borderRadius: BorderRadius.circular(8),
                                        //     borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                                        // errorBorder: OutlineInputBorder(
                                        //     borderRadius: BorderRadius.circular(8),
                                        //     borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Color(0xFFE8E8E8))),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFE8E8E8)),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        hintText: "Enter the street address...",
                                        hintStyle: GoogleFonts.inter(
                                            color: Color(0xFFBDBDBD),
                                            fontSize: 16),
                                      ),
                                      style: GoogleFonts.inter(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            //Store Number
                            Padding(
                              padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                              child: formField(
                                fieldTitle: "Store Number",
                                hintText: "Enter the Store Number...",
                                keyboardStyle: TextInputType.streetAddress,
                                containerWidth: 345,
                                titleFont: 22,
                                onChanged: (String storeNumber) {
                                  context
                                      .read(pharmacySignUpProvider.notifier)
                                      .changeStoreNumber(storeNumber);
                                  uploadDataMap["address"]["storeNumber"] =
                                      storeNumber;
                                },
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                initialValue: context
                                    .read(pharmacyMainProvider.notifier)
                                    .userData?["address"]["storeNumber"],
                              ),
                            ),
                            SizedBox(height: 20),

                            //City
                            Padding(
                              padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                              child: formField(
                                fieldTitle: "City",
                                hintText: "Enter the city...",
                                keyboardStyle: TextInputType.streetAddress,
                                containerWidth: 345,
                                titleFont: 22,
                                onChanged: (String city) {
                                  context
                                      .read(pharmacySignUpProvider.notifier)
                                      .changeCity(city);
                                  uploadDataMap["address"]["city"] = city;
                                },
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                controller: city,
                              ),
                            ),
                            SizedBox(height: 20),

                            //Postal Code
                            Padding(
                              padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                              child: formField(
                                fieldTitle: "Postal Code",
                                hintText: "Enter the postal code...",
                                keyboardStyle: TextInputType.streetAddress,
                                containerWidth: 345,
                                titleFont: 22,
                                onChanged: (String postalCode) {
                                  context
                                      .read(pharmacySignUpProvider.notifier)
                                      .changePostalCode(postalCode);
                                  uploadDataMap["address"]["postalCode"] =
                                      postalCode;
                                },
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                controller: postalCode,
                              ),
                            ),
                            SizedBox(height: 20),

                            //Country
                            Padding(
                              padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                              child: formField(
                                fieldTitle: "Country",
                                hintText: "Enter the country...",
                                keyboardStyle: TextInputType.streetAddress,
                                containerWidth: 345,
                                titleFont: 22,
                                onChanged: (String country) {
                                  context
                                      .read(pharmacySignUpProvider.notifier)
                                      .changeCountry(country);

                                  uploadDataMap["address"]["country"] = country;
                                },
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                controller: country,
                              ),
                            ),
                            SizedBox(height: 20),

                            //Phone Number
                            Padding(
                              padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                              child: formField(
                                fieldTitle: "Pharmacy Phone Number",
                                hintText: "Enter the pharmacy phone Number...",
                                keyboardStyle: TextInputType.number,
                                containerWidth: 345,
                                titleFont: 22,
                                onChanged: (String phoneNumber) {
                                  context
                                      .read(pharmacySignUpProvider.notifier)
                                      .changePhoneNumberPharmacy(phoneNumber);

                                  checkIfChanged(
                                      phoneNumber, "pharmacyPhoneNumber");
                                },
                                validation: (value) {
                                  if (value.length < 4) {
                                    return "Phone Number is invalid";
                                  }
                                  return null;
                                },
                                initialValue: context
                                    .read(pharmacyMainProvider.notifier)
                                    .userData?["pharmacyPhoneNumber"],
                                formatter: [
                                  MaskedInputFormatter('(###) ###-####')
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            //Fax Number
                            Padding(
                              padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                              child: formField(
                                fieldTitle: "Pharmacy Fax Number",
                                hintText: "Enter the pharmacy fax Number...",
                                keyboardStyle: TextInputType.number,
                                containerWidth: 345,
                                titleFont: 22,
                                onChanged: (String faxNumber) {
                                  context
                                      .read(pharmacySignUpProvider.notifier)
                                      .changeFaxNumber(faxNumber);
                                  uploadDataMap["pharmacyFaxNumber"] =
                                      faxNumber;
                                  checkIfChanged(
                                      faxNumber, "pharmacyFaxNumber");
                                },
                                validation: (value) {
                                  if (value.length < 4) {
                                    return "Phone Number is invalid";
                                  }
                                  return null;
                                },
                                initialValue: context
                                    .read(pharmacyMainProvider.notifier)
                                    .userData?["pharmacyFaxNumber"],
                                formatter: [
                                  MaskedInputFormatter('(###) ###-####')
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            //Accreditation Province
                            Padding(
                              padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                              child: formField(
                                fieldTitle: "Accreditation Province",
                                hintText: "Enter the accreditation province...",
                                keyboardStyle: TextInputType.streetAddress,
                                containerWidth: 345,
                                titleFont: 22,
                                onChanged: (String accreditationProvince) {
                                  context
                                      .read(pharmacySignUpProvider.notifier)
                                      .changeAccreditationProvince(
                                          accreditationProvince);

                                  checkIfChanged(accreditationProvince,
                                      "accreditationProvice");
                                },
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                initialValue: context
                                    .read(pharmacyMainProvider.notifier)
                                    .userData?["accreditationProvice"],
                              ),
                            ),
                            SizedBox(height: 20),

                            //Pharmacy Software
                            Padding(
                              padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                        text: "Pharmacy Software",
                                        style: GoogleFonts.questrial(
                                          fontSize: 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 345,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0.3, 3),
                                            blurRadius: 3.0,
                                            spreadRadius: 0.5,
                                            color: Colors.grey.shade400)
                                      ],
                                      color: Color(0xFFF0F0F0),
                                      border: Border.all(
                                        color: Color(0xFFE8E8E8),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        MultiSelectBottomSheetField<Software?>(
                                          selectedColor: Color(0xFF5DB075),
                                          selectedItemsTextStyle:
                                              TextStyle(color: Colors.white),
                                          initialChildSize: 0.4,
                                          decoration: BoxDecoration(),
                                          listType: MultiSelectListType.CHIP,
                                          initialValue: context
                                              .read(pharmacySignUpProvider
                                                  .notifier)
                                              .softwareList,
                                          searchable: true,
                                          items: _items,
                                          buttonText: Text(
                                              "Select Pharmacy Software...",
                                              style: GoogleFonts.inter(
                                                  color: Color(0xFFBDBDBD),
                                                  fontSize: 16)),
                                          onConfirm: (values) {
                                            context
                                                .read(pharmacySignUpProvider
                                                    .notifier)
                                                .changeSoftwareList(values);
                                            print(context
                                                .read(pharmacySignUpProvider
                                                    .notifier)
                                                .softwareList);
                                            uploadDataMap["softwareList"] =
                                                values.toString();
                                            checkIfChanged(values.toString(),
                                                "softwareList");
                                          },
                                          chipDisplay: MultiSelectChipDisplay(
                                            items: context
                                                .read(pharmacySignUpProvider
                                                    .notifier)
                                                .softwareList
                                                ?.map((e) => MultiSelectItem(
                                                    e, e.toString()))
                                                .toList(),
                                            chipColor: Color(0xFF5DB075),
                                            onTap: (value) {
                                              context
                                                  .read(pharmacySignUpProvider
                                                      .notifier)
                                                  .softwareList
                                                  ?.remove(value);

                                              return context
                                                  .read(pharmacySignUpProvider
                                                      .notifier)
                                                  .softwareList;
                                            },
                                            textStyle:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20),
                            //Next Button
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
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
                          else if (states.contains(MaterialState.disabled))
                            return Colors.grey;
                          return Color(
                              0xFF5DB075); // Use the component's default.
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ))),
                  onPressed: () async {
                    print(uploadDataMap);
                    String? result = await context
                        .read(authProvider.notifier)
                        .updatePharmacyUserInformation(
                            context.read(userProviderLogin.notifier).userUID,
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
                                    style: TextStyle(color: Color(0xFF5DB075)),
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
                  },
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

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class SignatureBox extends StatefulWidget {
  const SignatureBox({
    Key? key,
    required SignatureController sigController,
  })  : _sigController = sigController,
        super(key: key);

  final SignatureController _sigController;

  @override
  _SignatureBoxState createState() => _SignatureBoxState();
}

class _SignatureBoxState extends State<SignatureBox> {
  bool signatureSaved = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 40,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFF5DB075)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
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
                        color: Color(0xFF5DB075),
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF5DB075)),
                            ),
                            onPressed: () async {
                              if (widget._sigController.isNotEmpty) {
                                context
                                    .read(pharmacySignUpProvider.notifier)
                                    .changeSignature(await widget._sigController
                                        .toPngBytes());
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
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
