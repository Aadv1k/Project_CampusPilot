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
  String phoneNumber;

  UserLoginDetails(this.phoneNumber);
}
