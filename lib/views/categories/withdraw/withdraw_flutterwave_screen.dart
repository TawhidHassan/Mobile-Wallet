import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';
import 'package:qrpay/widgets/buttons/primary_button.dart';

import '../../../controller/categories/withdraw_controller/withdraw_controller.dart';
import '../../../widgets/dropdown/flutter_wave_banks_drop_down.dart';
import '../../../widgets/inputs/primary_input_filed.dart';
import '../../../widgets/others/congratulation_widget.dart';

class WithdrawFlutterWaveScreen extends StatelessWidget {
  WithdrawFlutterWaveScreen({super.key});

  final controller = Get.put(WithdrawController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(text: Strings.withdraw),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
        bottomNavigationBar: _buttonWidget(context),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.9),
      child: Column(
        children: [
          _inputWidget(context),
        ],
      ),
    );
  }

  _inputWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 1),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryInputWidget(
              controller: controller.accountNumberController,
              hint: Strings.enterAccountNumber.tr,
              label: Strings.accountNumber.tr,
              onFieldSubmitted: (value) {
                controller.isButtonEnable.value = false;
              },
            ),
            verticalSpace(Dimensions.heightSize * .8),
            const FlutterWaveBanksDropDown(),
          ],
        ),
      ),
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(Dimensions.paddingSize * .5),
      child: Obx(
        () => controller.isConfirmManualLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.confirm,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.flutterwavePaymentProcess().then((value) =>
                        StatusScreen.show(
                            context: context,
                            subTitle: controller.manualPaymentConfirmModel
                                .message.success.first,
                            onPressed: () {
                              controller.isButtonEnable.value = false;
                              Get.offAllNamed(Routes.bottomNavBarScreen);
                            }));
                  }
                }),
      ),
    );
  }
}
