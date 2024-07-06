import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';

import '../../../data/models/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utilities/urls.dart';
import '../../utilities/app_colors.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _resetPassInProgress = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;


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
                      'Set Password',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                        'Minimum length password character with letter and Number combination',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 16),
                    TextFormField(
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
                                icon: Icon(
                                    _showPassword
                                        ? Icons.remove_red_eye
                                        : Icons.visibility_off,
                                    color: _showPassword
                                        ? AppColors.themeColor
                                        : null))),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter New password';
                          }
                          return null;
                        }),
                    const SizedBox(height: 8),
                    TextFormField(
                        obscureText: _showConfirmPassword == false,
                        controller: _confirmPasswordTEController,
                        decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  _showConfirmPassword = !_showConfirmPassword;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                },
                                icon: Icon(
                                    _showConfirmPassword
                                        ? Icons.remove_red_eye
                                        : Icons.visibility_off,
                                    color: _showConfirmPassword
                                        ? AppColors.themeColor
                                        : null))),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter Confirm password';
                          }
                          return null;
                        }),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: _resetPassInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                          onPressed: _onTapConfirmButton,
                          child: const Text('Confirm')),
                    ),
                    const SizedBox(height: 45),
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

  void _onTapSingIn() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false);
  }

  void _onTapConfirmButton() {
    if (_formKey.currentState!.validate() &&
        _passwordTEController.text == _confirmPasswordTEController.text) {
      _resetPass();
    } else {
      if (mounted) {
        showSnackBArMessage(context, 'Confirm password are not same', true);
      }
    }
  }

  Future<void> _resetPass() async {
    _resetPassInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestData = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": _confirmPasswordTEController.text
    };
    NetworkResponse response =
        await NetworkCaller.postRequest(Urls.resetPass, body: requestData);
    _resetPassInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      if (mounted) {
        showSnackBArMessage(context, 'Password Successfully Changed');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false);
      }
    } else {
      if (mounted) {
        showSnackBArMessage(
            context, ' Failed to Change password! Try again.', true);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _confirmPasswordTEController.dispose();
    _passwordTEController.dispose();
  }
}
