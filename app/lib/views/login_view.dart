import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/utils/sizes.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8FF),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              "assets/placeholder_logo.svg",
              width: 50,
              height: 50,
            ),
            SizedBox(height: Spacing.md),
            Text(
              "Sign in",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Spacing.xl),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Eg 1234567890',
              ),
            ),
            SizedBox(height: 16.0),
            MaterialButton(
              onPressed: () {},
              color: Colors.green,
              textColor: Colors.white,
              child: Text("Get OTP", style: TextStyle(fontSize: 16),),
              height: 40,
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginView(),
    debugShowCheckedModeBanner: false,
  ));
}
