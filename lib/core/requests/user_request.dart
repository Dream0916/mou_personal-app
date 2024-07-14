import 'dart:io';

class UserRequest {
  String? name;
  String? email;
  File? avatar;
  DateTime? birthday;
  int? gender;
  String? countryCode;
  String? city;
  String? phoneNumber;
  String? dialCode;

  UserRequest(
      {this.name,
      this.email,
      this.avatar,
      this.birthday,
      this.gender,
      this.countryCode,
      this.city,
      this.phoneNumber,
      this.dialCode});
}
