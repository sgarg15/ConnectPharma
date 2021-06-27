class LogInModel {
  final String? email;
  final String? password;
  final String emailErr;
  final String passwordErr;
  final bool passwordVisibility;

  LogInModel({
    this.email = "",
    this.password = "",
    this.emailErr = "",
    this.passwordErr = "",
    this.passwordVisibility = false,
  });

  LogInModel updateLogIn({
    String? email,
    String? password,
    String? emailErr,
    String? passwordErr,
    bool passwordVisibility = false,
  }) {
    return LogInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      emailErr: emailErr ?? this.emailErr,
      passwordErr: passwordErr ?? this.passwordErr,
      passwordVisibility: passwordVisibility,
    );
  }
}
