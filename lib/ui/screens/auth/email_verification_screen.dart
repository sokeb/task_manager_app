import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screens/auth/pin_verification_screen.dart';
import '../../controllers/recover_verify_email_controller.dart';
import '../../utilities/app_colors.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/snack_bar_message.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    Text('Your Email Address ',
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(
                        'A 6 digit verification pin will send to your email address',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter Your Email Address';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: _onTapNextButton,
                        child: const Icon(Icons.arrow_circle_right_outlined)),
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
    Get.back();
  }

  Future<void> _onTapNextButton() async {
    if (_formKey.currentState!.validate()) {
      final RecoverVerifyEmailController recoverController = Get.find<RecoverVerifyEmailController>();
      final bool result =
          await recoverController.recoverVerifyEmail(_emailTEController.text.trim());

      if(result){
        Get.offAll(()=> PinVerificationScreen(email: _emailTEController.text.trim()));
      }else{
        if(mounted){
          showSnackBArMessage(context, recoverController.errorMessage);
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
  }
}
