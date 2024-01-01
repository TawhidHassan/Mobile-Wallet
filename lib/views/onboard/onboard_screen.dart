import 'package:qrpay/backend/local_storage/local_storage.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/utils/custom_color.dart';
import 'package:qrpay/utils/custom_style.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/widgets/text_labels/custom_title_heading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../backend/services/api_endpoint.dart';
import '../../controller/app_settings/app_settings_controller.dart';
import '../../controller/splsh_onboard/onboard_controller.dart';

class OnboardScreen extends StatelessWidget {
  OnboardScreen({Key? key}) : super(key: key);
  final controller = Get.put(OnBoardController());
  final appSettingsController = Get.put(AppSettingsController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
          backgroundColor: Theme
              .of(context)
              .scaffoldBackgroundColor,
          body: Column(children: [
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: controller.pageController,
                onPageChanged: controller.selectedIndex,
                itemCount: appSettingsController.onboardScreen.length,
                itemBuilder: (context, index) {
                  var data = appSettingsController.onboardScreen[index];
                  return Stack(
                    children: [
                      Positioned(
                        top: 10,
                        child: CachedNetworkImage(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height,
                          imageUrl:
                          "${ApiEndpoint.mainDomain}/${appSettingsController
                              .appSettingsModel.data.imagePath}/${data.image}",
                          placeholder: (context, url) => Container(),
                          errorWidget: (context, url, error) => Container(),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: mainEnd,
                        children: [
                          _bottomContainerWidget(context,
                              child: Column(
                                children: [
                                  _titleAndSubTitleWidget(context, index, data),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                        Dimensions.paddingSize * 0.35),
                                    child: Row(
                                      mainAxisAlignment: mainSpaceBet,
                                      children: [
                                        _skipButtonWidget(context),
                                        Obx(() => controller.dotWidget()),
                                        Obx(() => controller.arrowWidget()),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ])),
    );
  }
}

_bottomContainerWidget(BuildContext context, {required Widget child}) {
  Radius borderRadius = const Radius.circular(20);
  return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSizeHorizontal * 0.5),
      decoration: BoxDecoration(
        color: CustomColor.whiteColor,
        borderRadius:
        BorderRadius.only(topLeft: borderRadius, topRight: borderRadius),
        boxShadow: [
          BoxShadow(
            color: Theme
                .of(context)
                .primaryColor
                .withOpacity(0.015),
            spreadRadius: 7,
            blurRadius: 5,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.all(Dimensions.paddingSize),
      child: child);
}

_titleAndSubTitleWidget(BuildContext context, int index, data) {
  return Column(
    children: [
      Builder(builder: (context) {
        return CustomTitleHeadingWidget(
          text: data.title,
          textAlign: TextAlign.start,
          maxLines: 2,
          textOverflow: TextOverflow.ellipsis,
          style: CustomStyle.onboardTitleStyle,
        );
      }),
      verticalSpace(Dimensions.heightSize),
      Padding(
        padding: EdgeInsets.all(Dimensions.paddingSize * 0.04),
        child: CustomTitleHeadingWidget(
          text: data.subTitle,
          textAlign: TextAlign.justify,
          maxLines: 3,
          textOverflow: TextOverflow.ellipsis,
          style: CustomStyle.onboardSubTitleStyle,
        ),
      ),
      verticalSpace(Dimensions.heightSize * 1.8)
    ],
  );
}

_skipButtonWidget(BuildContext context) {
  return InkWell(
    onTap: (() {
      Get.toNamed(Routes.signInScreen);
      LocalStorage.saveOnboardDoneOrNot(isOnBoardDone: true);
    }),
    child: CustomTitleHeadingWidget(
      text: Strings.skip,
      style: CustomStyle.onboardSkipStyle,
    ),
  );
}
