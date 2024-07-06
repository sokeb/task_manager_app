import 'package:flutter/material.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import '../widgets/profile_appbar.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_item.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  bool _getInProgressTaskInProgress = false;
  List<TaskModel> inProgressTaskList = [];

  @override
  void initState() {
    super.initState();
    _getInProgressTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async => _getInProgressTask(),
        child: Visibility(
          visible: _getInProgressTaskInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.builder(
              itemCount: inProgressTaskList.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  task: inProgressTaskList[index],
                  onUpdateTask: () {
                    _getInProgressTask();
                  },
                );
              }),
        ),
      ),
    );
  }


  Future<void> _getInProgressTask() async {
    _getInProgressTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse networkResponse =
    await NetworkCaller.getRequest(Urls.inProgressTasks);
    if (networkResponse.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(networkResponse.responseData);
      inProgressTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBArMessage(
            context,
            networkResponse.errorMessage ?? 'Failed to get In-Progress Task',
            true);
      }
    }
    _getInProgressTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
