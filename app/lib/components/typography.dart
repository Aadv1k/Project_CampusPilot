import 'package:flutter/material.dart';


class Heading extends StatelessWidget {
  final int order;
  final String text;
  final TextAlign? textAlign;
  final TextStyle? style;

  static const Map<int, Map<String, double>> sizes = {
    3: {'fontSize': 16.0, 'lineHeight': 1.2},
    2: {'fontSize': 24.0, 'lineHeight': 1.3},
    1: {'fontSize': 32.0, 'lineHeight': 1.4},
  };

  const Heading({Key? key, required this.order, required this.text, this.style, this.textAlign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, double> defaultStyle = sizes.containsKey(order) ? sizes[order]! : sizes[1]!;

    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: defaultStyle['fontSize']!,
        height: defaultStyle['lineHeight']!,
      ).merge(style),
    );
  }
}