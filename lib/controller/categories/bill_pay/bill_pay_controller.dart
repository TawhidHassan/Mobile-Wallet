import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/routes/routes.dart';

import '../../../backend/model/categories/bill_pay_model/bill_pay_model.dart';
import '../../../backend/model/common/common_success_model.dart';
import '../../../backend/services/api_services.dart';
import '../../../backend/utils/logger.dart';

final log = logger(BillPayController);

class BillPayController extends GetxController {
  RxString billMethodselected = "".obs;
  RxString type = "".obs;
  List<String> billList = [];

  final billNumberController = TextEditingController();
  final amountController = TextEditingController();

  RxDouble fee = 0.0.obs;
  RxDouble limitMin = 0.0.obs;
  RxDouble limitMax = 0.0.obs;
  RxDouble percentCharge = 0.0.obs;
  RxDouble fixedCharge = 0.0.obs;
  RxDouble rate = 0.0.obs;
  RxDouble totalFee = 0.0.obs;
  RxString baseCurrency = "".obs;

  @override
  void onInit() {
    getBillPayInfoData();
    super.onInit();
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  final _isInsertLoading = false.obs;

  bool get isInsertLoading => _isInsertLoading.value;

  late BillPayInfoModel _billPayInfoData;

  BillPayInfoModel get billPayInfoData => _billPayInfoData;

  // --------------------------- Api function ----------------------------------
  // get bill pay data function
  Future<BillPayInfoModel> getBillPayInfoData() async {
    _isLoading.value = true;
    update();

    await ApiServices.billPayInfoAPi().then((value) {
      _billPayInfoData = value!;

      baseCurrency.value = _billPayInfoData.data.baseCurr;
      limitMin.value = _billPayInfoData.data.billPayCharge.minLimit;
      limitMax.value = _billPayInfoData.data.billPayCharge.maxLimit;
      percentCharge.value = _billPayInfoData.data.billPayCharge.percentCharge;
      fixedCharge.value = _billPayInfoData.data.billPayCharge.fixedCharge;
      rate.value = _billPayInfoData.data.baseCurrRate;

      billMethodselected.value = _billPayInfoData.data.billTypes.first.name;
      for (var element in _billPayInfoData.data.billTypes) {
        billList.add(element.name);
      }
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _billPayInfoData;
  }

  late CommonSuccessModel _successDatya;

  CommonSuccessModel get successDatya => _successDatya;

  // Login process function
  Future<CommonSuccessModel> billPayApiProcess({
    required String type,
    required String amount,
    required String billNumber,
  }) async {
    _isInsertLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'bill_type': type,
      'bill_number': billNumber,
      'amount': amount,
    };
    // calling login api from api service
    await ApiServices.billPayConfirmedApi(body: inputBody).then((value) {
      _successDatya = value!;

      _isInsertLoading.value = false;
      update();

      // Get.offAllNamed(Routes.bottomNavBarScreen);
    }).catchError((onError) {
      log.e(onError);
    });

    _isInsertLoading.value = false;
    update();
    return _successDatya;
  }

  void gotoBillPreview(BuildContext context) {
    Get.toNamed(Routes.billPayPreviewScreen);
  }

  String? getType(String value) {
    for (var element in billPayInfoData.data.billTypes) {
      if (element.name == value) {
        return element.id.toString();
      }
    }
    return null;
  }

  RxDouble getFee({required double rate}) {
    double value = fixedCharge.value * rate;
    value = value +
        (double.parse(
                amountController.text.isEmpty ? '0.0' : amountController.text) *
            (percentCharge.value / 100));

    if (amountController.text.isEmpty) {
      totalFee.value = 0.0;
    } else {
      totalFee.value = value;
    }

    debugPrint(totalFee.value.toStringAsPrecision(2));
    return totalFee;
  }
}
