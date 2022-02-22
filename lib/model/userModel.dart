class UserModel {
  String userUID;

  UserModel({
    this.userUID = "",
  });

  UserModel copyWithUser({
    String? userUID,
  }) {
    return UserModel(
      userUID: userUID ?? this.userUID,
    );
  }
}
