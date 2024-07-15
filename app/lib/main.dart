import 'package:app/services/token_service.dart';
import 'package:app/utils/colors.dart';
import 'package:app/views/announcement_create_view.dart';
import 'package:app/views/announcement_list_view.dart';
import 'package:app/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _shouldShowLogin() async {
    final String? token = await TokenService.getAccessToken();
    if (token == null) return true;

    return TokenService.tokenExpired(token) == false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _shouldShowLogin(), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return MaterialApp(
          title: "Project CampusPilot",
          theme: ThemeData(brightness: Brightness.light, 
          buttonTheme: ButtonThemeData(
            splashColor: Palette.slate950,
            highlightColor: Palette.slate950.withOpacity(0.8)
          ),
          )
              .copyWith(textTheme: GoogleFonts.poppinsTextTheme()),
          home: const AnnouncementCreateView(),
          debugShowCheckedModeBanner: true,
        );
      }

      return const MaterialApp(home: Scaffold(body: CircularProgressIndicator()));

    });

  }
}
