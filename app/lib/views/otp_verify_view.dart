import 'dart:async';

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
  bool _otpLoading = false;
  bool hasError = false;
  String? errorMessage = "";
  String _otp = '';
  bool _resendButtonEnabled = true;
  int _resendTimer = 0;

  void _sendOtpAndUpdate() {
    setState(() {
      _otpLoading = true;
      hasError = false;
    });

    // Simulate an API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _otpLoading = false;
        hasError = true;
        errorMessage =
            "Unable to send OTP due to internal error, please try again later";
      });

      // Handle successful OTP submission here
      // For example, navigate to another screen
    });
  }

  void _handleOtpSubmit(String otpStr) {
    _sendOtpAndUpdate();
  }

  void _startResendTimer() {
    setState(() {
      _resendButtonEnabled = false;
      _resendTimer = 120;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _resendButtonEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  void _handleResend() {
    _sendOtpAndUpdate();
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: Spacing.lg, horizontal: Spacing.xl),
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
                size: 48,
              ),
              const SizedBox(height: Spacing.md),
              const Text("Verify your OTP",
                  style: TextStyle(
                      fontSize: FontSize.xxxl, fontWeight: FontWeight.bold)),
              const SizedBox(height: Spacing.xs),
              Text(
                "We texted you a code. Please verify that",
                style: TextStyle(
                    fontSize: FontSize.md, color: Colors.grey.shade500),
              ),
              const SizedBox(height: Spacing.sm),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 64),
                      OtpTextField(
                        numberOfFields: 6,
                        showFieldAsBox: true,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(Spacing.sm)),
                        onSubmit: _handleOtpSubmit,
                        onCodeChanged: (value) {
                          setState(() {
                            _otp = value;
                          });
                        },
                        borderColor: Colors.transparent,
                        enabledBorderColor: Colors.grey.shade300,
                        focusedBorderColor: CustomPalette.black,
                        disabledBorderColor: Colors.grey.shade400,
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        textStyle: TextStyle(
                            fontSize: FontSize.md,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600),
                        enabled: !_otpLoading,
                      ),
                      const SizedBox(height: Spacing.xs),
                      TextButton(
                        onPressed: _resendButtonEnabled ? _handleResend : null,
                        child: Text(
                          _resendButtonEnabled
                              ? "Didn't get the code?"
                              : "Resend in $_resendTimer",
                          style: TextStyle(
                            fontSize: FontSize.sm,
                            color: _resendButtonEnabled
                                ? Colors.grey.shade700
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                      PrimaryButton(
                        width: double.infinity,
                        text: "Verify",
                        onPressed: () => _handleOtpSubmit(_otp),
                        isLoading: _otpLoading,
                      ),
                      if (hasError)
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: Spacing.sm),
                          child: Text(
                            errorMessage ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: FontSize.sm,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
