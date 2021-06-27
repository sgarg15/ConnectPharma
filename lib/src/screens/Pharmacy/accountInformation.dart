import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                      MaterialPageRoute(builder: (context) => PharmaConnect()),
                    );
                  },
                )
              ],
            );
          },
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}
