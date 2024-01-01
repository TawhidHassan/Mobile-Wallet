import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/model/send_money/add_money_razorpay_insert_model.dart';

import '../../../backend/model/categories/deposit/add_money_flutter_wave_model.dart';
import '../../../backend/model/common/common_success_model.dart';
import '../../../backend/model/send_money/add_money_paypal_insert_model.dart';
import '../../../backend/model/send_money/add_money_stripe_insert_model.dart';
import '../../../backend/model/send_money/send_money_manual_insert_model.dart';
import '../../../backend/model/send_money/send_money_payment_gateway_model.dart';
import '../../../backend/services/api_services.dart';
import '../../../routes/routes.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/custom_style.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/inputs/manual_payment_image_widget.dart';
import '../../../widgets/inputs/primary_input_filed.dart';
import '../../../widgets/text_labels/custom_title_heading_widget.dart';

class DepositController extends GetxController {
  final flipCardController = FlipCardController();
  final copyInputController = TextEditingController();

  List<TextEditingController> inputFieldControllers = [];
  RxList inputFields = [].obs;
  List<String> listImagePath = [];
  List<String> listFieldName = [];
  RxBool hasFile = false.obs;

  RxString baseCurrency = "".obs;
  RxString selectedCurrencyAlias = "".obs;
  RxString selectedCurrencyName = "Select Method".obs;
  RxString selectedCurrencyType = "".obs;
  RxString selectedGatewaySlug = "".obs;
  RxString currencyCode = "".obs;
  RxString currencyWalletCode = "".obs;
  RxString gatewayTrx = "".obs;
  RxInt selectedCurrencyId = 0.obs;
  RxDouble fee = 0.0.obs;
  RxDouble limitMin = 0.0.obs;
  RxDouble limitMax = 0.0.obs;
  RxDouble percentCharge = 0.0.obs;
  RxDouble rate = 0.0.obs;

  String enteredAmount = "";
  String transferFeeAmount = "";
  String totalCharge = "";
  String youWillGet = "";
  String payableAmount = "";

  List<Currency> currencyList = [];
  List<String> baseCurrencyList = [];

  final depositMethod = TextEditingController();

  final cardNumberController = TextEditingController();
  final cardExpiryController = TextEditingController();
  final cardCVCController = TextEditingController();

  final cardHolderNameController = TextEditingController();
  final cardExpiryDateController = TextEditingController();
  final cardCvvController = TextEditingController();

  void gotoPreview() {
    Get.toNamed(Routes.depositPreviewScreen);
  }

  @override
  void onInit() {
    getAddMoneyPaymentGatewayData();
    amountTextController.text = 'Amount:-  0.0';
    super.onInit();
  }

  // ---------------------------- AddMoneyPaymentGatewayModel ------------------
  // api loading process indicator variable
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late AddMoneyPaymentGatewayModel _addMoneyPaymentGatewayModel;

  AddMoneyPaymentGatewayModel get addMoneyPaymentGatewayModel =>
      _addMoneyPaymentGatewayModel;

  // --------------------------- Api function ----------------------------------
  // get addMoneyPaymentGateway data function
  Future<AddMoneyPaymentGatewayModel> getAddMoneyPaymentGatewayData() async {
    _isLoading.value = true;
    update();

    await ApiServices.addMoneyPaymentGatewayAPi().then((value) {
      _addMoneyPaymentGatewayModel = value!;

      currencyCode.value =
          _addMoneyPaymentGatewayModel.data.userWallet.currency;
      currencyWalletCode.value = _addMoneyPaymentGatewayModel
          .data.gateways.first.currencies.first.currencyCode;

      for (var gateways in _addMoneyPaymentGatewayModel.data.gateways) {
        for (var currency in gateways.currencies) {
          currencyList.add(
            Currency(
              id: currency.id,
              paymentGatewayId: currency.paymentGatewayId,
              name: currency.name,
              alias: currency.alias,
              currencyCode: currency.currencyCode,
              currencySymbol: currency.currencySymbol,
              minLimit: currency.minLimit,
              maxLimit: currency.maxLimit,
              percentCharge: currency.percentCharge,
              fixedCharge: currency.fixedCharge,
              rate: currency.rate,
              createdAt: currency.createdAt,
              updatedAt: currency.updatedAt,
              type: currency.type,
              image: currency.image,
            ),
          );
        }
      }

      Currency currency =
          _addMoneyPaymentGatewayModel.data.gateways.first.currencies.first;
      Gateway gateway = _addMoneyPaymentGatewayModel.data.gateways.first;

      selectedCurrencyAlias.value = currency.alias;
      selectedCurrencyType.value = currency.type;
      selectedGatewaySlug.value = gateway.slug;
      selectedCurrencyId.value = currency.id;
      selectedCurrencyName.value = currency.name;

      rate.value = currency.rate.toDouble();

      fee.value = currency.fixedCharge.toDouble();
      limitMin.value = currency.minLimit.toDouble() / rate.value;
      limitMax.value = currency.maxLimit.toDouble() / rate.value;
      percentCharge.value = currency.percentCharge.toDouble();

      //Base Currency
      baseCurrency.value = _addMoneyPaymentGatewayModel.data.baseCurr;
      baseCurrencyList.add(baseCurrency.value);

      _isLoading.value = false;
      update();
      update();
    }).catchError((onError) {
      log.e(onError);
      _isLoading.value = false;
      update();
    });

    return _addMoneyPaymentGatewayModel;
  }

  // ---------------------------- AddMoneyPaypalInsertModel --------------------

  final _isInsertLoading = false.obs;

  bool get isInsertLoading => _isInsertLoading.value;

  late AddMoneyPaypalInsertModel _addMoneyInsertPaypalModel;

  AddMoneyPaypalInsertModel get addMoneyInsertPaypalModel =>
      _addMoneyInsertPaypalModel;

  // --------------------------- Api function ----------------------------------
  // add money paypal
  Future<AddMoneyPaypalInsertModel> addMoneyPaypalInsertProcess() async {
    _isInsertLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'amount': amountTextController.text,
      'currency': selectedCurrencyAlias.value,
    };

    await ApiServices.sendMoneyInsertPaypalApi(body: inputBody).then((value) {
      _addMoneyInsertPaypalModel = value!;
      final data = _addMoneyInsertPaypalModel.data.paymentInformations;
      enteredAmount = data.requestAmount;
      transferFeeAmount = data.totalCharge;
      totalCharge = data.totalCharge;
      youWillGet = data.willGet;
      payableAmount = data.payableAmount;
      gotoPreview();
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isInsertLoading.value = false;
    update();
    return _addMoneyInsertPaypalModel;
  }

  late AddMoneyFlutterWavePaymentModel _addMoneyInsertFlutterWaveModel;

  AddMoneyFlutterWavePaymentModel get addMoneyInsertFlutterWaveModel =>
      _addMoneyInsertFlutterWaveModel;

  // --------------------------- Api function ----------------------------------
  // add money paypal
  Future<AddMoneyFlutterWavePaymentModel>
  addMoneyFlutterWaveInsertProcess() async {
    _isInsertLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'amount': amountTextController.text,
      'currency': selectedCurrencyAlias.value,
    };

    await ApiServices.sendMoneyInsertFlutterWaveApi(body: inputBody)
        .then((value) {
      _addMoneyInsertFlutterWaveModel = value!;
      final data = _addMoneyInsertFlutterWaveModel.data.paymentInformations;
      enteredAmount = data.requestAmount;
      transferFeeAmount = data.totalCharge;
      totalCharge = data.totalCharge;
      youWillGet = data.willGet;
      payableAmount = data.payableAmount;
      gotoPreview();
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isInsertLoading.value = false;
    update();
    return _addMoneyInsertFlutterWaveModel;
  }

  /// >>> Add Money RazorPay Insert Process
  late AddMoneyRazorPayInsertModel _addMoneyRazorPayInsertModel;

  AddMoneyRazorPayInsertModel get addMoneyRazorPayInsertModel =>
      _addMoneyRazorPayInsertModel;

  // --------------------------- Api function ----------------------------------
  // add money RazorPay
  Future<AddMoneyRazorPayInsertModel> addMoneyRazorPayInsertProcess() async {
    _isInsertLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'amount': amountTextController.text,
      'currency': selectedCurrencyAlias.value,
    };

    await ApiServices.addMoneyInsertRazorPayApi(body: inputBody).then((value) {
      _addMoneyRazorPayInsertModel = value!;
      final data = _addMoneyRazorPayInsertModel.data.paymentInformations;
      enteredAmount = data.requestAmount;
      transferFeeAmount = data.totalCharge;
      totalCharge = data.totalCharge;
      youWillGet = data.willGet;
      payableAmount = data.payableAmount;
      gotoPreview();
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isInsertLoading.value = false;
    update();
    return _addMoneyRazorPayInsertModel;
  }

  // ---------------------------- AddMoneyStripeInsertModel --------------------
  late AddMoneyStripeInsertModel _addMoneyInsertStripeModel;

  AddMoneyStripeInsertModel get addMoneyInsertStripeModel =>
      _addMoneyInsertStripeModel;

  // --------------------------- Api function ----------------------------------
  // add money stripe
  Future<AddMoneyStripeInsertModel> addMoneyStripeInsertProcess() async {
    _isInsertLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'amount': amountTextController.text,
      'currency': selectedCurrencyAlias.value,
    };

    await ApiServices.addMoneyInsertStripeApi(body: inputBody).then((value) {
      _addMoneyInsertStripeModel = value!;
      final data = _addMoneyInsertStripeModel.data.paymentInformations;
      enteredAmount = data.requestAmount;
      transferFeeAmount = data.totalCharge;
      totalCharge = data.totalCharge;
      youWillGet = data.willGet;
      payableAmount = data.payableAmount;
      gotoPreview();
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isInsertLoading.value = false;
    update();
    return _addMoneyInsertStripeModel;
  }

  // ---------------------------- addMoneyStripeConfirmProcess -----------------
  final _isConfirmLoading = false.obs;

  bool get isConfirmLoading => _isConfirmLoading.value;

  late CommonSuccessModel _addMoneyStripeConfirmModel;

  CommonSuccessModel get addMoneyStripeConfirmModel =>
      _addMoneyStripeConfirmModel;

  // --------------------------- Api function ----------------------------------
  // send money stripe
  Future<CommonSuccessModel> addMoneyStripeConfirmProcess() async {
    _isConfirmLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'track': addMoneyInsertStripeModel.data.paymentInformations.trx,
      'name': cardHolderNameController.text,
      'cardNumber': cardNumberController.text,
      'cardExpiry':
      '${cardExpiryDateController.text.split('/')[0]}/${cardExpiryDateController.text.split('/')[1]}',
      'cardCVC': cardCvvController.text,
    };

    await ApiServices.addMoneyStripeConfirmApi(body: inputBody).then((value) {
      _addMoneyStripeConfirmModel = value!;

      // Get.offAllNamed(Routes.bottomNavBarScreen);
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isConfirmLoading.value = false;
    update();
    return _addMoneyStripeConfirmModel;
  }

  goToWebPaymentViewScreen() {
    Get.toNamed(Routes.paypalWebPaymentScreen);
  }

  goToWebFlutterWavePaymentViewScreen() {
    Get.toNamed(Routes.flutterWaveWebPaymentScreen);
  }

  goToStripeScreen() {
    Get.toNamed(Routes.sendMoneyStripeAnimatedScreen);
  }

  goToRazorPayScreen() {
    Get.toNamed(Routes.razorPayScreen);
  }

  goToManualSendMoneyManualScreen() {
    Get.toNamed(Routes.sendMoneyManualPaymentScreen);
  }

  // ---------------------------- AddMoneyManualInsertModel -----------------

  late AddMoneyManualInsertModel _addMoneyManualInsertModel;

  AddMoneyManualInsertModel get addMoneyManualInsertModel =>
      _addMoneyManualInsertModel;

  // --------------------------- Api function ----------------------------------
  // Manual Payment Get Gateway process function
  Future<AddMoneyManualInsertModel> manualPaymentGetGatewaysProcess() async {
    _isInsertLoading.value = true;
    inputFields.clear();
    listImagePath.clear();
    listFieldName.clear();
    inputFieldControllers.clear();
    update();

    Map<String, dynamic> inputBody = {
      'amount': amountTextController.text,
      'currency': selectedCurrencyAlias.value,
    };

    await ApiServices.addMoneyManualInsertApi(body: inputBody).then((value) {
      _addMoneyManualInsertModel = value!;

      final previewData = _addMoneyManualInsertModel.data.paymentInformations;
      enteredAmount = previewData.requestAmount;
      transferFeeAmount = previewData.totalCharge;
      totalCharge = previewData.totalCharge;
      youWillGet = previewData.willGet;
      payableAmount = previewData.payableAmount;

      //-------------------------- Process inputs start ------------------------
      final data = _addMoneyManualInsertModel.data.inputFields;

      for (int item = 0; item < data.length; item++) {
        // make the dynamic controller
        var textEditingController = TextEditingController();
        inputFieldControllers.add(textEditingController);

        // make dynamic input widget
        if (data[item].type.contains('file')) {
          hasFile.value = true;
          inputFields.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ManualPaymentImageWidget(
                labelName: data[item].label,
                fieldName: data[item].name,
              ),
            ),
          );
        } else if (data[item].type.contains('text') ||
            data[item].type.contains('textarea')) {
          inputFields.add(
            Column(
              children: [
                PrimaryInputWidget(
                  paddings: EdgeInsets.only(
                      left: Dimensions.widthSize,
                      right: Dimensions.widthSize,
                      top: Dimensions.heightSize * 0.5),
                  controller: inputFieldControllers[item],
                  label: data[item].label,
                  hint: data[item].label,
                  isValidator: data[item].required,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        int.parse(data[item].validation.max.toString())),
                  ],
                ),
              ],
            ),
          );
        }
      }

      //-------------------------- Process inputs end --------------------------
      _isInsertLoading.value = false;
      gotoPreview();
      update();
    }).catchError((onError) {
      _isInsertLoading.value = false;
      log.e(onError);
    });

    update();
    return _addMoneyManualInsertModel;
  }

  // ---------------------------- manualPaymentProcess -------------------------

  final _isConfirmManualLoading = false.obs;

  bool get isConfirmManualLoading => _isConfirmManualLoading.value;

  late CommonSuccessModel _manualPaymentConfirmModel;

  CommonSuccessModel get manualPaymentConfirmModel =>
      _manualPaymentConfirmModel;

  Future<CommonSuccessModel> manualPaymentProcess() async {
    _isConfirmManualLoading.value = true;
    Map<String, String> inputBody = {
      'track': addMoneyManualInsertModel.data.paymentInformations.trx,
    };

    final data = addMoneyManualInsertModel.data.inputFields;

    for (int i = 0; i < data.length; i += 1) {
      if (data[i].type != 'file') {
        inputBody[data[i].name] = inputFieldControllers[i].text;
      }
    }

    await ApiServices.manualPaymentConfirmApi(
        body: inputBody, fieldList: listFieldName, pathList: listImagePath)
        .then((value) {
      _manualPaymentConfirmModel = value!;
      _isConfirmManualLoading.value = false;
      update();
      Get.offAndToNamed(Routes.bottomNavBarScreen);
    }).catchError((onError) {
      log.e(onError);
    });
    _isConfirmManualLoading.value = false;
    update();
    return _manualPaymentConfirmModel;
  }

//todo keyboard fuction
  final amountTextController = TextEditingController();
  List<String> totalAmount = [];

  RxString selectCurrency = 'USD'.obs;
  RxString selectWallet = 'Paypal'.obs;

  @override
  void dispose() {
    amountTextController.dispose();

    super.dispose();
  }

  RxString selectItem = ''.obs;
  List<String> keyboardItemList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '.',
    '0',
    '<'
  ];

  inputItem(int index) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onLongPress: () {
        if (index == 11) {
          if (totalAmount.isNotEmpty) {
            totalAmount.clear();
            amountTextController.text = totalAmount.join('');
            update();
          } else {
            return;
          }
        }
      },
      onTap: () {
        if (index == 11) {
          if (totalAmount.isNotEmpty) {
            totalAmount.removeLast();
            amountTextController.text = totalAmount.join('');
            update();
            if(totalAmount.join('')==''){
              amountTextController.text = "Amount:-  0.0";
            }
          } else {
            return;
          }
        } else {
          if (totalAmount.contains('.') && index == 9) {
            return;
          } else {
            totalAmount.add(keyboardItemList[index]);
            amountTextController.text = totalAmount.join('');
            update();
            debugPrint(totalAmount.join(''));
          }
        }
      },
      child: Center(
        child: CustomTitleHeadingWidget(
          text: keyboardItemList[index],
          style: Get.isDarkMode
              ? CustomStyle.lightHeading2TextStyle.copyWith(
            fontSize: Dimensions.headingTextSize3 * 2,
          )
              : CustomStyle.darkHeading2TextStyle.copyWith(
            color: CustomColor.primaryLightColor,
            fontSize: Dimensions.headingTextSize3 * 2,
          ),
        ),
      ),
    );
  }
}
