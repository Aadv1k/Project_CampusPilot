import 'package:app/models/announcement.dart';
import 'package:app/views/announcement_list_view.dart';
import 'package:app/views/announcement_readonly_view.dart';
import 'package:app/views/otp_verify_view.dart';
import 'package:flutter/material.dart';
import 'package:app/views/login_view.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Project CampusPilot",
      theme: ThemeData(brightness: Brightness.light)
          .copyWith(textTheme: GoogleFonts.dmSansTextTheme()),
      home: AnnouncementReadonlyView( Announcement(
    "j34g8g88-3e7c-4f7a-a8e2-9e9a2d2d4f4a",
    "Annual Day Celebrations",
    "We are excited to announce that Annual Day celebrations will take place on August 5, 2024. More details will follow soon.",
    "Mr. Singh",
    "2024-07-06T14:00:00.000Z",
  ),
),
      debugShowCheckedModeBanner: false,
    );
  }
}
