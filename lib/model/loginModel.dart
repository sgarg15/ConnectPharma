class LogInModel {
  String email;
  String password;

  LogInModel({
    this.email = "",
    this.password = "",
  });

  LogInModel updateLogIn({
    String? email,
    String? password,
  }) {
    return LogInModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
