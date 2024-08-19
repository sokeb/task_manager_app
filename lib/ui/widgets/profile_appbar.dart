import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import '../screens/update_profile.dart';
import '../utilities/app_colors.dart';

AppBar profileAppBar(context, [bool formUpdatePage = false]) {
  return AppBar(
    backgroundColor: AppColors.themeColor,
    foregroundColor: Colors.white,
    leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
          onTap: () {
            if (formUpdatePage == true) {
              return;
            }
            Get.to(()=> const UpdateProfileScreen());
          },
        child: CircleAvatar(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.memory(base64Decode(AuthController.userData?.photo ?? ''))),
        ),
      ),
    ),
    title: GestureDetector(
      onTap: () {
        if (formUpdatePage == true) {
          return;
        }
        Get.to(()=> const UpdateProfileScreen());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AuthController.userData?.fullName ?? '',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            AuthController.userData?.email ?? '',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
          )
        ],
      ),
    ),
    actions: [
      IconButton(
          onPressed: () async {
            await AuthController.clearAllData();
            Get.offAll(()=> const SignInScreen());
          },
          icon: const Icon(Icons.logout_rounded))
    ],
  );
}
