import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectpharma/src/screens/Pharmacist/Sign Up/1pharmacistSignUp.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class TestScreen extends ConsumerStatefulWidget {
  TestScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {
  bool filePicked = false;
  FilePickerResult? _result;
  File? file;

  File? frontFile;
  FilePickerResult? _frontOfIDResult;
  bool frontOfIDPicked = false;

  @override
  Widget build(BuildContext context) {
    return testingImageUpload(context);
  }

  Container testingFileUpload(BuildContext context) {
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
                      print("File Size: ${file?.lengthSync()}");
                      print("File Path: ${file?.path}");

                      // ref.read(userSignUpProvider.notifier).changeResumePDF(file);
                      // print(ref.read(userSignUpProvider.notifier).resumePDFData);
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

  Future<File?> compressAndGetFile(File file) async {
    print("File Path2: " + file.path);
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = dir.absolute.path + '/temp.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 50,
    );

    print(file.lengthSync() * 0.000001);
    print(result!.lengthSync() * 0.000001);

    return result;
  }

  Container testingImageUpload(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10),
          if (ref.read(userSignUpProvider.notifier).frontIDData != null)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                DottedBorder(
                  radius: Radius.circular(10),
                  borderType: BorderType.RRect,
                  color: Color(0xFFDBDBDB),
                  strokeWidth: 1,
                  child: SizedBox(
                    height: 50,
                    width: 110,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        frontFile = ref.read(userSignUpProvider.notifier).frontIDData;
                        print("FILE PATH: " + frontFile!.path.toString());
                        OpenFile.open(frontFile!.path);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "View Front",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                DottedBorder(
                  radius: Radius.circular(10),
                  borderType: BorderType.RRect,
                  color: Color(0xFFDBDBDB),
                  strokeWidth: 1,
                  child: SizedBox(
                    height: 50,
                    width: 90,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Color(0xFFF0069C1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _frontOfIDResult = null;
                          frontFile = null;
                        });

                        ref.read(userSignUpProvider.notifier).clearFrontIDImage();
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Clear",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            DottedBorder(
              radius: Radius.circular(10),
              borderType: BorderType.RRect,
              color: Color(0xFFDBDBDB),
              strokeWidth: 1,
              child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Color(0xFFF0069C1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      _frontOfIDResult = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if (_frontOfIDResult!.files.first.path != null) {
                        setState(() {
                          frontOfIDPicked = true;
                        });
                        frontFile = File(_frontOfIDResult!.files.first.path.toString());
                        print("File Size: ${frontFile?.lengthSync()}");
                        print("File Path: ${frontFile?.path}");
                        frontFile = await compressAndGetFile(frontFile!);
                        print(frontFile!.lengthSync() * 0.000001);
                        print("File Path: ${frontFile?.path}");

                        ref.read(userSignUpProvider.notifier).changeFrontIDImage(frontFile);
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
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          text: "Upload Front of ID",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
