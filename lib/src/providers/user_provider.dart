import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/model/userModel.dart';

class UserProvider extends StateNotifier<UserModel> {
  UserProvider() : super(UserModel());

  String get userUID => state.userUID;

  void changeUserUID(String? userUID) {
    print("CHANGING");
    state = state.copyWithUser(userUID: userUID);
  }
}
