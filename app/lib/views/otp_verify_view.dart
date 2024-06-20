import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpVerifyView extends StatefulWidget {
  const OtpVerifyView({super.key});

  @override
  _OtpVerifyViewState createState() => _OtpVerifyViewState();
}

class _OtpVerifyViewState extends State<OtpVerifyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Go back button

          const Text("Verify your OTP",
              style: TextStyle(
                  fontSize: FontSize.lg, fontWeight: FontWeight.bold)),
          const SizedBox(height: Spacing.xs),
          Text(
            "We texted you a code. Please verify that",
            style:
                TextStyle(fontSize: FontSize.md, color: Colors.grey.shade500),
          ),

          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OtpTextField(
                    numberOfFields: 6,
                    showFieldAsBox: true,
                    borderColor: Colors.green.shade400,
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text("Didn't get the code? Try again in ___",
                      style: TextStyle(
                          fontSize: FontSize.md, color: Colors.grey.shade500))
                  // Login Button
                ]),
          )
        ],
      ),
    )));
  }
}
