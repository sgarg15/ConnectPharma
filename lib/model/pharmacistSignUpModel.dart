import 'package:pharma_connect/model/validatorModel.dart';

class PharmacistSignUpModel {
  ValidatorModel? email = ValidatorModel("", "");
  ValidatorModel? password = ValidatorModel("", "");
  bool passwordVisibility;

  String? firstName = "";
  String? lastName = "";
  String? address = "";
  String? phoneNumber = "";

  PharmacistSignUpModel({
    this.email,
    this.password,
    this.passwordVisibility = false,
    this.firstName,
    this.lastName,
    this.address,
    this.phoneNumber,
  });

  PharmacistSignUpModel updatePharmacistSignUp({
    ValidatorModel? email,
    ValidatorModel? password,
    bool passwordVisibility = false,
    String? firstName,
    String? lastName,
    String? address,
    String? phoneNumber,
  }) {
    return PharmacistSignUpModel(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordVisibility: passwordVisibility,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
