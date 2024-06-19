import 'package:flutter/material.dart';

class PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (value) => value.length == 10
    )
  }
}
