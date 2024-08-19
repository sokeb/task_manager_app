import 'package:get/get.dart';
import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class RegisterUserController extends GetxController {
  bool _registrationInProgress = false;
  String _errorMassage = '';

  bool get registrationInProgress => _registrationInProgress;

  String get errorMassage => _errorMassage;

  Future<bool> registerUser(String email, String firstName, String lastName,
      String mobile, String password) async {

    bool isSuccess = false;
    _registrationInProgress = true;
    update();

    Map<String, dynamic> requestInput = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
      "photo": ""
    };
    final NetworkResponse response =
        await NetworkCaller.postRequest(Urls.registration, body: requestInput);

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMassage = response.errorMessage ?? 'Registration Failed! try again';
    }
    _registrationInProgress = false;
    update();
    return isSuccess;
  }
}
