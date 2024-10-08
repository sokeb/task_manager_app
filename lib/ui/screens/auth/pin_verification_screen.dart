import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/controllers/pin_verification_controller.dart';
import 'package:task_manager/ui/screens/auth/reset_password_screen.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import '../../utilities/app_colors.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/snack_bar_message.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(45.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 90),
                  Text('Pin Verification',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(
                      'A 6 digit verification pin has been send to your email address',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 16),
                  buildPinCodeTextField(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: _onTapVerifyButton,
                      child: const Text('Verify')),
                  const SizedBox(height: 25),
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
                            style: const TextStyle(color: AppColors.themeColor),
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
    );
  }

  Widget buildPinCodeTextField() {
    return PinCodeTextField(
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.white,
        selectedFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedColor: AppColors.themeColor,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      keyboardType: TextInputType.number,
      enableActiveFill: true,
      controller: _pinTEController,
      appContext: context,
    );
  }

  Future<void> _onTapVerifyButton() async {
    String otp = _pinTEController.text.trim();
    if (_pinTEController.text.isNotEmpty) {
      final PinVerificationController pinController =
          Get.find<PinVerificationController>();
      final bool result = await pinController.verifyOTP(
        widget.email,
        otp,
      );
      if (result) {
        Get.to(() => ResetPasswordScreen(email: widget.email, otp: otp));
      } else {
        if (mounted) {
          showSnackBArMessage(context, pinController.errorMessage);
        }
      }
    } else {
      if (mounted) {
        showSnackBArMessage(context, 'Please Enter OTP', true);
      }
    }
  }

  void _onTapSingIn() {
    Get.offAll(()=> const  SignInScreen());
  }

  @override
  void dispose() {
    super.dispose();
    _pinTEController.dispose();
  }
}
