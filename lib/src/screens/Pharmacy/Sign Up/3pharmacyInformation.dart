import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pharma_connect/all_used.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/src/Address%20Search/locationSearch.dart';
import 'package:pharma_connect/src/Address%20Search/placeService.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Sign Up/4pharmacyManagerInformation.dart';
import 'package:uuid/uuid.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Sign Up/1pharmacy_signup.dart';

class Software {
  final int id;
  final String name;

  Software({
    required this.id,
    required this.name,
  });
}

class PharmacyInformation extends StatefulWidget {
  PharmacyInformation({Key? key}) : super(key: key);

  @override
  _PharmacyInformationState createState() => _PharmacyInformationState();
}

class _PharmacyInformationState extends State<PharmacyInformation> {
  static List<Software> _software = [
    Software(id: 1, name: "A and H"),
    Software(id: 1, name: "Applied Robotics"),
    Software(id: 1, name: "Applied Technology"),
    Software(id: 1, name: "Auto-Ned"),
    Software(id: 1, name: "Centricity"),
    Software(id: 1, name: "Cerner/Pharmnet"),
    Software(id: 1, name: "Connexus"),
    Software(id: 1, name: "Delta"),
    Software(id: 1, name: "Epic"),
    Software(id: 1, name: "Kroll"),
  ];

  final _items = _software
      .map((software) => MultiSelectItem<Software>(software, software.name))
      .toList();

  @override
  void initState() {
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
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: new Text(
          "Pharmacy Information",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFF6F6F6),
        foregroundColor: Colors.black,
        elevation: 12,
        bottomOpacity: 1,
        shadowColor: Colors.black,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //Information Text
            Align(
              alignment: Alignment(0, -0.96),
              child: Padding(
                padding: EdgeInsets.fromLTRB(11, 10, 0, 0),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text:
                        "Please provide us with information about the pharmacy.",
                    style: GoogleFonts.questrial(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            //Pharmacy Name
            formField(
              fieldTitle: "Pharmacy Name",
              hintText: "Enter the Pharmacy name...",
              keyboardStyle: TextInputType.name,
              onChanged: (String pharmacyName) {
                context
                    .read(pharmacySignUpProvider.notifier)
                    .changePharmacyName(pharmacyName);
              },
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
              initialValue:
                  context.read(pharmacySignUpProvider.notifier).pharmacyName,
            ),
            SizedBox(height: 20),

            //Street Address
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                      text: "Street Address",
                      style: GoogleFonts.questrial(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                SizedBox(height: 10),
                Container(
                  width: 335,
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
                      final Suggestion? result = await showSearch<Suggestion?>(
                        context: context,
                        delegate: AddressSearch(sessionToken),
                      );

                      if (result != null) {
                        final placeDetails =
                            await PlaceApiProvider(sessionToken)
                                .getPlaceDetailFromId(result.placeId);
                        context
                            .read(pharmacySignUpProvider.notifier)
                            .changeStreetAddress(placeDetails.streetNumber! +
                                " " +
                                placeDetails.street.toString());
                        context
                            .read(pharmacySignUpProvider.notifier)
                            .changeCity(placeDetails.city);
                        context
                            .read(pharmacySignUpProvider.notifier)
                            .changePostalCode(placeDetails.zipCode);
                        context
                            .read(pharmacySignUpProvider.notifier)
                            .changeCountry(placeDetails.country);
                        streetAddress.text = placeDetails.streetNumber! +
                            " " +
                            placeDetails.street.toString();
                        postalCode.text = placeDetails.zipCode.toString();
                        country.text = placeDetails.country.toString();
                        city.text = placeDetails.city.toString();
                      }
                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontWeight: FontWeight.w500),
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 30),
                      filled: true,
                      fillColor: Color(0xFFF0F0F0),
                      // focusedErrorBorder: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(8),
                      //     borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                      // errorBorder: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(8),
                      //     borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE8E8E8)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      hintText: "Enter the street address...",
                      hintStyle: GoogleFonts.inter(
                          color: Color(0xFFBDBDBD), fontSize: 16),
                    ),
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            //Store Number
            formField(
              fieldTitle: "Store Number",
              hintText: "Enter the Store Number...",
              keyboardStyle: TextInputType.streetAddress,
              onChanged: (String storeNumber) {
                context
                    .read(pharmacySignUpProvider.notifier)
                    .changeStoreNumber(storeNumber);
              },
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
              initialValue:
                  context.read(pharmacySignUpProvider.notifier).storeNumber,
            ),
            SizedBox(height: 20),

            //City
            formField(
              fieldTitle: "City",
              hintText: "Enter the city...",
              keyboardStyle: TextInputType.streetAddress,
              onChanged: (String city) {
                context.read(pharmacySignUpProvider.notifier).changeCity(city);
              },
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
              //initialValue: pharmacySignUp.city,
              controller: city,
            ),
            SizedBox(height: 20),

            //Postal Code
            formField(
              fieldTitle: "Postal Code",
              hintText: "Enter the postal code...",
              keyboardStyle: TextInputType.streetAddress,
              onChanged: (String postalCode) {
                context
                    .read(pharmacySignUpProvider.notifier)
                    .changePostalCode(postalCode);
              },
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
              controller: postalCode,
            ),
            SizedBox(height: 20),

            //Country
            formField(
              fieldTitle: "Country",
              hintText: "Enter the country...",
              keyboardStyle: TextInputType.streetAddress,
              onChanged: (String country) {
                context
                    .read(pharmacySignUpProvider.notifier)
                    .changeCountry(country);
              },
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
              controller: country,
            ),
            SizedBox(height: 20),

            //Phone Number
            formField(
              fieldTitle: "Pharmacy Phone Number",
              hintText: "Enter the pharmacy phone Number...",
              keyboardStyle: TextInputType.number,
              onChanged: (String phoneNumber) {
                context
                    .read(pharmacySignUpProvider.notifier)
                    .changePhoneNumberPharmacy(phoneNumber);
              },
              validation: (value) {
                if (value.length < 4) {
                  return "Phone Number is invalid";
                }
                return null;
              },
              initialValue: context
                  .read(pharmacySignUpProvider.notifier)
                  .phoneNumberPharmacy,
              formatter: [MaskedInputFormatter('(###) ###-####')],
            ),
            SizedBox(height: 20),

            //Fax Number
            formField(
              fieldTitle: "Pharmacy Fax Number",
              hintText: "Enter the pharmacy fax Number...",
              keyboardStyle: TextInputType.number,
              onChanged: (String faxNumber) {
                context
                    .read(pharmacySignUpProvider.notifier)
                    .changeFaxNumber(faxNumber);
              },
              validation: (value) {
                if (value.length < 4) {
                  return "Phone Number is invalid";
                }
                return null;
              },
              initialValue:
                  context.read(pharmacySignUpProvider.notifier).faxNumber,
              formatter: [MaskedInputFormatter('(###) ###-####')],
            ),
            SizedBox(height: 20),

            //Accreditation Province
            formField(
              fieldTitle: "Accreditation Province",
              hintText: "Enter the accreditation province...",
              keyboardStyle: TextInputType.streetAddress,
              onChanged: (String accreditationProvince) {
                context
                    .read(pharmacySignUpProvider.notifier)
                    .changeAccreditationProvince(accreditationProvince);
              },
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
              initialValue: context
                  .read(pharmacySignUpProvider.notifier)
                  .accreditationProvince,
            ),
            SizedBox(height: 20),

            //Pharmacy Software
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                      text: "Pharmacy Software",
                      style: GoogleFonts.questrial(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                SizedBox(height: 10),
                Container(
                  width: 335,
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
                        selectedItemsTextStyle: TextStyle(color: Colors.white),
                        initialChildSize: 0.4,
                        decoration: BoxDecoration(),
                        listType: MultiSelectListType.CHIP,
                        initialValue: context
                            .read(pharmacySignUpProvider.notifier)
                            .softwareList,
                        searchable: true,
                        items: _items,
                        buttonText: Text("Select Pharmacy Software...",
                            style: GoogleFonts.inter(
                                color: Color(0xFFBDBDBD), fontSize: 16)),
                        onConfirm: (values) {
                          context
                              .read(pharmacySignUpProvider.notifier)
                              .changeSoftwareList(values);
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          items: context
                              .read(pharmacySignUpProvider.notifier)
                              .softwareList
                              ?.map((e) => MultiSelectItem(e, e.toString()))
                              .toList(),
                          chipColor: Color(0xFF5DB075),
                          onTap: (value) {
                            context
                                .read(pharmacySignUpProvider.notifier)
                                .softwareList
                                ?.remove(value);
                            return context
                                .read(pharmacySignUpProvider.notifier)
                                .softwareList;
                          },
                          textStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            //Next Button
            Consumer(builder: (context, watch, child) {
              watch(pharmacySignUpProvider);
              return SizedBox(
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
                  onPressed: (context
                          .read(pharmacySignUpProvider.notifier)
                          .isValidPharmacyInformation())
                      ? null
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PharmacyManagerInformation()));
                        },
                  child: RichText(
                    text: TextSpan(
                      text: "Next",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
