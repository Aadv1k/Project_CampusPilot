import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:app/widgets/mailto_link.dart';
import 'package:app/widgets/phone_number_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.interTextTheme().copyWith(
          bodyMedium: const TextStyle(fontSize: FontSize.lg, color: Palette.body)
        )
      ),
      home: const InitialPage(),
      debugShowCheckedModeBanner: true,
    );
  }
}

// at this point I am just trying to pass time because all my work is done and I have nnothing left other thatnbcwthan to just do  bullshit like writing code that barely works or pretneding like I am something I hate socializing with people in an informal setting, while in a formal setting

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primary,
      body: Center(
        child: Column(
          children: [
              Container(
                height: MediaQuery.sizeOf(context).height * 0.50,
                width: double.infinity,
                decoration: const BoxDecoration(
                color: Palette.primary,
              ),
            ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                  decoration: const BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PhoneNumberInput(onInput: (str) { print (str); }, hasError: false),
                    const SizedBox(height: Spacing.sm),
                    SizedBox(
                      height: ComponentSizes.buttonHeight,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {}, 
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Palette.primary),
                          foregroundColor: WidgetStateProperty.all(Palette.white),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(ComponentSizes.buttonRadius),
                          ))
                        ),
                      child: const Text("Verify", style: TextStyle(color: Palette.white, fontSize: FontSize.base))
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    const MailtoLink(emailSubject: "help", emailBody: "help", child: Text("Can't Login? Get Support", style: TextStyle(color: TwZinc.shade600, fontSize: FontSize.sm)))
                  ]
                )
              ),
              )

          ],
        )
      ),
    );
  }
}