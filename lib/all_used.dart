import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class formField extends StatelessWidget {
  String? fieldTitle;
  String? hintText;
  TextInputType? keyboardStyle;
  Function(String)? onChanged;
  String? initialValue;
  FormFieldValidator? validation;
  TextEditingController? controller;
  bool decoration;
  InputDecoration? inputDecoration;
  TextCapitalization? textCapitalization;
  bool obscureText;
  List<TextInputFormatter>? formatter;

  formField({
    this.fieldTitle,
    this.hintText,
    this.keyboardStyle,
    this.onChanged,
    this.initialValue,
    this.validation,
    this.controller,
    this.decoration = true,
    this.inputDecoration,
    this.textCapitalization,
    this.obscureText = false,
    this.formatter,
  });

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
            inputFormatters: formatter,
            obscureText: obscureText,
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: initialValue,
            textAlignVertical: TextAlignVertical.center,
            textCapitalization:
                textCapitalization ?? TextCapitalization.sentences,
            keyboardType: keyboardStyle,
            onChanged: onChanged,
            validator: validation,
            decoration: inputDecoration ??
                InputDecoration(
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

          decoration: decoration
              ? BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0.3, 3),
                        blurRadius: 3.0,
                        spreadRadius: 0.5,
                        color: Colors.grey.shade400)
                  ],
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade200,
                )
              : null,
        ),
      ],
    );
  }
}

class Software {
  int id;
  String name;

  Software({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    return "$name";
  }
}

class Skill {
  final int id;
  final String name;

  Skill({
    required this.id,
    required this.name,
  });
  @override
  String toString() {
    return "$name";
  }
}

class Language {
  final int id;
  final String name;

  Language({
    required this.id,
    required this.name,
  });
  @override
  String toString() {
    return "$name";
  }
}

List<Software> software = [
  Software(id: 1, name: "A and H"),
  Software(id: 1, name: "Applied Robotics"),
  Software(id: 1, name: "Applied Technology"),
  Software(id: 1, name: "Auto-Ned"),
  Software(id: 1, name: "Centricity"),
  Software(id: 1, name: "Cerner/Pharmnet"),
  Software(id: 1, name: "Connexus"),
  Software(id: 1, name: "Delta"),
  Software(id: 1, name: "Epic"),
  Software(id: 1, name: "Kroll"),
];

List<Skill> skill = [
  Skill(id: 1, name: "Additional Prescribing Authorization"),
  Skill(id: 1, name: "Blister Pack"),
  Skill(id: 1, name: "Cash Trained"),
  Skill(id: 1, name: "Diabetes Education"),
  Skill(id: 1, name: "Injection Certified"),
  Skill(id: 1, name: "Interpreting Lab Results"),
  Skill(id: 1, name: "Medication Review"),
  Skill(id: 1, name: "Methadone/Suboxone"),
  Skill(id: 1, name: "Minor Ailment Prescribing"),
  Skill(id: 1, name: "Respiratory Education"),
  Skill(id: 1, name: "Smoking Cessation"),
  Skill(id: 1, name: "Speciality Compounding"),
  Skill(id: 1, name: "Sterile IV Compounding"),
  Skill(id: 1, name: "Travel Health Education"),
];

List<Language> language = [
  Language(id: 1, name: "Arabic"),
  Language(id: 1, name: "Bengali"),
  Language(id: 1, name: "Cantonese"),
  Language(id: 1, name: "Chinese"),
  Language(id: 1, name: "Chinese"),
  Language(id: 1, name: "Croatian"),
  Language(id: 1, name: "English"),
  Language(id: 1, name: "French"),
  Language(id: 1, name: "German"),
  Language(id: 1, name: "Greek"),
  Language(id: 1, name: "Gujarati"),
  Language(id: 1, name: "Hindi"),
  Language(id: 1, name: "Hungarian"),
  Language(id: 1, name: "Italian"),
  Language(id: 1, name: "Korean"),
  Language(id: 1, name: "Mandarin"),
  Language(id: 1, name: "Persian"),
  Language(id: 1, name: "Polish"),
  Language(id: 1, name: "Portuguese"),
  Language(id: 1, name: "Punjabi"),
  Language(id: 1, name: "Romanian"),
  Language(id: 1, name: "Russian"),
  Language(id: 1, name: "Serbian"),
  Language(id: 1, name: "Somali"),
  Language(id: 1, name: "Spanish"),
  Language(id: 1, name: "Tagalog"),
  Language(id: 1, name: "Tamil"),
  Language(id: 1, name: "Turkish"),
  Language(id: 1, name: "Ukrainian"),
  Language(id: 1, name: "Urdu"),
  Language(id: 1, name: "Vietnamese"),
];

String getInitials(String? firstName, String? lastName) {
  String initials = "";
  if (firstName == null || lastName == null) {
    return "N/A";
  }
  int numWords = 2;

  if (numWords < firstName.length) {
    numWords = firstName.length;
  }
  initials = firstName[0] + lastName[0];

  return initials;
}
