import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';

class SafeScaffold extends StatelessWidget {
  final AppBar? appBar;
  final Widget body;

  SafeScaffold({ this.appBar, required this.body});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBar != null ? AppBar() : appBar,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric( horizontal: Spacing.lg, vertical: Spacing.xxl),
          child: body
        ),
      )

    );

  }

}