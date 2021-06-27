import 'package:pharma_connect/src/providers/auth_provider.dart';

class UserModel {
  String? uid;
  String? email;
  String? displayName;

  UserModel({
    this.uid = "",
    this.email = "",
    this.displayName = "",
  });
}
