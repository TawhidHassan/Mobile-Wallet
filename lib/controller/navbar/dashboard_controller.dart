import 'package:get/get.dart';

import '../../backend/model/bottom_navbar_model/dashboard_model.dart';
import '../../backend/services/api_services.dart';
import '../../custom_assets/assets.gen.dart';
import '../../model/categories_model.dart';
import '../../routes/routes.dart';
import '../../utils/strings.dart';

class DashBoardController extends GetxController {
  List<CategoriesModel> categoriesData = [];

  @override
  void onInit() {
    getDashboardData();
    super.onInit();
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  late DashboardModel _dashboardModel;

  DashboardModel get dashBoardModel => _dashboardModel;

  Future<DashboardModel> getDashboardData() async {
    _isLoading.value = true;
    update();

    // calling  from api service
    await ApiServices.dashboardApi().then((value) {
  
      _dashboardModel = value!;
      final data = _dashboardModel.data.moduleAccess;
      categoriesData.clear();

      if (data.sendMoney) {
        categoriesData.add(CategoriesModel(Assets.icon.send, Strings.send, () {
          Get.toNamed(Routes.moneyTransferScreen);
        }));
      }

      if (data.receiveMoney) {
        categoriesData
            .add(CategoriesModel(Assets.icon.receive, Strings.receive, () {
          Get.toNamed(Routes.moneyReceiveScreen);
        }));
      }

      if (data.remittanceMoney) {
        categoriesData.add(
            CategoriesModel(Assets.icon.remittance, Strings.remittance, () {
          Get.toNamed(Routes.remittanceScreen);
        }));
      }

      if (data.addMoney) {
        categoriesData.add(
          CategoriesModel(Assets.icon.deposit, Strings.addMoney, () {
            Get.toNamed(Routes.addMoneyScreen);
          }),
        );
      }

      if (data.withdrawMoney) {
        categoriesData.add(
          CategoriesModel(Assets.icon.withdraw, Strings.withdraw, () {
            Get.toNamed(Routes.withdrawScreen);
          }),
        );
      }

      if (data.makePayment) {
        categoriesData.add(
          CategoriesModel(Assets.icon.receipt, Strings.makePayment, () {
            Get.toNamed(Routes.makePaymentScreen);
          }),
        );
      }

      if (data.virtualCard) {
        categoriesData.add(
          CategoriesModel(Assets.icon.virtualCard, Strings.virtualCard, () {
            Get.toNamed(Routes.virtualCardScreen);
          }),
        );
      }

      if (data.billPay) {
        categoriesData
            .add(CategoriesModel(Assets.icon.billPay, Strings.billPay, () {
          Get.toNamed(Routes.billPayScreen);
        }));
      }

      if (data.mobileTopUp) {
        categoriesData.add(
          CategoriesModel(Assets.icon.mobileTopUp, Strings.mobileTopUp, () {
            Get.toNamed(Routes.mobileToUpScreen);
          }),
        );
      }

      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    update();
    return _dashboardModel;
  }
}
