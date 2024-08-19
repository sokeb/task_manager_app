import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/task_model.dart';
import '../controllers/in_progress_task_controller.dart';
import '../widgets/profile_appbar.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_item.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  List<TaskModel> inProgressTaskList = [];

  @override
  void initState() {
    super.initState();
    Get.find<InProgressTaskController>();
    _getInProgressTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async => _getInProgressTask(),
        child: GetBuilder<InProgressTaskController>(
            builder: (inProgressTaskController) {
          return Visibility(
            visible:
                inProgressTaskController.getInProgressTaskInProgress == false,
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
          );
        }),
      ),
    );
  }

  Future<void> _getInProgressTask() async {
    final InProgressTaskController inProgressTaskController =
        Get.find<InProgressTaskController>();
    final bool result = await inProgressTaskController.getInProgressTask();
    if (result) {
      inProgressTaskList = inProgressTaskController.inProgressTaskList;
    } else {
      if (mounted) {
        showSnackBArMessage(
            context, inProgressTaskController.errorMessage, false);
      }
    }
  }
}
