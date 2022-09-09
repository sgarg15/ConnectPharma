import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../all_used.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign Up/1pharmacistSignUp.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign Up/6photoInformation.dart';
import 'package:signature/signature.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

class PharmacistSkills extends ConsumerStatefulWidget {
  PharmacistSkills({Key? key}) : super(key: key);

  @override
  _PharmacistSkillsState createState() => _PharmacistSkillsState();
}

class _PharmacistSkillsState extends ConsumerState<PharmacistSkills> {
  final _softwareItems =
      software.map((software) => MultiSelectItem<Software>(software, software.name)).toList();
  final _skillItems = skill.map((skill) => MultiSelectItem<Skill>(skill, skill.name)).toList();

  final _languageItems =
      language.map((language) => MultiSelectItem<Language>(language, language.name)).toList();

  final SignatureController _sigController = SignatureController(
    penStrokeWidth: 3, //you can set pen stroke with by changing this value
    penColor: Colors.black, // change your pen color
    exportBackgroundColor: Colors.white, //set the color you want to see in final result
  );

  bool filePicked = false;
  FilePickerResult? _result;
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_sharp), onPressed: () => Navigator.pop(context)),
          title: new Text(
            "Skills",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily,
            ),
          ),
          backgroundColor: Color(0xFFF0069C1),
          foregroundColor: Colors.white,
          elevation: 12,
          bottomOpacity: 1,
          shadowColor: Colors.white,
        ),
        body: Stack(
          children: [
            Center(
              child: Column(children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return NotificationListener(
                        onNotification: (OverscrollIndicatorNotification overscroll) {
                          overscroll.disallowIndicator();
                          return true;
                        },
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              //Information Text
                              Padding(
                                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    text:
                                        "Please provide us with your Pharmacist Information, to help us verify.",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),

                              selectSoftware(),
                              SizedBox(height: 30),
                              selectSkills(),
                              SizedBox(height: 30),
                              selectLanguages(),
                              SizedBox(height: 30),
                              selectResume(context),
                              SizedBox(height: 40),
                              nextButton(),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ]),
            )
          ],
        ));
  }

/*
SingleChildScrollView(
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
            //Information Text
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(11, 10, 0, 0),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: "Please select all applicable skills, software and languages",
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
                    selectSoftware(),
                    SizedBox(height: 20),

                    //Skill
                    selectSkills(),
                    SizedBox(height: 20),

                    //Language
                    selectLanguages(),
                    SizedBox(height: 50),

                    //Resume
                    selectResume(context),
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
            nextButton(),
            SizedBox(height: 15),
          ],
        ),
      ),
    
*/

  Center nextButton() {
    return Center(
      child: Consumer(
        builder: (context, ref, child) {
          ref.watch(userSignUpProvider);
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 51,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey; // Disabled color
                    }
                    return Color(0xFFF0069C1); // Regular color
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))),
              onPressed: (ref.read(userSignUpProvider.notifier).isValidPharmacistSkills())
                  ? null
                  : () {
                      print("Pressed");
                     
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => PhotoInformation()));
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
    );
  }

  Container selectResume(BuildContext context) {
    String documentIcon = "assets/icons/document.svg";
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              SvgPicture.asset(documentIcon, width: 21, height: 21),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: RichText(
                    text: TextSpan(
                        text: "Resume",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF4A4848),
                            fontFamily:
                                GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily))),
              ),
            ],
          ),
          SizedBox(height: 10),
          if (ref.read(userSignUpProvider.notifier).resumePDFData != null)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                          return Color(0xFFF0069C1); // Regular color
                        }),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                    onPressed: () async {
                      file = ref.read(userSignUpProvider.notifier).resumePDFData;
                      print("FILE PATH: " + file!.path.toString());
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
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                          return Color(0xFFF0069C1); // Regular color
                        }),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                    onPressed: () async {
                      setState(() {
                        _result = null;
                        file = null;
                      });
                      print(ref.read(userSignUpProvider.notifier).firstName);
                      ref.read(userSignUpProvider.notifier).clearResumePDF();
                      print(ref.read(userSignUpProvider.notifier).firstName);
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
              height: 45,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      return Color(0xFFF0069C1); // Regular color
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
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
                      file = File(_result!.files.first.path.toString());

                      ref.read(userSignUpProvider.notifier).changeResumePDF(file);
                      print(ref.read(userSignUpProvider.notifier).resumePDFData);
                    } else {
                      // User canceled the picker
                    }
                  } catch (error) {
                    print("ERROR: " + error.toString());
                    final snackBar = SnackBar(
                      content: Text('There was an error, please try again.'),
                      duration: Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            ),
        ],
      ),
    );
  }

  Container selectLanguages() {
    String languagesIcon = "assets/icons/languages.svg";

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: SvgPicture.asset(languagesIcon, width: 19, height: 19),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: RichText(
                    text: TextSpan(
                        text: "Languages",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF4A4848),
                            fontFamily:
                                GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily))),
              ),
            ],
          ),
          MultiSelectBottomSheetField<Language?>(
            selectedColor: Color(0xFFF0069C1),
            selectedItemsTextStyle: TextStyle(color: Colors.white),
            initialChildSize: 0.4,
            decoration: BoxDecoration(),
            listType: MultiSelectListType.CHIP,
            initialValue: ref.read(userSignUpProvider.notifier).languageList,
            searchable: true,
            items: _languageItems,
            buttonText: Text("Select known languages...",
                style: GoogleFonts.inter(color: Color(0xFFBDBDBD), fontSize: 16)),
            onConfirm: (values) {
              ref.read(userSignUpProvider.notifier).changeLanguageList(values);
            },
            chipDisplay: MultiSelectChipDisplay(
              items: ref
                  .read(userSignUpProvider.notifier)
                  .languageList
                  ?.map((e) => MultiSelectItem(e, e.toString()))
                  .toList(),
              chipColor: Color(0xFFF0069C1),
              onTap: (value) {
                ref.read(userSignUpProvider.notifier).languageList?.remove(value);
                return ref.read(userSignUpProvider.notifier).languageList;
              },
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Container selectSkills() {
    String gearIcon = "assets/icons/gear.svg";
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              SvgPicture.asset(gearIcon, width: 21, height: 21),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: RichText(
                    text: TextSpan(
                        text: "Skills",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF4A4848),
                            fontFamily:
                                GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily))),
              ),
            ],
          ),
          MultiSelectBottomSheetField<Skill?>(
            selectedColor: Color(0xFFF0069C1),
            selectedItemsTextStyle: TextStyle(color: Colors.white),
            initialChildSize: 0.4,
            decoration: BoxDecoration(),
            listType: MultiSelectListType.CHIP,
            initialValue: ref.read(userSignUpProvider.notifier).skillList,
            searchable: true,
            items: _skillItems,
            buttonText: Text("Select your skills...",
                style: GoogleFonts.inter(color: Color(0xFFBDBDBD), fontSize: 16)),
            onConfirm: (values) {
              ref.read(userSignUpProvider.notifier).changeSkillList(values);
            },
            chipDisplay: MultiSelectChipDisplay(
              items: ref
                  .read(userSignUpProvider.notifier)
                  .skillList
                  ?.map((e) => MultiSelectItem(e, e.toString()))
                  .toList(),
              chipColor: Color(0xFFF0069C1),
              onTap: (value) {
                ref.read(userSignUpProvider.notifier).skillList?.remove(value);
                return ref.read(userSignUpProvider.notifier).skillList;
              },
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Container selectSoftware() {
    final String gearIcon = 'assets/icons/gear.svg';

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              SvgPicture.asset(gearIcon, width: 21, height: 21),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: RichText(
                    text: TextSpan(
                        text: "Software",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF4A4848),
                            fontFamily:
                                GoogleFonts.montserrat(fontWeight: FontWeight.normal).fontFamily))),
              ),
            ],
          ),
          MultiSelectBottomSheetField<Software?>(
            selectedColor: Color(0xFFF0069C1),
            selectedItemsTextStyle: TextStyle(color: Colors.white),
            initialChildSize: 0.4,
            decoration: BoxDecoration(),
            listType: MultiSelectListType.CHIP,
            initialValue: ref.read(userSignUpProvider.notifier).softwareList,
            searchable: true,
            items: _softwareItems,
            buttonText: Text("Select known software...",
                style: GoogleFonts.inter(color: Color(0xFFBDBDBD), fontSize: 16)),
            onConfirm: (values) {
              ref.read(userSignUpProvider.notifier).changeSoftwareList(values);
            },
            chipDisplay: MultiSelectChipDisplay(
              items: ref
                  .read(userSignUpProvider.notifier)
                  .softwareList
                  ?.map((e) => MultiSelectItem(e, e.toString()))
                  .toList(),
              chipColor: Color(0xFFF0069C1),
              onTap: (value) {
                ref.read(userSignUpProvider.notifier).softwareList?.remove(value);
                return ref.read(userSignUpProvider.notifier).softwareList;
              },
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

class SignatureBox extends ConsumerStatefulWidget {
  const SignatureBox({
    Key? key,
    required SignatureController sigController,
  })  : _sigController = sigController,
        super(key: key);

  final SignatureController _sigController;

  @override
  _SignatureBoxState createState() => _SignatureBoxState();
}

class _SignatureBoxState extends ConsumerState<SignatureBox> {
  bool signatureSaved = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 40,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF0069C1)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
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
                        color: Color(0xFFF0069C1),
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
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF0069C1)),
                            ),
                            onPressed: () async {
                              if (widget._sigController.isNotEmpty) {
                                ref
                                    .read(userSignUpProvider.notifier)
                                    .changeSignature(await widget._sigController.toPngBytes());
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
                              style: TextStyle(color: Colors.white, fontSize: 13),
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
