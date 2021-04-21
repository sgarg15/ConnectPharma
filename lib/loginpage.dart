import 'package:flutter/material.dart';

class LogInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //Log In Text
            Container(
              alignment: Alignment(0, -0.85),
              child: RichText(
                text: TextSpan(
                  text: "Log In",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 35.0,
                      color: Colors.black),
                ),
              ),
            ),
            //Back Arrow Icon
            Container(
              alignment: Alignment(-0.93, -0.84),
              child: GestureDetector(
                child: Icon(Icons.keyboard_backspace,
                    size: 35.0, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            //Sign Up Text
            Container(
              alignment: Alignment(0.92, -0.817),
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
            ),
            Container(
              width: 320,
              alignment: Alignment(0, 0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF6F6F6),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red)),
                    hintText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.black45,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
