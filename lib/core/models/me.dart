class Me {
  int? id;
  String? name;
  String? email;
  String? birthday;
  int? gender;
  String? fullAddress;
  String? countryCode;
  String? city;
  String? phoneNumber;
  String? dialCode;
  String? avatar;
  Settings? settings;
  Company? company;
  Permission? permission;

  Me(
      {this.id,
      this.name,
      this.email,
      this.birthday,
      this.gender,
      this.fullAddress,
      this.countryCode,
      this.city,
      this.phoneNumber,
      this.dialCode,
      this.avatar,
      this.settings,
      this.company,
      this.permission});

  Me.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    birthday = json['birthday'];
    gender = json['gender'];
    fullAddress = json['full_address'];
    countryCode = json['country_code'];
    city = json['city'];
    phoneNumber = json['phone_number'];
    dialCode = json['dial_code'];
    avatar = json['avatar'];
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
    company =
        json['company'] != null ? new Company.fromJson(json['company']) : null;
    permission = json['permission'] != null
        ? new Permission.fromJson(json['permission'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['birthday'] = this.birthday;
    data['gender'] = this.gender;
    data['full_address'] = this.fullAddress;
    data['country_code'] = this.countryCode;
    data['city'] = this.city;
    data['phone_number'] = this.phoneNumber;
    data['dial_code'] = this.dialCode;
    data['avatar'] = this.avatar;
    if (this.settings != null) {
      data['settings'] = this.settings?.toJson();
    }
    if (this.company != null) {
      data['company'] = this.company?.toJson();
    }
    if (this.permission != null) {
      data['permission'] = this.permission?.toJson();
    }
    return data;
  }
}

class Settings {
  String? languageCode;

  Settings({this.languageCode});

  Settings.fromJson(Map<String, dynamic> json) {
    languageCode = json['language_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['language_code'] = this.languageCode;
    return data;
  }
}

class Company {
  int? id;
  String? name;
  String? email;
  Null address;
  String? countryCode;
  String? city;
  String? logo;

  Company(
      {this.id,
      this.name,
      this.email,
      this.address,
      this.countryCode,
      this.city,
      this.logo});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
    countryCode = json['country_code'];
    city = json['city'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    data['country_code'] = this.countryCode;
    data['city'] = this.city;
    data['logo'] = this.logo;
    return data;
  }
}

class Permission {
  bool? isCreator;
  bool? permissionAccessBusiness;
  bool? permissionAddTask;
  bool? permissionAddProject;
  bool? permissionAddEmployee;

  Permission(
      {this.isCreator,
      this.permissionAccessBusiness,
      this.permissionAddTask,
      this.permissionAddProject,
      this.permissionAddEmployee});

  Permission.fromJson(Map<String, dynamic> json) {
    isCreator = json['is_creator'];
    permissionAccessBusiness = json['permission_access_business'];
    permissionAddTask = json['permission_add_task'];
    permissionAddProject = json['permission_add_project'];
    permissionAddEmployee = json['permission_add_employee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_creator'] = this.isCreator;
    data['permission_access_business'] = this.permissionAccessBusiness;
    data['permission_add_task'] = this.permissionAddTask;
    data['permission_add_project'] = this.permissionAddProject;
    data['permission_add_employee'] = this.permissionAddEmployee;
    return data;
  }
}
