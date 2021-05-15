import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'all_used.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => new _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _passwordVisible = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ignore: unused_field
  String _password, _email;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      _passwordVisible = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Back/LogIn/SignUp Widgets
            Align(
              alignment: Alignment(0, -0.88),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
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
                  RichText(
                    text: TextSpan(
                      text: "Log In",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 35.0,
                          color: Colors.black),
                    ),
                  ),
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
            //Email/Password Text Fields
            Align(
              alignment: Alignment(0, -0.28),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //Email Text Field
                    Container(
                      width: 324,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please type in a valid email.';
                          }
                          _formKey.currentState.save();
                        },
                        onSaved: (input) {
                          _email = input;
                        },
                        decoration: InputDecoration(
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
                          hintStyle:
                              TextStyle(color: Color(0xFFBDBDBD), fontSize: 16),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color(0xFFBDBDBD),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //Password Text Field
                    Container(
                      width: 324,
                      child: TextFormField(
                        validator: (input) {
                          if (input.length < 6) {
                            return 'Please type in a password longer then 6 characters.';
                          }
                        },
                        onSaved: (input) => _password = input,
                        obscureText: !_passwordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF6F6F6),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFE8E8E8)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: 'Password',
                          hintStyle:
                              TextStyle(color: Color(0xFFBDBDBD), fontSize: 16),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Color(0xFFBDBDBD),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            color: Color(0xFFBDBDBD),
                            splashRadius: 1,
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
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
                      //Log In Using Google
                      googleAuthenticationLogIn(context);
                    },
                    child: SvgPicture.asset('assets/icons/GoogleIcon.svg',
                        width: 48, height: 48),
                  ),
                  SizedBox(width: 50),
                  //Facebook
                  GestureDetector(
                      onTap: () {
                        //Log In Using Twitter
                      },
                      child: SvgPicture.asset('assets/icons/FacebookIcon.svg',
                          width: 48, height: 48)),
                  SizedBox(width: 50),
                  //Twitter
                  GestureDetector(
                      onTap: () {
                        //Log In Using Facebook
                      },
                      child: SvgPicture.asset('assets/icons/TwitterIcon.svg',
                          width: 48, height: 48)),
                ],
              ),
            ),
            //Login Button/ Forgot password text
            Align(
              alignment: Alignment(0, 0.9),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 324,
                    height: 51,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF5DB075)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ))),
                      onPressed: () {
                        //Login to account and send to disgnated pharmacy or pharmacist page
                        logInEmail(_formKey, _email, _password, context);
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
  }
}
