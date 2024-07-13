import 'package:app/common/phone_number.dart';
import 'package:app/components/button.dart';
import 'package:app/components/mailto_link.dart';
import 'package:app/components/phone_number_input.dart';
import 'package:app/models/user_model.dart';
import 'package:app/utils/colors.dart';
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
          MaterialPageRoute(
              builder: (context) => OtpVerifyView(_userLoginDetails)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Column(
              children: [
                SizedBox(height: Spacing.lg),
                Text(
                  "Stay informed, engaged, and connected with your school",
                  style: TextStyle(
                      fontSize: FontSize.xl, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const Spacer(),
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
                const SizedBox(height: Spacing.xs),
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
                    child: const Text("Can't login? Contact support.",
                        style: TextStyle(
                            color: Palette.slate500, fontSize: FontSize.base))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
