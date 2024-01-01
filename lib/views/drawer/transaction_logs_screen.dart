import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../backend/utils/custom_loading_api.dart';
import '../../controller/drawer/transaction_controller.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/responsive_layout.dart';
import '../../utils/strings.dart';
import '../../widgets/appbar/transaction_appbar.dart';
import 'transactions/add_money_log_screen.dart';
import 'transactions/add_sub_balance_log_screen.dart';
import 'transactions/bill_pay_log_screen.dart';
import 'transactions/make_payment_log_screen.dart';
import 'transactions/merchant_payment_log_screen.dart';
import 'transactions/mobile_top_up_log_screen.dart';
import 'transactions/remittance_log_screen.dart';
import 'transactions/send_money_log_screen.dart';
import 'transactions/virtual_card_log_screen.dart';
import 'transactions/withdraw_log_screen.dart';

class TransactionLogScreen extends StatelessWidget {
  TransactionLogScreen({super.key});

  final controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: DefaultTabController(
        length: 10,
        child: Scaffold(
          appBar: TransactionAppBarWidget(
              text: Strings.transactionLog.tr,
              bottomBar: PreferredSize(
                preferredSize: _tabBarWidget.preferredSize,
                child: ColoredBox(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: _tabBarWidget,
                ),
              )),
          body: Obx(
            () => controller.isLoading
                ? const CustomLoadingAPI()
                : _bodyWidget(context),
          ),
        ),
      ),
    );
  }

  // tab bar widget
  TabBar get _tabBarWidget => TabBar(
        isScrollable: true,
        labelColor: Colors.white,
        unselectedLabelColor: CustomColor.primaryLightTextColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: CustomStyle.lightHeading4TextStyle.copyWith(
          color: CustomColor.primaryLightColor,
          fontSize: Dimensions.headingTextSize4,
        ),
        unselectedLabelStyle: CustomStyle.lightHeading4TextStyle.copyWith(
          color: CustomColor.primaryLightTextColor,
          fontSize: Dimensions.headingTextSize4,
        ),
        indicator: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(50),
          color: CustomColor.primaryLightColor,
        ),
        tabs: [
          Tab(
            child: Text(
              Strings.addMoneyLog.tr,
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            child: Text(
              Strings.withdrawLog.tr,
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            child: Text(
              Strings.sendMoneyLog.tr,
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            child: Text(
              Strings.billPayLog.tr,
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            child: Text(
              Strings.mobileTopUpLog.tr,
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            child: Text(
              Strings.virtualCardLog.tr,
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            child: Text(
              Strings.remittanceLog.tr,
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            child: Text(
              Strings.merchantPaymentLog.tr,
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            child: Text(
              Strings.makePaymentLog.tr,
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            child: Text(
              Strings.addSubBalanceLog.tr,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );

  _bodyWidget(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSizeHorizontal * 0.5),
      child: TabBarView(
        physics: const BouncingScrollPhysics(),
        children: [
          AddMoneyLogScreen(controller: controller),
          WithdrawLogScreen(controller: controller),
          SendMoneyLogScreen(controller: controller),
          BillPayLogScreen(controller: controller),
          MobileTopUpLogScreen(controller: controller),
          VirtualCardLogScreen(controller: controller),
          RemittanceLogScreen(controller: controller),
          MerchantPaymentLogScreen(controller: controller),
          MakePaymentLogScreen(controller: controller),
          AddSubBalanceLogScreen(controller: controller),
        ],
      ),
    );
  }
}
