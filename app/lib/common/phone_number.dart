enum CountryCode {
  INDIA('+91'),
  USA('+1');

  const CountryCode(this.code);
  final String code;
}

class PhoneNumber {
  static bool isValid(CountryCode country, String phoneNumber) {
    if (!_isNumeric(phoneNumber)) {
      return false;
    }

    switch (country) {
      case CountryCode.INDIA:
        return phoneNumber.length == 10;
      case CountryCode.USA:
        return phoneNumber.length == 10;
      default:
        return false;
    }
  }

  static bool _isNumeric(String str) {
    // Check if the string is a numeric value
    return RegExp(r'^[0-9]+$').hasMatch(str);
  }
}
