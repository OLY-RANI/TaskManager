import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_oly/data/models/login_model.dart';
import 'package:task_manager_oly/data/models/network_response.dart';
import 'package:task_manager_oly/data/network_caller/network_caller.dart';
import 'package:task_manager_oly/ui/controllers/auth_controller.dart';
import 'package:task_manager_oly/ui/screens/auth/email_verification_screen.dart';
import 'package:task_manager_oly/ui/screens/auth/sign_up_screen.dart';
import 'package:task_manager_oly/ui/screens/main_bottom_nav_screen.dart';

import 'package:task_manager_oly/ui/utility/app_colors.dart';
import 'package:task_manager_oly/ui/widgets/snack_bar_messege.dart';

import '../../../data/utilities/urls.dart';
import '../../utility/app_constants.dart';
import '../../widgets/background_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool _showPassword = false;
  bool _signInApiInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    Text(
                      'Get Started With',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'This field Cannot remain empty!';
                        }
                        if (AppConstants.emailRegEx.hasMatch(value!) == false) {
                          return 'Enter a valid E-mail address!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      obscureText: _showPassword == false,
                      controller: _passwordTEController,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        //TOD: Eye button add
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'This field Cannot remain empty!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Visibility(
                      visible: _signInApiInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: _onTapNextButton,
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Center(
                      child: Column(
                        children: [
                          TextButton(
                              onPressed: _onTapForgetPasswordButton,
                              child: const Text('Forget Password?')),
                          RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.4),
                                text: "Don't have an account?",
                                children: [
                                  TextSpan(
                                      text: 'Sign up',
                                      style: const TextStyle(
                                        color: AppColors.themeColor,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = _onTapSignUpButton)
                                ]),
                          ),
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


  void _onTapSignUpButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }

  Future<void> _signUp() async {
    _signInApiInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestData = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text
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

      if(mounted){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainBottomNavScreen()));
      }

    } else {
      if(mounted){
        showSnackBarMessage(
            context,
            response.errorMassege ??
                'E-mail/Password is not correct! Try Again');
      }

    }
  }



  void _onTapForgetPasswordButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmailVerificationScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
