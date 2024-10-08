import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../controllers/add_new_task_controller.dart';
import '../widgets/background_widget.dart';
import '../widgets/profile_appbar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Get.put(AddNewTaskController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(45.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 90),
                    Text(
                      'Add New Task',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleTEController,
                      decoration: const InputDecoration(hintText: 'Title'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Please Enter the Title of New task';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                        controller: _descriptionTEController,
                        maxLines: 4,
                        decoration:
                            const InputDecoration(hintText: 'Description'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Please Enter the Description of New task';
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(height: 16),
                    GetBuilder<AddNewTaskController>(
                        init: Get.find<AddNewTaskController>(),
                        builder: (addNewTaskController) {
                          return Visibility(
                            visible:
                                addNewTaskController.addNewTaskInProgress ==
                                    false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _onTabAddButton();
                                  }
                                },
                                child: const Text('Add')),
                          );
                        }),
                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTabAddButton() async {
    Map<String, dynamic> requestData = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New"
    };
    final AddNewTaskController addTaskController =
        Get.find<AddNewTaskController>();
    final bool result = await addTaskController.addTask(requestData);
    if (result) {
      if (mounted) {
        _clearTextFlied();
        showSnackBArMessage(context, 'New Task Added');}
    } else {
      if (mounted) {
        showSnackBArMessage(context, addTaskController.errorMessage);
      }
    }
  }

  void _clearTextFlied() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _titleTEController.dispose();
    _descriptionTEController.dispose();
  }
}
