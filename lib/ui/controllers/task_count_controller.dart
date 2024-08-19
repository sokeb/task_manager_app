import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_by_status_count_wrapper_model.dart';
import '../../data/models/task_count_by_status_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class TaskCountController extends GetxController {
  bool _getTaskCountByStatusInProgress = false;
  String _errorMessage = '';
  List<TaskCountByStatusModel> _statusCountList = [];

  List<TaskCountByStatusModel> get statusCountList => _statusCountList;
  bool get getTaskCountByStatusInProgress => _getTaskCountByStatusInProgress;
  String get errorMessage => _errorMessage;

  Future<bool> getTaskCountByStatus() async {
    bool isSuccess = false;
    _getTaskCountByStatusInProgress = true;
    update();

    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.taskStatusCount);

    if (response.isSuccess) {
      TaskCountByStatusWrapperModel taskCountByStatusWrapperModel =
          TaskCountByStatusWrapperModel.fromJson(response.responseData);
      _statusCountList =
          taskCountByStatusWrapperModel.taskCountByStatusList ?? [];
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to get Status Count';
    }
    _getTaskCountByStatusInProgress = false;
    update();
    return isSuccess;
  }
}
