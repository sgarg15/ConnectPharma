import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class formField extends StatelessWidget {
  String? fieldTitle;
  String? hintText;
  TextEditingController? textController;
  TextInputType? keyboardStyle;

  formField(
      {this.fieldTitle,
      this.hintText,
      this.textController,
      this.keyboardStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
              text: fieldTitle,
              style: GoogleFonts.questrial(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              )),
        ),
        SizedBox(height: 10),
        Container(
          width: 335,
          height: 50,
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            child: TextFormField(
              //textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.bottom,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: keyboardStyle,
              controller: textController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF0F0F0),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFE8E8E8))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE8E8E8)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: hintText,
                hintStyle:
                    GoogleFonts.inter(color: Color(0xFFBDBDBD), fontSize: 16),
              ),
              style: GoogleFonts.inter(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
