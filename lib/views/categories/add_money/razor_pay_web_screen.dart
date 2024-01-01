import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../backend/utils/custom_loading_api.dart';
import '../../../controller/categories/deposit/deposti_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/strings.dart';
import '../../../widgets/appbar/appbar_widget.dart';

class RazorPayWebPaymentScreen extends StatelessWidget {
  RazorPayWebPaymentScreen({super.key});

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
          text: Strings.razorPayPayment,
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
    final data = controller.addMoneyRazorPayInsertModel.data;
    var paymentUrl = data.url;

    return InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(paymentUrl)),
      onWebViewCreated: (InAppWebViewController controller) {},
      onProgressChanged: (InAppWebViewController controller, int progress) {},
    );
  }
}
