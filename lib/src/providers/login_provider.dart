import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/model/loginModel.dart';

class LogInProvider extends StateNotifier<LogInModel> {
  LogInProvider() : super(LogInModel());

  String get email => state.email;
  String get password => state.password;

  ///Check if the email is valid
  bool isValidEmail() {
    if (EmailValidator.validate(state.email.toString()) == false || state.password.length < 6) {
      print("Email not valid");
      return false;
    } else {
      print("Email is valid");
      return true;
    }
  }

  ///Clears the email and password information
  void clearEmailAndPassword() {
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
