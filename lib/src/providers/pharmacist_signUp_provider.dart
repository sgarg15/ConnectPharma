import 'dart:typed_data';

import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/model/pharmacistSignUpModel.dart';
import 'package:pharma_connect/model/validatorModel.dart';
import 'package:pharma_connect/src/screens/Pharmacist/pharmacistSkills.dart';

class PharmacistSignUpProvider extends StateNotifier<PharmacistSignUpModel> {
  PharmacistSignUpProvider() : super(PharmacistSignUpModel());

  bool isValidPharmacistLocation() {
    if (state.firstName == "" ||
        state.lastName == "" ||
        state.phoneNumber == "" ||
        state.firstName == null ||
        state.lastName == null ||
        state.phoneNumber == null) {
      print("true account info");
      return true;
    } else {
      print("false account info");
      return false;
    }
  }

  bool isValidPharmacistInformation() {
    if (state.firstYearLicensed == "" ||
        state.registrationNumber == "" ||
        state.registrationProvince == "" ||
        state.graduationYear == "" ||
        state.institutionName == "" ||
        state.workingExperiance == "" ||
        state.firstYearLicensed == null ||
        state.registrationNumber == null ||
        state.registrationProvince == null ||
        state.graduationYear == null ||
        state.institutionName == null ||
        state.workingExperiance == null) {
      print("true account info");
      return true;
    } else {
      print("false account info");
      return false;
    }
  }

  bool isValidPharmacistSkills() {
    if (state.softwareList == "" ||
        state.skillList == "" ||
        state.languageList == "" ||
        state.softwareList == null ||
        state.skillList == null ||
        state.languageList == null) {
      print("true account info");
      return true;
    } else {
      print("false account info");
      return false;
    }
  }

  //Getters
  String? get email => state.email?.value;
  String? get passwprd => state.password?.value;
  bool? get passwordVisiblity => state.passwordVisibility;

  String? get firstName => state.firstName;
  String? get lastName => state.lastName;
  String? get address => state.address;
  String? get phoneNumber => state.phoneNumber;

  String? get firstYearLicensed => state.firstYearLicensed;
  String? get registrationNumber => state.registrationNumber;
  String? get registrationProvince => state.registrationProvince;
  String? get graduationYear => state.graduationYear;
  String? get institutionName => state.institutionName;
  String? get workingExperience => state.workingExperiance;
  bool get willingToMove => state.willingToMove;

  bool get entitledToWork => state.entitledToWork;
  bool get activeMember => state.activeMember;
  bool get liabilityInsurance => state.liabilityInsurance;
  bool get licenseRestricted => state.licenseRestricted;
  bool get malpractice => state.malpractice;
  bool get felon => state.felon;

  List<Software?>? get softwareList => state.softwareList;
  List<Skill?>? get skillList => state.skillList;
  List<Language?>? get languageList => state.languageList;
  //Setters Sign Up
  void changeEmail(String value) {
    state = state.updatePharmacistSignUp(
      email: ValidatorModel(
          value, (!EmailValidator.validate(value)) ? "Incorrect Format" : null),
    );
  }

  void changePassword(String value) {
    state = state.updatePharmacistSignUp(
      password: ValidatorModel(
          value, (value.length < 6) ? "Must be at least 6 characters" : null),
    );
  }

  void changePasswordVisibility(bool value) {
    state = state.updatePharmacistSignUp(passwordVisibility: value);
  }

//Setters Pharmacist Location
  void changeFirstName(String value) {
    state = state.updatePharmacistSignUp(firstName: value);
  }

  void changeLastName(String value) {
    state = state.updatePharmacistSignUp(lastName: value);
  }

  void changePhoneNumber(String value) {
    state = state.updatePharmacistSignUp(phoneNumber: value);
  }

  void changePharmacistAddress(String value) {
    state = state.updatePharmacistSignUp(address: value);
  }

  //Setters Pharmacist Information
  void changeFirstYearLicensed(String value) {
    state = state.updatePharmacistSignUp(firstYearLicensed: value);
  }

  void changeRegistrationNumber(String value) {
    state = state.updatePharmacistSignUp(registrationNumber: value);
  }

  void changeRegistrationProvince(String value) {
    state = state.updatePharmacistSignUp(registrationProvince: value);
  }

  void changeGraduationYear(String value) {
    state = state.updatePharmacistSignUp(graduationYear: value);
  }

  void changeInstitutionName(String value) {
    state = state.updatePharmacistSignUp(instituationName: value);
  }

  void changeWorkingExperience(String value) {
    state = state.updatePharmacistSignUp(workingExperiance: value);
  }

  void changeWillingToMove(bool value) {
    state = state.updatePharmacistSignUp(willingToMove: value);
  }

  //Setters Pharmacist Legal Information
  void changeEntitledToWork(bool value) {
    state = state.updatePharmacistSignUp(entitledToWork: value);
  }

  void changeActiveMember(bool value) {
    state = state.updatePharmacistSignUp(activeMember: value);
  }

  void changeLiabilityInsurance(bool value) {
    state = state.updatePharmacistSignUp(liabilityInsurance: value);
  }

  void changeLicenseRestricted(bool value) {
    state = state.updatePharmacistSignUp(licenseRestricted: value);
  }

  void changeMalpractice(bool value) {
    state = state.updatePharmacistSignUp(malpractice: value);
  }

  void changeFelonStatus(bool value) {
    state = state.updatePharmacistSignUp(felon: value);
  }

  //Setters Pharmacist Skills
  void changeSoftwareList(List<Software?> value) {
    state = state.updatePharmacistSignUp(softwareList: value);
  }

  void changeSkillList(List<Skill?> value) {
    state = state.updatePharmacistSignUp(skillList: value);
  }

  void changeLanguageList(List<Language?> value) {
    state = state.updatePharmacistSignUp(languageList: value);
  }

  void changeSignature(Uint8List? value) {
    state = state.updatePharmacistSignUp(signatureData: value);
  }
}
