import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_oly/ui/screens/auth/reset_password_screen.dart';
import 'package:task_manager_oly/ui/screens/auth/sign_in_screen.dart';

import 'package:task_manager_oly/ui/utility/app_colors.dart';

import '../../widgets/background_widget.dart';



class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  TextEditingController pinTEController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BackgroundWidget(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  Text(
                    'PIN Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'A 6 digits verification pin has been sent to your email address',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  buildPinCodeTextField(),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: _onTapVerifyOTPButton,
                    child: const Text('Verify'),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  buildSignInSection()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSignInSection() {
    return Center(
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4),
                        text: "Have account?",
                        children: [
                          TextSpan(
                              text: 'Sign in',
                              style: const TextStyle(
                                color: AppColors.themeColor,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton)
                        ]),
                  ),
                );
  }

  PinCodeTextField buildPinCodeTextField() {
    return PinCodeTextField(
                  length: 6,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedColor: AppColors.themeColor
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  keyboardType: TextInputType.number,
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  controller: pinTEController,
                 appContext: context,
                );
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
        (route) => false);
  }

  void _onTapVerifyOTPButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResetPasswordScreen(),
      ),
    );
  }

  @override
  void dispose() {
    pinTEController.dispose();
    super.dispose();
  }
}
