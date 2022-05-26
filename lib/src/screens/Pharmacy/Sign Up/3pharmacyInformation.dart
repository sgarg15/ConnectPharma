import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  final String shopIcon = 'assets/icons/shop.svg';
  final String searchIcon = 'assets/icons/search.svg';
  final String stampIcon = 'assets/icons/stamp.svg';
  final String phoneIcon = 'assets/icons/phone.svg';
  final String gearIcon = 'assets/icons/gear.svg';

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
    TextEditingController province =
        TextEditingController(text: ref.read(pharmacySignUpProvider.notifier).province);
    TextEditingController country =
        TextEditingController(text: ref.read(pharmacySignUpProvider.notifier).country);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_sharp), onPressed: () => Navigator.pop(context)),
          title: new Text(
            "Pharmacy Information",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily,
            ),
          ),
          backgroundColor: Color(0xFFF0069C1),
          foregroundColor: Colors.white,
          elevation: 12,
          bottomOpacity: 1,
          shadowColor: Colors.white,
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: Column(children: <Widget>[
                Expanded(child: LayoutBuilder(
                  builder: (context, constraints) {
                    return NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (OverscrollIndicatorNotification overscroll) {
                        overscroll.disallowIndicator();
                        return true;
                      },
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 30),
                            //Information Text
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: "Please provide us with information about the pharmacy.",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),

                            //Pharmacy Name
                            CustomInputField(
                              fieldTitle: "Pharmacy Name",
                              hintText: "Enter the pharmacy name",
                              icon: shopIcon,
                              keyboardStyle: TextInputType.name,
                              onChanged: (String pharmacyName) {
                                ref
                                    .read(pharmacySignUpProvider.notifier)
                                    .changePharmacyName(pharmacyName);
                              },
                              validation: (value) {
                                if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                    .hasMatch(value ?? "")) {
                                  return "Invalid field";
                                }
                                return null;
                              },
                              initialValue: ref.read(pharmacySignUpProvider.notifier).pharmacyName,
                            ),
                            SizedBox(height: 30),

                            //Street Address
                            getPharmacyAddress(streetAddress, context, postalCode, province,
                                country, city, searchIcon),
                            SizedBox(height: 30),

                            //Store Number
                            CustomInputField(
                              fieldTitle: "Store Number",
                              hintText: "Enter the Store Number...",
                              icon: searchIcon,
                              keyboardStyle: TextInputType.streetAddress,
                              onChanged: (String storeNumber) {
                                ref
                                    .read(pharmacySignUpProvider.notifier)
                                    .changeStoreNumber(storeNumber);
                              },
                              validation: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This field is required";
                                }
                                return null;
                              },
                              initialValue: ref.read(pharmacySignUpProvider.notifier).storeNumber,
                            ),
                            SizedBox(height: 30),

                            //City
                            CustomInputField(
                              fieldTitle: "City",
                              hintText: "Enter the city...",
                              icon: searchIcon,
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
                            SizedBox(height: 30),

                            //Postal Code
                            CustomInputField(
                              fieldTitle: "Postal Code",
                              hintText: "Enter the postal code...",
                              icon: searchIcon,
                              keyboardStyle: TextInputType.streetAddress,
                              onChanged: (String postalCode) {
                                ref
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
                            SizedBox(height: 30),

                            //Province
                            CustomInputField(
                              fieldTitle: "Province/State",
                              hintText: "Enter the province/state...",
                              icon: searchIcon,
                              keyboardStyle: TextInputType.streetAddress,
                              onChanged: (String province) {
                                ref.read(pharmacySignUpProvider.notifier).changeProvince(province);
                              },
                              validation: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This field is required";
                                }
                                return null;
                              },
                              controller: province,
                            ),
                            SizedBox(height: 30),

                            //Country
                            CustomInputField(
                              fieldTitle: "Country",
                              hintText: "Enter the country...",
                              icon: searchIcon,
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
                            SizedBox(height: 30),

                            //Accreditation Province
                            CustomInputField(
                              fieldTitle: "Accreditation Province",
                              hintText: "Enter the accreditation province...",
                              icon: stampIcon,
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
                              initialValue:
                                  ref.read(pharmacySignUpProvider.notifier).accreditationProvince,
                            ),
                            SizedBox(height: 30),

                            //Phone Number
                            CustomInputField(
                              fieldTitle: "Pharmacy Phone Number",
                              hintText: "+1 234 567 8910",
                              icon: phoneIcon,
                              keyboardStyle: TextInputType.number,
                              onChanged: (String phoneNumber) {
                                ref
                                    .read(pharmacySignUpProvider.notifier)
                                    .changePhoneNumberPharmacy(phoneNumber);
                              },
                              validation: (value) {
                                if (value.length < 4) {
                                  return "Phone Number is invalid";
                                }
                                return null;
                              },
                              initialValue:
                                  ref.read(pharmacySignUpProvider.notifier).phoneNumberPharmacy,
                              formatter: [PhoneInputFormatter()],
                            ),
                            SizedBox(height: 30),

                            //Fax Number
                            CustomInputField(
                              fieldTitle: "Pharmacy Fax Number",
                              hintText: "+1 234 567 8910",
                              icon: phoneIcon,
                              keyboardStyle: TextInputType.number,
                              onChanged: (String faxNumber) {
                                ref
                                    .read(pharmacySignUpProvider.notifier)
                                    .changeFaxNumber(faxNumber);
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
                            SizedBox(height: 30),

                            //Pharmacy Software
                            selectPharmacySoftware(gearIcon),
                            SizedBox(height: 30),

                            //Next Button
                            nextButton(),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  },
                )),
              ]),
            ),
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
                  return Color(0xFF0069C1); // Use the component's default.
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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

  Container selectPharmacySoftware(String icon) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              SvgPicture.asset(icon, width: 16, height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: RichText(
                  text: TextSpan(
                    text: "Pharmacy Software",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF4A4848),
                        fontFamily:
                            GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          MultiSelectBottomSheetField<Software?>(
            selectedColor: Color(0xFFF0069C1),
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
              chipColor: Color(0xFFF0069C1),
              onTap: (value) {
                ref.read(pharmacySignUpProvider.notifier).softwareList?.remove(value);
                return ref.read(pharmacySignUpProvider.notifier).softwareList;
              },
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Container getPharmacyAddress(
      TextEditingController streetAddress,
      BuildContext context,
      TextEditingController postalCode,
      TextEditingController province,
      TextEditingController country,
      TextEditingController city,
      String icon) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              SvgPicture.asset(icon, width: 16, height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: RichText(
                  text: TextSpan(
                    text: "Street Address",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF4A4848),
                        fontFamily:
                            GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
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
                      .changeStreetAddress(placeDetails.street.toString());
                }

                ref.read(pharmacySignUpProvider.notifier).changeCity(placeDetails.city);
                ref.read(pharmacySignUpProvider.notifier).changePostalCode(placeDetails.zipCode);
                ref.read(pharmacySignUpProvider.notifier).changeProvince(placeDetails.province);
                ref.read(pharmacySignUpProvider.notifier).changeCountry(placeDetails.country);

                setState(() {
                  streetAddress.text =
                      "${placeDetails.streetNumber.toString()} ${placeDetails.street.toString()}";
                  postalCode.text = placeDetails.zipCode.toString();
                  print("Postal Code: ${postalCode.text}");
                  province.text = placeDetails.province.toString();
                  country.text = placeDetails.country.toString();
                  city.text = placeDetails.city.toString();
                });
              }
            },
            decoration: InputDecoration(
              isDense: true,
              hintText: "Enter pharmacy street address",
              hintStyle: TextStyle(
                fontSize: 14.0,
                color: Color(0xFFC6C6C6),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
