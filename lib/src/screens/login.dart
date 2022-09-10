import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/main.dart';
import 'package:connectpharma/model/loginModel.dart';
import 'package:connectpharma/src/providers/auth_provider.dart';
import 'package:connectpharma/src/providers/login_provider.dart';
import 'package:connectpharma/src/providers/user_provider.dart';
import 'package:connectpharma/src/screens/Pharmacist/Main/jobHistoryPharmacist.dart';
import 'package:connectpharma/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../all_used.dart';

final logInProvider = StateNotifierProvider<LogInProvider, LogInModel>((ref) {
  return LogInProvider();
});

final userProviderLogin = StateNotifierProvider<UserProvider, dynamic>((ref) => UserProvider());

final authProviderLogin = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class LogInPage extends ConsumerStatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool passwordVisibility = false;
  bool logginIn = false;

  final String backArrow = 'assets/icons/back-arrow.svg';
  final String logInDude = 'assets/icons/LoginDude.svg';
  final String emailIcon = 'assets/icons/emailIcon.svg';
  final String passwordIcon = 'assets/icons/passwordIcon.svg';
  final String cornerCircles = 'assets/icons/CornerDesigns.svg';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final logIn = ref.watch(logInProvider);
        final authModel = ref.watch(authProviderLogin);
        ref.watch(userProviderLogin);

        return WillPopScope(
          onWillPop: () async {
            print("Sending");
            Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectPharma()));
            return true;
          },
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: Stack(
                children: <Widget>[
                  //Designs
                  Container(
                      transform: Matrix4.translationValues(
                          MediaQuery.of(context).size.width * -0.55,
                          MediaQuery.of(context).size.height * -0.28,
                          0),
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

                  //Content
                  Center(
                    child: Column(
                      children: [
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
                                      //Login Picture
                                      SvgPicture.asset(logInDude),
                                      SizedBox(height: 30),

                                      //LogIn Text
                                      RichText(
                                        text: TextSpan(
                                          text: "Login",
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

                                      //Forgot Password
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.8,
                                        alignment: Alignment.centerRight,
                                        child: RichText(
                                          text: TextSpan(
                                            text: "Forgot your Password?",
                                            recognizer: new TapGestureRecognizer()
                                              ..onTap = () {
                                                if (ref.read(logInProvider.notifier).email == "") {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          "Error",
                                                          style: GoogleFonts.montserrat(),
                                                        ),
                                                        content:
                                                            Text("Please enter your email above"),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text("OK"),
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  ref
                                                      .read(authProviderLogin.notifier)
                                                      .sendPasswordResetEmail(
                                                          ref.read(logInProvider.notifier).email);
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          "Reset Password",
                                                          style: GoogleFonts.montserrat(),
                                                        ),
                                                        content: Text(
                                                            "An email will be sent to your email address with instructions on how to reset your password"),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text("OK"),
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF0069C1),
                                              fontFamily: GoogleFonts.montserrat(
                                                      fontWeight: FontWeight.normal)
                                                  .fontFamily,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 30),

                                      //Login Button
                                      logInButton(context, ref, authModel, logIn),
                                      SizedBox(height: 25),

                                      //Sign Up Text
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Don't have an account? ",
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
                                                          builder: (context) => ConnectPharma()));
                                                },
                                              text: "Sign Up",
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
                        )
                      ],
                    ),
                  )
                ],
              ),
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
                ref.read(logInProvider.notifier).changeEmail(emailAddress);
              },
              validator: (value) {
                if (!EmailValidator.validate(value!)) {
                  return "Incorrect Format";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: ref.read(logInProvider.notifier).email,
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
              ref.read(logInProvider.notifier).changePassword(password);
            },
            validator: (value) {
              if (value!.length < 6) {
                return "Password must be greater than 6 characters";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: ref.read(logInProvider.notifier).password,
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

  SizedBox logInButton(
      BuildContext context, WidgetRef ref, AuthProvider authModel, LogInModel logIn) {
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
        onPressed: (ref.read(logInProvider.notifier).isValidEmail() && !logginIn)
            ? () async {
                setState(() {
                  logginIn = true;
                });
                List? user = await authModel.signInWithEmailAndPassword(
                    logIn.email.toString(), logIn.password.toString());
                print("----------User[0]----: ${user?[0]}");
                if (user?[0] == null) {
                  var errorMessage = "";
                  print("Error MEssage: ${user?[2]}");
                  if (user?[2] == "user-disabled") {
                    setState(() {
                      errorMessage =
                          "Your account has been momentarilly disabled for unsolicited behaviour towards a pharmacy or pharmacist. If you think this is a mistake, please email __, with your name and email.";
                    });
                  } else if (user?[2] == "user-not-found") {
                    setState(() {
                      errorMessage =
                          "A user by that email address was not found, please re-check the email and assure you have created an account through the sign up pages.";
                    });
                  } else if (user?[2] == "wrong-password") {
                    setState(() {
                      errorMessage =
                          "Please check your email and password and try logging in again after a few minutes.";
                    });
                  } else if (user?[2] == "user-not-verified") {
                    setState(() {
                      errorMessage = "Before logging in, please verify your email.";
                    });
                  } else {
                    setState(() {
                      errorMessage = "There was an unexpected error. Please try again.";
                    });
                  }
                  showErrorDialog(context, errorMessage);

                  setState(() {
                    logginIn = false;
                  });
                } else if (user?[1] == "Pharmacist") {
                  print("Pharmacist");
                  ref.read(logInProvider.notifier).clearEmailAndPassword();
                  ref.read(userProviderLogin.notifier).changeUserUID(user?[0].user.uid.toString());

                  //send to pharmacist main page
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => JobHistoryPharmacist()));
                } else if (user?[1] == "Pharmacy") {
                  print("Pharmacy");

                  ref.read(logInProvider.notifier).clearEmailAndPassword();
                  ref.read(userProviderLogin.notifier).changeUserUID(user?[0].user.uid.toString());

                  //send to pharmacy main page
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => JobHistoryPharmacy()));
                }
              }
            : null,
        child: RichText(
          text: TextSpan(
            text: "Log In",
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

  Future<dynamic> showErrorDialog(BuildContext context, String errorMessage) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                  child: Text(
                "Login Failed",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.w500).fontFamily),
              )),
              content: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextButton(
                        child: Center(
                            child: Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white),
                        )),
                        style: ButtonStyle(backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Color(0xFF0069C1);
                          } else if (states.contains(MaterialState.disabled)) {
                            return Colors.grey;
                          }
                          return Color(0xFF0069C1);
                        })),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }
}
