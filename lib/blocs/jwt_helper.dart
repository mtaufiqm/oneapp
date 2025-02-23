import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

final JWTKey secretKey = SecretKey("taufiq1729taufiq1729taufiq1729");

class JwtHelper{
  static JWT tryVerify(String token){
      return JWT.verify(token, secretKey);
  }

  static String generator(String username,List<String> roles){
    var jwtToken = JWT({
      "username":username,"roles":roles
    });
    var token = jwtToken.sign(secretKey);
    return token;
  }
}