import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  void changeSoftwareToList(String? stringList) {
    int indexOfOpenBracket = stringList!.indexOf("[");
    int indexOfLastBracket = stringList.lastIndexOf("]");
    var noBracketString = stringList.substring(indexOfOpenBracket + 1, indexOfLastBracket);
    List<Software?>? templist = [];
    var list = noBracketString.split(", ");
    for (var i = 0; i < list.length; i++) {
      templist.add(Software(id: 1, name: list[i].toString()));
    }
    setState(() {
      softwareList = templist;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      changeSoftwareToList(ref.read(pharmacyMainProvider.notifier).userData?["softwareList"]);
      ref.read(pharmacySignUpProvider.notifier).changeSoftwareList(softwareList as List<Software?>);

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
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 12,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
        ),
        backgroundColor: Color(0xFFF6F6F6),
      ),
      body: Consumer(builder: (context, ref, child) {
        ref.watch(pharmacySignUpProvider);
        return SingleChildScrollView(
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
                            color: Color(0xFFF0069C1),
                          ),
                          //First Name
                          Padding(
                            padding: const EdgeInsets.fromLTRB(11, 10, 0, 0),
                            child: CustomFormField(
                              fieldTitle: "First Name",
                              hintText: "Enter your First Name...",
                              keyboardStyle: TextInputType.name,
                              containerWidth: MediaQuery.of(context).size.width * 0.85,
                              titleFont: 22,
                              onChanged: (String firstName) {
                                ref
                                    .read(pharmacySignUpProvider.notifier)
                                    .changeFirstName(firstName);
                                checkIfChanged(ref, firstName, "firstName");
                              },
                              validation: (value) {
                                if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                    .hasMatch(value)) {
                                  return "Invalid field";
                                }
                                return null;
                              },
                              initialValue:
                                  ref.read(pharmacyMainProvider.notifier).userData?["firstName"],
                            ),
                          ),
                          SizedBox(height: 20),
                          //Last Name
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: CustomFormField(
                              fieldTitle: "Last Name",
                              hintText: "Enter your Last Name...",
                              keyboardStyle: TextInputType.name,
                              containerWidth: MediaQuery.of(context).size.width * 0.85,
                              titleFont: 22,
                              onChanged: (String lastName) {
                                ref.read(pharmacySignUpProvider.notifier).changeLastName(lastName);
                                checkIfChanged(ref, lastName, "lastName");
                              },
                              validation: (value) {
                                if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                    .hasMatch(value)) {
                                  return "Invalid field";
                                }
                                return null;
                              },
                              initialValue:
                                  ref.read(pharmacyMainProvider.notifier).userData?["lastName"],
                            ),
                          ),
                          SizedBox(height: 20),
                          //Phone Number
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: CustomFormField(
                              fieldTitle: "Phone Number",
                              hintText: "Enter your Phone Number...",
                              keyboardStyle: TextInputType.number,
                              containerWidth: MediaQuery.of(context).size.width * 0.85,
                              titleFont: 22,
                              onChanged: (String phoneNumber) {
                                ref
                                    .read(pharmacySignUpProvider.notifier)
                                    .changePhoneNumber(phoneNumber);
                                checkIfChanged(ref, phoneNumber, "phoneNumber");
                              },
                              validation: (value) {
                                if (value.length < 4) {
                                  return "Phone is invalid";
                                }
                                return null;
                              },
                              initialValue:
                                  ref.read(pharmacyMainProvider.notifier).userData?["phoneNumber"],
                              formatter: [MaskedInputFormatter('(###) ###-####')],
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
                                  width: MediaQuery.of(context).size.width * 0.85,
                                  constraints: BoxConstraints(maxHeight: 60, minHeight: 50),
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
                                            color: Color(0xFFBDBDBD), fontSize: 16),
                                      ),
                                      value: ref
                                          .read(pharmacyMainProvider.notifier)
                                          .userData?["position"],
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xFFF0F0F0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                                      ),
                                      items: <String>[
                                        'Pharmacy',
                                        'Pharmacist',
                                        'Technician',
                                      ].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                            child: Text(value), value: value);
                                      }).toList(),
                                      onChanged: (String? value) {
                                        ref
                                            .read(pharmacySignUpProvider.notifier)
                                            .changePosition(value);
                                        checkIfChanged(ref, value, "position");
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
                        builder: (context, ref, child) {
                          ref.watch(pharmacySignUpProvider);
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
                                color: Color(0xFFF0069C1),
                              ),

                              //Pharmacy Name
                              Padding(
                                padding: const EdgeInsets.fromLTRB(11, 10, 0, 0),
                                child: CustomFormField(
                                  fieldTitle: "Pharmacy Name",
                                  hintText: "Enter the pharmacy name...",
                                  keyboardStyle: TextInputType.name,
                                  containerWidth: MediaQuery.of(context).size.width * 0.85,
                                  titleFont: 22,
                                  onChanged: (String value) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changePharmacyName(value);
                                    checkIfChanged(ref, value, "pharmacyName");
                                  },
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  initialValue: ref
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
                                      width: MediaQuery.of(context).size.width * 0.85,

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
                                            ref
                                                .read(pharmacySignUpProvider.notifier)
                                                .changeStreetAddress(placeDetails.streetNumber! +
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
                                            uploadDataMap["address"] = {
                                              "streetAddress": placeDetails.streetNumber! +
                                                  " " +
                                                  placeDetails.street.toString(),
                                              "postalCode": placeDetails.zipCode.toString(),
                                              "country": placeDetails.country.toString(),
                                              "city": placeDetails.city.toString()
                                            };

                                            setState(() {
                                              streetAddress.text = placeDetails.streetNumber! +
                                                  " " +
                                                  placeDetails.street.toString();
                                              postalCode.text = placeDetails.zipCode.toString();
                                              country.text = placeDetails.country.toString();
                                              city.text = placeDetails.city.toString();
                                            });
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
                              ),
                              SizedBox(height: 20),

                              //Store Number
                              Padding(
                                padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                                child: CustomFormField(
                                  fieldTitle: "Store Number",
                                  hintText: "Enter the Store Number...",
                                  keyboardStyle: TextInputType.streetAddress,
                                  containerWidth: MediaQuery.of(context).size.width * 0.85,
                                  titleFont: 22,
                                  onChanged: (String storeNumber) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changeStoreNumber(storeNumber);
                                    uploadDataMap["address"]["storeNumber"] = storeNumber;
                                  },
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  initialValue: ref
                                      .read(pharmacyMainProvider.notifier)
                                      .userData?["address"]["storeNumber"],
                                ),
                              ),
                              SizedBox(height: 20),

                              //City
                              Padding(
                                padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                                child: CustomFormField(
                                  fieldTitle: "City",
                                  hintText: "Enter the city...",
                                  keyboardStyle: TextInputType.streetAddress,
                                  containerWidth: MediaQuery.of(context).size.width * 0.85,
                                  titleFont: 22,
                                  onChanged: (String city) {
                                    ref.read(pharmacySignUpProvider.notifier).changeCity(city);
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
                                child: CustomFormField(
                                  fieldTitle: "Postal Code",
                                  hintText: "Enter the postal code...",
                                  keyboardStyle: TextInputType.streetAddress,
                                  containerWidth: MediaQuery.of(context).size.width * 0.85,
                                  titleFont: 22,
                                  onChanged: (String postalCode) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changePostalCode(postalCode);
                                    uploadDataMap["address"]["postalCode"] = postalCode;
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
                                child: CustomFormField(
                                  fieldTitle: "Country",
                                  hintText: "Enter the country...",
                                  keyboardStyle: TextInputType.streetAddress,
                                  containerWidth: MediaQuery.of(context).size.width * 0.85,
                                  titleFont: 22,
                                  onChanged: (String country) {
                                    ref
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
                                child: CustomFormField(
                                  fieldTitle: "Pharmacy Phone Number",
                                  hintText: "Enter the pharmacy phone Number...",
                                  keyboardStyle: TextInputType.number,
                                  containerWidth: MediaQuery.of(context).size.width * 0.85,
                                  titleFont: 22,
                                  onChanged: (String phoneNumber) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changePhoneNumberPharmacy(phoneNumber);

                                    checkIfChanged(ref, phoneNumber, "pharmacyPhoneNumber");
                                  },
                                  validation: (value) {
                                    if (value.length < 4) {
                                      return "Phone Number is invalid";
                                    }
                                    return null;
                                  },
                                  initialValue: ref
                                      .read(pharmacyMainProvider.notifier)
                                      .userData?["pharmacyPhoneNumber"],
                                  formatter: [MaskedInputFormatter('(###) ###-####')],
                                ),
                              ),
                              SizedBox(height: 20),

                              //Fax Number
                              Padding(
                                padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                                child: CustomFormField(
                                  fieldTitle: "Pharmacy Fax Number",
                                  hintText: "Enter the pharmacy fax Number...",
                                  keyboardStyle: TextInputType.number,
                                  containerWidth: MediaQuery.of(context).size.width * 0.85,
                                  titleFont: 22,
                                  onChanged: (String faxNumber) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changeFaxNumber(faxNumber);
                                    uploadDataMap["pharmacyFaxNumber"] = faxNumber;
                                    checkIfChanged(ref, faxNumber, "pharmacyFaxNumber");
                                  },
                                  validation: (value) {
                                    if (value.length < 4) {
                                      return "Phone Number is invalid";
                                    }
                                    return null;
                                  },
                                  initialValue: ref
                                      .read(pharmacyMainProvider.notifier)
                                      .userData?["pharmacyFaxNumber"],
                                  formatter: [MaskedInputFormatter('(###) ###-####')],
                                ),
                              ),
                              SizedBox(height: 20),

                              //Accreditation Province
                              Padding(
                                padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                                child: CustomFormField(
                                  fieldTitle: "Accreditation Province",
                                  hintText: "Enter the accreditation province...",
                                  keyboardStyle: TextInputType.streetAddress,
                                  containerWidth: MediaQuery.of(context).size.width * 0.85,
                                  titleFont: 22,
                                  onChanged: (String accreditationProvince) {
                                    ref
                                        .read(pharmacySignUpProvider.notifier)
                                        .changeAccreditationProvince(accreditationProvince);

                                    checkIfChanged(
                                        ref, accreditationProvince, "accreditationProvice");
                                  },
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  initialValue: ref
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
                                      width: MediaQuery.of(context).size.width * 0.85,
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
                                          CustomMultiSelectBottomSheetField<Software?>(
                                            selectedColor: Color(0xFFF0069C1),
                                            selectedItemsTextStyle: TextStyle(color: Colors.white),
                                            initialChildSize: 0.4,
                                            decoration: BoxDecoration(),
                                            listType: MultiSelectListType.CHIP,
                                            initialValue: ref
                                                .read(pharmacySignUpProvider.notifier)
                                                .softwareList,
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
                                                        element?.name.toString() ==
                                                        value.toString());

                                                return ref
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
                  width: MediaQuery.of(context).size.width * 0.87,
                  height: 51,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Color(0xFFF0069C1);
                            else if (states.contains(MaterialState.disabled)) return Colors.grey;
                            return Color(0xFFF0069C1); // Use the component's default.
                          },
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ))),
                    onPressed: (uploadDataMap.isNotEmpty || softwareListToUpload!.isNotEmpty)
                        ? () async {
                            print(uploadDataMap);
                            if (ref.read(pharmacySignUpProvider.notifier).softwareList != null) {
                              uploadDataMap["softwareList"] =
                                  ref.read(pharmacySignUpProvider.notifier).softwareList.toString();
                            }
                            print("Upload Data Map: $uploadDataMap");
                            String? result = await ref
                                .read(authProvider.notifier)
                                .updatePharmacyUserInformation(
                                    ref.read(userProviderLogin.notifier).userUID, uploadDataMap);

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
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => JobHistoryPharmacy()));
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

              SizedBox(height: 20),
            ],
          ),
        );
      }),
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
