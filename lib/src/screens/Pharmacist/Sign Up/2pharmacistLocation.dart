import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        TextEditingController(text: ref.read(userSignUpProvider.notifier).address);

    final String personIcon = 'assets/icons/person.svg';
    final String phoneIcon = 'assets/icons/phone.svg';

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_sharp), onPressed: () => Navigator.pop(context)),
            title: new Text(
              "Pharmacist Location",
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
            children: [
              Center(
                child: Column(children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: ((context, constraints) {
                        return NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (OverscrollIndicatorNotification overscroll) {
                            overscroll.disallowIndicator();
                            return true;
                          },
                          
                          child: SingleChildScrollView(
                            physics: ClampingScrollPhysics(),
                            child: Column(
                              children: [
                              SizedBox(height: 30),
                              //Information Text
                              Padding(
                                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    text:
                                        "Please provide us with your location information, to help us provide results tailored to you.",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),

                              //First Name
                              CustomInputField(
                                fieldTitle: "First Name",
                                hintText: "Enter your first name",
                                icon: personIcon,
                                keyboardStyle: TextInputType.name,
                                onChanged: (String firstName) {
                                  ref
                                      .read(userSignUpProvider.notifier)
                                      .changeFirstName(firstName);
                                },
                                validation: (value) {
                                  if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                      .hasMatch(value ?? "")) {
                                    return "Invalid field";
                                  }
                                  return null;
                                },
                                initialValue: ref.read(userSignUpProvider.notifier).firstName,
                              ),
                              SizedBox(height: 30),

                              //Last Name
                              CustomInputField(
                                fieldTitle: "Last Name",
                                hintText: "Enter your last name",
                                icon: personIcon,
                                keyboardStyle: TextInputType.name,
                                onChanged: (String lastName) {
                                  ref
                                      .read(userSignUpProvider.notifier)
                                      .changeLastName(lastName);
                                },
                                validation: (value) {
                                  if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                                      .hasMatch(value ?? "")) {
                                    return "Invalid field";
                                  }
                                  return null;
                                },
                                initialValue: ref.read(userSignUpProvider.notifier).lastName,
                              ),
                              SizedBox(height: 30),

                              streetAddressContainer(context, ref, streetAddress),
                              SizedBox(height: 30),

                              //Phone Number
                              CustomInputField(
                                fieldTitle: "Phone Number",
                                hintText: "+1 234 567 8910",
                                icon: phoneIcon,
                                keyboardStyle: TextInputType.number,
                                onChanged: (String phoneNumber) {
                                  ref
                                      .read(userSignUpProvider.notifier)
                                      .changePhoneNumber(phoneNumber);
                                },
                                validation: (value) {
                                  if (value.length < 4) {
                                    return "Phone Number is invalid";
                                  }
                                  return null;
                                },
                                initialValue:
                                    ref.read(userSignUpProvider.notifier).phoneNumber,
                                formatter: [PhoneInputFormatter()],
                              ),
                              SizedBox(height: 30),

                              nextButton(),
                            ]),
                          ),
                        );
                      }),
                    ),
                  )
                ]),
              )
            ],
          )),
    );
  }

  Container streetAddressContainer(
      BuildContext context, WidgetRef ref, TextEditingController streetAddress) {
    const String locationIcon = 'assets/icons/location.svg';
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                SvgPicture.asset(locationIcon, width: 16, height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: RichText(
                      text: TextSpan(
                          text: "Address",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF4A4848),
                              fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                  .fontFamily))),
                ),
              ],
            ),
            streetAddressField(streetAddress, context),
          ],
        ));
  }

  Center nextButton() {
    return Center(
      child: Consumer(
        builder: (context, ref, child) {
          ref.watch(userSignUpProvider);
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 51,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey; // Disabled color
                    }
                    return Color(0xFF0069C1); // Regular color
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))),
              
              onPressed: (ref.read(userSignUpProvider.notifier).isValidPharmacistLocation())
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
            ref.read(userSignUpProvider.notifier).changePharmacistAddress(
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
          isDense: true,
          hintText: "Enter your address",
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
    );
  }
}
