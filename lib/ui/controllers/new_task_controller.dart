import 'package:get/get.dart';
import 'package:task_manager/data/models/task_model.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';

class NewTaskController extends GetxController {
  bool _getNewTaskInProgress = false;
  String errorMassage = '';
  List<TaskModel> _taskList = [];

  bool get getNewTaskInProgress => _getNewTaskInProgress;
  List<TaskModel> get newTaskModel => _taskList;

  Future<bool> getNewTask() async {
    bool isSuccess = false;
    _getNewTaskInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(Urls.newTasks);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      _taskList = taskListWrapperModel.taskList ?? [];
    } else {
      errorMassage = response.errorMessage ?? 'Failed to get new tasks';
    }

    _getNewTaskInProgress = false;
    update();

    return isSuccess;
  }
}
