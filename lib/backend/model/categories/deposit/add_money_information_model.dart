// To parse this JSON data, do
//
//     final addMoneyInfoModel = addMoneyInfoModelFromJson(jsonString);

import 'dart:convert';

AddMoneyInfoModel addMoneyInfoModelFromJson(String str) =>
    AddMoneyInfoModel.fromJson(json.decode(str));

String addMoneyInfoModelToJson(AddMoneyInfoModel data) =>
    json.encode(data.toJson());

class AddMoneyInfoModel {
  AddMoneyInfoModel({
    required this.message,
    required this.data,
  });

  Message message;
  Data data;

  factory AddMoneyInfoModel.fromJson(Map<String, dynamic> json) =>
      AddMoneyInfoModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.baseCurr,
    required this.baseCurrRate,
    required this.defaultImage,
    required this.imagePath,
    required this.userWallet,
    required this.gateways,
    required this.transactionss,
  });

  String baseCurr;
  dynamic baseCurrRate;
  String defaultImage;
  String imagePath;
  UserWallet userWallet;
  List<Gateway> gateways;
  List<dynamic> transactionss;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        baseCurr: json["base_curr"],
        baseCurrRate: json["base_curr_rate"]?.toDouble() ?? 0.0,
        defaultImage: json["default_image"],
        imagePath: json["image_path"],
        userWallet: UserWallet.fromJson(json["userWallet"]),
        gateways: List<Gateway>.from(
            json["gateways"].map((x) => Gateway.fromJson(x))),
        transactionss: List<dynamic>.from(json["transactionss"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "base_curr": baseCurr,
        "base_curr_rate": baseCurrRate,
        "default_image": defaultImage,
        "image_path": imagePath,
        "userWallet": userWallet.toJson(),
        "gateways": List<dynamic>.from(gateways.map((x) => x.toJson())),
        "transactionss": List<dynamic>.from(transactionss.map((x) => x)),
      };
}

class Gateway {
  Gateway({
    required this.id,
    required this.image,
    required this.slug,
    required this.code,
    required this.type,
    required this.alias,
    required this.supportedCurrencies,
    required this.status,
    required this.currencies,
  });

  int id;
  String image;
  String slug;
  int code;
  String type;
  String alias;
  List<String> supportedCurrencies;
  int status;
  List<Currency> currencies;

  factory Gateway.fromJson(Map<String, dynamic> json) => Gateway(
        id: json["id"],
        image: json["image"],
        slug: json["slug"],
        code: json["code"],
        type: json["type"],
        alias: json["alias"],
        supportedCurrencies:
            List<String>.from(json["supported_currencies"].map((x) => x)),
        status: json["status"],
        currencies: List<Currency>.from(
            json["currencies"].map((x) => Currency.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "slug": slug,
        "code": code,
        "type": type,
        "alias": alias,
        "supported_currencies":
            List<dynamic>.from(supportedCurrencies.map((x) => x)),
        "status": status,
        "currencies": List<dynamic>.from(currencies.map((x) => x.toJson())),
      };
}

class Currency {
  Currency({
    required this.id,
    required this.paymentGatewayId,
    required this.type,
    required this.name,
    required this.alias,
    required this.currencyCode,
    required this.currencySymbol,
    this.image,
    required this.minLimit,
    required this.maxLimit,
    required this.percentCharge,
    required this.fixedCharge,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int paymentGatewayId;
  String type;
  String name;
  String alias;
  String currencyCode;
  String currencySymbol;
  dynamic image;
  dynamic minLimit;
  dynamic maxLimit;
  dynamic percentCharge;
  dynamic fixedCharge;
  dynamic rate;
  DateTime createdAt;
  DateTime updatedAt;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        paymentGatewayId: json["payment_gateway_id"],
        type: json["type"],
        name: json["name"],
        alias: json["alias"],
        currencyCode: json["currency_code"],
        currencySymbol: json["currency_symbol"],
        image: json["image"] ?? "",
        minLimit: json["min_limit"]?.toDouble() ?? 0.0,
        maxLimit: json["max_limit"]?.toDouble() ?? 0.0,
        percentCharge: json["percent_charge"]?.toDouble() ?? 0.0,
        fixedCharge: json["fixed_charge"]?.toDouble() ?? 0.0,
        rate: json["rate"]?.toDouble() ?? 0.0,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_gateway_id": paymentGatewayId,
        "type": type,
        "name": name,
        "alias": alias,
        "currency_code": currencyCode,
        "currency_symbol": currencySymbol,
        "image": image,
        "min_limit": minLimit,
        "max_limit": maxLimit,
        "percent_charge": percentCharge,
        "fixed_charge": fixedCharge,
        "rate": rate,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class UserWallet {
  UserWallet({
    required this.balance,
    required this.currency,
  });

  double balance;
  String currency;

  factory UserWallet.fromJson(Map<String, dynamic> json) => UserWallet(
        balance: json["balance"].toDouble(),
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "currency": currency,
      };
}

class Message {
  Message({
    required this.success,
  });

  List<String> success;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        success: List<String>.from(json["success"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": List<dynamic>.from(success.map((x) => x)),
      };
}
