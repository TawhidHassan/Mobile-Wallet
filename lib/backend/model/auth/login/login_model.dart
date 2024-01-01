// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));
String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  Message message;
  Data data;

  LoginModel({
    required this.message,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    message: Message.fromJson(json["message"]),
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message.toJson(),
    "data": data.toJson(),
  };
}

class Data {
  dynamic token;
  User user;

  Data({
    required this.token,
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"] ?? "",
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user.toJson(),
  };
}

class User {
  // int id;
  // dynamic firstname;
  // dynamic lastname;
  // dynamic username;
  // dynamic email;
  // dynamic mobileCode;
  // dynamic mobile;
  // dynamic fullMobile;
  // dynamic refferalUserId;
  // dynamic image;
  // int status;
  // Address address;
  int emailVerified;
  int smsVerified;
  int kycVerified;
  dynamic verCode;
  dynamic verCodeSendAt;
  int twoFactorVerified;
  int twoFactorStatus;
  dynamic twoFactorSecret;
  // dynamic deviceId;
  // dynamic firebaseToken;
  // dynamic emailVerifiedAt;
  // dynamic deletedAt;
  // DateTime createdAt;
  // DateTime updatedAt;
  // dynamic fullname;
  // dynamic userImage;
  // StringStatus stringStatus;
  // dynamic lastLogin;
  // StringStatus kycStringStatus;
  // List<Wallet> wallets;

  User({
    // required this.id,
    // required this.firstname,
    // required this.lastname,
    // required this.username,
    // required this.email,
    // required this.mobileCode,
    // required this.mobile,
    // required this.fullMobile,
    // this.refferalUserId,
    // this.image,
    // required this.status,
    // required this.address,
    required this.emailVerified,
    required this.smsVerified,
    required this.kycVerified,
    this.verCode,
    this.verCodeSendAt,
    required this.twoFactorVerified,
    required this.twoFactorStatus,
    required this.twoFactorSecret,
    // this.deviceId,
    // this.firebaseToken,
    // this.emailVerifiedAt,
    // this.deletedAt,
    // required this.createdAt,
    // required this.updatedAt,
    // required this.fullname,
    // required this.userImage,
    // required this.stringStatus,
    // required this.lastLogin,
    // required this.kycStringStatus,
    // required this.wallets,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    // id: json["id"] ?? "",
    // firstname: json["firstname"] ?? "",
    // lastname: json["lastname"] ?? "",
    // username: json["username"] ?? "",
    // email: json["email"] ?? "",
    // mobileCode: json["mobile_code"] ?? "",
    // mobile: json["mobile"] ?? "",
    // fullMobile: json["full_mobile"] ?? "",
    // refferalUserId: json["refferal_user_id"] ?? "",
    // image: json["image"] ?? "",
    // status: json["status"] ?? "",
    // address: Address.fromJson(json["address"]),
    emailVerified: json["email_verified"] ?? "",
    smsVerified: json["sms_verified"] ?? "",
    kycVerified: json["kyc_verified"] ?? "",
    verCode: json["ver_code"] ?? "",
    verCodeSendAt: json["ver_code_send_at"] ?? "",
    twoFactorVerified: json["two_factor_verified"] ?? "",
    twoFactorStatus: json["two_factor_status"] ?? "",
    twoFactorSecret: json["two_factor_secret"] ?? "",
    // deviceId: json["device_id"] ?? "",
    // firebaseToken: json["firebase_token"] ?? "",
    // emailVerifiedAt: json["email_verified_at"] ?? "",
    // deletedAt: json["deleted_at"] ?? "",
    // createdAt: DateTime.parse(json["created_at"]) ,
    // updatedAt: DateTime.parse(json["updated_at"]) ,
    // fullname: json["fullname"] ?? "",
    // userImage: json["userImage"] ?? "",
    // stringStatus: StringStatus.fromJson(json["stringStatus"]),
    // lastLogin: json["lastLogin"],
    // kycStringStatus: StringStatus.fromJson(json["kycStringStatus"]),
    // wallets: List<Wallet>.from(json["wallets"].map((x) => Wallet.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    // "id": id,
    // "firstname": firstname,
    // "lastname": lastname,
    // "username": username,
    // "email": email,
    // "mobile_code": mobileCode,
    // "mobile": mobile,
    // "full_mobile": fullMobile,
    // "refferal_user_id": refferalUserId,
    // "image": image,
    // "status": status,
    // "address": address.toJson(),
    "email_verified": emailVerified,
    "sms_verified": smsVerified,
    "kyc_verified": kycVerified,
    "ver_code": verCode,
    "ver_code_send_at": verCodeSendAt,
    "two_factor_verified": twoFactorVerified,
    "two_factor_status": twoFactorStatus,
    "two_factor_secret": twoFactorSecret,
    // "device_id": deviceId,
    // "firebase_token": firebaseToken,
    // "email_verified_at": emailVerifiedAt,
    // "deleted_at": deletedAt,
    // "created_at": createdAt.toIso8601String(),
    // "updated_at": updatedAt.toIso8601String(),
    // "fullname": fullname,
    // "userImage": userImage,
    // "stringStatus": stringStatus.toJson(),
    // "lastLogin": lastLogin,
    // "kycStringStatus": kycStringStatus.toJson(),
    // "wallets": List<dynamic>.from(wallets.map((x) => x.toJson())),
  };
}

class Address {
  dynamic country;
  dynamic state;
  dynamic city;
  dynamic zip;
  dynamic address;

  Address({
    required this.country,
    required this.state,
    required this.city,
    required this.zip,
    required this.address,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    country: json["country"] ?? "",
    state: json["state"] ?? "",
    city: json["city"] ?? "",
    zip: json["zip"] ?? "",
    address: json["address"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "state": state,
    "city": city,
    "zip": zip,
    "address": address,
  };
}

class StringStatus {
  dynamic stringStatusClass;
  dynamic value;

  StringStatus({
    required this.stringStatusClass,
    required this.value,
  });

  factory StringStatus.fromJson(Map<String, dynamic> json) => StringStatus(
    stringStatusClass: json["class"] ?? "",
    value: json["value"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "class": stringStatusClass,
    "value": value,
  };
}

class Wallet {
  int id;
  int userId;
  int currencyId;
  dynamic balance;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Wallet({
    required this.id,
    required this.userId,
    required this.currencyId,
    required this.balance,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    id: json["id"],
    userId: json["user_id"],
    currencyId: json["currency_id"],
    balance: json["balance"]?.toDouble(),
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "currency_id": currencyId,
    "balance": balance,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Message {
  List<String> success;

  Message({
    required this.success,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    success: List<String>.from(json["success"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": List<dynamic>.from(success.map((x) => x)),
  };
}
