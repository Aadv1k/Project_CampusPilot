import 'dart:io';

import 'package:app/models/user_model.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import "dart:convert"

class UserLoginService extends ChangeNotifier {
  final UserModel? user = null;
  static const serviceUrl = "http://localhost:8000/api/users";

  void loginUser(UserLoginModel userLogin) async {
    HttpResponse res = (await http.post(
      Uri.parse("$serviceUrl/login"), 
      headers: { 
        "Content-Type": "application/json",
      },
      body: json.encode({
        "countryCode": userLogin.countryCode.countryPhoneCode,
        "phoneNumber": userLogin.phoneNumber,
        "deviceToken": "joemama"
      })
    )) as HttpResponse;

    if (res.statusCode != 200) {
      // TODO
    }
  }

  void verifyUserOtp(UserLoginModel userLogin, String otp) async {
    HttpResponse res = await http.post(
      Uri.parse("$serviceUrl/otp_verify"), 
      headers: { 
        "Content-Type": "application/json",
      },
      body: json.encode({
        "countryCode": userLogin.countryCode.countryPhoneCode,
        "phoneNumber": userLogin.phoneNumber,
        "otp": otp
      })
    )

    if (res.statusCode != 200) {
      // TODO
    }

    var data = json.decode(res.body);

    user.accessToken = data.get("access_token");

    notifyListeners()
  }
}

class UserContext extends InheritedWidget {
  final UserLoginService userLoginService;

  const UserContext({super.key, 
    required this.userLoginService,
    required super.child
  });

  @override
  bool updateShouldNotify(covariant UserContext oldWidget) {
    return oldWidget.userLoginService.user != null;
  }

  static UserLoginService of(BuildContext context) {
    return context
      .dependOnInheritedWidgetOfExactType<UserContext>()!
      .userLoginService;
  }
}

