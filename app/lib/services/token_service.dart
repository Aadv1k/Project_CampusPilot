import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class TokenService {
  static const _storage = FlutterSecureStorage();

  static Future<String?> getAccessToken() {
    return TokenService._storage.read(key: "pcp_access_token");
  }

  static void storeAccessToken(String token) {
    TokenService._storage.write(key: "pcp_access_token", value: token);
  }

  static bool tokenExpired(String token)  {
    return JwtDecoder.isExpired(token);
  }
}