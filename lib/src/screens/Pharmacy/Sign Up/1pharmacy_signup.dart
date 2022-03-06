import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/model/pharmacySignUpModel.dart';
import 'package:connectpharma/src/providers/auth_provider.dart';
import 'package:connectpharma/src/providers/pharmacy_signup_provider.dart';
import 'package:connectpharma/src/screens/Pharmacy/Sign Up/2accountInformation.dart';
import 'package:connectpharma/src/screens/login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import '../../../../all_used.dart';

final pharmacySignUpProvider =
    StateNotifierProvider<PharmacySignUpProvider, PharmacySignUpModel>((ref) {
  return PharmacySignUpProvider();
});

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class PharmacySignUpPage extends ConsumerStatefulWidget {
  const PharmacySignUpPage({Key? key}) : super(key: key);

  @override
  _PharmacySignUpPageState createState() => _PharmacySignUpPageState();
}

class _PharmacySignUpPageState extends ConsumerState<PharmacySignUpPage> {
  bool checkedValue = false;
  bool passwordVisibility = false;

  final String backArrow = 'assets/icons/back-arrow.svg';
  final String singUpDude = 'assets/icons/sign-up.svg';
  final String emailIcon = 'assets/icons/emailIcon.svg';
  final String passwordIcon = 'assets/icons/passwordIcon.svg';
  final String cornerCircles = 'assets/icons/CornerDesigns.svg';

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(pharmacySignUpProvider);

        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Stack(
              children: <Widget>[
                Container(
                    transform: Matrix4.translationValues(MediaQuery.of(context).size.width * -0.55,
                        MediaQuery.of(context).size.height * -0.28, 0),
                    child: SvgPicture.asset(cornerCircles)),
                Container(
                    transform: Matrix4.translationValues(MediaQuery.of(context).size.width * 0.65,
                        MediaQuery.of(context).size.height * 0.77, 0),
                    child: SvgPicture.asset(cornerCircles)),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 50),
                  child: GestureDetector(
                    child: SvgPicture.asset(backArrow),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
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
                                    SvgPicture.asset(singUpDude),
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
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      child: CheckboxListTile(
                                        selectedTileColor: Color(0xFF0069C1),
                                        activeColor: Color(0xFF0069C1),
                                        contentPadding: EdgeInsets.only(left: 0, right: 0),
                                        title: Transform.translate(
                                          offset: Offset(-10, 0),
                                          child: RichText(
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
                                        ),
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
                                    ),
                                    SizedBox(height: 20),

                                    //Sign Up Button
                                    signUpButton(context, ref),
                                    SizedBox(height: 20),

                                    //Sign Up Text
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Already have an Account? ",
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
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => LogInPage()));
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
                          },
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

  Container emailField(BuildContext context, WidgetRef ref) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                SvgPicture.asset(emailIcon, width: 15, height: 15),
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
                ref.read(pharmacySignUpProvider.notifier).changeEmail(emailAddress);
              },
              validator: (value) {
                if (!EmailValidator.validate(value!)) {
                  return "Incorrect Format";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: ref.read(pharmacySignUpProvider.notifier).email,
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
              SvgPicture.asset(passwordIcon, width: 25, height: 25),
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
              ref.read(pharmacySignUpProvider.notifier).changePassword(password);
            },
            validator: (value) {
              if (value!.length < 6) {
                return "Password must be greater than 6 characters";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: ref.read(pharmacySignUpProvider.notifier).password,
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
      width: MediaQuery.of(context).size.width * 0.8,
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
        onPressed: (ref.read(pharmacySignUpProvider.notifier).isValidSignUp())
            ? null
            : () async {
                List<String> signInMethod = await FirebaseAuth.instance
                    .fetchSignInMethodsForEmail(ref.read(pharmacySignUpProvider.notifier).email);
                if (signInMethod.isNotEmpty) {
                  print("-----------------ERROR------------------");
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AccountInformationPharmacy()));
                }
              },
        child: RichText(
          text: TextSpan(
            text: "Sign Up as a Pharmacy",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.w600).fontFamily,
            ),
          ),
        ),
      ),
    );
  }

}
