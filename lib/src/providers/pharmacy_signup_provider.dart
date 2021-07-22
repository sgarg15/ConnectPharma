import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/model/pharmacySignUpModel.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pharma_connect/src/screens/Pharmacy/Sign Up/3pharmacyInformation.dart';

class PharmacySignUpProvider extends StateNotifier<PharmacySignUpModel> {
  PharmacySignUpProvider() : super(PharmacySignUpModel());

  bool isValidSignUp() {
    if (EmailValidator.validate(state.email.toString()) == false ||
        state.password.length < 6) {
      return true;
    } else {
      return false;
    }
  }

  bool isValidAccountInfo() {
    if (state.firstName == "" ||
        state.lastName == "" ||
        state.phoneNumber == "" ||
        state.position == "") {
      print("true account info");
      return true;
    } else {
      print("false account info");
      return false;
    }
  }

  bool isValidPharmacyInformation() {
    if (state.pharmacyName == "" ||
        state.streetAddress == "" ||
        state.city == "" ||
        state.postalCode == "" ||
        state.country == "" ||
        state.phoneNumberPharmacy == "" ||
        state.faxNumberPharmacy == "" ||
        state.postalCode == "" ||
        state.accreditationProvince == "") {
      print("true pharmacy info");
      return true;
    } else {
      print("false pharmacy info");
      return false;
    }
  }

  bool isValidManagerInformation() {
    if (state.managerFirstName == "" ||
        state.managerLastName == "" ||
        state.managerPhoneNumber.length < 4 ||
        state.licenseNumber.length < 5) {
      print("true manager info");
      return true;
    } else {
      print("false manager info");
      return false;
    }
  }

  void clearAllValues() {
    state.email = "";
    state.password = "";
    state.firstName = "";
    state.lastName = "";
    state.phoneNumber = "";
    state.position = null;
    state.pharmacyName = "";
    state.streetAddress = "";
    state.storeNumber = "";
    state.city = "";
    state.postalCode = "";
    state.country = "";
    state.phoneNumberPharmacy = "";
    state.faxNumberPharmacy = "";
    state.softwareList = null;
    state.managerFirstName = "";
    state.managerLastName = "";
    state.managerPhoneNumber = "";
    state.licenseNumber = "";
  }

  //Getters
  String get email => state.email;
  String get password => state.password;
  bool get passwordVisiblity => state.passwordVisibility;

  String get firstName => state.firstName;
  String get lastName => state.lastName;
  String get phoneNumber => state.phoneNumber;
  String? get position => state.position;
  Uint8List? get signatureData => state.signatureData;

  String get pharmacyName => state.pharmacyName;
  String get streetAddress => state.streetAddress;
  String get storeNumber => state.storeNumber;
  String get city => state.city;
  String get postalCode => state.postalCode;
  String get country => state.country;
  String get phoneNumberPharmacy => state.phoneNumberPharmacy;
  String get faxNumber => state.faxNumberPharmacy;
  String get accreditationProvince => state.accreditationProvince;
  List<Software?>? get softwareList => state.softwareList;

  String get managerFirstName => state.managerFirstName;
  String get managerLastName => state.managerLastName;
  String get managerPhoneNumber => state.managerPhoneNumber;
  String get licenseNumber => state.licenseNumber;

  //Setters Sign Up
  void changeEmail(String value) {
    state = state.copyWithPharmacySignUp(
      email: value.trim(),
    );
  }

  void changePassword(String value) {
    state = state.copyWithPharmacySignUp(
      password: value,
    );
  }

  void changePasswordVisibility(bool value) {
    state = state.copyWithPharmacySignUp(passwordVisibility: value);
  }

  //Setters Account Info
  void changeFirstName(String value) {
    state = state.copyWithPharmacySignUp(firstName: value.trim());
  }

  void changeLastName(String value) {
    state = state.copyWithPharmacySignUp(lastName: value.trim());
  }

  void changePhoneNumber(String value) {
    state = state.copyWithPharmacySignUp(phoneNumber: value.trim());
  }

  void changePosition(String? value) {
    state = state.copyWithPharmacySignUp(position: value);
  }

  void changeSignature(Uint8List? value) {
    state = state.copyWithPharmacySignUp(signatureData: value);
  }

  //Setters Pharmacy Information
  void changePharmacyName(String value) {
    state = state.copyWithPharmacySignUp(pharmacyName: value.trim());
  }

  void changeStreetAddress(String? value) {
    state = state.copyWithPharmacySignUp(streetAddress: value?.trim());
  }

  void changeStoreNumber(String? value) {
    state = state.copyWithPharmacySignUp(storeNumber: value?.trim());
  }

  void changeCity(String? value) {
    state = state.copyWithPharmacySignUp(city: value?.trim());
  }

  void changePostalCode(String? value) {
    state = state.copyWithPharmacySignUp(postalCode: value?.trim());
  }

  void changeCountry(String? value) {
    state = state.copyWithPharmacySignUp(country: value?.trim());
  }

  void changePhoneNumberPharmacy(String value) {
    state = state.copyWithPharmacySignUp(phoneNumberPharmacy: value.trim());
  }

  void changeFaxNumber(String value) {
    state = state.copyWithPharmacySignUp(faxNumberPharmacy: value.trim());
  }

  void changeAccreditationProvince(String value) {
    state = state.copyWithPharmacySignUp(accreditationProvince: value.trim());
  }

  void changeSoftwareList(List<Software?> value) {
    state = state.copyWithPharmacySignUp(softwareList: value);
  }

  //Manager Information
  void changeManagerFirstName(String value) {
    state = state.copyWithPharmacySignUp(managerFirstName: value.trim());
  }

  void changeMangagerLastName(String value) {
    state = state.copyWithPharmacySignUp(managerLastName: value.trim());
  }

  void changeManagerPhoneNumber(String value) {
    state = state.copyWithPharmacySignUp(managerPhoneNumber: value.trim());
  }

  void changeLicenseNumber(String value) {
    state = state.copyWithPharmacySignUp(licenseNumber: value.trim());
  }
}
