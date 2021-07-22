import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/model/loginModel.dart';

class LogInProvider extends StateNotifier<LogInModel> {
  LogInProvider() : super(LogInModel());

  String get email => state.email;
  String get password => state.password;

  bool isValid() {
    if (EmailValidator.validate(state.email.toString()) == false ||
        state.password.length < 6) {
      print("true");
      return true;
    } else {
      print("false");
      return false;
    }
  }

  void clearAllValue() {
    state.email = "";
    state.password = "";
  }

  //Setters
  void changeEmail(String value) {
    state = state.updateLogIn(
      email: value,
    );
  }

  void changePassword(String value) {
    state = state.updateLogIn(
      password: value,
    );
  }
}
