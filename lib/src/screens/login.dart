import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/main.dart';
import 'package:pharma_connect/model/loginModel.dart';
import 'package:pharma_connect/src/providers/auth_provider.dart';
import 'package:pharma_connect/src/providers/login_provider.dart';
import 'package:pharma_connect/src/providers/user_provider.dart';
import 'package:pharma_connect/src/screens/Pharmacist/Main/jobHistoryPharmacist.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Main/jobHistoryPharmacy.dart';

import '../../all_used.dart';

final logInProvider = StateNotifierProvider<LogInProvider, LogInModel>((ref) {
  return LogInProvider();
});

final userProviderLogin = StateNotifierProvider((ref) => UserProvider());

final authProviderLogin = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool passwordVisibility = false;
  bool logginIn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final logIn = watch(logInProvider);
        final authModel = watch(authProviderLogin);
        watch(userProviderLogin);

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
                          text: "Log In",
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
                                    builder: (context) => PharmaConnect()));
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Sign Up",
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
                                .read(logInProvider.notifier)
                                .changeEmail(emailAddress);
                          },
                          validation: (value) {
                            if (!EmailValidator.validate(value)) {
                              return "Incorrect Format";
                            }
                            return null;
                          },
                          initialValue:
                              context.read(logInProvider.notifier).email,
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
                          keyboardStyle: TextInputType.text,
                          onChanged: (String password) {
                            context
                                .read(logInProvider.notifier)
                                .changePassword(password);
                          },
                          validation: (value) {
                            if (value!.length < 6) {
                              return "Password must be greater than 6 characters";
                            }
                            return null;
                          },
                          initialValue:
                              context.read(logInProvider.notifier).password,
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
                      ],
                    ),
                  ),
                ),

                //LogIn Button/Forgot Password Text
                Align(
                  alignment: Alignment(0, 0.9),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //LogIn Button
                      SizedBox(
                        width: 324,
                        height: 51,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled))
                                    return Colors.grey;
                                  else {
                                    return Color(0xFF5DB075);
                                  }
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ))),
                          onPressed: (!context
                                      .read(logInProvider.notifier)
                                      .isValid() &&
                                  !logginIn)
                              ? () async {
                                  setState(() {
                                    logginIn = true;
                                  });
                                  List? user = await authModel
                                      .signInWithEmailAndPassword(
                                          logIn.email.toString(),
                                          logIn.password.toString());
                                  if (user?[0] == null) {
                                    var errorMessage = "";
                                    print(user?[2]);
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
                                    } else if (user?[2] ==
                                        "user-not-verified") {
                                      setState(() {
                                        errorMessage =
                                            "Before logging in, please verify your email.";
                                      });
                                    } else {
                                      setState(() {
                                        errorMessage =
                                            "There was an unexpected error. Please try again.";
                                      });
                                    }
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Error"),
                                              content: Text(errorMessage),
                                              actions: <Widget>[
                                                new TextButton(
                                                  child: new Text("Ok"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ));

                                    setState(() {
                                      logginIn = false;
                                    });
                                  } else if (user?[1] == "Pharmacist") {
                                    print("Pharmacist");
                                    context
                                        .read(logInProvider.notifier)
                                        .clearAllValue();
                                    context
                                        .read(userProviderLogin.notifier)
                                        .changeUserUID(
                                            user?[0].user.uid.toString());

                                    //send to pharmacist main page
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                JobHistoryPharmacist()));
                                  } else if (user?[1] == "Pharmacy") {
                                    print("Pharmacy");

                                    context
                                        .read(logInProvider.notifier)
                                        .clearAllValue();
                                    context
                                        .read(userProviderLogin.notifier)
                                        .changeUserUID(
                                            user?[0].user.uid.toString());

                                    //send to pharmacy main page
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                JobHistoryPharmacy()));
                                  }
                                }
                              : null,
                          child: RichText(
                            text: TextSpan(
                              text: logginIn ? "Loading..." : "Log In",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //Forget Password
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          child: RichText(
                            text: TextSpan(
                              text: "Forgot your password?",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: Color(0xFF5DB075),
                              ),
                            ),
                          ),
                          onTap: () {
                            //Push to Forgot password screen
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
}
