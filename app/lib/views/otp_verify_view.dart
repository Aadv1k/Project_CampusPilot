import 'dart:async';
import 'package:app/components/button.dart';
import 'package:app/models/user_model.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:app/views/announcement_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpVerifyView extends StatefulWidget {
  final UserLoginDetails loginDetails;

  const OtpVerifyView(this.loginDetails, {super.key});

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

    Future.delayed(const Duration(seconds: 2), () {
      final success = _simulateOtpVerification();

      setState(() {
        _otpLoading = false;
      });

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AnnouncementListView()),
        );
      } else {
        setState(() {
          hasError = true;
          errorMessage =
              "Unable to send OTP due to internal error, please try again later";
        });
      }
    });
  }

  bool _simulateOtpVerification() {
    return true;
  }

  void _handleOtpSubmit(String otpStr) {
    if (_otp.isEmpty) {
      setState(() {
        hasError = true;
        errorMessage = "Please enter your OTP before proceeding";
      });
      return;
    }

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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg, vertical: Spacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Verify the OTP Sent to ***** ${widget.loginDetails.phoneNumber.substring(5, 10)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.xl,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                OtpTextField(
                  numberOfFields: 6,
                  showFieldAsBox: true,
                  margin: const EdgeInsets.only(right: Spacing.sm),
                  clearText: true,
                  fieldWidth: Widths.lg,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(Spacing.sm)),
                  onSubmit: _handleOtpSubmit,
                  onCodeChanged: (value) {
                    setState(() {
                      _otp = value;
                    });
                  },
                  borderColor: Colors.transparent,
                  enabledBorderColor: Palette.slate200,
                  focusedBorderColor: Palette.primary,
                  filled: true,
                  fillColor: Palette.bgSecondary,
                  textStyle: const TextStyle(
                    fontSize: FontSize.lg,
                    fontWeight: FontWeight.normal,
                    color: Palette.slate800,
                  ),
                  enabled: !_otpLoading,
                ),
                const SizedBox(height: Spacing.sm),
                TextButton(
                  onPressed: _resendButtonEnabled ? _handleResend : null,
                  child: Text(
                    _resendButtonEnabled
                        ? "Didn't get the code?"
                        : "Resend in $_resendTimer",
                    style: TextStyle(
                      fontSize: FontSize.base,
                      color: _resendButtonEnabled
                          ? Palette.slate500
                          : Palette.slate300,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                PrimaryButton(
                  width: double.infinity,
                  text: "Continue",
                  onPressed: () => _handleOtpSubmit(_otp),
									radius: Radii.xl,
									height: Heights.xxl,
                  isLoading: _otpLoading,
                ),
                if (hasError) const SizedBox(height: Spacing.md),
                Text(
                  errorMessage ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: FontSize.base,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
