import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/widgets/task_item.dart';
import '../../data/models/task_model.dart';
import '../controllers/canceled_task_controller.dart';
import '../widgets/profile_appbar.dart';
import '../widgets/snack_bar_message.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {
  List<TaskModel> canceledTaskList = [];

  @override
  void initState() {
    super.initState();
    Get.find<CanceledTaskController>();
    _getCanceledTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async => _getCanceledTask(),
        child: GetBuilder<CanceledTaskController>(
            builder: (canceledTaskController) {
          return Visibility(
            visible: canceledTaskController.getCanceledTaskInProgress == false,
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
          );
        }),
      ),
    );
  }

  Future<void> _getCanceledTask() async {
    final CanceledTaskController canceledTaskController =
        Get.find<CanceledTaskController>();
    final bool result = await canceledTaskController.getCanceledTask();
    if (result) {
      canceledTaskList = canceledTaskController.canceledTaskList;
    } else {
      if (mounted) {
        showSnackBArMessage(
            context, canceledTaskController.errorMessage, true);
      }
    }
  }
}
