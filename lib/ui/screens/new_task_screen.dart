import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_by_status_count_wrapper_model.dart';
import 'package:task_manager/data/models/task_count_by_Status_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../utilities/app_colors.dart';
import '../widgets/profile_appbar.dart';
import '../widgets/task_item.dart';
import '../widgets/task_summary_card.dart';
import 'add_new_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTaskInProgress = false;
  bool _getTaskCountByStatusInProgress = false;
  List<TaskModel> newTaskList = [];
  List<TaskCountByStatusModel> statusCountList = [];

  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus();
    _getNewTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Column(
          children: [
            _buildSummarySection(),
            const SizedBox(height: 10),
            Expanded(
                child: RefreshIndicator(
              onRefresh: () async {
                _getNewTask();
                _getTaskCountByStatus();
              },
              child: Visibility(
                visible: _getNewTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: ListView.builder(
                    itemCount: newTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        task: newTaskList[index],
                        onUpdateTask: () {
                          _getNewTask();
                          _getTaskCountByStatus();
                        },
                      );
                    }),
              ),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddButton,
        backgroundColor: AppColors.themeColor,
        foregroundColor: AppColors.forGroundColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Visibility(
      visible: _getTaskCountByStatusInProgress == false,
      replacement: const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: statusCountList.map((e) {
            return TaskSummaryCard(
              title: (e.sId ?? '').toUpperCase(),
              count: e.sum.toString(),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _onTapAddButton() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddNewTaskScreen()));
  }

  Future<void> _getNewTask() async {
    _getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.newTasks);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      newTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBArMessage(
            context, response.errorMessage ?? 'Failed to get new tasks', true);
      }
    }
    _getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getTaskCountByStatus() async {
    _getTaskCountByStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.taskStatusCount);

    if (response.isSuccess) {
      TaskCountByStatusWrapperModel taskCountByStatusWrapperModel =
          TaskCountByStatusWrapperModel.fromJson(response.responseData);
      statusCountList =
          taskCountByStatusWrapperModel.taskCountByStatusList ?? [];
    } else {
      if (mounted) {
        showSnackBArMessage(context,
            response.errorMessage ?? 'Failed to get Status Count', true);
      }
    }
    _getTaskCountByStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

}
