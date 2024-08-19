import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class InProgressTaskController extends GetxController {
  bool _getInProgressTaskInProgress = false;
  String _errorMessage = '';
  List<TaskModel> _inProgressTaskList = [];

  List<TaskModel> get inProgressTaskList => _inProgressTaskList;

  bool get getInProgressTaskInProgress => _getInProgressTaskInProgress;

  String get errorMessage => _errorMessage;

  Future<bool> getInProgressTask() async {
    bool isSuccess = false;

    _getInProgressTaskInProgress = true;
    update();

    NetworkResponse networkResponse =
        await NetworkCaller.getRequest(Urls.inProgressTasks);

    if (networkResponse.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(networkResponse.responseData);
      _inProgressTaskList = taskListWrapperModel.taskList ?? [];
      isSuccess = true;
    } else {
      _errorMessage =
          networkResponse.errorMessage ?? 'Failed to get In-Progress Task';
    }
    _getInProgressTaskInProgress = false;
    update();

    return isSuccess;
  }
}
