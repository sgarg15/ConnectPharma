import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma_connect/Sign%20Up%20Information%20Pages/Pharmacy/PharmacyInformation.dart';
import 'package:pharma_connect/all_used.dart';
import 'package:signature/signature.dart';
import '../../main.dart';

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
    penStrokeWidth: 3, //you can set pen stroke with by changing this value
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
                        Container(
                          width: 100,
                          height: 40,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFF5DB075)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
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
                                        height: 100,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 3,
                                            color: Color(0xFF5DB075),
                                          ),
                                        ),
                                        child: Signature(
                                          controller: _controller,
                                          height: 100,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              20,
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    //Buttons
                                    Material(
                                      child: Container(
                                        color: Colors.grey.shade200,
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        child: Row(
                                          //mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: 100,
                                              height: 31,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(left: 5),
                                              child: TextButton.icon(
                                                clipBehavior: Clip.none,
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Color(0xFF5DB075)),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 13,
                                                ),
                                                label: Text(
                                                  "Apply",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerRight,
                                              width: 100,
                                              height: 35,
                                              child: TextButton(
                                                onPressed: () {
                                                  _controller.clear();
                                                },
                                                child: Text(
                                                  "Reset",
                                                  style: TextStyle(
                                                      color: Colors.grey),
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
                        ),
                        SizedBox(height: 20),
                        //Next Button
                        SizedBox(
                          width: 324,
                          height: 51,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFF5DB075)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ))),
                            onPressed: () {
                              //Go to Next sign up form page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PharmacyInformation()),
                              );
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
                ),
              ],
            )),
      ),
    );
  }
}
