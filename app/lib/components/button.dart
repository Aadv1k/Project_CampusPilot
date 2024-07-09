import 'dart:ui_web';

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
    this.height = 72.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: Heights.xxl,
      color: Palette.slate950,
      disabledColor: Palette.slate600,
      onPressed: isLoading ? null : onPressed,
      disabledElevation: 0,
      minWidth: width,
      textColor: Palette.white,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.xl)),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Palette.slate100),
              ))
          : Text(text,
              style: const TextStyle(
                fontSize: FontSize.base,
                fontWeight: FontWeight.normal,
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

class UserProfileButton extends StatelessWidget {
  final String profileInitials;
  final double radius;
  final double size;
  final Color colorBasedOnProfileInitials;

  UserProfileButton(
      {required this.profileInitials,
      required this.size,
      required this.radius,
      super.key})
      : colorBasedOnProfileInitials =
            _getColorBasedOnProfileInitials(profileInitials);

  static Color _getColorBasedOnProfileInitials(String initials) {
    if (initials.isEmpty) {
      return Palette.pastelOrange; // Fallback color
    }

    var colors = [
      Palette.pastelLavender,
      Palette.pastelPink,
      Palette.pastelAqua,
      Palette.pastelIceBlue,
      Palette.pastelOrange,
      Palette.pastelRed,
    ];

    String alphabet = "abcdefghijklmnopqrstuvwxyz";
    int sumIndex = 0;

    for (int i = 0; i < initials.length; i++) {
      int index = alphabet.indexOf(initials[i].toLowerCase());
      if (index != -1) {
        sumIndex += index;
      }
    }

    int colorIndex = sumIndex % colors.length;
    return colors[colorIndex];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("tapped kiddo");
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: colorBasedOnProfileInitials,
        ),
        child: Center(
          child: Text(profileInitials.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Palette.white,
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.lg)),
        ),
      ),
    );
  }
}
