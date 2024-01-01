import 'dart:async';

import 'package:get/get.dart';

import '../../backend/local_storage/local_storage.dart';
import '../../routes/routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() async {
    super.onReady();
    _goToScreen();
  }

  _goToScreen() async {
    Timer(const Duration(seconds: 3), () {
      LocalStorage.isLoggedIn()
          ? Get.offAndToNamed(Routes.signInScreen)
          : Get.offAndToNamed(
              LocalStorage.isOnBoardDone()
                  ? Routes.signInScreen
                  : Routes.onboardScreen,
            );
    });
  }
}
