import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

class RespHelper{
  static Response message({int statusCode = HttpStatus.ok,String? message, Map<String,Object> headers = const <String,Object>{}}){
    return Response.json(
      statusCode: statusCode,
      body: {
        "message":message
      },
      headers: headers
    );
  }

  static Response badRequest({String? message}){
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: message);
  }

  static Response unauthorized(){
    return RespHelper.message(statusCode: HttpStatus.unauthorized,message: "Your Are Not Allowed to Access This Resources!");
  }

  static Response forbidden(){
    return RespHelper.message(statusCode: HttpStatus.forbidden,message: "Your Are Not Allowed to Access This Resources!");
  }

  static Response methodNotAllowed(){
    return RespHelper.message(statusCode: HttpStatus.methodNotAllowed,message: "Method Not Allowed");
  }
}

