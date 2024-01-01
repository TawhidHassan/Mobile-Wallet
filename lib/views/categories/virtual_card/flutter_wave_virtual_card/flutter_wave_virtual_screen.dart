import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/extentions/custom_extentions.dart';
import 'package:qrpay/widgets/others/custom_glass/custom_glass_widget.dart';

import '../../../../backend/model/categories/virtual_card/virtual_card_flutter_wave/card_info_model.dart';
import '../../../../backend/utils/custom_loading_api.dart';
import '../../../../controller/categories/virtual_card/flutter_wave_virtual_card/virtual_card_controller.dart';
import '../../../../custom_assets/assets.gen.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/custom_color.dart';
import '../../../../utils/custom_style.dart';
import '../../../../utils/dimensions.dart';
import '../../../../utils/size.dart';
import '../../../../utils/strings.dart';
import '../../../../widgets/bottom_navbar/categorie_widget.dart';
import '../../../../widgets/bottom_navbar/transaction_history_widget.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/text_labels/custom_title_heading_widget.dart';
import '../../../../widgets/text_labels/title_heading3_widget.dart';

class FlutterWaveVirtualCardScreen extends StatelessWidget {
  const FlutterWaveVirtualCardScreen({super.key, required this.controller});

  final VirtualCardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading
          ? const CustomLoadingAPI()
          : _bodyWidget(context),
    );
  }

  _bodyWidget(BuildContext context) {
    final data = controller.cardInfoModel.data.myCard;
    return Stack(
      children: [
        Column(
          children: [
            data.isEmpty ? _emptyCardWidget(context) : _cardWidget(context),
            data.isEmpty
                ? _createCardWidget(context)
                : _cardCategoriesWidget(context),
            const SizedBox()
          ],
        ),
        _draggableSheet(context),
      ],
    );
  }

  _draggableSheet(BuildContext context) {
    return DraggableScrollableSheet(
      builder: (_, scrollController) {
        return _recentTransWidget(context, scrollController);
      },
      initialChildSize: 0.45,
      minChildSize: 0.45,
      maxChildSize: 1,
    );
  }

  _cardWidget(BuildContext context) {
    final data = controller.cardInfoModel.data.myCard.first;
    return FlipCard(
        front: cardFontWidget(context, data),
        back: cardBackWidget(context, data));
  }

  cardFontWidget(BuildContext context, MyCard data) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        bottom: Dimensions.paddingSize * 0.5,
        left: Dimensions.paddingSize * 0.5,
        right: Dimensions.paddingSize * 2,
      ),
      height: MediaQuery.of(context).size.height * 0.30,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.card.frontPart.path),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: crossStart,
        children: [
          verticalSpace(Dimensions.heightSize * 1.2),
          Padding(
            padding: EdgeInsets.only(left: Dimensions.paddingSize * 1.5),
            child: const TitleHeading3Widget(
              text: Strings.payAndGo,
              color: CustomColor.whiteColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          verticalSpace(Dimensions.heightSize * 5),
          Center(
            child: Text(
              data.cardPan.formatCardNumber(),
              style: TextStyle(
                fontFamily: "AgencyFB",
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: CustomColor.whiteColor.withOpacity(0.6),
              ),
            ),
          ),
          verticalSpace(Dimensions.heightSize * 1.5),
          Padding(
            padding: EdgeInsets.only(left: Dimensions.paddingSize * 1.3),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: mainCenter,
                  crossAxisAlignment: crossStart,
                  children: [
                    CustomTitleHeadingWidget(
                      text:
                          '${data.expiration.split('-')[1]}/${data.expiration.split('-')[0].substring(data.expiration.split('-')[0].length - 2)}',
                      style: CustomStyle.f20w600pri
                          .copyWith(color: CustomColor.whiteColor),
                    ),
                    CustomTitleHeadingWidget(
                      text: Strings.expiryDate,
                      style: CustomStyle.f20w600pri.copyWith(
                          color: CustomColor.whiteColor.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                          fontSize: Dimensions.headingTextSize5),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  cardBackWidget(BuildContext context, MyCard data) {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(
          bottom: Dimensions.paddingSize * 1.5,
          left: Dimensions.paddingSize * 0.5,
          right: Dimensions.paddingSize * 0.5),
      height: MediaQuery.of(context).size.height * 0.30,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.card.backPart.path),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: crossStart,
        children: [
          verticalSpace(Dimensions.heightSize),
          horizontalSpace(Dimensions.widthSize),
          Column(
            mainAxisAlignment: mainCenter,
            children: [
              CustomTitleHeadingWidget(
                text: data.cvv,
                style: CustomStyle.f20w600pri
                    .copyWith(color: CustomColor.whiteColor),
              ),
              CustomTitleHeadingWidget(
                text: Strings.cvc,
                style: CustomStyle.f20w600pri.copyWith(
                    color: CustomColor.whiteColor.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                    fontSize: Dimensions.headingTextSize5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _emptyCardWidget(BuildContext context) {
    return FlipCard(
      front: emptyCardFontWidget(context),
      back: emptyCardBackWidget(context),
    );
  }

  emptyCardFontWidget(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        bottom: Dimensions.paddingSize * 0.5,
        left: Dimensions.paddingSize * 0.5,
        right: Dimensions.paddingSize * 2,
      ),
      height: MediaQuery.of(context).size.height * 0.30,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.card.frontPart.path),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: crossStart,
        children: [
          verticalSpace(Dimensions.heightSize * 1.5),
          Padding(
            padding: EdgeInsets.only(left: Dimensions.paddingSize * 1.5),
            child: const TitleHeading3Widget(
              text: Strings.payAndGo,
              color: CustomColor.whiteColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          verticalSpace(Dimensions.heightSize * 5),
          Center(
            child: Text(
              "0000000000000000".formatCardNumber(),
              style: TextStyle(
                fontFamily: "AgencyFB",
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: CustomColor.whiteColor.withOpacity(0.6),
              ),
            ),
          ),
          verticalSpace(Dimensions.heightSize * 1.5),
          Padding(
            padding: EdgeInsets.only(left: Dimensions.paddingSize * 1.3),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: mainCenter,
                  crossAxisAlignment: crossStart,
                  children: [
                    CustomTitleHeadingWidget(
                      text: '00/00',
                      style: CustomStyle.f20w600pri
                          .copyWith(color: CustomColor.whiteColor),
                    ),
                    CustomTitleHeadingWidget(
                      text: Strings.expiryDate,
                      style: CustomStyle.f20w600pri.copyWith(
                          color: CustomColor.whiteColor.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                          fontSize: Dimensions.headingTextSize5),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  emptyCardBackWidget(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(
          bottom: Dimensions.paddingSize * 1.5,
          left: Dimensions.paddingSize * 0.5,
          right: Dimensions.paddingSize * 0.5),
      height: MediaQuery.of(context).size.height * 0.30,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.card.backPart.path),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: crossStart,
        children: [
          verticalSpace(Dimensions.heightSize),
          horizontalSpace(Dimensions.widthSize),
          Column(
            mainAxisAlignment: mainCenter,
            children: [
              CustomTitleHeadingWidget(
                text: "000",
                style: CustomStyle.f20w600pri
                    .copyWith(color: CustomColor.whiteColor),
              ),
              CustomTitleHeadingWidget(
                text: Strings.cvc,
                style: CustomStyle.f20w600pri.copyWith(
                    color: CustomColor.whiteColor.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                    fontSize: Dimensions.headingTextSize5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _cardCategoriesWidget(BuildContext context) {
    final data = controller.cardInfoModel.data.myCard.first;
    return Container(
      margin: EdgeInsets.only(
          bottom: Dimensions.marginSizeVertical,
          top: Dimensions.marginSizeVertical),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CategoriesWidget(
              icon: Assets.icon.details,
              text: Strings.details,
              onTap: () {
                controller.getCardDetailsData(data.cardId);
                Get.toNamed(Routes.cardDetailsScreen);
              }),
          CategoriesWidget(
              icon: Assets.icon.fund,
              text: Strings.fund,
              onTap: () {
                Get.toNamed(Routes.addFundScreen);
              }),
          CategoriesWidget(
              icon: Assets.icon.transaction,
              text: Strings.transaction,
              onTap: () {
                controller.getCardTransactionData(
                    controller.cardInfoModel.data.myCard.first.cardId);
              }),
        ],
      ),
    );
  }

  _recentTransWidget(BuildContext context, ScrollController scrollController) {
    final data = controller.cardInfoModel.data.transactions;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.8),
      child: data.isNotEmpty
          ? ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                CustomTitleHeadingWidget(
                  text: Strings.recentTransactions,
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
                          amount: data[index].requestAmount,
                          title: data[index].transactionType,
                          dateText: controller.getDay(data[index].dateTime),
                          transaction: data[index].trx,
                          monthText: controller.getMonth(data[index].dateTime),
                        );
                      }),
                )
              ],
            ).customGlassWidget()
          : Container(),
    );
  }

  _createCardWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSize * .5,
        vertical: Dimensions.paddingSize * .5,
      ),
      padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSize * .5),
      child: PrimaryButton(
        title: Strings.createCard.tr,
        onPressed: () {
          Get.toNamed(Routes.buyCardScreen);
        },
        borderColor: Theme.of(context).primaryColor,
        buttonColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
