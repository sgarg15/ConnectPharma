import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pharma_connect/model/loginModel.dart';
import 'package:pharma_connect/model/pharmacySignUpModel.dart';

class PharmacySignUpProvider extends StateNotifier<PharmacySignUpModel> {
  PharmacySignUpProvider() : super(PharmacySignUpModel());

  bool isValid() {
    if (state.emailErr == "" ||
        state.passwordErr == "" ||
        state.email == "" ||
        state.password == "") {
      print("true");
      return true;
    } else {
      print("false");
      return false;
    }
  }

  //Setters
  void changeEmail(String value) {
    state = state.updatePharmacySignUp(
      email: value,
      emailErr:
          (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value))
              ? "Incorrect Format"
              : "",
    );
  }

  void changePassword(String value) {
    state = state.updatePharmacySignUp(
      password: value,
      passwordErr: (value.length < 6) ? "Must be at least 6 characters" : "",
    );
  }

  void changePasswordVisibility(bool value) {
    state = state.updatePharmacySignUp(passwordVisibility: value);
  }
}
