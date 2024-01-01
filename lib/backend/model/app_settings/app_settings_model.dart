import 'dart:convert';

AppSettingsModel appSettingsModelFromJson(String str) =>
    AppSettingsModel.fromJson(json.decode(str));

String appSettingsModelToJson(AppSettingsModel data) =>
    json.encode(data.toJson());

class AppSettingsModel {
  Message message;
  Data data;

  AppSettingsModel({
    required this.message,
    required this.data,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      AppSettingsModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  String defaultImage;
  String imagePath;
  List<OnboardScreen> onboardScreen;
  SplashScreen splashScreen;
  AppUrl appUrl;
  AllLogo allLogo;
  String logoImagePath;

  Data({
    required this.defaultImage,
    required this.imagePath,
    required this.onboardScreen,
    required this.splashScreen,
    required this.appUrl,
    required this.allLogo,
    required this.logoImagePath,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        defaultImage: json["default_image"],
        imagePath: json["image_path"],
        onboardScreen: List<OnboardScreen>.from(
            json["onboard_screen"].map((x) => OnboardScreen.fromJson(x))),
        splashScreen: SplashScreen.fromJson(json["splash_screen"]),
        appUrl: AppUrl.fromJson(json["app_url"]),
        allLogo: AllLogo.fromJson(json["all_logo"]),
        logoImagePath: json["logo_image_path"],
      );

  Map<String, dynamic> toJson() => {
        "default_image": defaultImage,
        "image_path": imagePath,
        "onboard_screen":
            List<dynamic>.from(onboardScreen.map((x) => x.toJson())),
        "splash_screen": splashScreen.toJson(),
        "app_url": appUrl.toJson(),
        "all_logo": allLogo.toJson(),
        "logo_image_path": logoImagePath,
      };
}

class AllLogo {
  String siteLogoDark;
  String siteLogo;
  String siteFavDark;
  String siteFav;

  AllLogo({
    required this.siteLogoDark,
    required this.siteLogo,
    required this.siteFavDark,
    required this.siteFav,
  });

  factory AllLogo.fromJson(Map<String, dynamic> json) => AllLogo(
        siteLogoDark: json["site_logo_dark"],
        siteLogo: json["site_logo"],
        siteFavDark: json["site_fav_dark"],
        siteFav: json["site_fav"],
      );

  Map<String, dynamic> toJson() => {
        "site_logo_dark": siteLogoDark,
        "site_logo": siteLogo,
        "site_fav_dark": siteFavDark,
        "site_fav": siteFav,
      };
}

class AppUrl {
  int id;
  String androidUrl;
  String isoUrl;
  DateTime createdAt;
  DateTime updatedAt;

  AppUrl({
    required this.id,
    required this.androidUrl,
    required this.isoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppUrl.fromJson(Map<String, dynamic> json) => AppUrl(
        id: json["id"],
        androidUrl: json["android_url"],
        isoUrl: json["iso_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "android_url": androidUrl,
        "iso_url": isoUrl,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class OnboardScreen {
  int id;
  String title;
  String subTitle;
  String image;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  OnboardScreen({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OnboardScreen.fromJson(Map<String, dynamic> json) => OnboardScreen(
        id: json["id"],
        title: json["title"],
        subTitle: json["sub_title"],
        image: json["image"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "sub_title": subTitle,
        "image": image,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class SplashScreen {
  int id;
  String splashScreenImage;
  String version;
  DateTime createdAt;
  DateTime updatedAt;

  SplashScreen({
    required this.id,
    required this.splashScreenImage,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SplashScreen.fromJson(Map<String, dynamic> json) => SplashScreen(
        id: json["id"],
        splashScreenImage: json["splash_screen_image"],
        version: json["version"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "splash_screen_image": splashScreenImage,
        "version": version,
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
