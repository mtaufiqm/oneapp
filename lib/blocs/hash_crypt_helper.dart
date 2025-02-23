
import 'dart:convert';

import 'package:crypto/crypto.dart';

//USING SHA256 HASH

class HashCryptHelper{
  static bool isEqual({required String hasedPass,required String passInput}){
    if(hasedPass == HashCryptHelper.hashPassword(passInput)){
      return true;
    }
    return false;
  }

  static String hashPassword(String password){
    Digest result = sha256.convert(utf8.encode(password));
    return result.toString();    
  }
}