import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma_connect/model/pharmacySignUpModel.dart';
import 'package:pharma_connect/src/providers/auth_provider.dart';
import 'package:pharma_connect/src/providers/pharmacy_signup_provider.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3, //you can set pen stroke with by changing this value
    penColor: Colors.black, // change your pen color
    exportBackgroundColor:
        Colors.white, //set the color you want to see in final result
  );
  String _dropdownValue = "";

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final pharmacySignUp = watch(pharmacySignUpProvider);
        final authModel = watch(authProvider);

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
                          authModel.signOut();
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
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              title: new Text(
                "Pharmacy",
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
                        children: <Widget>[],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
