import 'package:flutter/material.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneNumberInput extends StatefulWidget {
  final Function(String) onInput;
  final bool hasError;
  final String? errorMessage;

  const PhoneNumberInput({
    super.key,
    required this.onInput,
    required this.hasError,
    this.errorMessage,
  });

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  late FocusNode _focusNode;
  final phoneNumberInputController = TextEditingController();
  bool isFocused = false;
  String phoneNumber = "";

  var maskFormatter = MaskTextInputFormatter(
    mask: "##### #####",
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  void _handleInputChange() {
    widget.onInput(maskFormatter.getUnmaskedText());
    setState(() {
      phoneNumber = phoneNumberInputController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    phoneNumberInputController.addListener(_handleInputChange);
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
    phoneNumberInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.hasError
                    ? (isFocused ? Colors.red.shade600 : Colors.red.shade500)
                    : (isFocused ? Colors.grey.shade600 : Colors.grey.shade400),
                width: 1.8,
              ),
              borderRadius: BorderRadius.circular(Spacing.xs),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(Spacing.sm),
                  child: Center(
                    child: Text(
                      "+91",
                      style: TextStyle(
                        fontSize: FontSize.md,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                VerticalDivider(
                  width: 6,
                  thickness: 1.2,
                  indent: Spacing.sm,
                  endIndent: Spacing.sm,
                  color:
                      isFocused ? Colors.grey.shade700 : Colors.grey.shade400,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                    child: TextField(
                      focusNode: _focusNode,
                      keyboardType: TextInputType.phone,
                      controller: phoneNumberInputController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                        maskFormatter,
                      ],
                      decoration: const InputDecoration(
                        hintText: "XXXXX XXXXX",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        widget.hasError
            ? Text(
                widget.errorMessage!,
                style: TextStyle(
                    color: Colors.red.shade500, fontSize: FontSize.md),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
