import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            Column(children: [
              SvgPicture.asset(
                "assets/placeholder_logo.svg",
                width: 60,
                height: 60,
              ),
              const SizedBox(height: Spacing.md),
              const Text(
                "Sign in",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
            const SizedBox(height: Spacing.xl),
            PhoneNumberInput(),
            const SizedBox(height: 16.0),
            MaterialButton(
              onPressed: () {},
              color: Colors.lightGreen.shade800,
              textColor: Colors.white,
              height: 40,
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: const Text(
                "Get OTP",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneNumberInput extends StatefulWidget {
  const PhoneNumberInput({super.key});

  @override
  PhoneNumberInputState createState() => PhoneNumberInputState();
}

enum CountryCode {
  INDIA("🇮🇳", "+91"),
  USA("🇺🇸", "+1");

  final String countryEmoji;
  final String countryPhoneCode;

  const CountryCode(this.countryEmoji, this.countryPhoneCode);
}

class PhoneNumberInputState extends State<PhoneNumberInput> {
  CountryCode? selectedCountryCode;
  String? phoneNumber;

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownMenu<String>(
          initialSelection: CountryCode.INDIA.countryPhoneCode,
          controller: countryCodeController,
          label: const Text("Country"),
          onSelected: (String? value) {
            setState(() {
              selectedCountryCode = CountryCode.values
                  .firstWhere((country) => country.countryPhoneCode == value);
            });
          },
          dropdownMenuEntries: CountryCode.values
              .map((CountryCode country) => DropdownMenuEntry<String>(
                    value: country.countryPhoneCode,
                    label: country.countryEmoji,
                  ))
              .toList(),
        ),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.phone,
            controller: phoneNumberController,
            onChanged: (String value) {
              setState(() {
                phoneNumber = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
