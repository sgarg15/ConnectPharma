import 'dart:typed_data';

import 'package:pharma_connect/src/screens/Pharmacist/5pharmacistSkills.dart';

class PharmacistSignUpModel {
  String email;
  String password;

  String firstName;
  String lastName;
  String address;
  String phoneNumber;

  String firstYearLicensed;
  String registrationNumber;
  String registrationProvince;
  String graduationYear;
  String institutionName;
  String workingExperiance;
  bool willingToMove;

  bool entitledToWork;
  bool activeMember;
  bool liabilityInsurance;
  bool licenseRestricted;
  bool malpractice;
  bool felon;

  List<Software?>? softwareList = [];
  List<Skill?>? skillList = [];
  List<Language?>? languageList = [];
  Uint8List? signatureData;

  PharmacistSignUpModel({
    this.email = "",
    this.password = "",
    this.firstName = "",
    this.lastName = "",
    this.address = "",
    this.phoneNumber = "",
    this.firstYearLicensed = "",
    this.registrationNumber = "",
    this.registrationProvince = "",
    this.graduationYear = "",
    this.institutionName = "",
    this.workingExperiance = "",
    this.willingToMove = false,
    this.entitledToWork = false,
    this.activeMember = false,
    this.liabilityInsurance = false,
    this.licenseRestricted = false,
    this.malpractice = false,
    this.felon = false,
    this.softwareList,
    this.skillList,
    this.languageList,
    this.signatureData,
  });

  PharmacistSignUpModel copyWithPharmacistSignUp({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? address,
    String? phoneNumber,
    String? firstYearLicensed,
    String? registrationNumber,
    String? registrationProvince,
    String? graduationYear,
    String? instituationName,
    String? workingExperiance,
    bool? willingToMove,
    bool? entitledToWork,
    bool? activeMember,
    bool? liabilityInsurance,
    bool? licenseRestricted,
    bool? malpractice,
    bool? felon,
    List<Software?>? softwareList,
    List<Skill?>? skillList,
    List<Language?>? languageList,
    Uint8List? signatureData,
  }) {
    return PharmacistSignUpModel(
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstYearLicensed: firstYearLicensed ?? this.firstYearLicensed,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      registrationProvince: registrationProvince ?? this.registrationProvince,
      graduationYear: graduationYear ?? this.graduationYear,
      institutionName: instituationName ?? this.institutionName,
      workingExperiance: workingExperiance ?? this.workingExperiance,
      willingToMove: willingToMove ?? this.willingToMove,
      entitledToWork: entitledToWork ?? this.entitledToWork,
      activeMember: activeMember ?? this.activeMember,
      liabilityInsurance: liabilityInsurance ?? this.liabilityInsurance,
      licenseRestricted: licenseRestricted ?? this.licenseRestricted,
      malpractice: malpractice ?? this.malpractice,
      felon: felon ?? this.felon,
      softwareList: softwareList ?? this.softwareList,
      skillList: skillList ?? this.skillList,
      languageList: languageList ?? this.languageList,
      signatureData: signatureData ?? this.signatureData,
    );
  }
}
