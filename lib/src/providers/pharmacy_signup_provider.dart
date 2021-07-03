import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pharma_connect/model/loginModel.dart';
import 'package:pharma_connect/model/pharmacySignUpModel.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pharma_connect/model/validatorModel.dart';
import 'package:pharma_connect/src/screens/Pharmacy/pharmacyInformation.dart';

class PharmacySignUpProvider extends StateNotifier<PharmacySignUpModel> {
  PharmacySignUpProvider() : super(PharmacySignUpModel());

  bool isValidSignUp() {
    if (state.email?.error != null ||
        state.password?.error != null ||
        state.email?.value == "" ||
        state.password?.value == "") {
      print("true");
      return true;
    } else {
      print("false");
      return false;
    }
  }

  bool isValidAccountInfo() {
    if (state.firstName == "" ||
        state.lastName == "" ||
        state.phoneNumber == "" ||
        state.position == "" ||
        state.firstName == null ||
        state.lastName == null ||
        state.phoneNumber == null ||
        state.position == null) {
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
        state.accreditationProvince == "" ||
        state.pharmacyName == null ||
        state.streetAddress == null ||
        state.city == null ||
        state.postalCode == null ||
        state.country == null ||
        state.phoneNumberPharmacy == null ||
        state.faxNumberPharmacy == null ||
        state.postalCode == null ||
        state.accreditationProvince == null) {
      print("true pharmacy info");
      return true;
    } else {
      print("false pharmacy info");
      return false;
    }
  }

  //Getters
  String? get email => state.email?.value;
  String? get passwprd => state.password?.value;
  bool? get passwordVisiblity => state.passwordVisibility;

  String? get firstName => state.firstName;
  String? get lastName => state.lastName;
  String? get phoneNumber => state.phoneNumber;
  String? get position => state.position;
  Uint8List? get signatureData => state.signatureData;

  String? get pharmacyName => state.pharmacyName;
  String? get streetAddress => state.streetAddress;
  String? get storeNumber => state.storeNumber;
  String? get city => state.city;
  String? get postalCode => state.postalCode;
  String? get country => state.country;
  String? get phoneNumberPharmacy => state.phoneNumberPharmacy;
  String? get faxNumber => state.faxNumberPharmacy;
  String? get accreditationProvince => state.accreditationProvince;
  List<Software?>? get softwareList => state.softwareList;

  //Setters Sign Up
  void changeEmail(String value) {
    state = state.updatePharmacySignUp(
      email: ValidatorModel(
          value, (!EmailValidator.validate(value)) ? "Incorrect Format" : null),
    );
  }

  void changePassword(String value) {
    state = state.updatePharmacySignUp(
      password: ValidatorModel(
          value, (value.length < 6) ? "Must be at least 6 characters" : null),
    );
  }

  void changePasswordVisibility(bool value) {
    state = state.updatePharmacySignUp(passwordVisibility: value);
  }

  //Setters Account Info
  void changeFirstName(String value) {
    state = state.updatePharmacySignUp(firstName: value);
  }

  void changeLastName(String value) {
    state = state.updatePharmacySignUp(lastName: value);
  }

  void changePhoneNumber(String value) {
    state = state.updatePharmacySignUp(phoneNumber: value);
  }

  void changePosition(String? value) {
    state = state.updatePharmacySignUp(position: value);
  }

  void changeSignature(Uint8List? value) {
    state = state.updatePharmacySignUp(signatureData: value);
  }

  //Setters Pharmacy Information
  void changePharmacyName(String? value) {
    state = state.updatePharmacySignUp(pharmacyName: value);
  }

  void changeStreetAddress(String? value) {
    state = state.updatePharmacySignUp(streetAddress: value);
  }

  void changeStoreNumber(String? value) {
    state = state.updatePharmacySignUp(storeNumber: value);
  }

  void changeCity(String? value) {
    state = state.updatePharmacySignUp(city: value);
  }

  void changePostalCode(String? value) {
    state = state.updatePharmacySignUp(postalCode: value);
  }

  void changeCountry(String? value) {
    state = state.updatePharmacySignUp(country: value);
  }

  void changePhoneNumberPharmacy(String? value) {
    state = state.updatePharmacySignUp(phoneNumberPharmacy: value);
  }

  void changeFaxNumber(String? value) {
    state = state.updatePharmacySignUp(faxNumberPharmacy: value);
  }

  void changeAccreditationProvince(String? value) {
    state = state.updatePharmacySignUp(accreditationProvince: value);
  }

  void changeSoftwareList(List<Software?> value) {
    state = state.updatePharmacySignUp(softwareList: value);
  }
}
