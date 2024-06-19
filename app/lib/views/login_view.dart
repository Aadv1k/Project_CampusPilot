import 'package:app/components/phone_number_input.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md, vertical: Spacing.xs),
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
                const PhoneNumberInput(),
                const SizedBox(height: Spacing.sm),
                MaterialButton(
                    onPressed: () {},
                    height: 48,
                    minWidth: double.infinity,
                    color: Colors.lightGreen.shade800,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Spacing.xs)),
                    child: const Text("Verify",
                        style: TextStyle(
                            fontSize: FontSize.md,
                            fontWeight: FontWeight.bold)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
