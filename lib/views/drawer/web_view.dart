import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../widgets/appbar/appbar_widget.dart';

class WebScreen extends StatelessWidget {
  const WebScreen({super.key, required this.url, required this.title});

  final String url, title;
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
          text: title,
          onTapLeading: () {
            Get.offAllNamed(Routes.bottomNavBarScreen);
          },
        ),
        body: _bodyWidget(context),
      ),
    );
  }

  _bodyWidget(BuildContext context) {

    return InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(url)),
      onWebViewCreated: (InAppWebViewController controller) {},
      onProgressChanged: (InAppWebViewController controller, int progress) {},
    );
  }
}
