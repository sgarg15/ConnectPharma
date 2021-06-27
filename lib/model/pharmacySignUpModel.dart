class PharmacySignUpModel {
  final String? email;
  final String? password;
  final String emailErr;
  final String passwordErr;
  final bool passwordVisibility;

  PharmacySignUpModel({
    this.email = "",
    this.password = "",
    this.emailErr = "",
    this.passwordErr = "",
    this.passwordVisibility = false,
  });

  PharmacySignUpModel updatePharmacySignUp({
    String? email,
    String? password,
    String? emailErr,
    String? passwordErr,
    bool passwordVisibility = false,
  }) {
    return PharmacySignUpModel(
      email: email ?? this.email,
      password: password ?? this.password,
      emailErr: emailErr ?? this.emailErr,
      passwordErr: passwordErr ?? this.passwordErr,
      passwordVisibility: passwordVisibility,
    );
  }
}
