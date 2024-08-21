import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_oly/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_oly/ui/utility/app_colors.dart';
import 'package:task_manager_oly/ui/widgets/center_progress_indicator.dart';

import '../../../data/models/network_response.dart';
import '../../../data/models/reset_password_model.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utilities/urls.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/snack_bar_messege.dart';

class ResetPasswordScreen extends StatefulWidget {
  final ResetPasswordModel resetPasswordModel;

  const ResetPasswordScreen({super.key, required this.resetPasswordModel});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordTEController = TextEditingController();
  TextEditingController confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _resetPassInProgress = false;

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
                      'Set Password',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Minimum length of password should be more than 8 characters with letter and number combination',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: passwordTEController,
                              decoration:
                                  const InputDecoration(hintText: 'Password'),
                              validator: (String? value) {
                                if (value != null &&
                                    value.isEmpty &&
                                    value.length < 8) {
                                  return 'Invalid Password!';
                                }
                                if (value!.isNotEmpty && value.length < 8) {
                                  return 'Password should be more than 8 characters!';
                                }
                                return null;
                                /*if (AppConstants.mobileRegEx.hasMatch(value!) == false) {
                              return 'Enter a valid mobile number!';
                            }*/
                                // return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: confirmPasswordTEController,
                              decoration: const InputDecoration(
                                  hintText: 'Confirm Password'),
                              validator: (String? value) {
                                if (value != null && value.isEmpty) {
                                  return 'Invalid Password!';
                                }
                                if (value!.isNotEmpty && value.length < 8) {
                                  return 'Password should be more than 8 characters!';
                                }
                                if (value != passwordTEController.text) {
                                  return "Password didn't match!";
                                }
                                return null;
                                /*if (AppConstants.mobileRegEx.hasMatch(value!) == false) {
                              return 'Enter a valid mobile number!';
                            }*/
                                // return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    Visibility(
                      visible: !_resetPassInProgress,
                      replacement: const CenterProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapConfirmButton,
                        child: const Text('Confirm'),
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Center(
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

  void _onTapSignInButton() {
    Get.offAll(const SignInScreen());
   /* Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
        (route) => false);*/
  }

  Future<void> _onTapConfirmButton() async {
    if (_formKey.currentState!.validate()) {
      _resetPassInProgress = true;
      if (mounted) {
        setState(() {});
      }
      widget.resetPasswordModel.password = passwordTEController.text;
      Map<String, dynamic> resetPasswordData = {
        "email": widget.resetPasswordModel.recoveryEmail,
        "OTP": widget.resetPasswordModel.pinCode,
        "password": widget.resetPasswordModel.password
      };
      NetworkResponse response = await NetworkCaller.postRequest(Urls.resetPass,
          body: resetPasswordData);

      if (response.isSuccess && response.responseData["status"] == "success") {
        if (mounted) {
          showSnackBarMessage(
              context, 'Your Password has been reset successfully');
        }
        Get.offAll(const SignInScreen());
        /*Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
                (route) => false);*/

        return;
      } else {
        if (mounted) {
          showSnackBarMessage(context, 'Something went wrong! Try Again.');
        }
      }
      _resetPassInProgress = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    passwordTEController.dispose();
    super.dispose();
  }
}
