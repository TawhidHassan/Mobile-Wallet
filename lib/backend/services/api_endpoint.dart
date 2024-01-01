import 'package:qrpay/extentions/custom_extentions.dart';

class ApiEndpoint {
  static const String mainDomain = "https://mobilewallet.top";
  static const String baseUrl = "$mainDomain/api";
//! auth
  static String loginURL = '/user/login'.addBaseURl();
  static String logOutURL = '/user/logout'.addBaseURl();
  static String sendOTPEmailURL = '/user/send-code'.addBaseURl();
  static String sendForgotOTPEmailURL = '/user/forget/password'.addBaseURl();
  static String verifyForgotOTPEmailURL =
      '/user/forget/verify/otp'.addBaseURl();
  static String verifyEmailURL = '/user/email-verify'.addBaseURl();
  static String checkingUserURL =
      '/user/forget/password/check/user'.addBaseURl();
  static String resetPasswordURL = '/user/forget/reset/password'.addBaseURl();

  //!register

  static String checkRegisterURL = '/user/register/check/exist'.addBaseURl();
  static String basicDataURL = '/get/basic/data'.addBaseURl();
  static String userKycURL = '/user/kyc'.addBaseURl();
  static String registerURL = '/user/register'.addBaseURl();
  static String sendRegisterEmailOTPURL =
      '/user/register/send/otp'.addBaseURl();
  static String verifyRegisterEmailOTPURL =
      '/user/register/verify/otp'.addBaseURl();

//! navbar
  static String dashboardURL = '/user/dashboard'.addBaseURl();
  static String notificationsURL = '/user/notifications'.addBaseURl();

//! profile
  static String profileURL = '/user/profile'.addBaseURl();
  static String updateProfileApi = '/user/profile/update'.addBaseURl();
  static String updateKYCApi = '/user/kyc/submit'.addBaseURl();

//! categories
  static String addMoneyInfoURL = '/user/add-money/information'.addBaseURl();

  //! drawer
  static String passwordUpdate = '/user/password/update'.addBaseURl();
  static String logout = '/user/logout'.addBaseURl();

//! send money
  static String sendMoneyInsertURL = '/user/add-money/submit-data'.addBaseURl();
  static String sendMoneyStripeConfirmURL =
      '/user/add-money/stripe/payment/confirm'.addBaseURl();
  static String sendMoneyManualConfirmURL =
      '/user/add-money/manual/payment/confirmed'.addBaseURl();

  ///flutterwave virtual card
  static String cardInfoURL = '/user/my-card'.addBaseURl();
  static String cardDetailsURL = '/user/my-card/details?card_id='.addBaseURl();
  static String cardBlockURL = '/user/my-card/block'.addBaseURl();
  static String cardUnBlockURL = '/user/my-card/unblock'.addBaseURl();
  static String cardAddFundURL = '/user/my-card/fund'.addBaseURl();
  static String createCardURL = '/user/my-card/create'.addBaseURl();
  static String cardTransactionURL =
      '/user/my-card/transaction?card_id='.addBaseURl();

  ///sudo virtual card
  static String sudoCardInfoURL = '/user/my-card/sudo'.addBaseURl();
  static String sudoCardDetailsURL =
      '/user/my-card/sudo/details?card_id='.addBaseURl();
  static String sudoCardBlockURL = '/user/my-card/sudo/block'.addBaseURl();
  static String sudoCardUnBlockURL = '/user/my-card/sudo/unblock'.addBaseURl();
  static String sudoCardMakeOrRemoveDefaultFundURL =
      '/user/my-card/sudo/make-remove/default'.addBaseURl();
  static String sudoCreateCardURL = '/user/my-card/sudo/create'.addBaseURl();
  static String sudoCardTransactionURL =
      '/user/my-card/transaction?card_id='.addBaseURl();

  static String receiveMoneyURL = '/user/receive-money'.addBaseURl();
  static String sendMoneyInfoURL = '/user/send-money/info'.addBaseURl();
  static String checkUserExistURL = '/user/send-money/exist'.addBaseURl();
  static String checkUserWithQeCodeURL =
      '/user/send-money/qr/scan'.addBaseURl();
  static String sendMoneyURL = '/user/send-money/confirmed'.addBaseURl();

  // money_out
  static String withdrawInfoURL = '/user/withdraw/info'.addBaseURl();
  static String flutterWaveBanksURL =
      '/user/withdraw/get/flutterwave/banks?trx='.addBaseURl();
  static String withdrawInsertURL = '/user/withdraw/insert'.addBaseURl();
  static String manualWithdrawConfirmURL =
      '/user/withdraw/manual/confirmed'.addBaseURl();
  static String checkFlutterwaveAccountURL =
      '/user/withdraw/check/flutterwave/bank'.addBaseURl();
  static String automaticWithdrawConfirmURL =
      '/user/withdraw/automatic/confirmed'.addBaseURl();

  static String billPayInfoURL = '/user/bill-pay/info'.addBaseURl();
  static String billPayConfirmedURL = '/user/bill-pay/confirmed'.addBaseURl();

  static String topupInfoURL = '/user/mobile-topup/info'.addBaseURl();
  static String topupConfirmedURL = '/user/mobile-topup/confirmed'.addBaseURl();

  /// recipient
  static String allRecipientURL = '/user/recipient/list'.addBaseURl();
  static String checkRecipientURL = '/user/recipient/check/user'.addBaseURl();

  static String recipientSaveInfoURL = '/user/recipient/save/info'.addBaseURl();
  static String recipientDynamicFieldURL =
      '/user/recipient/dynamic/fields'.addBaseURl();

  static String recipientCheckUserURL =
      '/user/recipient/check/user'.addBaseURl();
  static String recipientStoreURL = '/user/recipient/store'.addBaseURl();
  static String recipientUpdateURL = '/user/recipient/update'.addBaseURl();
  static String recipientDeleteURL = '/user/recipient/delete'.addBaseURl();
  static String recipientEditURL = '/user/recipient/edit?id='.addBaseURl();

  /// remittance
  static String remittanceInfoURL = '/user/remittance/info'.addBaseURl();
  static String remittanceGetRecipientURL =
      '/user/remittance/get/recipient'.addBaseURl();
  static String remittanceConfirmedURL =
      '/user/remittance/confirmed'.addBaseURl();

  /// transactions
  static String transactionLogURL = '/user/transactions'.addBaseURl();

  //app settings
  static String appSettingsURL = '/app-settings'.addBaseURl();

  // 2 fa security
  static String twoFAInfoURL = '/user/security/google/2fa/status'.addBaseURl();
  static String twoFAVerifyURL = '/user/google/2fa/verify'.addBaseURl();

  static String makePaymentInfoURL = '/user/make-payment/info'.addBaseURl();
  static String checkMerchantExistURL =
      '/user/make-payment/check/merchant'.addBaseURl();
  static String checkMerchantWithQeCodeURL =
      '/user/make-payment/merchants/scan'.addBaseURl();
  static String makePaymentURL = '/user/make-payment/confirmed'.addBaseURl();

  static String smsVerifyURL = '/user/sms/verify'.addBaseURl();
  static String deleteAccountURL = '/user/delete/account'.addBaseURl();
}
