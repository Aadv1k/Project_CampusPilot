import 'package:app/common/phone_number.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneNumberInput extends StatefulWidget {
  const PhoneNumberInput({super.key});

  @override
  State<StatefulWidget> createState() => PhoneNumberInputState();
}

class PhoneNumberInputState extends State<PhoneNumberInput> {
  final String selectedCountryCode =
      '+91'; // Replace with your default country code
  late String phoneNumber;

  final maskFormatter = MaskTextInputFormatter(
    mask: '##### #####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  PhoneNumberInputState() {
    phoneNumber = "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Mobile Number",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    selectedCountryCode,
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ),
                const VerticalDivider(
                  thickness: 1,
                  color: Colors.black26,
                  indent: Spacing.sm,
                  endIndent: Spacing.sm,
                ),
                Expanded(
                  child: TextField(
                    inputFormatters: [maskFormatter],
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none, // Remove default border
                      hintText: "XXXXX XXXXX",
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      counterText: '',
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
