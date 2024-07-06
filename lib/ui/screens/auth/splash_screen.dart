import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_screen.dart';
import '../../utilities/asset_paths.dart';
import '../../widgets/background_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToTheNextScreen();
  }

  Future<void> _moveToTheNextScreen() async {
    await Future.delayed(const Duration(seconds: 1));

    bool isUserLoggedIn = await AuthController.checkAuthState();

    if (mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => isUserLoggedIn
                ? const MainBottomNavScreen()
                : const SignInScreen(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Center(
          child: SvgPicture.asset(
            AssetPaths.logoSvg,
            height: 70,
          ),
        ),
      ),
    );
  }
}
