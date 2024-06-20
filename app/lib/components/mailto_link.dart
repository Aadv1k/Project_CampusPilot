import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MailtoLink extends StatelessWidget {
  final String emailSubject;
  final Widget child;

  const MailtoLink({
    super.key,
    required this.emailSubject,
    required this.child,
  });

  void _launchEmail() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'our.email@gmail.com',
      queryParameters: {
        'subject': 'CallOut user Profile',
      },
    );
    launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _launchEmail();
      },
      style: TextButton.styleFrom(
        shadowColor: Colors.transparent,
        overlayColor: Colors.transparent,
      ),
      child: child,
    );
  }
}
