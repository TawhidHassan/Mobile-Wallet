import 'dart:convert';

CardInfoModel cardInfoModelFromJson(String str) =>
    CardInfoModel.fromJson(json.decode(str));

String cardInfoModelToJson(CardInfoModel data) => json.encode(data.toJson());

class Transaction {
  Transaction({
    required this.id,
    required this.trx,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.totalCharge,
    required this.cardAmount,
    required this.cardNumber,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
  });

  final int id;
  final String trx;
  final String transactionType;
  final String requestAmount;
  final String payable;
  final String totalCharge;
  final String cardAmount;
  final String cardNumber;
  final String currentBalance;
  final String status;
  final String dateTime;
  final TransactionStatusInfo statusInfo;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        trx: json["trx"],
        transactionType: json["transaction_type"],
        requestAmount: json["request_amount"],
        payable: json["payable"],
        totalCharge: json["total_charge"],
        cardAmount: json["card_amount"],
        cardNumber: json["card_number"],
        currentBalance: json["current_balance"],
        status: json["status"],
        dateTime: json["date_time"],
        statusInfo: TransactionStatusInfo.fromJson(json["status_info"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trx": trx,
        "transaction_type": transactionType,
        "request_amount": requestAmount,
        "payable": payable,
        "total_charge": totalCharge,
        "card_amount": cardAmount,
        "card_number": cardNumber,
        "current_balance": currentBalance,
        "status": status,
        "date_time": dateTime,
        "status_info": statusInfo.toJson(),
      };
}

class TransactionStatusInfo {
  TransactionStatusInfo({
    required this.success,
    required this.pending,
    required this.rejected,
  });

  final int success;
  final int pending;
  final int rejected;

  factory TransactionStatusInfo.fromJson(Map<String, dynamic> json) =>
      TransactionStatusInfo(
        success: json["success"],
        pending: json["pending"],
        rejected: json["rejected"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "pending": pending,
        "rejected": rejected,
      };
}

class CardInfoModel {
  Message message;
  Data data;

  CardInfoModel({
    required this.message,
    required this.data,
  });

  factory CardInfoModel.fromJson(Map<String, dynamic> json) => CardInfoModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  String baseCurr;
  List<MyCard> myCard;
  UserWallet userWallet;
  CardCharge cardCharge;
  List<Transaction> transactions;

  Data({
    required this.baseCurr,
    required this.myCard,
    required this.userWallet,
    required this.cardCharge,
    required this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        baseCurr: json["base_curr"],
        myCard:
            List<MyCard>.from(json["myCard"].map((x) => MyCard.fromJson(x))),
        userWallet: UserWallet.fromJson(json["userWallet"]),
        cardCharge: CardCharge.fromJson(json["cardCharge"]),
        transactions: List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "base_curr": baseCurr,
        "myCard": List<dynamic>.from(myCard.map((x) => x.toJson())),
        "userWallet": userWallet.toJson(),
        "cardCharge": cardCharge.toJson(),
        "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
      };
}

class CardCharge {
  int id;
  String slug;
  String title;
  dynamic fixedCharge;
  dynamic percentCharge;
  dynamic minLimit;
  dynamic maxLimit;

  CardCharge({
    required this.id,
    required this.slug,
    required this.title,
    required this.fixedCharge,
    required this.percentCharge,
    required this.minLimit,
    required this.maxLimit,
  });

  factory CardCharge.fromJson(Map<String, dynamic> json) => CardCharge(
        id: json["id"],
        slug: json["slug"],
        title: json["title"],
        fixedCharge: json["fixed_charge"]?.toDouble() ?? 0.0,
        percentCharge: json["percent_charge"]?.toDouble() ?? 0.0,
        minLimit: json["min_limit"]?.toDouble() ?? 0.0,
        maxLimit: json["max_limit"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "title": title,
        "fixed_charge": fixedCharge,
        "percent_charge": percentCharge,
        "min_limit": minLimit,
        "max_limit": maxLimit,
      };
}

class MyCard {
  int id;
  String name;
  String cardPan;
  String cardId;
  String expiration;
  String cvv;
  int amount;
  dynamic cardBackDetails;
  String siteTitle;
  String siteLogo;
  int status;
  MyCardStatusInfo statusInfo;

  MyCard({
    required this.id,
    required this.name,
    required this.cardPan,
    required this.cardId,
    required this.expiration,
    required this.cvv,
    required this.amount,
    this.cardBackDetails,
    required this.siteTitle,
    required this.siteLogo,
    required this.status,
    required this.statusInfo,
  });

  factory MyCard.fromJson(Map<String, dynamic> json) => MyCard(
        id: json["id"],
        name: json["name"],
        cardPan: json["card_pan"],
        cardId: json["card_id"],
        expiration: json["expiration"],
        cvv: json["cvv"],
        amount: json["amount"],
        cardBackDetails: json["card_back_details"],
        siteTitle: json["site_title"],
        siteLogo: json["site_logo"],
        status: json["status"],
        statusInfo: MyCardStatusInfo.fromJson(json["status_info"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "card_pan": cardPan,
        "card_id": cardId,
        "expiration": expiration,
        "cvv": cvv,
        "amount": amount,
        "card_back_details": cardBackDetails,
        "site_title": siteTitle,
        "site_logo": siteLogo,
        "status": status,
        "status_info": statusInfo.toJson(),
      };
}

class MyCardStatusInfo {
  int block;
  int unblock;

  MyCardStatusInfo({
    required this.block,
    required this.unblock,
  });

  factory MyCardStatusInfo.fromJson(Map<String, dynamic> json) =>
      MyCardStatusInfo(
        block: json["block"],
        unblock: json["unblock"],
      );

  Map<String, dynamic> toJson() => {
        "block": block,
        "unblock": unblock,
      };
}

class UserWallet {
  double balance;
  String currency;

  UserWallet({
    required this.balance,
    required this.currency,
  });

  factory UserWallet.fromJson(Map<String, dynamic> json) => UserWallet(
        balance: json["balance"]?.toDouble(),
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "currency": currency,
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
