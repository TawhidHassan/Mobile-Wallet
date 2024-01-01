import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/controller/navbar/dashboard_controller.dart';
import 'package:qrpay/utils/custom_color.dart';
import 'package:qrpay/utils/custom_style.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/widgets/bottom_navbar/categorie_widget.dart';
import 'package:qrpay/widgets/others/custom_glass/custom_glass_widget.dart';
import 'package:qrpay/widgets/text_labels/custom_title_heading_widget.dart';

import '../../backend/utils/no_data_widget.dart';
import '../../widgets/bottom_navbar/transaction_history_widget.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final controller = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        body: Obx(() => controller.isLoading
            ? const CustomLoadingAPI()
            : _bodyWidget(context)),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.black,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      strokeWidth: 2.5,
      onRefresh: () async {
        controller.getDashboardData();
        return Future<void>.delayed(const Duration(seconds: 3));
      },
      child: Stack(
        children: [
          ListView(
            children: [
              _appbarContainer(context),
              _categoriesWidget(context),
            ],
          ),
          _draggableSheet(context)
        ],
      ),
    );
  }

  _draggableSheet(BuildContext context) {
    return DraggableScrollableSheet(
      builder: (_, scrollController) {
        return _transactionWidget(context, scrollController);
      },
      initialChildSize: 0.55,
      minChildSize: 0.55,
      maxChildSize: 0.80,
    );
  }

  _appbarContainer(BuildContext context) {
    var data = controller.dashBoardModel.data.userWallet;
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.17,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(Dimensions.radius * 2),
            bottomRight: Radius.circular(Dimensions.radius * 2),
          )),
      child: Column(
        mainAxisAlignment: mainCenter,
        children: [
          CustomTitleHeadingWidget(
            text: "${data.balance.toString()} ${data.currency}",
            style: CustomStyle.darkHeading1TextStyle.copyWith(
              fontSize: Dimensions.headingTextSize4 * 2,
              fontWeight: FontWeight.w800,
              color: CustomColor.whiteColor,
            ),
          ),
          CustomTitleHeadingWidget(
            text: Strings.currentBalance,
            style: CustomStyle.lightHeading4TextStyle.copyWith(
              fontSize: Dimensions.headingTextSize3,
              color: CustomColor.whiteColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  _categoriesWidget(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
          top: Dimensions.marginSizeVertical * 0.5,
          bottom: Dimensions.marginSizeVertical * 0.8,
          right: Dimensions.marginSizeVertical * 0.4,
          left: Dimensions.marginSizeVertical * 0.2,
        ),
        child: GridView.count(
          padding: const EdgeInsets.only(),
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          crossAxisCount: 5,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 10.0,
          shrinkWrap: true,
          children: List.generate(
            controller.categoriesData.length,
            (index) => CategoriesWidget(
              onTap: controller.categoriesData[index].onTap,
              icon: controller.categoriesData[index].icon,
              text: controller.categoriesData[index].text,
            ),
          ),
        ));
  }

  _transactionWidget(BuildContext context, ScrollController scrollController) {
    var data = controller.dashBoardModel.data.transactions;
    return data.isEmpty
        ? NoDataWidget(
            title: Strings.noTransaction.tr,
          )
        : ListView(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.8),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CustomTitleHeadingWidget(
                text: Strings.recentTransactions,
                padding: EdgeInsets.only(top: Dimensions.paddingSize),
                style: Get.isDarkMode
                    ? CustomStyle.darkHeading3TextStyle.copyWith(
                        fontSize: Dimensions.headingTextSize2,
                        fontWeight: FontWeight.w600,
                      )
                    : CustomStyle.lightHeading3TextStyle.copyWith(
                        fontSize: Dimensions.headingTextSize2,
                        fontWeight: FontWeight.w600,
                      ),
              ),
              verticalSpace(Dimensions.widthSize),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return TransactionWidget(
                        amount: data[index].requestAmount!,
                        title: data[index].transactionType!,
                        dateText: DateFormat.d().format(data[index].dateTime!),
                        transaction: data[index].trx!,
                        monthText:
                            DateFormat.MMMM().format(data[index].dateTime!),
                      );
                    }),
              )
            ],
          ).customGlassWidget();
  }
}
