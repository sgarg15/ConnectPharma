import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pharma_connect/model/loginModel.dart';
import 'package:pharma_connect/model/user_model.dart';
import 'package:pharma_connect/src/providers/auth_provider.dart';
import 'package:pharma_connect/src/providers/login_provider.dart';

final logInProvider = StateNotifierProvider<LogInProvider, LogInModel>((ref) {
  return LogInProvider();
});

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ignore: unused_field
  late String _password, _email;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final logIn = watch(logInProvider);
        final authModel = watch(authProvider);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                //Back/LogIn/SignUp Widgets
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
                      //Log In Text
                      RichText(
                        text: TextSpan(
                          text: "Log In",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 35.0,
                              color: Colors.black),
                        ),
                      ),
                      //Sign Up Text
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            //Go to Sign Up Page
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
                        Container(
                          width: 324,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (emailAddress) {
                              context
                                  .read(logInProvider.notifier)
                                  .changeEmail(emailAddress);
                            },
                            decoration: InputDecoration(
                              errorText: logIn.emailErr.toString(),
                              filled: true,
                              fillColor: Color(0xFFF6F6F6),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Color(0xFFE8E8E8))),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFE8E8E8)),
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
                        ),
                        SizedBox(height: 10),
                        //Password
                        Container(
                          width: 324,
                          child: TextFormField(
                            obscureText: !logIn.passwordVisibility,
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (password) {
                              context
                                  .read(logInProvider.notifier)
                                  .changePassword(password);
                            },
                            decoration: InputDecoration(
                              errorText: logIn.emailErr.toString(),
                              filled: true,
                              fillColor: Color(0xFFF6F6F6),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Color(0xFFE8E8E8))),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFE8E8E8)),
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
                                icon: Icon(logIn.passwordVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                                color: Color(0xFFBDBDBD),
                                splashRadius: 1,
                                onPressed: () {
                                  context
                                      .read(logInProvider.notifier)
                                      .changePasswordVisibility(
                                          !logIn.passwordVisibility);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Google/Twitter/Facebook Icons
                Align(
                  alignment: Alignment(0, 0.31),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //Google
                      GestureDetector(
                        onTap: () {
                          //Log In using Google
                        },
                        child: SvgPicture.asset(
                          'assets/icons/GoogleIcon.svg',
                          width: 48,
                          height: 48,
                        ),
                      ),
                      //Facebook
                      GestureDetector(
                          onTap: () {
                            //Log In Using facebook
                          },
                          child: SvgPicture.asset(
                              'assets/icons/FacebookIcon.svg',
                              width: 48,
                              height: 48)),
                      SizedBox(width: 50),
                      //Twitter
                      GestureDetector(
                          onTap: () {
                            //Log In Using Facebook
                          },
                          child: SvgPicture.asset(
                              'assets/icons/TwitterIcon.svg',
                              width: 48,
                              height: 48)),
                    ],
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF5DB075)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ))),
                          onPressed:
                              (context.read(logInProvider.notifier).isValid())
                                  ? null
                                  : () async {
                                      UserModel? userModel = await authModel
                                          .signInWithEmailAndPassword(
                                              logIn.email.toString(),
                                              logIn.password.toString())
                                          .then((value) {
                                        if (value == null) {
                                          Get.snackbar("Error!",
                                              "There was an error Logging In the user. Please try again.");
                                        } else {
                                          print(value.uid);
                                          print(value.email);
                                          print(value.displayName);
                                          //Get.to(LoggedInScreen());
                                        }
                                      });
                                    },
                          child: RichText(
                            text: TextSpan(
                              text: "Log In",
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
