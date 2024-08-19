import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../controllers/update_profile_data_controller.dart';
import '../widgets/background_widget.dart';
import '../widgets/profile_appbar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    Get.find<UpdateProfileDataController>();
    final userData = AuthController.userData!;
    _emailTEController.text = userData.email ?? '';
    _firstNameTEController.text = userData.firstName ?? '';
    _lastNameTEController.text = userData.lastName ?? '';
    _mobileTEController.text = userData.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context, true),
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
                    const SizedBox(height: 30),
                    Text(
                      'Update Profile',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    buildPhotoPickerWidget(),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                      enabled: false,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _firstNameTEController,
                      decoration: const InputDecoration(hintText: 'First Name'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _lastNameTEController,
                      decoration: const InputDecoration(hintText: 'Last Name'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _mobileTEController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'Mobile'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordTEController,
                      decoration: const InputDecoration(hintText: 'Password'),
                    ),
                    const SizedBox(height: 16),
                    GetBuilder<UpdateProfileDataController>(
                        init: Get.find<UpdateProfileDataController>(),
                        builder: (updateProfileDataController) {
                          return Visibility(
                            visible:
                                updateProfileDataController.updateInProgress ==
                                    false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                                onPressed: () {
                                  _updateProfileData();
                                },
                                child: const Icon(
                                    Icons.arrow_circle_right_outlined)),
                          );
                        }),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPhotoPickerWidget() {
    return GestureDetector(
      onTap: () {
        _photoPicker();
      },
      child: Container(
        height: 41,
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.white),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 41,
              width: 100,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                  color: Colors.grey),
              child: const Text(
                'Photo',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              _selectedImage?.name ?? 'No Image Selected',
              maxLines: 1,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ))
          ],
        ),
      ),
    );
  }

  Future<void> _photoPicker() async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      _selectedImage = image;
      if (mounted) {
        setState(() {});
      }
    } else {}
  }

  Future<void> _updateProfileData() async {
    String encodedPhoto = AuthController.userData?.photo ?? '';

    Map<String, dynamic> requestedBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": "",
      "photo": ""
    };
    if (_passwordTEController.text.isNotEmpty) {
      requestedBody['password'] = _passwordTEController.text;
    }

    if (_selectedImage != null) {
      File file = File(_selectedImage!.path);
      encodedPhoto = base64Encode(file.readAsBytesSync());
      requestedBody['photo'] = encodedPhoto;
    }

    final UpdateProfileDataController profileDataController =
        Get.find<UpdateProfileDataController>();
    final bool result = await profileDataController.updateProfileData(
        requestedBody,
        _emailTEController.text.trim(),
        _firstNameTEController.text.trim(),
        _lastNameTEController.text.trim(),
        _mobileTEController.text.trim(),
        encodedPhoto);
    if (result) {
      if (mounted) {
        showSnackBArMessage(context, 'Profile data update');
      }
    } else {
      if (mounted) {
        showSnackBArMessage(context, profileDataController.errorMessage);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
  }
}
