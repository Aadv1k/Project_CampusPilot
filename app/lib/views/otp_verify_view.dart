import 'package:app/components/button.dart';
import 'package:app/utils/colors.dart';
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
      padding: const EdgeInsets.symmetric(
          vertical: Spacing.xxl, horizontal: Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SquareIconButton(
            icon: Icons.chevron_left_sharp,
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: Colors.grey.shade200,
            iconColor: Colors.grey.shade800,
            size: 64,
          ),
          const SizedBox(height: Spacing.lg),
          const Text("Verify your OTP",
              style: TextStyle(
                  fontSize: FontSize.xxxl, fontWeight: FontWeight.bold)),
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
                    borderRadius:
                        const BorderRadius.all(Radius.circular(Spacing.sm)),
                    fieldWidth: 48,
                    borderColor: Colors.transparent,
                    enabledBorderColor: Colors.transparent,
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    focusedBorderColor: CustomPalette.black,
                    textStyle: TextStyle(
                        fontSize: FontSize.md,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600),
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
