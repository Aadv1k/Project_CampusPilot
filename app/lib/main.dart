import 'package:app/common/phone_number.dart';
import 'package:app/models/announcement.dart';
import 'package:app/models/user_model.dart';
import 'package:app/views/announcement_create_view.dart';
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
          .copyWith(textTheme: GoogleFonts.poppinsTextTheme()),
      home: const AnnouncementCreateView(),
      debugShowCheckedModeBanner: true,
    );
  }
}
