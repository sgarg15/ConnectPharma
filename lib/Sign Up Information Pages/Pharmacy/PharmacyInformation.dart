import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:pharma_connect/all_used.dart';
import 'AddressSearch.dart';
import 'place_service.dart';
import 'package:uuid/uuid.dart';

class Software {
  final int id;
  final String name;

  Software({
    this.id,
    this.name,
  });
}

class PharmacyInformation extends StatefulWidget {
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

  final _streetaddress = TextEditingController();
  final _pharmacyName = TextEditingController();
  final _storeNumber = TextEditingController();
  final _city = TextEditingController();
  final _postalCode = TextEditingController();
  final _country = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _faxNumber = TextEditingController();
  final _accreditationProvince = TextEditingController();

  final _items = _software
      .map((software) => MultiSelectItem<Software>(software, software.name))
      .toList();

  List<Software> _selectedSoftware = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
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
            //Pharmacy Name
            SizedBox(height: 20),
            //Pharmacy Name Field
            formField(
              fieldTitle: "Pharmacy Name",
              hintText: "Enter the Pharmacy name...",
              textController: _pharmacyName,
              keyboardStyle: TextInputType.name,
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
                  height: 50,
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: TextFormField(
                      readOnly: true,
                      onTap: () async {
                        // generate a new token here
                        final sessionToken = Uuid().v4();
                        final Suggestion result = await showSearch(
                          context: context,
                          delegate: AddressSearch(sessionToken),
                        );
                        // This will change the text displayed in the TextField
                        if (result != null) {
                          final placeDetails =
                              await PlaceApiProvider(sessionToken)
                                  .getPlaceDetailFromId(result.placeId);
                          setState(() {
                            _streetaddress.text = placeDetails.streetNumber +
                                " " +
                                placeDetails.street;
                            _city.text = placeDetails.city;
                            _postalCode.text = placeDetails.zipCode;
                            _country.text = placeDetails.country;
                          });
                        }
                      },
                      keyboardType: TextInputType.streetAddress,
                      controller: _streetaddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF0F0F0),
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
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            //Store Number
            formField(
              fieldTitle: "Store Number",
              hintText: "Enter the store number...",
              textController: _storeNumber,
            ),
            SizedBox(height: 20),
            //City
            formField(
              fieldTitle: "City",
              hintText: "Enter the city...",
              textController: _city,
              keyboardStyle: TextInputType.streetAddress,
            ),
            SizedBox(height: 20),
            //Postal Code
            formField(
              fieldTitle: "Postal Code",
              hintText: "Enter the postal code...",
              textController: _postalCode,
              keyboardStyle: TextInputType.streetAddress,
            ),
            SizedBox(height: 20),
            //Country
            formField(
              fieldTitle: "Country",
              hintText: "Enter the Country...",
              textController: _country,
              keyboardStyle: TextInputType.streetAddress,
            ),
            SizedBox(height: 20),
            //Phone Number
            formField(
              fieldTitle: "Phone Number",
              hintText: "Enter the Pharmacy phone number...",
              textController: _phoneNumber,
              keyboardStyle: TextInputType.number,
            ),
            SizedBox(height: 20),
            //Fax Number
            formField(
              fieldTitle: "Fax Number",
              hintText: "Enter the Pharmacy fax number...",
              textController: _faxNumber,
              keyboardStyle: TextInputType.number,
            ),
            SizedBox(height: 20),
            //Accreditation Province
            formField(
              fieldTitle: "Accreditation Province",
              hintText: "Enter the Accreditation province...",
              textController: _accreditationProvince,
              keyboardStyle: TextInputType.streetAddress,
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
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 335,
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F0F0),
                      border: Border.all(
                        color: Color(0xFFE8E8E8),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: <Widget>[
                        MultiSelectBottomSheetField<Software>(
                          selectedColor: Color(0xFF5DB075),
                          selectedItemsTextStyle:
                              TextStyle(color: Colors.white),
                          initialChildSize: 0.4,
                          decoration: BoxDecoration(),
                          listType: MultiSelectListType.CHIP,
                          initialValue: _selectedSoftware,
                          searchable: true,
                          items: _items,
                          buttonText: Text("Select Pharmacy Software...",
                              style: GoogleFonts.inter(
                                  color: Color(0xFFBDBDBD), fontSize: 16)),
                          onConfirm: (values) {
                            _selectedSoftware = values;
                          },
                          chipDisplay: MultiSelectChipDisplay(
                            items: _selectedSoftware
                                .map((e) => MultiSelectItem(e, e.toString()))
                                .toList(),
                            chipColor: Color(0xFF5DB075),
                            onTap: (value) {
                              _selectedSoftware.remove(value);
                              return _selectedSoftware;
                            },
                            textStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            //Next Button
            SizedBox(
              width: 324,
              height: 51,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF5DB075)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ))),
                onPressed: () {
                  //Go to Next sign up form page
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PharmacyInformation()),
                  );*/
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
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
