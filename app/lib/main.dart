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
      theme: ThemeData(brightness: Brightness.light).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(
              ThemeData(brightness: Brightness.light).textTheme)),
      home: const LoginView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
