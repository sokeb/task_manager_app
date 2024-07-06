import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/task_item.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import '../widgets/profile_appbar.dart';
import '../widgets/snack_bar_message.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {
  bool _getCanceledTaskInProgress = false;
  List<TaskModel> canceledTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCanceledTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async => _getCanceledTask(),
        child: Visibility(
          visible: _getCanceledTaskInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.builder(
              itemCount: canceledTaskList.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  task: canceledTaskList[index],
                  onUpdateTask: () {
                    _getCanceledTask();
                  },
                );
              }),
        ),
      ),
    );
  }

  Future<void> _getCanceledTask() async {
    _getCanceledTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse networkResponse =
        await NetworkCaller.getRequest(Urls.canceledTasks);

    if (networkResponse.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(networkResponse.responseData);
      canceledTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBArMessage(
            context,
            networkResponse.errorMessage ?? 'Failed to get In-Progress Task',
            true);
      }
    }
    _getCanceledTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
