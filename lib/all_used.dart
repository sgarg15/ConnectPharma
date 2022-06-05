import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomFormField extends StatelessWidget {
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
  double containerWidth;
  double titleFont;

  CustomFormField({
    Key? key,
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
    this.containerWidth = 335,
    this.titleFont = 16,
  }) : super(key: key);

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
                fontSize: titleFont,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              )),
        ),
        const SizedBox(height: 10),
        Container(
          width: containerWidth,
          //height: 50,
          child: TextFormField(
            inputFormatters: formatter,
            obscureText: obscureText,
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: initialValue,
            textAlignVertical: TextAlignVertical.center,
            textCapitalization: textCapitalization ?? TextCapitalization.sentences,
            keyboardType: keyboardStyle,
            onChanged: onChanged,
            validator: validation,
            decoration: inputDecoration ??
                InputDecoration(
                  errorStyle: const TextStyle(fontWeight: FontWeight.w500),
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 30),
                  filled: true,
                  fillColor: const Color(0xFFF0F0F0),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE8E8E8))),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE8E8E8))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFE8E8E8))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: hintText,
                  hintStyle: GoogleFonts.inter(color: const Color(0xFFBDBDBD), fontSize: 16),
                ),
            style: GoogleFonts.inter(color: Colors.black, fontSize: 16),
          ),

          decoration: decoration
              ? BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0.3, 3),
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

// ignore: must_be_immutable
class CustomInputField extends StatelessWidget {
  String? fieldTitle;
  String? hintText;
  String? icon;
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
  double containerWidth;
  double titleFont;

  CustomInputField({
    Key? key,
    this.fieldTitle,
    this.hintText,
    this.icon,
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
    this.containerWidth = 335,
    this.titleFont = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                SvgPicture.asset(icon!, width: 21, height: 21),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: RichText(
                      text: TextSpan(
                          text: fieldTitle,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF4A4848),
                              fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal)
                                  .fontFamily))),
                ),
              ],
            ),
            TextFormField(
              keyboardType: keyboardStyle,
              textCapitalization: textCapitalization ?? TextCapitalization.sentences,
              onChanged: onChanged,
              validator: validation,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: initialValue,
              controller: controller,
              inputFormatters: formatter,
              decoration: InputDecoration(
                isDense: true,
                hintText: hintText,
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
    return name;
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
    return name;
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
    return name;
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

Dio dio = Dio();
final String? googleMapsKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
final apiKey = googleMapsKey;

Future<Location> getLocationFromAddress(String address) async {
  List<Location> locations = await locationFromAddress(address);
  //print(address);
  //print(locations.first);
  return locations.first;
}

List<String> getHourDiff(TimeOfDay tod1, TimeOfDay tod2) {
  var totalDifferenceInMin = (tod1.hour * 60 + tod1.minute) - (tod2.hour * 60 + tod2.minute);
  var leftOverminutes = (totalDifferenceInMin % 60);
  var totalHours = ((totalDifferenceInMin - leftOverminutes) / 60).abs().toStringAsFixed(0);
  if (leftOverminutes == 0) {
    return [totalHours, ""];
  } else {
    return [totalHours, " " + leftOverminutes.toString() + " mins"];
  }
}

Future getDistance(Map pharmacyData, String pharmacistAddress) async {
  var distance = "";
  Location startingLocation = await getLocationFromAddress(pharmacyData["pharmacyAddress"]
          ["streetAddress"] +
      " " +
      pharmacyData["pharmacyAddress"]["city"] +
      " " +
      pharmacyData["pharmacyAddress"]["country"]);
  Location endingLocation = await getLocationFromAddress(pharmacistAddress);
  Response response = await dio.get(
      "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${startingLocation.latitude},${startingLocation.longitude}&destinations=${endingLocation.latitude},${endingLocation.longitude}&key=$apiKey");
  //print(response);
  if (response.data != null) {
    distance =
        double.parse("${response.data["rows"][0]["elements"][0]["distance"]["value"] / 1000}")
            .toStringAsFixed(2);
  } else {
    distance = "";
  }
  //print(distance);

  if (distance == "0.00") {
    return "Close by in ${pharmacyData["pharmacyAddress"]["city"]}";
  } else {
    return distance + " km";
  }
}
