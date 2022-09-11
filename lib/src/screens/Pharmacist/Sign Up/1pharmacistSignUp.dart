import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/model/userSignUpModel.dart';
import 'package:connectpharma/src/providers/auth_provider.dart';
import 'package:connectpharma/src/providers/user_signUp_provider.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign Up/2pharmacistLocation.dart';
import 'package:connectpharma/src/screens/login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../all_used.dart';

final userSignUpProvider =
    StateNotifierProvider<UserSignUpProvider, UserSignUpModel>((ref) {
  return UserSignUpProvider();
});

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class UserSignUpPage extends ConsumerStatefulWidget {
  String userType = "";
  UserSignUpPage({Key? key, required this.userType}) : super(key: key);

  @override
  _UserSignUpPageState createState() => _UserSignUpPageState();
}

class _UserSignUpPageState extends ConsumerState<UserSignUpPage> {
  bool checkedValue = false;
  bool passwordVisibility = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(userSignUpProvider.notifier).changeUserType(widget.userType);
      print("User Type: ${ref.read(userSignUpProvider.notifier).userType}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(userSignUpProvider);
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: _buildBody(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        Container(
            transform: Matrix4.translationValues(MediaQuery.of(context).size.width * -0.55,
                MediaQuery.of(context).size.height * -0.28, 0),
            child: SvgPicture.asset(CustomIcons.cornerCircles)),
        Container(
            transform: Matrix4.translationValues(MediaQuery.of(context).size.width * 0.65,
                MediaQuery.of(context).size.height * 0.77, 0),
            child: SvgPicture.asset(CustomIcons.cornerCircles)),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 50),
          child: GestureDetector(
            child: SvgPicture.asset(CustomIcons.backArrow),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        Center(
          child: Column(
            children: <Widget>[
              LayoutBuilder(
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
                          constraints.maxHeight > 700
                              ? SizedBox(height: 150)
                              : SizedBox(height: 70),
                          //Sign Up Picture
                          SvgPicture.asset(CustomIcons.singUpDude),
                          SizedBox(height: 30),

                          //Sign Up Text
                          RichText(
                            text: TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                  fontSize: 32.0,
                                  color: Color(0xFF4A4848),
                                  fontFamily: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                  ).fontFamily),
                            ),
                          ),
                          SizedBox(height: 30),

                          //Email Form
                          emailField(context, ref),
                          SizedBox(height: 30),

                          //Password Form
                          passwordField(context, ref),
                          SizedBox(height: 10),

                          //Newsletter Checkbox
                          newsLetterCheckbox(context),
                          SizedBox(height: 20),

                          //Sign Up Button
                          signUpButton(context, ref),
                          SizedBox(height: 20),

                          //Login Text
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: Color.fromARGB(169, 60, 60, 60),
                                      fontFamily: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w400,
                                      ).fontFamily),
                                ),
                                TextSpan(
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => LogInPage()));
                                    },
                                  text: "Login",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: Color(0xFF0069C1),
                                      fontFamily: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                      ).fontFamily),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //Seperated UI
  Column backgroundCircles() {
    return Column(
      children: [
        Container(
            transform: Matrix4.translationValues(MediaQuery.of(context).size.width * -0.55,
                MediaQuery.of(context).size.height * -0.28, 0),
            child: SvgPicture.asset(CustomIcons.cornerCircles)),
        Container(
            transform: Matrix4.translationValues(MediaQuery.of(context).size.width * 0.65,
                MediaQuery.of(context).size.height * 0.77, 0),
            child: SvgPicture.asset(CustomIcons.cornerCircles)),
      ],
    );
  }

  Container newsLetterCheckbox(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: CheckboxListTile(
        selectedTileColor: Color(0xFF0069C1),
        activeColor: Color(0xFF0069C1),
        contentPadding: EdgeInsets.only(left: 0, right: 0),
        title: Transform.translate(
          offset: Offset(-10, 0),
          child: RichText(
            text: TextSpan(
              text: "I would like to receive your newsletter and other promotional information.",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14.0,
                color: Color(0xFF666666),
              ),
            ),
          ),
        ),
        value: checkedValue,
        onChanged: (newValue) {
          //todo: Save the check value information to save to account
          setState(() {
            checkedValue = newValue!;
          });
        },
        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
    );
  }

  Container emailField(BuildContext context, WidgetRef ref) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                SvgPicture.asset(CustomIcons.emailIcon, width: 15, height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: RichText(
                      text: TextSpan(
                          text: "Email",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF4A4848),
                              fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                  .fontFamily))),
                ),
              ],
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              onChanged: (String emailAddress) {
                ref.read(userSignUpProvider.notifier).changeEmail(emailAddress);
              },
              validator: (value) {
                if (!EmailValidator.validate(value!)) {
                  return "Incorrect Format";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: ref.read(userSignUpProvider.notifier).email,
              decoration: InputDecoration(
                isDense: true,
                hintText: "abc@gmail.com",
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

  Container passwordField(BuildContext context, WidgetRef ref) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(CustomIcons.passwordIcon, width: 25, height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 6),
                child: RichText(
                    text: TextSpan(
                        text: "Password",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF4A4848),
                            fontFamily:
                                GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily))),
              ),
            ],
          ),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: !passwordVisibility,
            textCapitalization: TextCapitalization.none,
            onChanged: (String password) {
              ref.read(userSignUpProvider.notifier).changePassword(password);
            },
            validator: (value) {
              if (value!.length < 6) {
                return "Password must be greater than 6 characters";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: ref.read(userSignUpProvider.notifier).password,
            decoration: InputDecoration(
              suffixIconConstraints: BoxConstraints(minHeight: 40, minWidth: 40),
              suffixIcon: IconButton(
                padding: const EdgeInsets.only(top: 5),
                constraints: BoxConstraints(),
                icon: Icon(
                    passwordVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                color: Color(0xFFBDBDBD),
                splashRadius: 1,
                onPressed: () {
                  setState(() {
                    passwordVisibility = !passwordVisibility;
                  });
                },
              ),
              isDense: true,
              hintText: "............",
              hintStyle: TextStyle(
                fontSize: 14.0,
                color: Color(0xFFC6C6C6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox signUpButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.81,
      height: 51,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Color(0xFF0069C1);
                } else if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return Color(0xFF0069C1); // Use the component's default.
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ))),
        onPressed: (ref.read(userSignUpProvider.notifier).isValidPharmacistSignUp())
            ? () async {
                List<String> signInMethod = await FirebaseAuth.instance
                    .fetchSignInMethodsForEmail(ref.read(userSignUpProvider.notifier).email);
                if (signInMethod.isNotEmpty) {
                  print("Email already exists");
                  await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Error"),
                            content: Text(
                                "Sorry this email address already exists. Please use another address. \n\nThank you!"),
                            actions: <Widget>[
                              new TextButton(
                                child: new Text("Ok"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ));
                } else {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => PharmacistLocation()));
                }
              }
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.userType == "Pharmacist") ...[
              RichText(
                text: TextSpan(
                  text: "Sign Up as a Pharmacist",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.w600).fontFamily,
                  ),
                ),
              ),
            ] else if (widget.userType == "Pharmacy Assistant") ...[
              RichText(
                text: TextSpan(
                  text: "Sign Up as a Pharmacy Assistant",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.w600).fontFamily,
                  ),
                ),
              ),
            ] else if (widget.userType == "Pharmacy Technician") ...[
              RichText(
                text: TextSpan(
                  text: "Sign Up as a Pharmacy Technician",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.w600).fontFamily,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Align signUpInfo(WidgetRef ref) {
    return Align(
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
                ref.read(userSignUpProvider.notifier).changeEmail(emailAddress);
              },
              validation: (value) {
                if (!EmailValidator.validate(value)) {
                  return "Incorrect Format";
                }
                return null;
              },
              initialValue: ref.read(userSignUpProvider.notifier).email,
              inputDecoration: InputDecoration(
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                filled: true,
                fillColor: Color(0xFFF6F6F6),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE8E8E8)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: 16),
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
                ref.read(userSignUpProvider.notifier).changePassword(password);
              },
              validation: (value) {
                if (value!.length < 6) {
                  return "Password must be greater than 6 characters";
                }
                return null;
              },
              initialValue: ref.read(userSignUpProvider.notifier).password,
              inputDecoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF6F6F6),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE8E8E8)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: 'Password',
                hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: 16),
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
              activeColor: Color(0xFFF0069C1),
              value: checkedValue,
              onChanged: (newValue) {
                //todo: Save the check value information to save to account
                setState(() {
                  checkedValue = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ],
        ),
      ),
    );
  }

  Align signUpHeader(BuildContext context) {
    return Align(
      alignment: Alignment(0, -0.88),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //Back Button
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: GestureDetector(
              child: Icon(Icons.keyboard_backspace, size: 35.0, color: Colors.grey),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          //Sign Up Text
          RichText(
            text: TextSpan(
              text: "Sign Up",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 35.0, color: Colors.black),
            ),
          ),
          //Log In Text
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                //Go to Log In Page
                Navigator.push(context, MaterialPageRoute(builder: (context) => LogInPage()));
              },
              child: RichText(
                text: TextSpan(
                  text: "Log In",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 15.0, color: Color(0xFFF0069C1)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
