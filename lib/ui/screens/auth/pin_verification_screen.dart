import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_oly/data/models/reset_password_model.dart';
import 'package:task_manager_oly/ui/screens/auth/reset_password_screen.dart';
import 'package:task_manager_oly/ui/screens/auth/sign_in_screen.dart';

import 'package:task_manager_oly/ui/utility/app_colors.dart';
import 'package:task_manager_oly/ui/widgets/center_progress_indicator.dart';

import '../../../data/models/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utilities/urls.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/snack_bar_messege.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.recoveryEmail});

  final String recoveryEmail;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  TextEditingController _pinTEController = TextEditingController();
  bool _pinInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
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
                    Visibility(
                      visible: !_pinInProgress,
                      replacement: const CenterProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapVerifyOTPButton,
                        child: const Text('Verify'),
                      ),
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
                  recognizer: TapGestureRecognizer()
                    ..onTap = _onTapSignInButton)
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
          selectedColor: AppColors.themeColor),
      animationDuration: const Duration(milliseconds: 300),
      keyboardType: TextInputType.number,
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      controller: _pinTEController,
      appContext: context,
    );
  }

  void _onTapSignInButton() {

    Get.offAll(const SignInScreen());

/*
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
        (route) => false);*/
  }

  void _onTapVerifyOTPButton() async {
    _pinInProgress = true;
    if (mounted) {
      setState(() {});
    }
    //network call
    NetworkResponse response = await NetworkCaller.getRequest(
        "${Urls.verifyPin}/${widget.recoveryEmail}/${_pinTEController.text}");

    if (response.isSuccess && response.responseData["status"] == "success") {
      _pinInProgress = false;
      if (mounted) {
        setState(() {});
      }
      Get.to( ResetPasswordScreen(
        resetPasswordModel: ResetPasswordModel(
            recoveryEmail: widget.recoveryEmail,
            pinCode: _pinTEController.text),
      ),);
      /*
 push => to()
 pushReplacement => off()
 pushAndRemoveUntil => ofAll()
 pop => back()
*/



      /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(
            resetPasswordModel: ResetPasswordModel(
                recoveryEmail: widget.recoveryEmail,
                pinCode: _pinTEController.text),
          ),
        ),
      );*/
      return;
    } else {
      if (mounted) {
        showSnackBarMessage(context, 'Invalid PIN Code! Try Again.');
      }
    }
    _pinInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

/*
  @override
  void dispose() {
    pinTEController.dispose();
    super.dispose();
  }
*/
}
