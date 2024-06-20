import 'package:app/common/phone_number.dart';
import 'package:app/components/phone_number_input.dart';
import 'package:app/models/user_model.dart';
import 'package:app/utils/sizes.dart';
import 'package:app/views/otp_verify_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final UserLoginDetails _userLoginDetails =
      UserLoginDetails(CountryCode.INDIA, "");

  bool hasError = false;
  String? errorMessage;

  void _handleVerifyTap() {
    setState(() {
      if (!PhoneNumber.isValid(
          _userLoginDetails.phoneCountryCode, _userLoginDetails.phoneNumber)) {
        hasError = true;
        errorMessage = "Please enter a valid 10-digit phone number.";
      } else {
        hasError = false;
        errorMessage = null;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OtpVerifyView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md, vertical: Spacing.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/placeholder_logo.png", width: 100),
                  const SizedBox(height: Spacing.md),
                  const Text(
                    "Sign in",
                    style: TextStyle(
                        fontSize: FontSize.lg, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    "This app is currently in beta",
                    style: TextStyle(
                        fontSize: FontSize.md, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: Spacing.xl * 1.6),
                  PhoneNumberInput(
                    onInput: (value) {
                      setState(() {
                        _userLoginDetails.phoneNumber = value;
                      });
                    },
                    hasError: hasError,
                    errorMessage: errorMessage,
                  ),
                  const SizedBox(height: Spacing.sm),
                  MaterialButton(
                      onPressed: _handleVerifyTap,
                      height: 54,
                      minWidth: double.infinity,
                      color: Colors.lightGreen.shade700,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Spacing.sm)),
                      child: const Text("Verify",
                          style: TextStyle(
                            fontSize: FontSize.md,
                          )))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
