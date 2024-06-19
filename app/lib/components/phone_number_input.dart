import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';

class PhoneNumberInput extends StatefulWidget {
  const PhoneNumberInput({super.key});

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  bool isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: isFocused ? Colors.grey.shade500 : Colors.grey.shade400,
                width: 1.5),
            borderRadius: BorderRadius.circular(Spacing.xs)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.sm),
              child: Center(
                child: Text(
                  "+91",
                  style: TextStyle(
                      fontSize: FontSize.md, color: Colors.grey.shade600),
                ),
              ),
            ),
            VerticalDivider(
                width: 6,
                thickness: 1.2,
                indent: Spacing.sm,
                endIndent: Spacing.sm,
                color: Colors.grey.shade400),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
              child: TextField(
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: "XXXXX XXXXX",
                    border: InputBorder.none,
                  )),
            ))
          ],
        ),
      ),
    );
  }
}
