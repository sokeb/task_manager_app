import 'package:get/get.dart';
import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class UpdateTaskController extends GetxController{
  bool _updateInProgress = false;
  String _errorMessage = '';

  bool get updateInProgress => _updateInProgress;
  String get errorMessage => _errorMessage;

  Future<bool> updateTaskStatus(String taskId, String dropdownValue) async {
    bool isSuccess = false;

    _updateInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(
        Urls.updateTaskStatus(taskId, dropdownValue));

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to Delete task';
    }
    _updateInProgress = false;
    update();

    return isSuccess;
  }
}