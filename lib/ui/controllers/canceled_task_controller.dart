import 'package:get/get.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class CanceledTaskController extends GetxController {
  bool _getCanceledTaskInProgress = false;
  String _errorMessage = '';
  List<TaskModel> _canceledTaskList = [];

  List<TaskModel> get canceledTaskList => _canceledTaskList;
  bool get getCanceledTaskInProgress => _getCanceledTaskInProgress;
  String get errorMessage => _errorMessage;

  Future<bool> getCanceledTask() async {
    bool isSuccess = false;

    _getCanceledTaskInProgress = true;
    update();

    NetworkResponse networkResponse =
        await NetworkCaller.getRequest(Urls.canceledTasks);

    if (networkResponse.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(networkResponse.responseData);
      _canceledTaskList = taskListWrapperModel.taskList ?? [];
      isSuccess = true;
    } else {
      _errorMessage =
          networkResponse.errorMessage ?? 'Failed to get canceled Task';
    }

    _getCanceledTaskInProgress = false;
    update();

    return isSuccess;
  }
}
