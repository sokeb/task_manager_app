import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:task_manager/data/utilities/urls.dart';
import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';

class ResetPassController extends GetxController {
  bool _resetPassInProgress = false;

  String _errorMassage = '';

  bool get resetPassInProgress => _resetPassInProgress;

  String get errorMassage => _errorMassage;

  Future<bool> resetPass(String email, String otp, String password) async {
    bool isSuccess = false;
    _resetPassInProgress = true;
    update();

    Map<String, dynamic> requestData = {
      "email": email,
      "OTP": otp,
      "password": password
    };
    final NetworkResponse response =
        await NetworkCaller.postRequest(Urls.resetPass, body: requestData);

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMassage = ' Failed to Change password! Try again.';
    }
    _resetPassInProgress = false;
    update();

    return isSuccess;
  }
}
