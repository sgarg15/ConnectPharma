import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pharma_connect/src/screens/Pharmacist/1pharmacistSignUp.dart';
import 'package:pharma_connect/src/screens/Pharmacist/6photoInformation.dart';
import 'package:pharma_connect/src/screens/Pharmacist/1pharmacistSignUp.dart';
import 'package:signature/signature.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

class Software {
  final int id;
  final String name;

  Software({
    required this.id,
    required this.name,
  });
}

class Skill {
  final int id;
  final String name;

  Skill({
    required this.id,
    required this.name,
  });
}

class Language {
  final int id;
  final String name;

  Language({
    required this.id,
    required this.name,
  });
}

class PharmacistSkills extends StatefulWidget {
  PharmacistSkills({Key? key}) : super(key: key);

  @override
  _PharmacistSkillsState createState() => _PharmacistSkillsState();
}

class _PharmacistSkillsState extends State<PharmacistSkills> {
  static List<Software> _software = [
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

  static List<Skill> _skill = [
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

  static List<Language> _language = [
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

  final _softwareItems = _software
      .map((software) => MultiSelectItem<Software>(software, software.name))
      .toList();
  final _skillItems =
      _skill.map((skill) => MultiSelectItem<Skill>(skill, skill.name)).toList();

  final _languageItems = _language
      .map((language) => MultiSelectItem<Language>(language, language.name))
      .toList();

  final SignatureController _sigController = SignatureController(
    penStrokeWidth: 3, //you can set pen stroke with by changing this value
    penColor: Colors.black, // change your pen color
    exportBackgroundColor:
        Colors.white, //set the color you want to see in final result
  );

  bool filePicked = false;
  FilePickerResult? _result;
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: new Text(
          "Pharmacist Skills",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFF6F6F6),
        foregroundColor: Colors.black,
        elevation: 12,
        bottomOpacity: 1,
        shadowColor: Colors.black,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //Information Text
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(11, 10, 0, 0),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: "Software / Skills / Languages",
                    style: GoogleFonts.questrial(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(11, 10, 0, 0),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text:
                        "Please select all applicable skills, software and languages",
                    style: GoogleFonts.questrial(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            //All Fields
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Align(
                alignment: Alignment(-0.35, -0.70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Software
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text: "Software",
                              style: GoogleFonts.questrial(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 335,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0.3, 3),
                                  blurRadius: 3.0,
                                  spreadRadius: 0.5,
                                  color: Colors.grey.shade400)
                            ],
                            color: Color(0xFFF0F0F0),
                            border: Border.all(
                              color: Color(0xFFE8E8E8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: <Widget>[
                              MultiSelectBottomSheetField<Software?>(
                                selectedColor: Color(0xFF5DB075),
                                selectedItemsTextStyle:
                                    TextStyle(color: Colors.white),
                                initialChildSize: 0.4,
                                decoration: BoxDecoration(),
                                listType: MultiSelectListType.CHIP,
                                initialValue: context
                                    .read(pharmacistSignUpProvider.notifier)
                                    .softwareList,
                                searchable: true,
                                items: _softwareItems,
                                buttonText: Text("Select known software...",
                                    style: GoogleFonts.inter(
                                        color: Color(0xFFBDBDBD),
                                        fontSize: 16)),
                                onConfirm: (values) {
                                  context
                                      .read(pharmacistSignUpProvider.notifier)
                                      .changeSoftwareList(values);
                                },
                                chipDisplay: MultiSelectChipDisplay(
                                  items: context
                                      .read(pharmacistSignUpProvider.notifier)
                                      .softwareList
                                      ?.map((e) =>
                                          MultiSelectItem(e, e.toString()))
                                      .toList(),
                                  chipColor: Color(0xFF5DB075),
                                  onTap: (value) {
                                    context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .softwareList
                                        ?.remove(value);
                                    return context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .softwareList;
                                  },
                                  textStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    //Skill
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text: "Skill",
                              style: GoogleFonts.questrial(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 335,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0.3, 3),
                                  blurRadius: 3.0,
                                  spreadRadius: 0.5,
                                  color: Colors.grey.shade400)
                            ],
                            color: Color(0xFFF0F0F0),
                            border: Border.all(
                              color: Color(0xFFE8E8E8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: <Widget>[
                              MultiSelectBottomSheetField<Skill?>(
                                selectedColor: Color(0xFF5DB075),
                                selectedItemsTextStyle:
                                    TextStyle(color: Colors.white),
                                initialChildSize: 0.4,
                                decoration: BoxDecoration(),
                                listType: MultiSelectListType.CHIP,
                                initialValue: context
                                    .read(pharmacistSignUpProvider.notifier)
                                    .skillList,
                                searchable: true,
                                items: _skillItems,
                                buttonText: Text("Select your skills...",
                                    style: GoogleFonts.inter(
                                        color: Color(0xFFBDBDBD),
                                        fontSize: 16)),
                                onConfirm: (values) {
                                  context
                                      .read(pharmacistSignUpProvider.notifier)
                                      .changeSkillList(values);
                                },
                                chipDisplay: MultiSelectChipDisplay(
                                  items: context
                                      .read(pharmacistSignUpProvider.notifier)
                                      .skillList
                                      ?.map((e) =>
                                          MultiSelectItem(e, e.toString()))
                                      .toList(),
                                  chipColor: Color(0xFF5DB075),
                                  onTap: (value) {
                                    context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .skillList
                                        ?.remove(value);
                                    return context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .skillList;
                                  },
                                  textStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    //Language
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text: "Languages",
                              style: GoogleFonts.questrial(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 335,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0.3, 3),
                                  blurRadius: 3.0,
                                  spreadRadius: 0.5,
                                  color: Colors.grey.shade400)
                            ],
                            color: Color(0xFFF0F0F0),
                            border: Border.all(
                              color: Color(0xFFE8E8E8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: <Widget>[
                              MultiSelectBottomSheetField<Language?>(
                                selectedColor: Color(0xFF5DB075),
                                selectedItemsTextStyle:
                                    TextStyle(color: Colors.white),
                                initialChildSize: 0.4,
                                decoration: BoxDecoration(),
                                listType: MultiSelectListType.CHIP,
                                initialValue: context
                                    .read(pharmacistSignUpProvider.notifier)
                                    .languageList,
                                searchable: true,
                                items: _languageItems,
                                buttonText: Text("Select known languages...",
                                    style: GoogleFonts.inter(
                                        color: Color(0xFFBDBDBD),
                                        fontSize: 16)),
                                onConfirm: (values) {
                                  context
                                      .read(pharmacistSignUpProvider.notifier)
                                      .changeLanguageList(values);
                                },
                                chipDisplay: MultiSelectChipDisplay(
                                  items: context
                                      .read(pharmacistSignUpProvider.notifier)
                                      .languageList
                                      ?.map((e) =>
                                          MultiSelectItem(e, e.toString()))
                                      .toList(),
                                  chipColor: Color(0xFF5DB075),
                                  onTap: (value) {
                                    context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .languageList
                                        ?.remove(value);
                                    return context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .languageList;
                                  },
                                  textStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),

                    //Resume
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text: "Resume (PDF Only)",
                              style: GoogleFonts.questrial(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        SizedBox(height: 10),
                        if (context
                                .read(pharmacistSignUpProvider.notifier)
                                .resumePDFData !=
                            null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                width: 170,
                                height: 45,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>((states) {
                                        return Color(
                                            0xFF5DB075); // Regular color
                                      }),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ))),
                                  onPressed: () async {
                                    file = context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .resumePDFData;
                                    print(
                                        "FILE PATH: " + file!.path.toString());
                                    OpenFile.open(file!.path);
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      text: "View Resume",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 35),
                              SizedBox(
                                width: 100,
                                height: 45,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>((states) {
                                        return Color(
                                            0xFF5DB075); // Regular color
                                      }),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ))),
                                  onPressed: () async {
                                    setState(() {
                                      _result = null;
                                      file = null;
                                    });
                                    print(context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .firstName);
                                    context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .clearResumePDF();
                                    print(context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .firstName);
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Clear",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          SizedBox(
                            width: 270,
                            height: 45,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    return Color(0xFF5DB075); // Regular color
                                  }),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ))),
                              onPressed: () async {
                                try {
                                  _result = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf'],
                                    //withData: true,
                                  );
                                  if (_result!.files.first.path != null) {
                                    setState(() {
                                      filePicked = true;
                                    });
                                    file = File(
                                        _result!.files.first.path.toString());

                                    context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .changeResumePDF(file);
                                    print(context
                                        .read(pharmacistSignUpProvider.notifier)
                                        .resumePDFData);
                                  } else {
                                    // User canceled the picker
                                  }
                                } catch (error) {
                                  print("ERROR: " + error.toString());
                                  final snackBar = SnackBar(
                                    content: Text(
                                        'There was an error, please try again.'),
                                    duration: Duration(seconds: 3),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "Select Resume",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    SizedBox(height: 30),

                    //Signature Overlay
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                          text: "E-Signature",
                          style: GoogleFonts.questrial(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    SizedBox(height: 5),
                    SignatureBox(sigController: _sigController),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            //Next
            Center(
              child: Consumer(
                builder: (context, watch, child) {
                  watch(pharmacistSignUpProvider);
                  return SizedBox(
                    width: 324,
                    height: 51,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Colors.grey; // Disabled color
                            }
                            return Color(0xFF5DB075); // Regular color
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ))),
                      onPressed: (context
                              .read(pharmacistSignUpProvider.notifier)
                              .isValidPharmacistSkills())
                          ? null
                          : () {
                              print("Pressed");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PhotoInformation()));
                            },
                      child: RichText(
                        text: TextSpan(
                          text: "Next",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class SignatureBox extends StatefulWidget {
  const SignatureBox({
    Key? key,
    required SignatureController sigController,
  })  : _sigController = sigController,
        super(key: key);

  final SignatureController _sigController;

  @override
  _SignatureBoxState createState() => _SignatureBoxState();
}

class _SignatureBoxState extends State<SignatureBox> {
  bool signatureSaved = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 40,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFF5DB075)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ))),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Signature Pad
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 140,
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: Color(0xFF5DB075),
                      ),
                    ),
                    child: Signature(
                      controller: widget._sigController,
                      height: 140,
                      width: MediaQuery.of(context).size.width - 20,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                //Buttons
                Material(
                  child: Container(
                    color: Colors.grey.shade200,
                    height: 40,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Row(
                      //mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 31,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 5),
                          child: TextButton.icon(
                            clipBehavior: Clip.none,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF5DB075)),
                            ),
                            onPressed: () async {
                              if (widget._sigController.isNotEmpty) {
                                context
                                    .read(pharmacistSignUpProvider.notifier)
                                    .changeSignature(await widget._sigController
                                        .toPngBytes());
                                setState(() {
                                  signatureSaved = true;
                                });
                              }

                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 13,
                            ),
                            label: Text(
                              "Apply",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: 100,
                          height: 35,
                          child: TextButton(
                            onPressed: () {
                              widget._sigController.clear();
                              setState(() {
                                signatureSaved = false;
                              });
                            },
                            child: Text(
                              "Reset",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: !signatureSaved ? Text("Add") : Text("Change"),
      ),
    );
  }
}


// class SignatureBox extends StatelessWidget {
//   const SignatureBox({
//     Key? key,
//     required SignatureController sigController,
//   })  : _sigController = sigController,
//         super(key: key);

//   final SignatureController _sigController;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       height: 40,
//       child: ElevatedButton(
//         style: ButtonStyle(
//             backgroundColor:
//                 MaterialStateProperty.all<Color>(Color(0xFF5DB075)),
//             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                 RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ))),
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (_) => Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 //Signature Pad
//                 Align(
//                   alignment: Alignment.center,
//                   child: Container(
//                     height: 140,
//                     width: MediaQuery.of(context).size.width - 20,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         width: 3,
//                         color: Color(0xFF5DB075),
//                       ),
//                     ),
//                     child: Signature(
//                       controller: _sigController,
//                       height: 140,
//                       width: MediaQuery.of(context).size.width - 20,
//                       backgroundColor: Colors.white,
//                     ),
//                   ),
//                 ),
//                 //Buttons
//                 Material(
//                   child: Container(
//                     color: Colors.grey.shade200,
//                     height: 40,
//                     width: MediaQuery.of(context).size.width - 20,
//                     child: Row(
//                       //mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Container(
//                           width: 100,
//                           height: 31,
//                           alignment: Alignment.centerLeft,
//                           padding: EdgeInsets.only(left: 5),
//                           child: TextButton.icon(
//                             clipBehavior: Clip.none,
//                             style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(
//                                   Color(0xFF5DB075)),
//                             ),
//                             onPressed: () async {
//                               context
//                                   .read(pharmacistSignUpProvider.notifier)
//                                   .changeSignature((_sigController.isNotEmpty)
//                                       ? await _sigController.toPngBytes()
//                                       : null);

//                               Navigator.pop(context);
//                             },
//                             icon: Icon(
//                               Icons.check,
//                               color: Colors.white,
//                               size: 13,
//                             ),
//                             label: Text(
//                               "Apply",
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 13),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           alignment: Alignment.centerRight,
//                           width: 100,
//                           height: 35,
//                           child: TextButton(
//                             onPressed: () {
//                               _sigController.clear();
//                             },
//                             child: Text(
//                               "Reset",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//         child: _sigController.isEmpty ? Text("Add") : Text("Change"),
//       ),
//     );
 
//   }
// }
