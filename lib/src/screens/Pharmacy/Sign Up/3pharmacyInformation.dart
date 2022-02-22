import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:connectpharma/all_used.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/src/Address%20Search/locationSearch.dart';
import 'package:connectpharma/src/Address%20Search/placeService.dart';
import 'package:connectpharma/src/screens/Pharmacy/Sign Up/4pharmacyManagerInformation.dart';
import 'package:uuid/uuid.dart';
import 'package:connectpharma/src/screens/Pharmacy/Sign Up/1pharmacy_signup.dart';

class PharmacyInformation extends ConsumerStatefulWidget {
  PharmacyInformation({Key? key}) : super(key: key);

  @override
  _PharmacyInformationState createState() => _PharmacyInformationState();
}

class _PharmacyInformationState extends ConsumerState<PharmacyInformation> {
  final _items =
      software.map((software) => MultiSelectItem<Software>(software, software.name)).toList();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController city =
        TextEditingController(text: ref.read(pharmacySignUpProvider.notifier).city);
    TextEditingController streetAddress =
        TextEditingController(text: ref.read(pharmacySignUpProvider.notifier).streetAddress);
    TextEditingController postalCode =
        TextEditingController(text: ref.read(pharmacySignUpProvider.notifier).postalCode);
    TextEditingController country =
        TextEditingController(text: ref.read(pharmacySignUpProvider.notifier).country);

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
                    text: "Please provide us with information about the pharmacy.",
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
            CustomFormField(
              fieldTitle: "Pharmacy Name",
              hintText: "Enter the Pharmacy name...",
              keyboardStyle: TextInputType.name,
              onChanged: (String pharmacyName) {
                ref.read(pharmacySignUpProvider.notifier).changePharmacyName(pharmacyName);
              },
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
              initialValue: ref.read(pharmacySignUpProvider.notifier).pharmacyName,
            ),
            SizedBox(height: 20),

            //Street Address
            getPharmacyAddress(streetAddress, context, postalCode, country, city),
            SizedBox(height: 20),

            //Store Number
            CustomFormField(
              fieldTitle: "Store Number",
              hintText: "Enter the Store Number...",
              keyboardStyle: TextInputType.streetAddress,
              onChanged: (String storeNumber) {
                ref.read(pharmacySignUpProvider.notifier).changeStoreNumber(storeNumber);
              },
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
              initialValue: ref.read(pharmacySignUpProvider.notifier).storeNumber,
            ),
            SizedBox(height: 20),

            //City
            CustomFormField(
              fieldTitle: "City",
              hintText: "Enter the city...",
              keyboardStyle: TextInputType.streetAddress,
              onChanged: (String city) {
                ref.read(pharmacySignUpProvider.notifier).changeCity(city);
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
            CustomFormField(
              fieldTitle: "Postal Code",
              hintText: "Enter the postal code...",
              keyboardStyle: TextInputType.streetAddress,
              onChanged: (String postalCode) {
                ref.read(pharmacySignUpProvider.notifier).changePostalCode(postalCode);
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
            CustomFormField(
              fieldTitle: "Country",
              hintText: "Enter the country...",
              keyboardStyle: TextInputType.streetAddress,
              onChanged: (String country) {
                ref.read(pharmacySignUpProvider.notifier).changeCountry(country);
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
            CustomFormField(
              fieldTitle: "Pharmacy Phone Number",
              hintText: "+1 234 567 8910",
              keyboardStyle: TextInputType.number,
              onChanged: (String phoneNumber) {
                ref.read(pharmacySignUpProvider.notifier).changePhoneNumberPharmacy(phoneNumber);
              },
              validation: (value) {
                if (value.length < 4) {
                  return "Phone Number is invalid";
                }
                return null;
              },
              initialValue: ref.read(pharmacySignUpProvider.notifier).phoneNumberPharmacy,
              formatter: [PhoneInputFormatter()],
            ),
            SizedBox(height: 20),

            //Fax Number
            CustomFormField(
              fieldTitle: "Pharmacy Fax Number",
              hintText: "+1 234 567 8910",
              keyboardStyle: TextInputType.number,
              onChanged: (String faxNumber) {
                ref.read(pharmacySignUpProvider.notifier).changeFaxNumber(faxNumber);
              },
              validation: (value) {
                if (value.length < 4) {
                  return "Phone Number is invalid";
                }
                return null;
              },
              initialValue: ref.read(pharmacySignUpProvider.notifier).faxNumber,
              formatter: [PhoneInputFormatter()],
            ),
            SizedBox(height: 20),

            //Accreditation Province
            CustomFormField(
              fieldTitle: "Accreditation Province",
              hintText: "Enter the accreditation province...",
              keyboardStyle: TextInputType.streetAddress,
              onChanged: (String accreditationProvince) {
                ref
                    .read(pharmacySignUpProvider.notifier)
                    .changeAccreditationProvince(accreditationProvince);
              },
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return "This field is required";
                } else if ((value as String).length < 4) {
                  return "Please type the full province name";
                }
                return null;
              },
              initialValue: ref.read(pharmacySignUpProvider.notifier).accreditationProvince,
            ),
            SizedBox(height: 20),

            //Pharmacy Software
            selectPharmacySoftware(),

            SizedBox(height: 20),
            //Next Button
            nextButton(),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Consumer nextButton() {
    return Consumer(builder: (context, ref, child) {
      ref.watch(pharmacySignUpProvider);
      return SizedBox(
        width: 324,
        height: 51,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Color(0xFF5DB075);
                  } else if (states.contains(MaterialState.disabled)) {
                    return Colors.grey;
                  }
                  return Color(0xFF5DB075); // Use the component's default.
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ))),
          onPressed: (ref.read(pharmacySignUpProvider.notifier).isValidPharmacyInformation())
              ? null
              : () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PharmacyManagerInformation()));
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
    });
  }

  Column selectPharmacySoftware() {
    return Column(
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
                initialValue: ref.read(pharmacySignUpProvider.notifier).softwareList,
                searchable: true,
                items: _items,
                buttonText: Text("Select Pharmacy Software...",
                    style: GoogleFonts.inter(color: Color(0xFFBDBDBD), fontSize: 16)),
                onConfirm: (values) {
                  ref.read(pharmacySignUpProvider.notifier).changeSoftwareList(values);
                },
                chipDisplay: MultiSelectChipDisplay(
                  items: ref
                      .read(pharmacySignUpProvider.notifier)
                      .softwareList
                      ?.map((e) => MultiSelectItem(e, e.toString()))
                      .toList(),
                  chipColor: Color(0xFF5DB075),
                  onTap: (value) {
                    ref.read(pharmacySignUpProvider.notifier).softwareList?.remove(value);
                    return ref.read(pharmacySignUpProvider.notifier).softwareList;
                  },
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column getPharmacyAddress(TextEditingController streetAddress, BuildContext context,
      TextEditingController postalCode, TextEditingController country, TextEditingController city) {
    return Column(
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
                    await PlaceApiProvider(sessionToken).getPlaceDetailFromId(result.placeId);
                print("${placeDetails.streetNumber ?? ""} ${placeDetails.street.toString()}");
                if (placeDetails.streetNumber != null) {
                  print("${placeDetails.streetNumber ?? ""} ${placeDetails.street.toString()}");
                  print("Not null");
                  ref.read(pharmacySignUpProvider.notifier).changeStreetAddress(
                      "${placeDetails.streetNumber} ${placeDetails.street.toString()}");
                } else {
                  print("${placeDetails.streetNumber ?? ""} ${placeDetails.street.toString()}");
                  print("null");
                  ref
                      .read(pharmacySignUpProvider.notifier)
                      .changeStreetAddress("${placeDetails.street.toString()}");
                }

                ref.read(pharmacySignUpProvider.notifier).changeCity(placeDetails.city);
                ref.read(pharmacySignUpProvider.notifier).changePostalCode(placeDetails.zipCode);
                ref.read(pharmacySignUpProvider.notifier).changeCountry(placeDetails.country);
                streetAddress.text =
                    "${placeDetails.streetNumber.toString()} ${placeDetails.street.toString()}";
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
              hintStyle: GoogleFonts.inter(color: Color(0xFFBDBDBD), fontSize: 16),
            ),
            style: GoogleFonts.inter(color: Colors.black, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
