import 'package:qrpay/utils/responsive_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../backend/utils/custom_loading_api.dart';
import '../../controller/app_settings/app_settings_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);
  final controller = Get.put(AppSettingsController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        body: Obx(
              () =>
          controller.isLoading
              ? CustomLoadingAPI(color: Theme
              .of(context)
              .primaryColor)
              : Center(
            child: CachedNetworkImage(
              imageUrl: controller.splashImagePath.value,
              placeholder: (context, url) => const Text(''),
              errorWidget: (context, url, error) => const Text(''),
            ),
          ),
        ),
      ),
    );
  }
}
