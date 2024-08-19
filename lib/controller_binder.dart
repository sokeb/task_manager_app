import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/add_new_task_controller.dart';
import 'package:task_manager/ui/controllers/canceled_task_controller.dart';
import 'package:task_manager/ui/controllers/completed_task_controller.dart';
import 'package:task_manager/ui/controllers/delete_task_controller.dart';
import 'package:task_manager/ui/controllers/in_progress_task_controller.dart';
import 'package:task_manager/ui/controllers/new_task_controller.dart';
import 'package:task_manager/ui/controllers/pin_verification_controller.dart';
import 'package:task_manager/ui/controllers/recover_verify_email_controller.dart';
import 'package:task_manager/ui/controllers/register_user_controller.dart';
import 'package:task_manager/ui/controllers/reset_pass_controller.dart';
import 'package:task_manager/ui/controllers/sign_in_controller.dart';
import 'package:task_manager/ui/controllers/task_count_controller.dart';
import 'package:task_manager/ui/controllers/update_profile_data_controller.dart';
import 'package:task_manager/ui/controllers/update_task_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => NewTaskController());
    Get.lazyPut(() => RecoverVerifyEmailController());
    Get.lazyPut(() => PinVerificationController());
    Get.lazyPut(() => ResetPassController());
    Get.lazyPut(() => RegisterUserController());
    Get.lazyPut(() => AddNewTaskController());
    Get.lazyPut(() => CanceledTaskController());
    Get.lazyPut(() => CompletedTaskController());
    Get.lazyPut(() => InProgressTaskController());
    Get.lazyPut(() => TaskCountController());
    Get.lazyPut(() => UpdateProfileDataController());
    Get.lazyPut(() => DeleteTaskController());
    Get.lazyPut(() => UpdateTaskController());


    //Get.put(RegisterUserController());
  }
}