import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MailtoLink extends StatelessWidget {
  final String emailSubject;
  final String emailBody;
  final Widget child;

  const MailtoLink({
    super.key,
    required this.emailSubject,
    required this.emailBody,
    required this.child,
  });

  void _launchEmail() async {
    final String encodedSubject = Uri.encodeComponent(emailSubject);
    final String encodedBody = Uri.encodeComponent(emailBody);
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'aadvik.developer@gmail.com',
      query: 'subject=$encodedSubject&body=$encodedBody',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _launchEmail,
      style: TextButton.styleFrom(
        shadowColor: Colors.transparent,
        overlayColor: Colors.transparent,
      ),
      child: child,
    );
  }
}
