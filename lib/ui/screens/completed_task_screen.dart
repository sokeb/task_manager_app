import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../../data/models/task_model.dart';
import '../controllers/completed_task_controller.dart';
import '../widgets/profile_appbar.dart';
import '../widgets/task_item.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  List<TaskModel> completedTaskList = [];

  @override
  void initState() {
    super.initState();
    Get.find<CompletedTaskController>();
    _getCompletedTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          _getCompletedTask();
        },
        child: GetBuilder<CompletedTaskController>(
            builder: (completedTaskController) {
          return Visibility(
            visible:
                completedTaskController.getCompletedTaskInProgress == false,
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
          );
        }),
      ),
    );
  }

  Future<void> _getCompletedTask() async {
    final CompletedTaskController completedTaskController =
        Get.find<CompletedTaskController>();
    final bool result = await completedTaskController.getCompletedTask();
    if (result) {
      completedTaskList = completedTaskController.completedTaskList;
    } else {
      if (mounted) {
        showSnackBArMessage(
            context, completedTaskController.errorMassage, false);
      }
    }
  }
}
