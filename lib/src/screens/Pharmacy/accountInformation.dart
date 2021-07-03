import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma_connect/all_used.dart';
import 'package:pharma_connect/model/pharmacySignUpModel.dart';
import 'package:pharma_connect/src/providers/auth_provider.dart';
import 'package:pharma_connect/src/providers/pharmacy_signup_provider.dart';
import 'package:pharma_connect/src/screens/Pharmacy/pharmacyInformation.dart';
import 'package:signature/signature.dart';

import '../../../main.dart';

final pharmacySignUpProvider =
    StateNotifierProvider<PharmacySignUpProvider, PharmacySignUpModel>((ref) {
  return PharmacySignUpProvider();
});

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class AccountInformationPharmacy extends StatefulWidget {
  const AccountInformationPharmacy({Key? key}) : super(key: key);

  @override
  _AccountInformationPharmacyState createState() =>
      _AccountInformationPharmacyState();
}

class _AccountInformationPharmacyState
    extends State<AccountInformationPharmacy> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignatureController _sigController = SignatureController(
    penStrokeWidth: 3, //you can set pen stroke with by changing this value
    penColor: Colors.black, // change your pen color
    exportBackgroundColor:
        Colors.white, //set the color you want to see in final result
  );

  @override
  Widget build(BuildContext context) {
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
                      // Direct to whichever they are in Information Form pages
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PharmaConnect()),
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
          title: new Text(
            "Account Owner Information",
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
                          "Please provide us with the primary contact information for your Pharma Connect account.",
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
                      formField(
                        fieldTitle: "First Name",
                        hintText: "Enter your First Name...",
                        keyboardStyle: TextInputType.name,
                        onChanged: (String firstName) {
                          context
                              .read(pharmacySignUpProvider.notifier)
                              .changeFirstName(firstName);
                        },
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is required";
                          }
                          return null;
                        },
                        initialValue: context
                            .read(pharmacySignUpProvider.notifier)
                            .firstName,
                      ),
                      SizedBox(height: 20),

                      //Last Name
                      formField(
                        fieldTitle: "Last Name",
                        hintText: "Enter your Last Name...",
                        keyboardStyle: TextInputType.name,
                        onChanged: (String lastName) {
                          context
                              .read(pharmacySignUpProvider.notifier)
                              .changeLastName(lastName);
                        },
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is required";
                          }
                          return null;
                        },
                        initialValue: context
                            .read(pharmacySignUpProvider.notifier)
                            .lastName,
                      ),
                      SizedBox(height: 20),

                      //Phone Number
                      formField(
                        fieldTitle: "Phone Number",
                        hintText: "Enter your Phone Number...",
                        keyboardStyle: TextInputType.number,
                        onChanged: (String phoneNumber) {
                          context
                              .read(pharmacySignUpProvider.notifier)
                              .changePhoneNumber(phoneNumber);
                        },
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is required";
                          }
                          return null;
                        },
                        initialValue: context
                            .read(pharmacySignUpProvider.notifier)
                            .phoneNumber,
                      ),
                      SizedBox(height: 20),

                      //Position Drop Box
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                            text: "Position",
                            style: GoogleFonts.questrial(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 335,
                        constraints:
                            BoxConstraints(maxHeight: 60, minHeight: 50),
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
                            value: context
                                .read(pharmacySignUpProvider.notifier)
                                .position,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF0F0F0),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Color(0xFFE8E8E8))),
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
                              context
                                  .read(pharmacySignUpProvider.notifier)
                                  .changePosition(value);
                            },
                            style: GoogleFonts.questrial(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                      ),

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

              //Next Button
              Center(
                child: Consumer(
                  builder: (context, watch, child) {
                    final pharmacySignUp = watch(pharmacySignUpProvider);
                    return SizedBox(
                      width: 324,
                      height: 51,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey; // Disabled color
                              }
                              return Color(0xFF5DB075); // Regular color
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ))),
                        onPressed: (context
                                .read(pharmacySignUpProvider.notifier)
                                .isValidAccountInfo())
                            ? null
                            : () {
                                print("Pressed");
                                print("First Name: " +
                                    context
                                        .read(pharmacySignUpProvider.notifier)
                                        .firstName
                                        .toString());
                                print("Last Name: " +
                                    context
                                        .read(pharmacySignUpProvider.notifier)
                                        .lastName
                                        .toString());
                                print("Phone Number: " +
                                    context
                                        .read(pharmacySignUpProvider.notifier)
                                        .phoneNumber
                                        .toString());
                                print("Position: " +
                                    context
                                        .read(pharmacySignUpProvider.notifier)
                                        .position
                                        .toString());

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PharmacyInformation()));
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
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class SignatureBox extends StatelessWidget {
  const SignatureBox({
    Key? key,
    required SignatureController sigController,
  })  : _sigController = sigController,
        super(key: key);

  final SignatureController _sigController;

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
                      controller: _sigController,
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
                              context
                                  .read(pharmacySignUpProvider.notifier)
                                  .changeSignature((_sigController.isNotEmpty)
                                      ? await _sigController.toPngBytes()
                                      : null);

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
                              _sigController.clear();
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
        child: Text("Add"),
      ),
    );
  }
}
