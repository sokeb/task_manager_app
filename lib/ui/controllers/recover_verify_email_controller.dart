import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class RecoverVerifyEmailController extends GetxController{
  String _errorMessage = '' ;

  String get errorMessage => _errorMessage;

  Future<bool> recoverVerifyEmail(String emailId) async {
    bool isSuccess = false;
    String email = emailId.trim();
    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.emailVerify(email));

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Login failed! Try again';
    }
    update();
    return isSuccess;
  }
}