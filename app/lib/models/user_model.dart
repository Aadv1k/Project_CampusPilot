import 'package:app/common/phone_number.dart';

class UserModel {
  final String userId;
  final String fullName;
  final String accessToken;

  UserModel(
      {required this.userId,
      required this.fullName,
      required this.accessToken});
}

class UserLoginDetails {
  final CountryCode phoneCountryCode;
  final String phoneNumber;

  const UserLoginDetails(this.phoneCountryCode, this.phoneNumber);
}
