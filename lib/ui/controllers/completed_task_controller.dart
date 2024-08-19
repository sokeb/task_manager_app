import 'package:get/get.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class CompletedTaskController extends GetxController {
  bool _getCompletedTaskInProgress = false;
  String errorMassage = '';
  List<TaskModel> _completedTaskList = [];

  bool get getCompletedTaskInProgress => _getCompletedTaskInProgress;

  List<TaskModel> get completedTaskList => _completedTaskList;

  Future<bool> getCompletedTask() async {
    bool isSuccess = false;

    _getCompletedTaskInProgress = true;
    update();

    NetworkResponse networkResponse =
        await NetworkCaller.getRequest(Urls.completedTasks);

    if (networkResponse.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(networkResponse.responseData);
      _completedTaskList = taskListWrapperModel.taskList ?? [];
      isSuccess = true;
    } else {
      errorMassage =
          networkResponse.errorMessage ?? 'Failed to get completed Task';
    }

    _getCompletedTaskInProgress = false;
    update();

    return isSuccess;
  }
}
