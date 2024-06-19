import 'package:app/components/phone_number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/utils/sizes.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(255, 253, 248, 1),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: Spacing.md, horizontal: Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Column(children: [
                Text(
                  "Sign in",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              Column(
                children: [
                  const PhoneNumberInput(),
                  const SizedBox(height: Spacing.sm),
                  MaterialButton(
                    onPressed: () {},
                    color: Colors.lightGreen.shade700,
                    textColor: Colors.white,
                    height: 52,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Text(
                      "Get OTP",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
