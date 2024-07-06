import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_wrapper_model.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../../data/models/task_model.dart';
import '../widgets/profile_appbar.dart';
import '../widgets/task_item.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getCompletedTaskInProgress = false;
  List<TaskModel> completedTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCompletedTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: RefreshIndicator(
        onRefresh: ()async{
          _getCompletedTask();
        },
        child: Visibility(
          visible: _getCompletedTaskInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.builder(
              itemCount: completedTaskList.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  task: completedTaskList[index],
                  onUpdateTask: () {
                    _getCompletedTask();
                  },
                );
              }),
        ),
      ),
    );
  }

  Future<void> _getCompletedTask() async {
    _getCompletedTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse networkResponse =
        await NetworkCaller.getRequest(Urls.completedTasks);
    if (networkResponse.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(networkResponse.responseData);
      completedTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBArMessage(
            context,
            networkResponse.errorMessage ?? 'Failed to get completed Task',
            true);
      }
    }
    _getCompletedTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
