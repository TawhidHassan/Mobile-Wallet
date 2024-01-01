import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/controller/categories/virtual_card/flutter_wave_virtual_card/virtual_card_controller.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/views/categories/virtual_card/sudo_virtual_card/sudo_virtual_screen.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';

import '../../../controller/categories/virtual_card/sudo_virtual_card/virtual_card_sudo_controller.dart';
import '../../../controller/navbar/dashboard_controller.dart';
import 'flutter_wave_virtual_card/flutter_wave_virtual_screen.dart';

class VirtualCardScreen extends StatelessWidget {
  VirtualCardScreen({super.key});

  final flutterWaveController = Get.put(VirtualCardController());
  final sudoController = Get.put(VirtualSudoCardController());
  final dashboardController = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(
          text: Strings.virtualCard,
          homeButtonShow:
              dashboardController.dashBoardModel.data.activeVirtualSystem ==
                      'sudo'
                  ? true
                  : false,
          onTapAction: () {
            Get.toNamed(Routes.sudoCreateCardScreen);
          },
          actionIcon: Icons.add_circle_outline_outlined,
        ),
        body: dashboardController.dashBoardModel.data.activeVirtualSystem ==
                'sudo'
            ? SudoVirtualCardScreen(controller: sudoController)
            : FlutterWaveVirtualCardScreen(controller: flutterWaveController),
      ),
    );
  }
}
