import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.primary,
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Hello, and welcome. to the next gen of school communications", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.white))
        ],
      )
    );
  }
}
