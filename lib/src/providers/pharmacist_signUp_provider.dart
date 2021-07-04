import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/model/pharmacistSignUpModel.dart';
import 'package:pharma_connect/model/validatorModel.dart';

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

  //Getters
  String? get email => state.email?.value;
  String? get passwprd => state.password?.value;
  bool? get passwordVisiblity => state.passwordVisibility;

  String? get firstName => state.firstName;
  String? get lastName => state.lastName;
  String? get address => state.address;
  String? get phoneNumber => state.phoneNumber;

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
}
