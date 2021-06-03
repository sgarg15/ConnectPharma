import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma_connect/all_used.dart';
import 'package:signature/signature.dart';
import '../main.dart';

class PharmacySignUpInfoPage extends StatefulWidget {
  @override
  _PharmacySignUpInfoPage createState() => new _PharmacySignUpInfoPage();
}

class _PharmacySignUpInfoPage extends State<PharmacySignUpInfoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5, //you can set pen stroke with by changing this value
    penColor: Colors.black, // change your pen color
    exportBackgroundColor:
        Colors.white, //set the color you want to see in final result
  );

  String _dropdownValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        //TODO: REMOVE THIS ONCE EVERYTHING WORKS AND REPLACE IT INSIDE THE SIDE MENU
        return showDialog(
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
                      signOut();
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
      },
      child: new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
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
        body: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              //Page information Text
              Align(
                alignment: Alignment(0, -0.96),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
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
                      SizedBox(height: 30),
                      //First Name Field
                      formField(
                        fieldTitle: "First Name",
                        hintText: "Enter your First Name...",
                        textController: firstNameController,
                        keyboardStyle: TextInputType.name,
                      ),
                      SizedBox(height: 20),
                      //Last Name Field
                      formField(
                        fieldTitle: "Last Name",
                        hintText: "Enter your Last Name...",
                        textController: lastNameController,
                        keyboardStyle: TextInputType.name,
                      ),
                      SizedBox(height: 20),
                      //Phone Number Field
                      formField(
                        fieldTitle: "Phone Number",
                        hintText: "Enter your Phone Number...",
                        textController: phoneNumberController,
                        keyboardStyle: TextInputType.number,
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
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 335,
                          constraints:
                              BoxConstraints(maxHeight: 60, minHeight: 50),
                          child: DropdownButtonFormField<String>(
                              hint: Text(
                                "Select your Position...",
                                style: GoogleFonts.inter(
                                    color: Color(0xFFBDBDBD), fontSize: 16),
                              ),
                              value: _dropdownValue,
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
                              onChanged: (value) {
                                setState(() {
                                  _dropdownValue = value;
                                });
                              },
                              style: GoogleFonts.questrial(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
