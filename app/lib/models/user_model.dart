import 'package:app/views/login_view.dart';

class UserModel {
  final String userId;
  final String fullName;
  final String accessToken;

  UserModel(
      {required this.userId,
      required this.fullName,
      required this.accessToken});
}

class UserLoginModel {
  final String phoneNumber;
  final CountryCode countryCode;

  UserLoginModel({
    required this.phoneNumber,
    required this.countryCode,
  });
}
