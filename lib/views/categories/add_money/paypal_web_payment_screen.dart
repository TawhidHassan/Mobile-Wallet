import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../backend/utils/custom_loading_api.dart';
import '../../../controller/categories/deposit/deposti_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/strings.dart';
import '../../../widgets/appbar/appbar_widget.dart';

class PaypalWebPaymentScreen extends StatelessWidget {
  PaypalWebPaymentScreen({super.key});

  final controller = Get.put(DepositController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(Routes.bottomNavBarScreen);
        return false;
      },
      child: Scaffold(
        appBar: AppBarWidget(
          homeButtonShow: true,
          text: Strings.paypalPayment,
          onTapLeading: () {
            Get.offAllNamed(Routes.bottomNavBarScreen);
          },
        ),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    var paymentUrl = '';
    final data = controller.addMoneyInsertPaypalModel.data.url;
    for (int i = 0; i < data.length; i++) {
      if (data[i].rel.contains('approve')) {
        paymentUrl = data[i].href;
      }
    }
    return InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(paymentUrl)),
      onWebViewCreated: (InAppWebViewController controller) {},
      onProgressChanged: (InAppWebViewController controller, int progress) {},
    );
  }
}
