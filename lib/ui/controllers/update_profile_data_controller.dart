import 'package:get/get.dart';
import '../../data/models/network_response.dart';
import '../../data/models/user_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import 'auth_controller.dart';

class UpdateProfileDataController extends GetxController{
  bool _updateInProgress = false;
  String _errorMessage = '' ;

  bool get updateInProgress => _updateInProgress;
  String get errorMessage => _errorMessage;


  Future<bool> updateProfileData(Map<String, dynamic> requestedBody, String email,String firstName,String lastName,String mobile,String photo) async {
    bool isSuccess = false;

    _updateInProgress = true;
    update();


    final NetworkResponse response = await NetworkCaller.postRequest(
        Urls.profileUpdate,
        body: requestedBody);

    if (response.isSuccess) {
      UserModel userModel = UserModel(
        email: email,
        firstName: firstName,
        lastName: lastName,
        mobile: mobile,
        photo: photo
      );
      await AuthController.saveUserData(userModel);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to update profile data! try again';
    }
    _updateInProgress = false;
    update();

    return isSuccess;
  }
}