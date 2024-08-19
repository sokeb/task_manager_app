import 'package:get/get.dart';
import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class AddNewTaskController extends GetxController {
  bool _addNewTaskInProgress = false;
  String _errorMessage = '';

  bool get addNewTaskInProgress => _addNewTaskInProgress;

  String get errorMessage => _errorMessage;

  Future<bool> addTask(Map<String, dynamic> requestData) async {
    bool isSuccess = false;
    _addNewTaskInProgress = true;
    update();

    NetworkResponse response =
        await NetworkCaller.postRequest(Urls.createTask, body: requestData);

    _addNewTaskInProgress = false;
    update();

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage =
          response.errorMessage ?? 'New Task Add Failed! Try again.';
    }

    return isSuccess;
  }
}
