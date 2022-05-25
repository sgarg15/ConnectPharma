import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectpharma/all_used.dart';
import 'package:connectpharma/src/screens/Pharmacy/Sign Up/1pharmacy_signup.dart';
import 'package:connectpharma/src/screens/Pharmacy/Sign Up/3pharmacyInformation.dart';
import 'package:signature/signature.dart';

import '../../../../main.dart';

class AccountInformationPharmacy extends ConsumerStatefulWidget {
  const AccountInformationPharmacy({Key? key}) : super(key: key);

  @override
  _AccountInformationPharmacyState createState() => _AccountInformationPharmacyState();
}

class _AccountInformationPharmacyState extends ConsumerState<AccountInformationPharmacy> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignatureController _sigController = SignatureController(
    penStrokeWidth: 3, //you can set pen stroke with by changing this value
    penColor: Colors.black, // change your pen color
    exportBackgroundColor: Colors.white, //set the color you want to see in final result
  );

  final String personIcon = 'assets/icons/person.svg';
  final String phoneIcon = 'assets/icons/phone.svg';
  final String briefcaseIcon = 'assets/icons/briefcase.svg';
  final String signatureIcon = 'assets/icons/signature.svg';




  @override
  Widget build(BuildContext context) {
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
            "Account Owner Information",
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
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
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
                                            "Please provide us with the primary contact information for your ConnectPharma account.",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),

                                  firstNameInput(context, ref),
                                  SizedBox(height: 30),

                                  lastNameInput(context, ref),

                                  SizedBox(height: 30),
                                  phoneNumberInput(context, ref),
                                  SizedBox(height: 30),

                                  positionSelectDropDown(),

                                  SizedBox(height: 30),
                                  signatureInput(context, ref),
                                  SizedBox(height: 90),

                                  nextButton(),
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                ],
              ),
            ),
            /*
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
                        ref.read(pharmacySignUpProvider.notifier).changeFirstName(firstName);
                      },
                      validation: (value) {
                        if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                            .hasMatch(value)) {
                          return "Invalid field";
                        }
                        return null;
                      },
                      initialValue: ref.read(pharmacySignUpProvider.notifier).firstName,
                    ),
                    SizedBox(height: 20),
    
                    //Last Name
                    CustomFormField(
                      fieldTitle: "Last Name",
                      hintText: "Enter your Last Name...",
                      keyboardStyle: TextInputType.name,
                      onChanged: (String lastName) {
                        ref.read(pharmacySignUpProvider.notifier).changeLastName(lastName);
                      },
                      validation: (value) {
                        if (!RegExp(r"[^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                            .hasMatch(value)) {
                          return "Invalid field";
                        }
                        return null;
                      },
                      initialValue: ref.read(pharmacySignUpProvider.notifier).lastName,
                    ),
                    SizedBox(height: 20),
    
                    //Phone Number
                    CustomFormField(
                      fieldTitle: "Phone Number",
                      hintText: "+1 234 567 8910",
                      keyboardStyle: TextInputType.number,
                      onChanged: (String phoneNumber) {
                        ref.read(pharmacySignUpProvider.notifier).changePhoneNumber(phoneNumber);
                      },
                      validation: (value) {
                        if (value.length < 4) {
                          return "Phone is invalid";
                        }
                        return null;
                      },
                      initialValue: ref.read(pharmacySignUpProvider.notifier).phoneNumber,
                      formatter: [PhoneInputFormatter()],
                    ),
                    SizedBox(height: 20),
    
                    //Position Drop Box
                    positionSelectDropDown(),
    
                    SizedBox(height: 20),
    
                    //Signature Overlay
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                          text: "E-Signature",
                          style: GoogleFonts.questrial(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    SizedBox(height: 5),
                    SignatureBox(sigController: _sigController),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    */
            
            //Next Button
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Consumer nextButton() {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(pharmacySignUpProvider);
        return SizedBox(
          width: 324,
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
            onPressed: (ref.read(pharmacySignUpProvider.notifier).isValidAccountInfo())
                ? null
                : () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => PharmacyInformation()));
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
    );
  }

  Container firstNameInput(BuildContext context, WidgetRef ref) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                SvgPicture.asset(personIcon, width: 16, height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: RichText(
                      text: TextSpan(
                          text: "First Name",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF4A4848),
                              fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                  .fontFamily))),
                ),
              ],
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              onChanged: (String firstName) {
                ref.read(pharmacySignUpProvider.notifier).changeFirstName(firstName);
              },
              validator: (value) {
                if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                    .hasMatch(value ?? "")) {
                  return "Invalid field";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: ref.read(pharmacySignUpProvider.notifier).firstName,
              decoration: InputDecoration(
                isDense: true,
                hintText: "Enter your first name",
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
        ));
  }

  Container lastNameInput(BuildContext context, WidgetRef ref) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                SvgPicture.asset(personIcon, width: 16, height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: RichText(
                      text: TextSpan(
                          text: "Last Name",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF4A4848),
                              fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                  .fontFamily))),
                ),
              ],
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              onChanged: (String lastName) {
                ref.read(pharmacySignUpProvider.notifier).changeLastName(lastName);
              },
              validator: (value) {
                if (!RegExp(r"^[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
                    .hasMatch(value ?? "")) {
                  return "Invalid field";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: ref.read(pharmacySignUpProvider.notifier).lastName,
              decoration: InputDecoration(
                isDense: true,
                hintText: "Enter your last Name",
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
        ));
  }

  Container phoneNumberInput(BuildContext context, WidgetRef ref) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                SvgPicture.asset(phoneIcon, width: 16, height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: RichText(
                      text: TextSpan(
                          text: "Phone Number",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF4A4848),
                              fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                  .fontFamily))),
                ),
              ],
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              textCapitalization: TextCapitalization.none,
              onChanged: (String phoneNumber) {
                ref.read(pharmacySignUpProvider.notifier).changePhoneNumber(phoneNumber);
              },
              validator: (value) {
                if (value!.length < 4) {
                  return "Phone is invalid";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: ref.read(pharmacySignUpProvider.notifier).phoneNumber,
              inputFormatters: [PhoneInputFormatter()],
              decoration: InputDecoration(
                isDense: true,
                hintText: "Enter your phone number",
                hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFFC6C6C6),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 0,
                ),
              ),
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily),
            ),
          ],
        ));
  }

  Container positionSelectDropDown() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              SvgPicture.asset(briefcaseIcon, width: 17, height: 17),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: RichText(
                    text: TextSpan(
                        text: "Position",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF4A4848),
                            fontFamily:
                                GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily))),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            constraints: BoxConstraints(maxHeight: 60, minHeight: 50),
            child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                ),
                hint: Text(
                  "Select your Position...",
                  style: GoogleFonts.inter(color: Color(0xFFBDBDBD), fontSize: 16),
                ),
                value: ref.read(pharmacySignUpProvider.notifier).position,
               
                items: <String>[
                  'Pharmacy',
                  'Pharmacist',
                  'Technician',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(child: Text(value), value: value);
                }).toList(),
                onChanged: (String? value) {
                  ref.read(pharmacySignUpProvider.notifier).changePosition(value);
                },
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 16,
                )),
          ),
        ],
      ),
    );
  }

  Container signatureInput(BuildContext context, WidgetRef ref) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: <Widget>[
                    SvgPicture.asset(signatureIcon, width: 17, height: 17),
                    Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: RichText(
                          text: TextSpan(
                              text: "E-Signature",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xFF4A4848),
                                  fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                      .fontFamily))),
                    ),
                  ],
                ),
                SignatureBox(sigController: _sigController),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
            )
          ],
        ));
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
      width: 90,
      height: 35,
      child: OutlinedButton(

        style: ButtonStyle(
          side: MaterialStateProperty.all(
              BorderSide(color: Color(0xFF0069C1), width: 1.6, style: BorderStyle.solid)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
        ),

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
                        color: Color(0xFF0069C1),
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
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0069C1)),
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
        child: !signatureSaved
            ? Text(
                "Add",
                style: TextStyle(
                    color: Color(0xFF0069C1),
                    fontFamily: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ).fontFamily),
              )
            : Text(
                "Change",
                style: TextStyle(
                    color: Color(0xFF0069C1),
                    fontFamily: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ).fontFamily),
              ),
      ),
    );
  }
}
