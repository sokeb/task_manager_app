import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/task_count_by_status_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../controllers/new_task_controller.dart';
import '../controllers/task_count_controller.dart';
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
  List<TaskModel> newTaskList = [];
  List<TaskCountByStatusModel> statusCountList = [];

  @override
  void initState() {
    super.initState();
    _initialCall();
  }

  void _initialCall() {
    _getTaskCountByStatus();
    Get.find<TaskCountController>();
    Get.find<NewTaskController>().getNewTask();
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
                _initialCall();
              },
              child:
                  GetBuilder<NewTaskController>(builder: (newTaskController) {
                return Visibility(
                  visible: newTaskController.getNewTaskInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ListView.builder(
                      itemCount: newTaskController.newTaskModel.length,
                      itemBuilder: (context, index) {
                        return TaskItem(
                          task: newTaskController.newTaskModel[index],
                          onUpdateTask: _initialCall,
                        );
                      }),
                );
              }),
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
    return GetBuilder<TaskCountController>(builder: (taskCountController) {
      return Visibility(
        visible: taskCountController.getTaskCountByStatusInProgress == false,
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
    });
  }

  void _onTapAddButton() {
    Get.to(()=> const AddNewTaskScreen());
  }

  Future<void> _getTaskCountByStatus() async {
    final TaskCountController taskCountController =
        Get.find<TaskCountController>();
    final bool result = await taskCountController.getTaskCountByStatus();
    if (result) {
      statusCountList = taskCountController.statusCountList;
    } else {
      if (mounted) {
        showSnackBArMessage(context, taskCountController.errorMessage, true);
      }
    }
  }
}
