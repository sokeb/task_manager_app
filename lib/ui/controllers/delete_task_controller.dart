import 'package:get/get.dart';
import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class DeleteTaskController extends GetxController{
  bool _deleteInProgress = false;
  String _errorMessage = '';

  bool get deleteInProgress => _deleteInProgress;
  String get errorMessage => _errorMessage;

  Future<bool> deleteTask(String taskId) async {
    bool isSuccess = false;

    _deleteInProgress = true;
    update();

    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.deleteTask(taskId));

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to Delete task';
    }

    _deleteInProgress = false;
    update();

    return isSuccess;
    }
  }