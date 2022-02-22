import 'dart:io';
import 'dart:typed_data';
import '../all_used.dart';

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

  File? resumePDF;
  File? frontID;
  File? backID;
  File? registrationCertificate;
  File? profilePhoto;

  String userType;

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
    this.resumePDF,
    this.frontID,
    this.backID,
    this.registrationCertificate,
    this.profilePhoto,
    this.userType = "",
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
    File? resumePDF,
    File? frontID,
    File? backID,
    File? registrationCertificate,
    File? profilePhoto,
    String? userType,
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
      institutionName: instituationName ?? institutionName,
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
      resumePDF: resumePDF ?? this.resumePDF,
      frontID: frontID ?? this.frontID,
      backID: backID ?? this.backID,
      registrationCertificate:
          registrationCertificate ?? this.registrationCertificate,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      userType: userType ?? this.userType,
    );
  }
}
