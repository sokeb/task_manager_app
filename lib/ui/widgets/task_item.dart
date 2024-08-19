import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../controllers/delete_task_controller.dart';
import '../controllers/update_task_controller.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
    required this.onUpdateTask,
  });

  final TaskModel task;
  final VoidCallback onUpdateTask;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  String dropdownValue = '';
  List<String> statusList = [
    'New',
    'Progress',
    'Completed',
    'canceled',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.task.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.task.description ?? ''),
            Text(
              "Date : ${widget.task.createdDate}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    widget.task.status ?? 'New',
                    style: const TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  backgroundColor: widget.task.status == 'canceled'
                      ? Colors.red
                      : Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 13),
                ),
                ButtonBar(
                  children: [
                    PopupMenuButton<String>(
                        icon: const Icon(Icons.edit_document,
                            color: Colors.green),
                        onSelected: (String selectedValue) {
                          dropdownValue = selectedValue;
                          _updateTaskStatus();
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return statusList.map((String value) {
                            return PopupMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      color: dropdownValue == value
                                          ? Colors.green
                                          : null),
                                ));
                          }).toList();
                        }),
                    IconButton(
                        onPressed: () {
                          _deleteTask();
                        },
                        icon: const Icon(Icons.delete,
                            color: Colors.red))                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask() async {
    final DeleteTaskController deleteTaskController =
        Get.find<DeleteTaskController>();
    final bool result = await deleteTaskController.deleteTask(widget.task.sId!);
    if (result) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackBArMessage(context, deleteTaskController.errorMessage, true);
      }
    }
  }

  Future<void> _updateTaskStatus() async {
    final UpdateTaskController updateTaskController =
        Get.find<UpdateTaskController>();
    final bool result = await updateTaskController.updateTaskStatus(
        widget.task.sId!, dropdownValue);
    if (result) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackBArMessage(context, updateTaskController.errorMessage, true);
      }
    }
  }
}
