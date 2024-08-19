import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/register_user_controller.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/app_constants.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/snack_bar_message.dart';

class SignUnScreen extends StatefulWidget {
  const SignUnScreen({super.key});

  @override
  State<SignUnScreen> createState() => _SignUnScreenState();
}

class _SignUnScreenState extends State<SignUnScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    Get.put(RegisterUserController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Join With Us',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _emailTEController,
                      decoration: const InputDecoration(hintText: 'Email'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter Your Email';
                        }
                        if (AppConstants.emailRegEx.hasMatch(value!) == false) {
                          return 'Enter a Valid Email Address';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _firstNameTEController,
                        decoration:
                            const InputDecoration(hintText: 'First Name'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter Your First Name';
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(height: 8),
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _lastNameTEController,
                        decoration:
                            const InputDecoration(hintText: 'Last Name'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter Your last Name';
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(height: 8),
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _mobileTEController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Mobile'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter Your Mobile';
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(height: 8),
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: _showPassword == false,
                        controller: _passwordTEController,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  _showPassword = !_showPassword;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                },
                                icon: Icon(_showPassword
                                    ? Icons.remove_red_eye
                                    : Icons.visibility_off))),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter password';
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(height: 16),
                    GetBuilder<RegisterUserController>(
                        init: Get.find<RegisterUserController>(),
                        builder: (registerUserController) {
                          return Visibility(
                            visible:
                                registerUserController.registrationInProgress ==
                                    false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _onTapNextButton();
                                  }
                                },
                                child: const Icon(
                                    Icons.arrow_circle_right_outlined)),
                          );
                        }),
                    const SizedBox(height: 35),
                    Center(
                      child: RichText(
                          text: TextSpan(
                              text: "Have an account? ",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.bold),
                              children: [
                            TextSpan(
                              text: 'Sign In',
                              style:
                                  const TextStyle(color: AppColors.themeColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _onTapSingIn,
                            )
                          ])),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTapNextButton() async {
    if (_formKey.currentState!.validate()) {
      final RegisterUserController registerController =
          Get.find<RegisterUserController>();
      final bool result = await registerController.registerUser(
        _emailTEController.text.trim(),
        _firstNameTEController.text.trim(),
        _lastNameTEController.text.trim(),
        _mobileTEController.text.trim(),
        _passwordTEController.text,
      );

      if (result) {
        _clearTextFields();
        if (mounted) {
          showSnackBArMessage(context, 'Registration Success', false);
        }
      } else {
        if (mounted) {
          showSnackBArMessage(context, registerController.errorMassage, true);
        }
      }
    }
  }

  void _clearTextFields() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  void _onTapSingIn() {
    Get.back();
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
