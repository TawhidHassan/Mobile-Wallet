import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
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
import 'balance_show.dart';
import 'home_slider.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final controller = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    controller.getNotice();
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        body: Obx(() =>
        controller.isLoading
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
        controller.getNotice();
        controller.getSlider();
        return Future<void>.delayed(const Duration(seconds: 3));
      },
      child: Stack(
        children: [
          ListView(
            children: [
              _appbarContainer(context),
              _categoriesWidget(context),
              HomeSlider(),
              SizedBox(height: 16,),
              // _transactionWidget(context),
            ],
          ),

          // _draggableSheet(context)
        ],
      ),
    );
  }

  _draggableSheet(BuildContext context) {
    return DraggableScrollableSheet(
      builder: (_, scrollController) {
        return _transactionWidget(context);
      },
      initialChildSize: 0.44,
      minChildSize: 0.44,
      maxChildSize: 1.00,
    );
  }

  _appbarContainer(BuildContext context) {
    var data = controller.dashBoardModel.data.userWallet;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Theme
              .of(context)
              .primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(Dimensions.radius * 2),
            bottomRight: Radius.circular(Dimensions.radius * 2),
          )),
      child: Column(
        mainAxisAlignment: mainCenter,
        children: [
          GetBuilder<DashBoardController>(
            assignId: true,
            builder: (logic) {
              return Obx(() {
                return logic.noticeCirculer.value?CircularProgressIndicator():
                logic.noticeModel!.data!=null?
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                  decoration:  BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  width: 1.0.sw,
                  height: 30,
                  child: Marquee(
                  text:logic.noticeModel!.data!.description??"",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  blankSpace: 20.0,
                  velocity: 100.0,
                  pauseAfterRound: Duration(seconds: 1),
                  startPadding: 10.0,
                  accelerationDuration: Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,

                                    ),
                ):SizedBox();
              });
            },
          ),
          SizedBox(height: 12,),
          CustomAppBar(balance: "${data.balance.toString()} ${data.currency}"),
          // CustomTitleHeadingWidget(
          //   text: "${data.balance.toString()} ${data.currency}",
          //   style: CustomStyle.darkHeading1TextStyle.copyWith(
          //     fontSize: Dimensions.headingTextSize4 * 2,
          //     fontWeight: FontWeight.w800,
          //     color: CustomColor.whiteColor,
          //   ),
          // ),
          SizedBox(height: 6,),
          CustomTitleHeadingWidget(
            text: Strings.currentBalance,
            style: CustomStyle.lightHeading4TextStyle.copyWith(
              fontSize: Dimensions.headingTextSize3,
              color: CustomColor.whiteColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 12,)
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
                (index) =>
                CategoriesWidget(
                  onTap: controller.categoriesData[index].onTap,
                  icon: controller.categoriesData[index].icon,
                  text: controller.categoriesData[index].text,
                ),
          ),
        ));
  }

  _transactionWidget(BuildContext context,) {
    var data = controller.dashBoardModel.data.transactions;
    return data.isEmpty
        ? NoDataWidget(
      title: Strings.noTransaction.tr,
    )
        : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            shrinkWrap: true,
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
               child: ListView.builder(
                shrinkWrap: true,
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
              ).customGlassWidget(),
        );
  }
}
