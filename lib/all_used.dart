import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class formField extends StatelessWidget {
  String? fieldTitle;
  String? hintText;
  TextInputType? keyboardStyle;
  Function(String)? onChanged;
  String? initialValue;
  FormFieldValidator? validation;
  TextEditingController? controller;

  formField(
      {this.fieldTitle,
      this.hintText,
      this.keyboardStyle,
      this.onChanged,
      this.initialValue,
      this.validation,
      this.controller});

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
          //height: 50,
          child: TextFormField(
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: initialValue,
            textAlignVertical: TextAlignVertical.bottom,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: keyboardStyle,
            onChanged: onChanged,
            validator: validation,
            decoration: InputDecoration(
              errorStyle: TextStyle(fontWeight: FontWeight.w500),
              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 30),
              filled: true,
              fillColor: Color(0xFFF0F0F0),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFE8E8E8))),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFE8E8E8))),
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

          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0.3,5),
                  blurRadius: 3.0,
                  spreadRadius: 0.5,
                  color: Colors.grey.shade400)
            ],
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }
}
