import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/model/categories/withdraw/flutterwave_account_cheack_model.dart';
import 'package:qrpay/backend/utils/custom_snackbar.dart';

import '../../../backend/model/categories/withdraw/flutter_wave_banks_model.dart';
import '../../../backend/model/categories/withdraw/money_out_manual_insert_model.dart';
import '../../../backend/model/categories/withdraw/money_out_payment_getway_model.dart';
import '../../../backend/model/categories/withdraw/withdraw_flutterwave_insert_model.dart';
import '../../../backend/model/common/common_success_model.dart';
import '../../../backend/services/api_services.dart';
import '../../../backend/utils/logger.dart';
import '../../../routes/routes.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/custom_style.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/strings.dart';
import '../../../widgets/inputs/manual_payment_image_widget_for_money_out.dart';
import '../../../widgets/inputs/primary_input_filed.dart';
import '../../../widgets/text_labels/custom_title_heading_widget.dart';

final log = logger(WithdrawController);

class WithdrawController extends GetxController {
  final amountTextController = TextEditingController();
  List<String> totalAmount = [];

  RxString selectCurrency = 'USD'.obs;
  RxString selectWallet = 'Paypal'.obs;
  RxString currencyWalletCode = "".obs;

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

  /// >>> Flutter
  RxString selectFlutterWaveBankName = "".obs;
  RxString selectFlutterWaveBankCode = "".obs;
  List<BankInfos> bankInfoList = [];

  @override
  void dispose() {
    amountTextController.dispose();

    super.dispose();
  }

  @override
  void onInit() {
    amountTextController.text = "Amount:-  0.0";
    getWithdrawInfoData();
    super.onInit();
  }

  // ---------------------------- AddMoneyPaymentGatewayModel ------------------
  // api loading process indicator variable
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late WithdrawInfoModel _moneyOutPaymentGatewayModel;

  WithdrawInfoModel get moneyOutPaymentGatewayModel =>
      _moneyOutPaymentGatewayModel;

  // --------------------------- Api function ----------------------------------
  // get moneyOutPaymentGateway data function
  Future<WithdrawInfoModel> getWithdrawInfoData() async {
    _isLoading.value = true;
    update();

    await ApiServices.withdrawInfoAPi().then((value) {
      _moneyOutPaymentGatewayModel = value!;

      currencyCode.value =
          _moneyOutPaymentGatewayModel.data.userWallet.currency;
      currencyWalletCode.value = _moneyOutPaymentGatewayModel
          .data.gateways.first.currencies.first.currencyCode;

      for (var gateways in _moneyOutPaymentGatewayModel.data.gateways) {
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
          _moneyOutPaymentGatewayModel.data.gateways.first.currencies.first;
      Gateway gateway = _moneyOutPaymentGatewayModel.data.gateways.first;

      selectedCurrencyAlias.value = currency.alias;
      selectedCurrencyType.value = currency.type;
      selectedGatewaySlug.value = gateway.slug;
      selectedCurrencyId.value = currency.id;
      selectedCurrencyName.value = currency.name;
      // currencyCode.value = currency.currencyCode;

      rate.value = currency.rate.toDouble();

      fee.value = currency.fixedCharge.toDouble();
      limitMin.value = currency.minLimit.toDouble() / rate.value;
      limitMax.value = currency.maxLimit.toDouble() / rate.value;
      percentCharge.value = currency.percentCharge.toDouble();

      //Base Currency
      baseCurrency.value = _moneyOutPaymentGatewayModel.data.baseCurr;
      baseCurrencyList.add(baseCurrency.value);

      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _moneyOutPaymentGatewayModel;
  }

  // ---------------------------- Get Flutterwave banks ------------------
  late FlutterWaveBanksModel _flutterWaveBanksModel;

  FlutterWaveBanksModel get flutterWaveBanksModel => _flutterWaveBanksModel;

  // --------------------------- Api function ----------------------------------
  // get flutter Wave Banks data function
  Future<FlutterWaveBanksModel> getFlutterWaveBanks() async {
    _isLoading.value = true;
    update();

    await ApiServices.getFlutterWaveBanksApi(
      withdrawFlutterwaveInsertModel.data.paymentInformations.trx,
    ).then((value) {
      _flutterWaveBanksModel = value!;
      for (var element in _flutterWaveBanksModel.data.bankInfo) {
        bankInfoList.add(
          BankInfos(
            code: element.code,
            id: element.id,
            name: element.name,
          ),
        );
      }
      debugPrint(bankInfoList.length.toString());
      selectFlutterWaveBankName.value =
          _flutterWaveBanksModel.data.bankInfo.first.name;
      selectFlutterWaveBankCode.value =
          _flutterWaveBanksModel.data.bankInfo.first.code;
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _flutterWaveBanksModel;
  }

  final _isInsertLoading = false.obs;

  bool get isInsertLoading => _isInsertLoading.value;

  late WithdrawManualInsertModel _moneyOutManualInsertModel;

  WithdrawManualInsertModel get moneyOutManualInsertModel =>
      _moneyOutManualInsertModel;

  // --------------------------- Api function ----------------------------------
  // Manual Payment Get Gateway process function
  Future<WithdrawManualInsertModel> manualPaymentGetGatewaysProcess() async {
    _isInsertLoading.value = true;
    inputFields.clear();
    listImagePath.clear();
    listFieldName.clear();
    inputFieldControllers.clear();
    update();

    Map<String, dynamic> inputBody = {
      'amount': amountTextController.text,
      'gateway': selectedCurrencyAlias.value,
    };

    await ApiServices.withdrawManualInsertApi(body: inputBody).then((value) {
      _moneyOutManualInsertModel = value!;

      final previewData = _moneyOutManualInsertModel.data.paymentInformations;
      enteredAmount = previewData.requestAmount;
      transferFeeAmount = previewData.totalCharge;
      totalCharge = previewData.totalCharge;
      youWillGet = previewData.willGet;
      payableAmount = previewData.requestAmount;

      //-------------------------- Process inputs start ------------------------
      final data = _moneyOutManualInsertModel.data.inputFields;

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
              child: ManualPaymentImageWidgetForMoneyOut(
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
      goToAddMoneyPreviewScreen();
      update();
    }).catchError((onError) {
      _isInsertLoading.value = false;
      log.e(onError);
    });

    update();
    return _moneyOutManualInsertModel;
  }

  late WithdrawFlutterWaveInsertModel _withdrawFlutterwaveInsertModel;

  WithdrawFlutterWaveInsertModel get withdrawFlutterwaveInsertModel =>
      _withdrawFlutterwaveInsertModel;

  // Automatic Payment Get Gateway process function
  Future<WithdrawFlutterWaveInsertModel>
      automaticPaymentFlutterwaveInsertProcess() async {
    _isInsertLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'amount': amountTextController.text,
      'gateway': selectedCurrencyAlias.value,
    };

    await ApiServices.withdrawAutomaticFluuerwaveInsertApi(body: inputBody)
        .then((value) {
      _withdrawFlutterwaveInsertModel = value!;

      final previewData =
          _withdrawFlutterwaveInsertModel.data.paymentInformations;
      enteredAmount = previewData.requestAmount;
      transferFeeAmount = previewData.totalCharge;
      totalCharge = previewData.totalCharge;
      youWillGet = previewData.willGet;
      payableAmount = previewData.requestAmount;

      //-------------------------- Process inputs end --------------------------
      _isInsertLoading.value = false;
      getFlutterWaveBanks().then((value) => goToAddMoneyPreviewScreen());

      update();
    }).catchError((onError) {
      _isInsertLoading.value = false;
      log.e(onError);
    });

    update();
    return _withdrawFlutterwaveInsertModel;
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
      'trx': moneyOutManualInsertModel.data.paymentInformations.trx,
    };

    final data = moneyOutManualInsertModel.data.inputFields;

    for (int i = 0; i < data.length; i += 1) {
      if (data[i].type != 'file') {
        inputBody[data[i].name] = inputFieldControllers[i].text;
        debugPrint("----------------------");
        debugPrint(listFieldName.toString());
        debugPrint(data[i].name);
      }
    }

    await ApiServices.manualPaymentConfirmApiForWithdraw(
            body: inputBody, fieldList: listFieldName, pathList: listImagePath)
        .then((value) {
      _manualPaymentConfirmModel = value!;
      _isConfirmManualLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isConfirmManualLoading.value = false;
    update();
    return _manualPaymentConfirmModel;
  }

  Future<CommonSuccessModel> flutterwavePaymentProcess() async {
    _isConfirmManualLoading.value = true;
    Map<String, String> inputBody = {
      'trx': withdrawFlutterwaveInsertModel.data.paymentInformations.trx,
      'bank_name': bankCode.value,
      'account_number': accountNumberController.text,
    };

    await ApiServices.withdrawFluuerwaveConfirmApiApi(body: inputBody)
        .then((value) {
      _manualPaymentConfirmModel = value!;

      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isConfirmManualLoading.value = false;
    update();
    return _manualPaymentConfirmModel;
  }

  goToAddMoneyPreviewScreen() {
    Get.toNamed(Routes.withdrawPreviewScreen);
  }

  goToAddMoneyCongratulationScreen() {
    Get.toNamed(Routes.addFundPreviewScreen);
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
            if(totalAmount.join('')==''){
              amountTextController.text = "Amount:-  0.0";
              debugPrint("xxx");
            }
            update();
            update();
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

  final accountNumberController = TextEditingController();
  final bankNameController = TextEditingController();

  RxBool isSearchEnable = false.obs;
  RxBool isButtonEnable = false.obs;
  RxString bankCode = "".obs;
  Rx<List<BankInfos>> foundChapter = Rx<List<BankInfos>>([]);

  void filterTransaction(String? value) {
    List<BankInfos> results = [];
    if (value!.isEmpty) {
      results = _flutterWaveBanksModel.data.bankInfo;
    } else {
      results = _flutterWaveBanksModel.data.bankInfo
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    }

    if (results.isEmpty) {
      foundChapter.value = [
        BankInfos(name: Strings.noBankFound, id: 0, code: ''),
      ];
    } else {
      foundChapter.value = results;
    }
  }

  late FlutterwaveAccountCheckModel _flutterwaveAccountCheckModel;

  FlutterwaveAccountCheckModel get flutterwaveAccountCheckModel =>
      _flutterwaveAccountCheckModel;

  Future<FlutterwaveAccountCheckModel> cheackUser(value) async {
    // _isConfirmManualLoading.value = true;
    Map<String, String> inputBody = {
      // 'trx': withdrawFlutterwaveInsertModel.data.paymentInformations.trx,
      'bank_name': bankCode.value,
      'account_number': accountNumberController.text,
    };

    await ApiServices.flutterwaveAccountCheackerApi(body: inputBody)
        .then((value) {
      _flutterwaveAccountCheckModel = value!;

      isButtonEnable.value = true;
      CustomSnackBar.success(
          "Hello ${_flutterwaveAccountCheckModel.data.bankInfo.accountName}");
      update();
    }).catchError((onError) {
      isButtonEnable.value = false;
      log.e(onError);
    });
    // _isConfirmManualLoading.value = false;
    update();
    return _flutterwaveAccountCheckModel;
  }
}
