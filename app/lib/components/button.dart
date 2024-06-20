import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double height;
  final Color color;
  final double width;

  const PrimaryButton(
      {super.key,
      required this.child,
      required this.width,
      this.onPressed,
      this.height = 64.0,
      this.color = CustomPalette.black});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      onPressed: onPressed,
      disabledElevation: 0,
      color: color,
      minWidth: width,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.md)),
      child: child,
    );
  }
}
