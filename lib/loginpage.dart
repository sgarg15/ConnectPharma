import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => new _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _passwordVisible = true;

  String _password;

  @override
  void initState() {
    _passwordVisible = false;
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
            Align(
              alignment: Alignment(0, -0.4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //Email Text Field
                  Container(
                    width: 324,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
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
                      onSaved: (val) => _password = val,
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
            //Email Text Field
            /* Container(
              width: 324,
              alignment: Alignment(0, -0.3),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
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
                  hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: 16),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color(0xFFBDBDBD),
                  ),
                ),
              ),
            ),
            //Password Text Field
            Container(
              width: 324,
              alignment: Alignment(0, -0.035),
              child: TextFormField(
                onSaved: (val) => _password = val,
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
                  hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: 16),
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
            ),*/
          ],
        ),
      ),
    );
  }
}
