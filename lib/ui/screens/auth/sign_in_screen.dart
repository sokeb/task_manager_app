import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/login_model.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/auth/sing_up_screen.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/app_constants.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/snack_bar_message.dart';
import '../main_bottom_nav_screen.dart';
import 'email_verification_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _signInApiInProgress = false;
  bool _showPassword = false;

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
                      'Get Started With',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailTEController,
                      decoration: const InputDecoration(hintText: 'Email'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                color:
                                    _showPassword ? AppColors.themeColor : null,
                              ))),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter yor password';
                        }
                        return null;
                      }
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: _signInApiInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                          onPressed: _onTapNextButton,
                          child: const Icon(Icons.arrow_circle_right_outlined)),
                    ),
                    const SizedBox(height: 45),
                    Center(
                      child: Column(
                        children: [
                          TextButton(
                              onPressed: _onTapForgotButton,
                              child: const Text(
                                'Forget Password ?',
                              )),
                          RichText(
                              text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontWeight: FontWeight.bold),
                                  children: [
                                TextSpan(
                                  text: 'Sign up',
                                  style: const TextStyle(
                                      color: AppColors.themeColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _onTapSingUp,
                                )
                              ])),
                        ],
                      ),
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

  void _onTapSingUp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignUnScreen()));
  }

  void _onTapForgotButton() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const EmailVerificationScreen()));
  }

  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      _signup();
    }
  }

  Future<void> _signup() async {
    _signInApiInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestData = {
      'email': _emailTEController.text.trim(),
      'password': _passwordTEController.text,
    };

    final NetworkResponse response =
        await NetworkCaller.postRequest(Urls.login, body: requestData);
    _signInApiInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveUserAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.userModel!);
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MainBottomNavScreen()));
      }
    } else {
      if (mounted) {
        showSnackBArMessage(
            context, response.errorMessage ?? 'Invalid Email And Password');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
  }
}
