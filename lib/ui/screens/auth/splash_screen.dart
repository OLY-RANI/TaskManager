import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_oly/ui/controllers/auth_controller.dart';
import 'package:task_manager_oly/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_oly/ui/screens/main_bottom_nav_screen.dart';
import '../../utility/asset_paths.dart';
import '../../widgets/background_widget.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 10));

    bool isUserLoggedIn = await AuthController.checkAuthState();

    if (mounted) {

      Get.off(() =>isUserLoggedIn
          ? const MainBottomNavScreen()
          : const SignInScreen());
      /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => isUserLoggedIn
                ? const MainBottomNavScreen()
                : const SignInScreen()),
      );*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
      child: Center(
        child: SvgPicture.asset(
          AssetPaths.appLogoSvg,
          width: 140,
        ),
      ),
    ));
  }
}
