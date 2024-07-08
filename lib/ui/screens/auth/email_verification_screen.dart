import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_oly/ui/screens/auth/pin_verification_screen.dart';
import 'package:task_manager_oly/ui/utility/app_colors.dart';
import 'package:task_manager_oly/ui/widgets/center_progress_indicator.dart';

import '../../../data/models/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utilities/urls.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/snack_bar_messege.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  TextEditingController _emailTEController = TextEditingController();
  bool _emailVerificationInProgress = false;

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
                      'Your Email Address',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'A 6 digits verification pin will send to your email address',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'E-mail'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Visibility(
                      visible: !_emailVerificationInProgress,
                      replacement: const CenterProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapConfirmButton,
                        child: const Icon(Icons.arrow_circle_right_outlined),
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
    Navigator.pop(context);
  }

  void _onTapConfirmButton() async{

    _emailVerificationInProgress = true;
    if (mounted) {
      setState(() {});
    }
    //network call
    NetworkResponse response =
        await NetworkCaller.getRequest("${Urls.verifyEmail}/${_emailTEController.text}");

    if (response.isSuccess && response.responseData["status"] == "success") {
      _emailVerificationInProgress = false;
      if (mounted) {
        setState(() {});
      }
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  PinVerificationScreen(recoveryEmail: _emailTEController.text,),
      ),
    );
      return;
    } else {
      if (mounted) {
        showSnackBarMessage(
            context, 'This E-mail is not registered');
      }
    }
    _emailVerificationInProgress = false;
    if (mounted) {
      setState(() {});
    }

  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
