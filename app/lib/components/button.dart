import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double height;
  final double width;
  final String text;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.width,
    required this.text,
    this.onPressed,
    this.height = 84.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      color: Palette.primary,
      disabledColor: Colors.black45,
      onPressed: isLoading ? null : onPressed,
      disabledElevation: 0,
      minWidth: width,
      textColor: Palette.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.md)),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ))
          : Text(text,
              style: const TextStyle(
                  fontSize: FontSize.base, fontWeight: FontWeight.bold,
                  letterSpacing: 0.75
                  )),
    );
  }
}

class SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color iconColor;
  final Color backgroundColor;
  final double borderRadius;

  const SquareIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48.0, // Default size
    this.iconColor = Palette.gray400, // Default icon color
    this.backgroundColor = Palette.gray200, // Default background color
    this.borderRadius = 8.0, // Default border radius
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor, // Set background color
        borderRadius:
            BorderRadius.circular(borderRadius), // Rounded square shape
      ),
      child: IconButton(
        onPressed: onPressed,
        iconSize: size * 0.4, // Adjust icon size proportionally
        icon: Icon(icon, color: iconColor), // Set icon color
      ),
    );
  }
}
