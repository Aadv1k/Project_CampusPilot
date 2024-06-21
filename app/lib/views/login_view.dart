import 'package:app/common/phone_number.dart';
import 'package:app/components/button.dart';
import 'package:app/components/mailto_link.dart';
import 'package:app/components/phone_number_input.dart';
import 'package:app/models/user_model.dart';
import 'package:app/utils/sizes.dart';
import 'package:app/views/otp_verify_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Spacing.xl, vertical: Spacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/placeholder_logo.svg",
                    width: 50, height: 50),
                const SizedBox(height: Spacing.xl * 1.6),
                const Text(
                  "Welcome to Your School's Communication Hub.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: FontSize.xxxl,
                      height: 1,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: Spacing.xl),
                Column(
                  children: [
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
                    PrimaryButton(
                      onPressed: _handleVerifyTap,
                      width: double.infinity,
                      text: "Sign in",
                    ),
                    const SizedBox(height: Spacing.sm),
                    MailtoLink(
                        emailSubject: "Support request: Can't login",
                        emailBody:
                            "Entered Number: ${_userLoginDetails.phoneNumber}\nErrors: ${hasError ? errorMessage : "None"}",
                        child: Text("Can't login? Contact support.",
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: FontSize.md))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
