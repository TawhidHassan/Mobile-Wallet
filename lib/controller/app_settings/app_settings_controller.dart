import 'package:get/get.dart';

import '../../backend/local_storage/local_storage.dart';
import '../../backend/model/app_settings/app_settings_model.dart';
import '../../backend/services/api_endpoint.dart';
import '../../backend/services/api_services.dart';

class AppSettingsController extends GetxController {
  final List<OnboardScreen> onboardScreen = [];

  RxString splashImagePath = ''.obs;
  @override
  void onInit() {
    getSplashAndOnboardData();
    super.onInit();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late AppSettingsModel _appSettingsModel;
  AppSettingsModel get appSettingsModel => _appSettingsModel;

  Future<AppSettingsModel> getSplashAndOnboardData() async {
    _isLoading.value = true;
    update();

    await ApiServices.appSettingsApi().then((value) {
      _appSettingsModel = value!;
      splashImagePath.value =
          "${ApiEndpoint.mainDomain}/${_appSettingsModel.data.imagePath}/${_appSettingsModel.data.splashScreen.splashScreenImage}";

      LocalStorage.saveSplashImage(
          image:
              "${ApiEndpoint.mainDomain}/${_appSettingsModel.data.imagePath}/${_appSettingsModel.data.splashScreen.splashScreenImage}");

      for (var element in _appSettingsModel.data.onboardScreen) {
        onboardScreen.add(
          OnboardScreen(
            id: element.id,
            title: element.title,
            subTitle: element.subTitle,
            image: element.image,
            status: element.status,
            createdAt: element.createdAt,
            updatedAt: element.updatedAt,
          ),
        );
      }

      update();
      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
      _isLoading.value = false;
    });
    _isLoading.value = false;
    update();
    return _appSettingsModel;
  }
}
