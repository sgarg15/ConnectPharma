import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/model/pharmacySignUpModel.dart';
import 'package:pharma_connect/src/providers/auth_provider.dart';
import 'package:pharma_connect/src/providers/pharmacy_signup_provider.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Sign Up/2accountInformation.dart';
import 'package:pharma_connect/src/screens/login.dart';

import '../../../../all_used.dart';

final pharmacySignUpProvider =
    StateNotifierProvider<PharmacySignUpProvider, PharmacySignUpModel>((ref) {
  return PharmacySignUpProvider();
});

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class PharmacySignUpPage extends StatefulWidget {
  const PharmacySignUpPage({Key? key}) : super(key: key);

  @override
  _PharmacySignUpPageState createState() => _PharmacySignUpPageState();
}

class _PharmacySignUpPageState extends State<PharmacySignUpPage> {
  bool checkedValue = false;
  bool passwordVisibility = false;

  //String _password, _email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        watch(pharmacySignUpProvider);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                //Back/Sign up/Log In Widgets
                Align(
                  alignment: Alignment(0, -0.88),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //Back Button
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          child: Icon(Icons.keyboard_backspace,
                              size: 35.0, color: Colors.grey),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      //Sign Up Text
                      RichText(
                        text: TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 35.0,
                              color: Colors.black),
                        ),
                      ),
                      //Log In Text
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            //Go to Log In Page
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LogInPage()));
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Log In",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0,
                                  color: Color(0xFF5DB075)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                //Email/Password Widgets
                Align(
                  alignment: Alignment(0, -0.28),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        //Email
                        CustomFormField(
                          hintText: "Email",
                          decoration: false,
                          keyboardStyle: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          onChanged: (String emailAddress) {
                            context
                                .read(pharmacySignUpProvider.notifier)
                                .changeEmail(emailAddress);
                          },
                          validation: (value) {
                            if (!EmailValidator.validate(value)) {
                              return "Incorrect Format";
                            }
                            return null;
                          },
                          initialValue: context
                              .read(pharmacySignUpProvider.notifier)
                              .email,
                          inputDecoration: InputDecoration(
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Color(0xFFE8E8E8))),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Color(0xFFE8E8E8))),
                            filled: true,
                            fillColor: Color(0xFFF6F6F6),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Color(0xFFE8E8E8))),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFE8E8E8)),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(
                                color: Color(0xFFBDBDBD), fontSize: 16),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xFFBDBDBD),
                            ),
                          ),
                        ),

                        //Password
                        CustomFormField(
                          hintText: "Password",
                          obscureText: !passwordVisibility,
                          textCapitalization: TextCapitalization.none,
                          decoration: false,
                          keyboardStyle: TextInputType.emailAddress,
                          onChanged: (String password) {
                            context
                                .read(pharmacySignUpProvider.notifier)
                                .changePassword(password);
                          },
                          validation: (value) {
                            if (value!.length < 6) {
                              return "Password must be greater than 6 characters";
                            }
                            return null;
                          },
                          initialValue: context
                              .read(pharmacySignUpProvider.notifier)
                              .password,
                          inputDecoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFF6F6F6),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Color(0xFFE8E8E8))),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Color(0xFFE8E8E8))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Color(0xFFE8E8E8))),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFE8E8E8)),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                                color: Color(0xFFBDBDBD), fontSize: 16),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Color(0xFFBDBDBD),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              color: Color(0xFFBDBDBD),
                              splashRadius: 1,
                              onPressed: () {
                                setState(() {
                                  passwordVisibility = !passwordVisibility;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                        //Newsletter Check Box
                        CheckboxListTile(
                          title: RichText(
                            text: TextSpan(
                              text:
                                  "I would like to receive your newsletter and other promotional information.",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14.0,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                          activeColor: Color(0xFF5DB075),
                          value: checkedValue,
                          onChanged: (newValue) {
                            //todo: Save the check value information to save to account
                            setState(() {
                              checkedValue = newValue!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ],
                    ),
                  ),
                ),

                //Sign Up Button
                Align(
                  alignment: Alignment(0, 0.87),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //Sign Up Button
                      SizedBox(
                        width: 324,
                        height: 51,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Color(0xFF5DB075);
                                  else if (states
                                      .contains(MaterialState.disabled))
                                    return Colors.grey;
                                  return Color(
                                      0xFF5DB075); // Use the component's default.
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ))),
                          onPressed: (context
                                  .read(pharmacySignUpProvider.notifier)
                                  .isValidSignUp())
                              ? null
                              : () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AccountInformationPharmacy()));
                                },
                          child: RichText(
                            text: TextSpan(
                              text: "Sign Up as a pharmacy",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
