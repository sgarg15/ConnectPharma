import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectpharma/all_used.dart';
import 'package:connectpharma/src/Address%20Search/locationSearch.dart';
import 'package:connectpharma/src/Address%20Search/placeService.dart';
import '1pharmacistSignUp.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign Up/3pharmacistInformation.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../../../main.dart';

class PharmacistLocation extends ConsumerStatefulWidget {
  const PharmacistLocation({Key? key}) : super(key: key);

  @override
  _PharmacistLocationState createState() => _PharmacistLocationState();
}

class _PharmacistLocationState extends ConsumerState<PharmacistLocation> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController streetAddress =
        TextEditingController(text: ref.read(pharmacistSignUpProvider.notifier).address);

    return WillPopScope(
      onWillPop: () async {
        //TODO: REMOVE THIS ONCE EVERYTHING WORKS AND REPLACE IT INSIDE THE SIDE MENU
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Important!"),
                content: Text("You will be signed out."),
                actions: [
                  TextButton(
                    child: Text(
                      "Ok",
                      style: TextStyle(color: Color(0xFF5DB075)),
                    ),
                    onPressed: () {
                      ref.read(pharmacistSignUpProvider.notifier).clearAllValues();
                      // Direct to whichever they are in Information Form pages
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ConnectPharma()),
                      );
                    },
                  )
                ],
              );
            });
        return true;
      },
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
          title: new Text(
            "Location",
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
                  padding: EdgeInsets.fromLTRB(8, 10, 0, 0),
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text:
                          "Please provide us with your Location Information, to help us provide results tailored to you.",
                      style: GoogleFonts.questrial(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              //All Fields
              Align(
                alignment: Alignment(-0.35, -0.70),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 20),

                      //First Name
                      CustomFormField(
                        fieldTitle: "First Name",
                        hintText: "Enter your First Name...",
                        keyboardStyle: TextInputType.name,
                        onChanged: (String firstName) {
                          ref.read(pharmacistSignUpProvider.notifier).changeFirstName(firstName);
                        },
                        validation: (value) {
                          if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                              .hasMatch(value)) {
                            return "Invalid field";
                          }
                          return null;
                        },
                        initialValue: ref.read(pharmacistSignUpProvider.notifier).firstName,
                      ),
                      SizedBox(height: 20),

                      //Last Name
                      CustomFormField(
                        fieldTitle: "Last Name",
                        hintText: "Enter your Last Name...",
                        keyboardStyle: TextInputType.name,
                        onChanged: (String lastName) {
                          ref.read(pharmacistSignUpProvider.notifier).changeLastName(lastName);
                        },
                        validation: (value) {
                          if (!RegExp(r"[^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                              .hasMatch(value)) {
                            return "Invalid field";
                          }
                          return null;
                        },
                        initialValue: ref.read(pharmacistSignUpProvider.notifier).lastName,
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
                                text: "Address",
                                style: GoogleFonts.questrial(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                          SizedBox(height: 10),
                          streetAddressField(streetAddress, context),
                        ],
                      ),
                      SizedBox(height: 20),

                      //Phone Number
                      CustomFormField(
                          fieldTitle: "Phone Number",
                          hintText: "+1 234 567 8910",
                          keyboardStyle: TextInputType.number,
                          onChanged: (String phoneNumber) {
                            ref
                                .read(pharmacistSignUpProvider.notifier)
                                .changePhoneNumber(phoneNumber);
                          },
                          validation: (value) {
                            if (value.length < 4) {
                              return "Phone is invalid";
                            }
                            return null;
                          },
                          initialValue: ref.read(pharmacistSignUpProvider.notifier).phoneNumber,
                          formatter: [PhoneInputFormatter()]),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              //Next Button
              nextButton(),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Center nextButton() {
    return Center(
      child: Consumer(
        builder: (context, ref, child) {
          ref.watch(pharmacistSignUpProvider);
          return SizedBox(
            width: 324,
            height: 51,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey; // Disabled color
                    }
                    return Color(0xFF5DB075); // Regular color
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ))),
              onPressed: (ref.read(pharmacistSignUpProvider.notifier).isValidPharmacistLocation())
                  ? null
                  : () {
                      print("Pressed");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PharmacistInformation()));
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
        },
      ),
    );
  }

  Container streetAddressField(TextEditingController streetAddress, BuildContext context) {
    return Container(
      width: 335,
      //height: 50,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              offset: Offset(0.3, 3),
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
            ref.read(pharmacistSignUpProvider.notifier).changePharmacistAddress(
                placeDetails.streetNumber! +
                    " " +
                    placeDetails.street.toString() +
                    ", " +
                    placeDetails.city.toString() +
                    ", " +
                    placeDetails.country.toString());
            streetAddress.text = placeDetails.streetNumber! +
                " " +
                placeDetails.street.toString() +
                ", " +
                placeDetails.city.toString() +
                ", " +
                placeDetails.country.toString();
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
          hintText: "Enter the address...",
          hintStyle: GoogleFonts.inter(color: Color(0xFFBDBDBD), fontSize: 16),
        ),
        style: GoogleFonts.inter(color: Colors.black, fontSize: 16),
      ),
    );
  }
}
