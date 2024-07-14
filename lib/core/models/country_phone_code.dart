class CountryPhoneCode {
  String name;
  String dialCode;
  String code;

  CountryPhoneCode({
    this.name = '',
    this.dialCode = "+1",
    this.code = '',
  });

  factory CountryPhoneCode.fromJson(Map<String, dynamic> json) {
    return CountryPhoneCode(
        name: json["name"] ?? "",
        dialCode: json["dial_code"] ?? "",
        code: json["code"] ?? "");
  }
}
