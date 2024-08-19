import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class PinVerificationController extends GetxController {
  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  Future<bool> verifyOTP(String email, String pinCode) async {
    bool isSuccess = false;
    String otp = pinCode.trim();
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.otpVerify(email, otp));

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Wrong pin';
    }
    return isSuccess;
  }
}
